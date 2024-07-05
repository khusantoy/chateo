import 'package:flutter/material.dart';

class TextformfieldItem extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  const TextformfieldItem({
    super.key,
    required this.labelText,
    required this.textEditingController,
    required this.validator,
    required this.textInputType,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
