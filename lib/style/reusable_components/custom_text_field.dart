import 'package:flutter/material.dart';
import 'package:to_do_app/style/app_colors.dart';

typedef ValidationFunction = String? Function(String?);

class CustomTextField extends StatefulWidget {
  final String label;
  final TextInputType keyword;
  final TextEditingController controller;
  final bool isPassword;
  final ValidationFunction validator;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.keyword,
    required this.controller,
    this.isPassword = false,
    required this.validator,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      obscuringCharacter: '*',
      obscureText: widget.isPassword ? isVisible : false,
      maxLines: widget.maxLines,
      keyboardType: widget.keyword,
      controller: widget.controller,
      style: Theme.of(context).textTheme.titleSmall,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(
                  isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.lightPrimaryColor,
                ),
              )
            : null,
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
