import 'package:flutter/material.dart';
import '../utils/theme.dart';

// ============= CANVA-STYLE CARD =============

class CanvaCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final bool showBorder;
  final bool enableHover;
  
  const CanvaCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.showBorder = true,
    this.enableHover = true,
  });
  
  @override
  State<CanvaCard> createState() => _CanvaCardState();
}

class _CanvaCardState extends State<CanvaCard> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enableHover ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enableHover ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.color ?? AppTheme.cardBackground,
          borderRadius: AppTheme.radiusMedium,
          border: widget.showBorder 
              ? Border.all(
                  color: _isHovered ? AppTheme.canvaGray300 : AppTheme.canvaGray200,
                  width: 1,
                )
              : null,
          boxShadow: _isHovered && widget.onTap != null
              ? AppTheme.canvaShadowMD
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppTheme.radiusMedium,
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(AppTheme.space4),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

// ============= CANVA-STYLE BUTTON =============

class CanvaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final CanvaButtonStyle style;
  final CanvaButtonSize size;
  
  const CanvaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.style = CanvaButtonStyle.primary,
    this.size = CanvaButtonSize.medium,
  });
  
  @override
  State<CanvaButton> createState() => _CanvaButtonState();
}

class _CanvaButtonState extends State<CanvaButton> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;
    double fontSize;
    
    switch (widget.size) {
      case CanvaButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        fontSize = 13;
        break;
      case CanvaButtonSize.medium:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
        fontSize = 15;
        break;
      case CanvaButtonSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
        fontSize = 16;
        break;
    }
    
    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;
    
    switch (widget.style) {
      case CanvaButtonStyle.primary:
        backgroundColor = AppTheme.primaryOrange;
        foregroundColor = AppTheme.canvaWhite;
        borderColor = null;
        break;
      case CanvaButtonStyle.secondary:
        backgroundColor = AppTheme.canvaWhite;
        foregroundColor = AppTheme.textPrimary;
        borderColor = AppTheme.canvaGray300;
        break;
      case CanvaButtonStyle.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = AppTheme.textPrimary;
        borderColor = null;
        break;
    }
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? _getHoverColor(backgroundColor) : backgroundColor,
          borderRadius: AppTheme.radiusMedium,
          border: borderColor != null
              ? Border.all(
                  color: _isHovered ? AppTheme.canvaGray400 : borderColor,
                  width: 1.5,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: AppTheme.radiusMedium,
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                      ),
                    )
                  else ...[
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: foregroundColor, size: fontSize + 2),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getHoverColor(Color baseColor) {
    if (baseColor == Colors.transparent) {
      return AppTheme.canvaGray100;
    }
    return Color.alphaBlend(
      AppTheme.canvaBlack.withOpacity(0.1),
      baseColor,
    );
  }
}

enum CanvaButtonStyle { primary, secondary, ghost }
enum CanvaButtonSize { small, medium, large }

// ============= CANVA-STYLE SEARCH BAR =============

class CanvaSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  
  const CanvaSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onFilterTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.canvaWhite,
        borderRadius: AppTheme.radiusMedium,
        border: Border.all(color: AppTheme.canvaGray300, width: 1),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.search,
              color: AppTheme.canvaGray600,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                hintStyle: const TextStyle(
                  color: AppTheme.canvaGray400,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (onFilterTap != null)
            InkWell(
              onTap: onFilterTap,
              borderRadius: AppTheme.radiusMedium,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.tune,
                  color: AppTheme.canvaGray600,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============= CANVA-STYLE TAG/CHIP =============

class CanvaTag extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool isSelected;
  
  const CanvaTag({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.isSelected = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.radiusFull,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (backgroundColor ?? AppTheme.primaryOrange)
              : AppTheme.canvaGray100,
          borderRadius: AppTheme.radiusFull,
          border: isSelected
              ? null
              : Border.all(color: AppTheme.canvaGray300, width: 1),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? (textColor ?? AppTheme.canvaWhite)
                : AppTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

// ============= CANVA-STYLE GRID ITEM =============

class CanvaGridItem extends StatefulWidget {
  final Widget image;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? badge;
  
  const CanvaGridItem({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
    this.onTap,
    this.badge,
  });
  
  @override
  State<CanvaGridItem> createState() => _CanvaGridItemState();
}

class _CanvaGridItemState extends State<CanvaGridItem> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: AppTheme.radiusMedium,
          boxShadow: _isHovered ? AppTheme.canvaShadowLG : AppTheme.canvaShadowSM,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppTheme.radiusMedium,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.canvaWhite,
                borderRadius: AppTheme.radiusMedium,
                border: Border.all(
                  color: _isHovered ? AppTheme.canvaGray300 : AppTheme.canvaGray200,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: widget.image,
                        ),
                      ),
                      if (widget.badge != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: widget.badge!,
                        ),
                    ],
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
