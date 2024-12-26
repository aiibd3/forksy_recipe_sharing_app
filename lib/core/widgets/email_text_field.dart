import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final Icon? suffixIcon;

  const EmailTextField({
    super.key,
    required this.hintText,
    this.controller,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      validator: validator,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        errorBorder: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        suffixIcon: suffixIcon, // Add the suffixIcon to the InputDecoration
      ),
    );
  }
}

OutlineInputBorder _buildOutlineInputBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );
}
