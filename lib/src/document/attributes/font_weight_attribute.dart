import 'package:flutter_quill/flutter_quill.dart' show Attribute, AttributeScope;

/// Custom attribute for font weight (100-900)
class FontWeightAttribute extends Attribute<int> {
  const FontWeightAttribute(int value)
      : super('fontWeight', AttributeScope.inline, value);

  Attribute<int> withValue(int value) => FontWeightAttribute(value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FontWeightAttribute && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'FontWeightAttribute(value: $value)';

  // Register the attribute with Quill
  static void register() {
    // No need to manually register as Attribute handles it via the constructor
  }
}

// Initialize the font weight attribute
void initializeFontWeightAttribute() {
  // No-op as registration is handled by the Attribute constructor
}

/// Extension to add font weight attribute constants
extension FontWeightAttributeExtension on Attribute {
  static FontWeightAttribute fontWeight(int value) => FontWeightAttribute(value);

  static const FontWeightAttribute fontWeight100 = FontWeightAttribute(100);
  static const FontWeightAttribute fontWeight200 = FontWeightAttribute(200);
  static const FontWeightAttribute fontWeight300 = FontWeightAttribute(300);
  static const FontWeightAttribute fontWeight400 = FontWeightAttribute(400);
  static const FontWeightAttribute fontWeight500 = FontWeightAttribute(500);
  static const FontWeightAttribute fontWeight600 = FontWeightAttribute(600);
  static const FontWeightAttribute fontWeight700 = FontWeightAttribute(700);
  static const FontWeightAttribute fontWeight800 = FontWeightAttribute(800);
  static const FontWeightAttribute fontWeight900 = FontWeightAttribute(900);
}
