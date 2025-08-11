import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../quill_toolbar_icon_button.dart';

/// A reusable icon button for the Quill toolbar.
///
/// This widget is used internally by various toolbar buttons to maintain
/// consistent styling and behavior.
class QuillToolbarIconButton extends StatelessWidget {
  const QuillToolbarIconButton({
    super.key,
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.isSelected = false,
    this.iconTheme,
  });

  /// The icon to display in the button.
  final Widget icon;

  /// The tooltip to show when the button is long-pressed.
  final String? tooltip;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether the button should be shown as selected.
  final bool isSelected;

  /// The theme to use for the icon.
  final QuillToolbarIconTheme? iconTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = isSelected
        ? (iconTheme?.iconSelectedColor ?? theme.colorScheme.primary)
        : (iconTheme?.iconUnselectedColor ?? theme.iconTheme.color);
    final fillColor = isSelected
        ? (iconTheme?.iconSelectedFillColor ??
            theme.colorScheme.primary.withOpacity(0.1))
        : (iconTheme?.iconUnselectedFillColor ?? Colors.transparent);

    final button = Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: IconButton(
        icon: icon,
        color: iconColor,
        hoverColor: theme.hoverColor,
        highlightColor: theme.highlightColor,
        splashColor: theme.splashColor,
        padding: const EdgeInsets.all(4.0),
        constraints: const BoxConstraints(
          minWidth: 32.0,
          minHeight: 32.0,
        ),
        onPressed: onPressed,
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
