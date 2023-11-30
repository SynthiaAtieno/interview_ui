import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview_ui/screen/auth/signup.dart';

import '../../constants/routes/routes.dart';
import '../../widget/elevated_button.dart';
import '../../widget/textfield.dart';
import '../../widget/top_title.dart';
import '../homepage.dart';

import 'package:http/http.dart' as http;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = true;

  Future<Map<String, dynamic>> login() async {
    Map<String, dynamic> data = {
      'username': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };
    var response = await http.post(Uri.parse("http:192.168.42.154:8080/api/login"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data));
    return jsonDecode(response.body);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopTitles(
                    title: "Login", subtitle: "Welcome back to Your Account"),
                const SizedBox(height: 8),
                TextFields(
                  obsecure: false,
                  controller: emailController,
                  hintText: "Email",
                  iconData: Icons.email,
                  label: "Email",
                ),
                const SizedBox(height: 16),
                TextFields(
                  obsecure: isShowPassword,
                  controller: passwordController,
                  hintText: "Password",
                  iconData: Icons.lock,
                  suffixIconData: !isShowPassword ? Icons.visibility : Icons.visibility_off,
                  label: "Password",
                  onTap: (){
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                PrimaryButton(title: "LOGIN", onPressed: () {
                  login();
                  Routes.instance.pushAndRemoveUtil(widget: const HomePage(), context: context);
                }),
                const SizedBox(
                  height: 6,
                ),
                const Center(
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    )),
                Center(
                    child: TextButton(
                      onPressed: () {
                        Routes.instance.pushAndRemoveUtil(widget: const SignUp(), context: context);
                        //Routes.instance.push(widget:  SignUp(), context: context);
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(fontSize: 14,color: Theme.of(context).primaryColor),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
