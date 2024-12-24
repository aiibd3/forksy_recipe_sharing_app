import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final Icon? suffixIcon;

  const PhoneTextField(
      {super.key,
      required this.hintText,
      required this.validator,
      required this.controller,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: MyCustomTextField(
            hintText: hintText,
            typeOfKeyboard: TextInputType.phone,
            controller: controller,
            validator: validator,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class MyCustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType typeOfKeyboard;
  final Icon? suffixIcon;
  final String? Function(String?) validator;

  const MyCustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.typeOfKeyboard = TextInputType.text,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: typeOfKeyboard,
      controller: controller,
      validator: validator,
      style: const TextStyle(
        color: Colors.black,
        // fontFamily: context.fontFamily,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        errorBorder: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
          // fontFamily: context.fontFamily,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType typeOfKeyboard;
  final String? Function(String?) validator;

  const PasswordTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.typeOfKeyboard = TextInputType.text,
    required this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.typeOfKeyboard,
      controller: widget.controller,
      obscureText: obscureText,
      validator: widget.validator,
      style: const TextStyle(
        color: Colors.black,
        // fontFamily: context.fontFamily,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        errorBorder: _buildOutlineInputBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildOutlineInputBorder(),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
          // fontFamily: context.fontFamily,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primaryColor,
          ),
        ),
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
