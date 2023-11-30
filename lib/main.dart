import 'package:flutter/material.dart';
import 'package:interview_ui/screen/auth/signup.dart';

import 'constants/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interview App',
      theme: themeData,
      home: const SignUp(),
    );
  }
}
