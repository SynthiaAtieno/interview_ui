import 'dart:convert';

import 'package:flutter/material.dart';

import '../../constants/routes/routes.dart';
import '../../model/register.dart';
import '../../widget/elevated_button.dart';
import '../../widget/textfield.dart';
import '../../widget/top_title.dart';
import '../homepage.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final emailC = TextEditingController();

  final passwordC = TextEditingController();

  final nameC = TextEditingController();

  bool isShowPassword = true;

  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    Map<String, dynamic> data = {
      'name': nameC.text.trim(),
      'email': emailC.text.trim(),
      'password': passwordC.text.trim()
    };

    var response = await http.post(Uri.parse("http://192.168.42.154:8080/api/register"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data));


    print("response");
    print(response.body);
    return jsonDecode(response.body);
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
                  suffixIconData: !isShowPassword ? Icons.visibility : Icons.visibility_off,
                  onTap: (){
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                ),
                const SizedBox(height: 18),
                PrimaryButton(onPressed: () {
                  register(emailC.text.trim(), passwordC.text.trim(), nameC.text.trim());
                  Routes.instance.pushAndRemoveUtil(widget: const HomePage(), context: context);
                }, title: "SignUp"),
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
                      Routes.instance.pushAndRemoveUtil(widget: const Login(), context: context);},
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
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
