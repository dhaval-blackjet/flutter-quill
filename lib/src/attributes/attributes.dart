import 'package:flutter_quill/flutter_quill.dart';
import '../document/attributes/font_weight_attribute.dart';

/// Initialize all custom attributes for Quill editor
void initializeQuillAttributes() {
  // Register the font weight attribute
  FontWeightAttribute.register();
  
  // Add any additional attribute registrations here
}
