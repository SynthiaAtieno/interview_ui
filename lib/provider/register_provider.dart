import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../constants/routes/routes.dart';
import '../screen/auth/login.dart';

class RegisterProvider extends ChangeNotifier{
  TextEditingController emailC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  TextEditingController nameC = TextEditingController();

  String error = '';
  bool isLoading = true;

  get context => null;

  Future<Map<String, dynamic>?> register() async {
    try{
      if(emailC.text.trim() != "" && nameC.text.trim() !="" && passwordC.text.trim() != ""){
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
        var body = jsonDecode(response.body);
        if(body['code'] == 200){
          Routes.instance.pushAndRemoveUtil(widget: const Login(), context: context);
        }
        else{
          print("message");
          print(body['message']);
        }

        return body;


      }else{
        isLoading = false;
        notifyListeners();
        error = "Please fill all the fields";
        return null;
      }
    }
    catch(e){
      e.toString();
    }
    isLoading = false;
    notifyListeners();

  }
  // getProducts() async{
  //
  //   try{
  //     final uri = Uri.parse(endpoint);
  //     Response response = await http.get(uri);
  //     if(response.statusCode == 200){
  //
  //       products = productsFromJson(response.body);
  //     }else{
  //       error = response.statusCode.toString();
  //     }
  //   }
  //   catch(e){
  //     e.toString();
  //   }
  // 
  // }



}