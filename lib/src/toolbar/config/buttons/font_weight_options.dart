import 'package:flutter/material.dart';

import '../../../document/attributes/font_weight_attribute.dart';
import '../base_button_options.dart';

@immutable
/// Options for the font weight dropdown button in the toolbar
class QuillToolbarFontWeightButtonOptions
    extends QuillToolbarBaseButtonOptions<
        QuillToolbarFontWeightButtonOptions,
        QuillToolbarFontWeightButtonExtraOptions> {
  const QuillToolbarFontWeightButtonOptions({
    super.iconSize,
    super.iconButtonFactor,
    this.items = const {
      '100': 100,
      '200': 200,
      '300': 300,
      '400': 400,
      '500': 500,
      '600': 600,
      '700': 700,
      '800': 800,
      '900': 900,
    },
    this.onSelected,
    this.attribute = const FontWeightAttribute(400),
    super.afterButtonPressed,
    super.tooltip,
    this.padding,
    this.style,
    this.initialValue,
    this.labelOverflow = TextOverflow.visible,
    super.childBuilder,
    this.shape,
    this.defaultDisplayText,
    this.width,
  });

  final ButtonStyle? shape;
  final Map<String, int> items;
  final ValueChanged<int>? onSelected;
  final FontWeightAttribute attribute;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final String? initialValue;
  final TextOverflow labelOverflow;
  final String? defaultDisplayText;
  final double? width;
}

class QuillToolbarFontWeightButtonExtraOptions
    extends QuillToolbarBaseButtonExtraOptions {
  const QuillToolbarFontWeightButtonExtraOptions({
    required super.controller,
    required this.currentValue,
    required this.defaultDisplayText,
    required super.context,
    required super.onPressed,
  });

  final int currentValue;
  final String defaultDisplayText;
}
