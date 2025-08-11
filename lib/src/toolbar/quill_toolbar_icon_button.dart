import 'package:flutter/material.dart';

/// A reusable icon button for the Quill toolbar.
class QuillToolbarIconButton extends StatelessWidget {
  const QuillToolbarIconButton({
    required this.onPressed,
    required this.icon,
    required this.isSelected,
    required this.iconTheme,
    this.tooltip,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final bool isSelected;
  final QuillToolbarIconTheme? iconTheme;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isSelected
        ? iconTheme?.iconSelectedColor ?? theme.primaryIconTheme.color
        : iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconSize = iconTheme?.iconSize ?? 18.0;
    final fillColor = isSelected
        ? iconTheme?.iconSelectedFillColor ?? theme.primaryColor.withOpacity(0.1)
        : iconTheme?.iconUnselectedFillColor ?? Colors.transparent;

    final button = Material(
      type: MaterialType.transparency,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: IconButton(
        icon: IconTheme.merge(
          data: IconThemeData(
            color: iconColor,
            size: iconSize,
          ),
          child: icon,
        ),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: fillColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        padding: const EdgeInsets.all(2.0),
        constraints: BoxConstraints(
          minWidth: iconSize * 2,
          minHeight: iconSize * 2,
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }
}

/// Theme for toolbar icons
class QuillToolbarIconTheme {
  const QuillToolbarIconTheme({
    this.iconSize,
    this.iconSelectedColor,
    this.iconUnselectedColor,
    this.iconSelectedFillColor,
    this.iconUnselectedFillColor,
  });

  final double? iconSize;
  final Color? iconSelectedColor;
  final Color? iconUnselectedColor;
  final Color? iconSelectedFillColor;
  final Color? iconUnselectedFillColor;
}
