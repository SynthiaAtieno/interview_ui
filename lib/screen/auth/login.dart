import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:interview/constants/constatnts.dart';
import 'package:interview/screen/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoading = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<Map<String, dynamic>?> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (emailController.text.trim() != "" &&
          passwordController.text.trim() != "") {
        if (Constants.emailRegex(emailController.text.trim())) {
          Map<String, dynamic> data = {
            'username': emailController.text.trim(),
            'password': passwordController.text.trim(),
          };
          var response =
              await http.post(Uri.parse("${Constants.base_url}login"),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                  },
                  body: json.encode(data));
          var body = jsonDecode(response.body);

          setState(() {
            isLoading = false;
          });

          if (body['code'] == 200) {
            var token = body['token'];
            var uid = body['user']['id'];
            var name = body['user']['name'];
            prefs.setString('token', token);
            prefs.setString('name', name);
            prefs.setInt("id", uid);
            Routes.instance.pushAndRemoveUtil(
                widget: HomePage(
                  token: token,
                ),
                context: context);
          } else {
            setState(() {
              isLoading = false;
            });
            final snackBar = SnackBar(content: Text(body['message']));
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
          return body;
        } else {
          setState(() {
            isLoading = false;
          });
          const snackBar =
              SnackBar(content: Text("Please enter a valid email address"));
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        const snackBar = SnackBar(content: Text("Please fill all the fields"));
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
      //print(e.toString());
    }

    print("object");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (isLoading) ...[
            const Center(
              child: CircularProgressIndicator(),
            )
          ],
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TopTitles(
                        title: "Login",
                        subtitle: "Welcome back to Your Account"),
                    const SizedBox(height: 8),
                    TextFields(
                      keyboardType: TextInputType.emailAddress,
                      obsecure: false,
                      controller: emailController,
                      hintText: "Email",
                      iconData: Icons.email,
                      label: "Email",
                    ),
                    const SizedBox(height: 16),
                    TextFields(
                      keyboardType: TextInputType.visiblePassword,
                      obsecure: isShowPassword,
                      controller: passwordController,
                      hintText: "Password",
                      iconData: Icons.lock,
                      suffixIconData: !isShowPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      label: "Password",
                      onTap: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    PrimaryButton(
                        title: "LOGIN",
                        onPressed: () {
                          login();
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
                        Routes.instance.pushAndRemoveUtil(
                            widget: const SignUp(), context: context);
                        //Routes.instance.push(widget:  SignUp(), context: context);
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
