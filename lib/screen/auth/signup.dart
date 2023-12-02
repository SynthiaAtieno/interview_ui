import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/routes/routes.dart';
import '../../widget/elevated_button.dart';
import '../../widget/textfield.dart';
import '../../widget/top_title.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  TextEditingController nameC = TextEditingController();

  bool isShowPassword = true;
  final isLoading = true;

  Future<Map<String, dynamic>?> register() async {
    if (emailC.text.trim() != "" &&
        nameC.text.trim() != "" &&
        passwordC.text.trim() != "") {
      Map<String, dynamic> data = {
        'name': nameC.text.trim(),
        'email': emailC.text.trim(),
        'password': passwordC.text.trim()
      };

      var response =
          await http.post(Uri.parse("http://192.168.0.14:8080/api/register"),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode(data));
      var body = jsonDecode(response.body);
      if (body['code'] == 200) {
        Routes.instance
            .pushAndRemoveUtil(widget: const Login(), context: context);
      } else {
        final snackBar = SnackBar(content: Text(body['message']));
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackBar);
      }

      return body;
    } else {
      const snackBar = SnackBar(content: Text("Please fill all the fields"));
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopTitles(
                    title: "Create Account",
                    subtitle: "Create an account to continue"),
                const SizedBox(height: 10),
                TextFields(
                    obsecure: false,
                    controller: nameC,
                    hintText: "Name",
                    iconData: Icons.person,
                    label: "Name"),
                const SizedBox(height: 10),
                TextFields(
                    obsecure: false,
                    controller: emailC,
                    hintText: "Email",
                    iconData: Icons.email,
                    label: "Email"),
                const SizedBox(height: 10),
                TextFields(
                  obsecure: true,
                  controller: passwordC,
                  hintText: "Password",
                  iconData: Icons.lock,
                  label: "Password",
                  suffixIconData:
                      !isShowPassword ? Icons.visibility : Icons.visibility_off,
                  onTap: () {
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                    onPressed: () {
                      register();
                    },
                    title: "SignUp"),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Routes.instance.pushAndRemoveUtil(
                          widget: const Login(), context: context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
