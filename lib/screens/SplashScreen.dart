import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complete_women_care/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token = "";

  @override
  void initState() {
    super.initState();
    openHomeScreen();
  }

  openHomeScreen() async {
    token = await FirebaseMessaging.instance.getToken();
    SharedPreferences.getInstance().then((value) async {
      if (value.getBool("isTokenExist") ?? false) {
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TabBarScreen()),
          );
        });
      } else {
        print(Uri.parse("$SERVER_ADDRESS/api/savetoken"));
        final response =
            await post(Uri.parse("$SERVER_ADDRESS/api/savetoken"), body: {
          "token": token,
          "type": "1",
        });

        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (response.statusCode == 200 && jsonResponse['status'] == 1) {
          value.setBool("isTokenExist", true);
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TabBarScreen()),
            );
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: NAVY_BLUE,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/splashScreen/icon.png",
            height: 250,
            width: 250,
            // color: NAVY_BLUE,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " ",
                style: TextStyle(
                    color:NAVY_BLUE, fontSize: 35, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " ",
                style: TextStyle(
                  color: WHITE,
                  fontSize: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
