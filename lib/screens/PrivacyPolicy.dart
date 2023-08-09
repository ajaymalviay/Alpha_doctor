import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/foundation.dart';
import '../AllText.dart';
import '../main.dart';
import 'package:http/http.dart'as http;

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  Widget html;

  @override
  void initState() {
    getSettings();
    //loadHtml();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: LIGHT_GREY_SCREEN_BG,
          body: SafeArea(
            child: Stack(
              children: [
                html == null ? Center(
                  child: CircularProgressIndicator(),
                ) :SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                    child: html,
                  ),
                ),
                Container(
                  color: WHITE,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 17,
                          color: BLACK,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        PRIVACY_POLICY,
                        style: TextStyle(
                            color: BLACK,
                            fontWeight: FontWeight.bold,
                            fontSize: 23),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
  var finalResult ;

  getSettings()async{
    var request = http.Request('GET', Uri.parse('$SERVER_ADDRESS/api/setting'));


    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result =  await response.stream.bytesToString();
      finalResult = jsonDecode(result);
      loadHtml();
    }
    else {
      print(response.reasonPhrase);
    }

  }

  loadHtml() async{
    final data = await rootBundle.loadString('assets/tnc.html');
    setState((){
      html = Html(
        data: finalResult['data'][0]['privacy_policy'],
      );
    });
  }
}
