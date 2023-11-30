import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const PrimaryButton(
      {super.key, required this.title, this.onPressed});



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
