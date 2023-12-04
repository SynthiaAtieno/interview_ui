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
  String name ='';
  void initSharedPref() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name')!;
    });

  }
  @override
  void initState() {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['sub'];
    initSharedPref();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: kToolbarHeight,),
          Container(

              width: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle
              ),
              child: Column(
            children:  [
              Container(
              padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/profile.png"),
                  fit: BoxFit.fill),
            ),),
              Text(name, style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300),),
              Text(email, style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          )),
          ElevatedButton(onPressed: (){
            preferences.clear();
            Routes.instance.pushAndRemoveUtil(widget: const Login(), context: context);
          }, child: const Text("SignOut"))
        ],
      ),
    );
  }
}
