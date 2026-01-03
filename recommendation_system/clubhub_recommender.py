"""
clubhub_recommender.py
Event recommendation system for ClubHub using:
- Past attended events
- Fields of interest
- Club categories
"""

import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime


class ClubHubRecommender:
    
    def __init__(self, firebase_cred_path=None):
        """Initialize with Firebase credentials"""
        print("🔥 Connecting to Firebase...")
        
        try:
            if firebase_cred_path and not firebase_admin._apps:
                cred = credentials.Certificate(firebase_cred_path)
                firebase_admin.initialize_app(cred)
            
            self.db = firestore.client()
        except Exception as e:
            print(f"❌ Failed to connect to Firebase: {e}")
            print("Make sure your serviceAccountKey.json is valid!")
            raise
        
        # Interest to keyword mappings based on your categories
        self.interest_keywords = {
            'Technology & Programming': [
                'programming', 'code', 'coding', 'hackathon', 'software', 'algorithm',
                'web', 'dev', 'development', 'ai', 'ml', 'machine learning', 'python',
                'java', 'javascript', 'react', 'node', 'database', 'app', 'tech',
                'cybersecurity', 'security', 'network', 'robot', 'iot', 'embedded'
            ],
            'Sports & Fitness': [
                'sport', 'football', 'cricket', 'badminton', 'tournament', 'athletic',
                'fitness', 'gym', 'marathon', 'run', 'match', 'game', 'competition',
                'championship', 'player', 'team'
            ],
            'Arts & Culture': [
                'art', 'culture', 'cultural', 'drama', 'theater', 'play', 'performance',
                'traditional', 'festival', 'celebration', 'dance', 'painting', 'sketch',
                'exhibition', 'pohela', 'victory'
            ],
            'Music & Dance': [
                'music', 'song', 'singing', 'band', 'concert', 'dance', 'dancing',
                'acoustic', 'performance', 'instrumental', 'vocal', 'classical',
                'battle of bands', 'musical'
            ],
            'Photography': [
                'photo', 'photography', 'camera', 'picture', 'portrait', 'landscape',
                'exhibition', 'shoot', 'walk', 'digital', 'editing', 'visual'
            ],
            'Social Service': [
                'social', 'service', 'volunteer', 'community', 'blood', 'donation',
                'charity', 'help', 'teaching', 'education', 'tree', 'environment',
                'plantation', 'campaign', 'awareness'
            ],
            'Debate & Public Speaking': [
                'debate', 'public speaking', 'speech', 'model un', 'mun', 'parliamentary',
                'discussion', 'presentation', 'communication', 'diplomacy', 'negotiation'
            ],
            'Academic Research': [
                'research', 'academic', 'paper', 'study', 'thesis', 'publication',
                'journal', 'workshop', 'seminar', 'conference', 'writing'
            ],
            'Entrepreneurship': [
                'business', 'startup', 'entrepreneur', 'pitch', 'competition', 'case',
                'marketing', 'finance', 'management', 'innovation', 'idea'
            ],
            'Environment': [
                'environment', 'green', 'eco', 'sustainable', 'tree', 'plantation',
                'climate', 'nature', 'conservation', 'waste', 'pollution'
            ]
        }
        
        print("📊 Loading data from Firestore...")
        self._load_data()
        
        print("🛠️ Building recommendation model...")
        self._prepare_data()
        print("✅ System ready!\n")
    
    def _load_data(self):
        """Load data from Firestore"""
        # Load students
        students_ref = self.db.collection('students')
        students_data = []
        for doc in students_ref.stream():
            data = doc.to_dict()
            data['uid'] = doc.id
            students_data.append(data)
        
        self.students_df = pd.DataFrame(students_data)
        print(f"   ✓ Loaded {len(self.students_df)} students")
        
        # Load clubs
        clubs_ref = self.db.collection('clubs')
        clubs_data = []
        for doc in clubs_ref.stream():
            data = doc.to_dict()
            data['clubId'] = doc.id
            clubs_data.append(data)
        
        self.clubs_df = pd.DataFrame(clubs_data)
        print(f"   ✓ Loaded {len(self.clubs_df)} clubs")
        
        # Load events
        events_ref = self.db.collection('events')
        events_data = []
        for doc in events_ref.stream():
            data = doc.to_dict()
            data['eventId'] = doc.id
            # Convert timestamp to datetime
            if 'eventDate' in data and data['eventDate'] is not None:
                try:
                    data['eventDate'] = data['eventDate'].replace(tzinfo=None)
                except AttributeError:
                    # If it's already a datetime or invalid, keep as is
                    pass
            events_data.append(data)
        
        self.events_df = pd.DataFrame(events_data)
        
        # Join with clubs to get club names and categories
        if len(self.clubs_df) > 0:
            self.events_df = self.events_df.merge(
                self.clubs_df[['clubId', 'clubName', 'clubCategory']], 
                on='clubId', 
                how='left'
            )
        
        print(f"   ✓ Loaded {len(self.events_df)} events")
        
        # Load registrations with attendance
        registrations_ref = self.db.collection('event_registrations')
        registrations_data = []
        for doc in registrations_ref.stream():
            data = doc.to_dict()
            registrations_data.append(data)
        
        if len(registrations_data) > 0:
            self.registrations_df = pd.DataFrame(registrations_data)
            print(f"   ✓ Loaded {len(self.registrations_df)} registrations")
        else:
            print("   ⚠️  No registrations found")
            self.registrations_df = pd.DataFrame(columns=['studentUid', 'eventId', 'attended'])
    
    def _prepare_data(self):
        """Prepare data for recommendations"""
        if len(self.events_df) == 0:
            print("   ⚠️  No events available")
            return
        
        # Create searchable content with error handling
        try:
            self.events_df['searchable_content'] = (
                self.events_df['eventName'].fillna('').astype(str) + ' ' +
                self.events_df['eventDescription'].fillna('').astype(str) + ' ' +
                self.events_df['clubName'].fillna('').astype(str) + ' ' +
                self.events_df['clubCategory'].fillna('').astype(str)
            ).str.lower()
        except Exception as e:
            print(f"   ⚠️  Error creating searchable content: {e}")
            self.events_df['searchable_content'] = self.events_df['eventName'].fillna('').astype(str).str.lower()
        
        # Create TF-IDF vectors
        self.vectorizer = TfidfVectorizer(
            max_features=200,
            stop_words='english',
            ngram_range=(1, 2),
            min_df=1
        )
        self.event_vectors = self.vectorizer.fit_transform(
            self.events_df['searchable_content']
        )
        
        # Calculate popularity
        if len(self.registrations_df) > 0:
            event_counts = self.registrations_df['eventId'].value_counts()
            self.events_df['popularity'] = self.events_df['eventId'].map(event_counts).fillna(0)
        else:
            self.events_df['popularity'] = 0
        
        max_pop = self.events_df['popularity'].max()
        self.events_df['popularity_score'] = (
            self.events_df['popularity'] / max_pop if max_pop > 0 else 0
        )
        
        self.popular_events = self.events_df.sort_values('popularity', ascending=False)
    
    def _get_interest_match_score(self, content, interests):
        """Calculate how well event matches student's interests"""
        # Safety check: ensure interests is a list
        if not isinstance(interests, list):
            return 0.0
        
        total_score = 0
        
        for interest in interests:
            if interest not in self.interest_keywords:
                continue
            
            keywords = self.interest_keywords[interest]
            matches = sum(1 for keyword in keywords if keyword in content.lower())
            
            if matches > 0:
                # Score: 0.3 base + 0.1 per match, capped at 1.0
                score = min(1.0, 0.3 + (matches * 0.1))
                total_score += score
        
        # Average across all interests
        return total_score / len(interests) if interests else 0.0
    
    def _get_attended_events(self, student_uid):
        """Get events student attended (not just registered)"""
        if len(self.registrations_df) == 0:
            return set()
        
        attended = self.registrations_df[
            (self.registrations_df['studentUid'] == student_uid) &
            (self.registrations_df['attended'] == True)
        ]
        return set(attended['eventId'].values)
    
    def _get_registered_events(self, student_uid):
        """Get all events student registered for"""
        if len(self.registrations_df) == 0:
            return set()
        
        registered = self.registrations_df[
            self.registrations_df['studentUid'] == student_uid
        ]
        return set(registered['eventId'].values)
    
    def _calculate_content_similarity(self, event_id1, event_id2):
        """Calculate similarity between two events"""
        try:
            idx1 = self.events_df[self.events_df['eventId'] == event_id1].index[0]
            idx2 = self.events_df[self.events_df['eventId'] == event_id2].index[0]
            
            return cosine_similarity(
                self.event_vectors[idx1],
                self.event_vectors[idx2]
            )[0][0]
        except:
            return 0.0
    
    def _is_upcoming(self, event_id):
        """Check if event is upcoming"""
        event = self.events_df[self.events_df['eventId'] == event_id]
        if len(event) == 0:
            return False
        
        event_row = event.iloc[0]
        event_date = event_row.get('eventDate')
        
        # Check if event date is valid and upcoming
        if pd.isna(event_date) or event_date is None:
            return False
            
        try:
            return (
                event_date > datetime.now() and
                not event_row.get('isCompleted', False)
            )
        except (TypeError, AttributeError):
            return False
    
    def recommend(self, student_uid, top_n=5):
        """
        Generate recommendations for a student
        
        Strategy:
        1. If student attended events: recommend similar events
        2. Always consider student's interests
        3. Filter to upcoming events only
        4. Blend: 60% attended-event similarity + 40% interest match
        """
        
        if student_uid not in self.students_df['uid'].values:
            return {
                'studentUid': student_uid,
                'type': 'error',
                'message': 'Student not found',
                'recommendations': []
            }
        
        student = self.students_df[self.students_df['uid'] == student_uid].iloc[0]
        interests = student.get('fieldOfInterest', [])
        
        # Ensure interests is a list (handle NaN or invalid data)
        if not isinstance(interests, list):
            interests = []
        
        # Get events to exclude (already registered)
        registered_events = self._get_registered_events(student_uid)
        attended_events = self._get_attended_events(student_uid)
        
        # Get upcoming events only
        upcoming_events = self.events_df[
            self.events_df['eventId'].apply(self._is_upcoming)
        ]['eventId'].values
        
        # Exclude registered events
        candidate_events = set(upcoming_events) - registered_events
        
        if len(candidate_events) == 0:
            return {
                'studentUid': student_uid,
                'studentName': student.get('fullName', 'Unknown'),
                'type': 'no_events',
                'hasAttendedEvents': len(attended_events) > 0,
                'recommendations': []
            }
        
        # Calculate scores for each candidate event
        event_scores = {}
        
        for event_id in candidate_events:
            event = self.events_df[self.events_df['eventId'] == event_id].iloc[0]
            
            # 1. Interest match score
            interest_score = self._get_interest_match_score(
                event['searchable_content'], 
                interests
            )
            
            # 2. Similarity to attended events
            attended_similarity = 0.0
            if len(attended_events) > 0:
                similarities = []
                for attended_id in attended_events:
                    sim = self._calculate_content_similarity(event_id, attended_id)
                    similarities.append(sim)
                attended_similarity = max(similarities) if similarities else 0.0
            
            # 3. Popularity boost
            popularity_boost = event.get('popularity_score', 0) * 0.1
            
            # Final score calculation
            if len(attended_events) > 0:
                # Blend: 60% attended similarity + 40% interest
                final_score = (
                    (attended_similarity * 0.6) +
                    (interest_score * 0.4) +
                    popularity_boost
                )
            else:
                # New user: 95% interest + 5% popularity
                final_score = (interest_score * 0.95) + popularity_boost
            
            event_scores[event_id] = final_score
        
        # Sort by score
        sorted_events = sorted(event_scores.items(), key=lambda x: x[1], reverse=True)
        top_events = sorted_events[:top_n]
        
        # Format recommendations
        recommendations = []
        for event_id, score in top_events:
            event = self.events_df[self.events_df['eventId'] == event_id].iloc[0]
            recommendations.append({
                'eventId': event_id,
                'eventName': event['eventName'],
                'clubName': event['clubName'],
                'clubCategory': event['clubCategory'],
                'eventDescription': event['eventDescription'][:150] + '...' if len(event['eventDescription']) > 150 else event['eventDescription'],
                'score': round(float(score), 4)
            })
        
        return {
            'studentUid': student_uid,
            'studentName': student.get('fullName', 'Unknown'),
            'interests': interests,
            'type': 'hybrid' if len(attended_events) > 0 else 'interest-based',
            'hasAttendedEvents': len(attended_events) > 0,
            'attendedCount': len(attended_events),
            'recommendations': recommendations
        }


# Example usage
if __name__ == "__main__":
    # Initialize
    recommender = ClubHubRecommender('serviceAccountKey.json')
    
    # Get a real student UID from the database
    db = recommender.db
    students = list(db.collection('students').limit(1).stream())
    
    if not students:
        print("❌ No students found in database!")
        exit(1)
    
    student_uid = students[0].id
    student_data = students[0].to_dict()
    print(f"🎯 Testing with: {student_data.get('fullName')} ({student_data.get('email')})")
    
    # Get recommendations for a student
    results = recommender.recommend(student_uid, top_n=5)
    
    print(f"\n📋 Recommendations for {results.get('studentName', 'Unknown')}:")
    print(f"   Interests: {', '.join(results.get('interests', []))}")
    print(f"   Type: {results.get('type', 'N/A')}")
    print(f"   Attended events: {results.get('attendedCount', 0)}\n")
    
    for i, rec in enumerate(results.get('recommendations', []), 1):
        print(f"{i}. {rec['eventName']} ({rec['clubName']})")
        print(f"   Score: {rec['score']}")
        print(f"   {rec['eventDescription']}\n")