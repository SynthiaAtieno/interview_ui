import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final String hintText, label;
  final IconData iconData;
  final IconData? suffixIconData;
  final TextEditingController controller;
  final bool obsecure;
  final keyboardType;
  final void Function()? onTap;
  const TextFields({super.key, required this.hintText, required this.iconData, this.suffixIconData, required this.label, required this.controller, required this.obsecure, this.onTap, required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obsecure,
      decoration: InputDecoration(
          hintText: hintText,
          label: Text(label),
          prefixIcon: Icon(iconData, color: Colors.grey,),
          suffixIcon: GestureDetector(
            onTap: onTap,
              child: Icon(suffixIconData, color: Colors.grey,)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0
              ),
          ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0
          ),
        )
      ),
    );
  }
}
