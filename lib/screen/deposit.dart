import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview/widget/elevated_button.dart';
import 'package:interview/widget/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  late SharedPreferences preferences;
  var user = 0;

  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getInt("id")!;
    });
  }

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  final TextEditingController amount = TextEditingController();

  Future<Map<String, dynamic>?> deposit() async {
    try {
      if (amount.text.trim() != "") {
        Map<String, dynamic> data = {
          "amount": double.parse(amount.text.trim()),
          "user": user
        };
        print(data);
        var response = await http.post(
            Uri.parse("${Constants.base_url}transactions/deposit"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${preferences.getString('token')!}'
            },
            body: json.encode(data));
        var body = jsonDecode(response.body);

        if (body['code'] == 200) {
          var balance = body['balance'];
          preferences.setDouble('balance', balance);
          final snackBar = SnackBar(content: Text(body['message']));
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
          setState(() {
            amount.clear();
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
  void dispose() {
    amount.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deposit"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              TextFields(
                  hintText: "amount",
                  iconData: Icons.monetization_on_sharp,
                  label: "Enter amount",
                  controller: amount,
                  obsecure: false,
                  keyboardType: TextInputType.number),
              const SizedBox(
                height: 15,
              ),
              PrimaryButton(
                  onPressed: () {
                    deposit();
                  },
                  title: "Deposit")
            ],
          ),
        ),
      ),
    );
  }
}
