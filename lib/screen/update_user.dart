import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview/widget/elevated_button.dart';
import 'package:interview/widget/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();


}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController emailC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  TextEditingController nameC = TextEditingController();

  late String email;
  late SharedPreferences preferences;


  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email')!;
    });
  }

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  Future<Map<String, dynamic>?> update() async {
    try {
      if (nameC.text.trim() != "" && passwordC.text.trim() !="") {
        Map<String, dynamic> data = {
          "email":email,
          "name": nameC.text.trim(),
          "password": passwordC.text.trim()
        };
        print(data);
        var response = await http.post(
            Uri.parse("${Constants.base_url}users/update"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${preferences.getString('token')!}'
            },
            body: json.encode(data));
        var body = jsonDecode(response.body);

        if (body['code'] == 200) {
          final snackBar = SnackBar(content: Text(body['message']));
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
          setState(() {
            nameC.clear();
            passwordC.clear();
          });
        } else {
          setState(() {
            //isLoading = false;
          });
          final snackBar = SnackBar(content: Text(body['message']));
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
        return body;
      } else {
        const snackBar = SnackBar(content: Text("Please fill the amount"));
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update"),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFields(
                  hintText: "Name",
                  iconData: Icons.person,
                  label: "Update Name",
                  controller: nameC,
                  obsecure: false,
                  keyboardType: TextInputType.name),
              const SizedBox(height: 10,),
              TextFields(
                  hintText: "Password",
                  iconData: Icons.lock,
                  label: "Update Password",
                  controller: passwordC,
                  obsecure: false,
                  keyboardType: TextInputType.visiblePassword),
              const SizedBox(height: 10,),
              PrimaryButton(
                  onPressed: (){
                    update();
                  },
                  title: "Update")
            ],
          ),
        ),
      ),
    );
  }
}
