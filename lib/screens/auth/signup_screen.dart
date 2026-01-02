import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _studentFormKey = GlobalKey<FormState>();
  final _clubFormKey = GlobalKey<FormState>();

  // Student form controllers
  final _studentNameController = TextEditingController();
  final _studentEmailController = TextEditingController();
  final _studentLevelTermController = TextEditingController();
  final _studentContactController = TextEditingController();
  final _studentPasswordController = TextEditingController();
  String? _selectedDepartment;
  List<String> _selectedInterests = [];

  // Club form controllers
  final _clubNameController = TextEditingController();
  final _clubDescriptionController = TextEditingController();
  final _clubEmailController = TextEditingController();
  final _clubPasswordController = TextEditingController();
  String? _selectedCategory;

  bool _isLoading = false;
  bool _obscurePassword = true;

  // Department list
  final List<String> _departments = [
    'CE',
    'EEE',
    'ME',
    'CSE',
    'ETE',
    'Arch',
    'MIE',
    'PMEMME',
    'WRE',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _studentNameController.dispose();
    _studentEmailController.dispose();
    _studentLevelTermController.dispose();
    _studentContactController.dispose();
    _studentPasswordController.dispose();
    _clubNameController.dispose();
    _clubDescriptionController.dispose();
    _clubEmailController.dispose();
    _clubPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpStudent() async {
    if (!_studentFormKey.currentState!.validate()) return;
    if (_selectedDepartment == null) {
      _showError('Please select a department');
      return;
    }
    if (_selectedInterests.isEmpty) {
      _showError('Please select at least one field of interest');
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? error = await authProvider.signUpStudent(
      email: _studentEmailController.text.trim(),
      password: _studentPasswordController.text,
      fullName: _studentNameController.text.trim(),
      levelTerm: _studentLevelTermController.text.trim(),
      department: _selectedDepartment!,
      contactNumber: _studentContactController.text.trim(),
      fieldsOfInterest: _selectedInterests,
    );

    setState(() => _isLoading = false);

    if (error != null && mounted) {
      _showError(error);
    } else if (mounted) {
      // Sign out the user so they can login
      await authProvider.signOut();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please login.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      // AuthWrapper will automatically show WelcomeScreen/LoginScreen after signOut
    }
  }

  Future<void> _signUpClubManager() async {
    if (!_clubFormKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showError('Please select a club category');
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? error = await authProvider.signUpClubManager(
      email: _clubEmailController.text.trim(),
      password: _clubPasswordController.text,
      clubName: _clubNameController.text.trim(),
      clubDescription: _clubDescriptionController.text.trim(),
      clubCategory: _selectedCategory!,
    );

    setState(() => _isLoading = false);

    if (error != null && mounted) {
      _showError(error);
    } else if (mounted) {
      // Sign out the user so they can login
      await authProvider.signOut();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Club registered successfully! Please login.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      // AuthWrapper will automatically show WelcomeScreen/LoginScreen after signOut
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Wave background
          CustomPaint(
            size: size,
            painter: LoginWavePainter(),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom AppBar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppTheme.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.grey,
                    tabs: const [
                      Tab(text: 'Student'),
                      Tab(text: 'Club Manager'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildStudentForm(),
                      _buildClubManagerForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _studentFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: 'Full Name',
              hintText: 'Enter your full name',
              controller: _studentNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Full name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Email Address',
              hintText: 'example@student.cuet.ac.bd',
              controller: _studentEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Level–Term',
              hintText: 'e.g., 1-2, 2-1, 3-2',
              controller: _studentLevelTermController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Level-Term is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Department',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showDepartmentDialog(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDepartment ?? 'Select your department',
                            style: TextStyle(
                              color: _selectedDepartment == null
                                  ? AppTheme.grey
                                  : AppTheme.darkGrey,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Contact Number',
              hintText: 'Enter your contact number',
              controller: _studentContactController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Contact number is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Password',
              hintText: 'Create a password',
              controller: _studentPasswordController,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.grey,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Field of Interest',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showInterestsDialog(),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedInterests.isEmpty
                                ? 'Select interests'
                                : _selectedInterests.join(', '),
                            style: TextStyle(
                              color: _selectedInterests.isEmpty
                                  ? AppTheme.grey
                                  : AppTheme.darkGrey,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Sign Up',
              onPressed: _signUpStudent,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),

            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Or continue with', style: TextStyle(color: AppTheme.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.g_mobiledata),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.facebook),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.apple),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: AppTheme.darkGrey),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: AppTheme.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubManagerForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _clubFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: 'Club Name',
              hintText: 'Enter club name',
              controller: _clubNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Club name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Club Description',
              hintText: 'Describe your club',
              controller: _clubDescriptionController,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Club description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Club Category',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    hintText: 'Select category',
                  ),
                  items: AppConstants.clubCategories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Club Email Address',
              hintText: 'club@example.com',
              controller: _clubEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Password',
              hintText: 'Create a password',
              controller: _clubPasswordController,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.grey,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Register Club',
              onPressed: _signUpClubManager,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),

            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Or continue with', style: TextStyle(color: AppTheme.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.g_mobiledata),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.facebook),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.apple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey.withOpacity(0.3)),
      ),
      child: Icon(icon, color: AppTheme.navyBlue),
    );
  }

  void _showDepartmentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Department'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _departments.map((dept) {
                return RadioListTile<String>(
                  title: Text(dept),
                  value: dept,
                  groupValue: _selectedDepartment,
                  onChanged: (String? value) {
                    setState(() => _selectedDepartment = value);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showInterestsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempSelected = List.from(_selectedInterests);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Interests'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: AppConstants.fieldsOfInterest.map((interest) {
                    return CheckboxListTile(
                      title: Text(interest),
                      value: tempSelected.contains(interest),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelected.add(interest);
                          } else {
                            tempSelected.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedInterests = tempSelected);
                    Navigator.pop(context);
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Wave painter
class LoginWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = const Color(0xFFF5F5F5)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final paint = Paint()
      ..color = AppTheme.primaryBlue
      ..style = PaintingStyle.fill;

    final topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(0, size.height * 0.15);
    topPath.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.18,
      size.width * 0.5,
      size.height * 0.15,
    );
    topPath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.12,
      size.width,
      size.height * 0.15,
    );
    topPath.lineTo(size.width, 0);
    topPath.close();
    canvas.drawPath(topPath, paint);

    final bottomPath = Path();
    bottomPath.moveTo(0, size.height);
    bottomPath.lineTo(0, size.height * 0.85);
    bottomPath.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.82,
      size.width * 0.5,
      size.height * 0.85,
    );
    bottomPath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.88,
      size.width,
      size.height * 0.85,
    );
    bottomPath.lineTo(size.width, size.height);
    bottomPath.close();
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
