import 'package:flutter/material.dart';
import 'package:interview/constants/routes/routes.dart';
import 'package:interview/data/menu_items.dart';
import 'package:interview/model/menuItem.dart';
import 'package:interview/screen/auth/login.dart';
import 'package:interview/screen/deposit.dart';
import 'package:interview/screen/withdraw.dart';
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
  String name = '';
  double balance = 0.0;

  void initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name')!;
      balance = preferences.getDouble('balance')!;
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: height * 0.25,
                  width: width,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blueGrey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 0, right: 8, bottom: 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ClipRRect(
                            child: Image.asset(
                          "assets/images/profile.png",
                          height: 80,
                        )),
                        Positioned(
                            bottom: 0,
                            child: Column(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: PopupMenuButton<MenuItem>(
                                color: Colors.white,
                                onSelected: (item) => onSelected(context, item),
                                itemBuilder: (context) => [
                                  ...MenuItems.items.map(buildItem).toList()
                                ],
                              ),
                            ))
                      ],
                    ),
                  )),
              Container(
                height: height * 0.75,
                width: width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Routes.instance.push(
                                widget: const Deposit(), context: context);
                          },
                          child: const Text("deposit")),
                      TextButton(
                        onPressed: () {
                          Routes.instance
                              .push(widget: const Withdraw(), context: context);
                        },
                        child: const Text("Withdraw"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) {
    return PopupMenuItem<MenuItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.iconData,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(item.text)
          ],
        ));
  }

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemSignOut:
        showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        preferences.clear();
        Routes.instance
            .pushAndRemoveUtil(widget: const Login(), context: context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
