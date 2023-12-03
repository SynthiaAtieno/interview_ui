import 'package:flutter/material.dart';
import 'package:interview/constants/routes/routes.dart';
import 'package:interview/screen/auth/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String email;
  late SharedPreferences preferences;
  @override
  void initState() {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['sub'];
    initSharedPref();
    super.initState();
  }
  void initSharedPref() async{
    preferences = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Welcome home $email"),
          ),
          ElevatedButton(onPressed: (){
            preferences.clear();
            Routes.instance.pushAndRemoveUtil(widget: const Login(), context: context);
          }, child: const Text("SignOut"))
        ],
      ),
    );
  }
}
