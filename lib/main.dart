import 'package:flutter/material.dart';
import 'package:interview/screen/auth/login.dart';
import 'package:interview/screen/homepage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if(preferences.getString('token') == null){
    runApp(const MyApp(token: null,));
    print('token has expired');
  }else {
    runApp(MyApp(token: preferences.getString('token'),));
  }
}


class MyApp extends StatefulWidget {
  final String? token;
   const MyApp( {this.token,Key? key}): super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interview App',
      theme: themeData,
      home: widget.token != null ? HomePage(token: widget.token!) : const Login(),
    );
  }
}
