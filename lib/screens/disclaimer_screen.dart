import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api_model/disclaimer_model.dart';
import 'package:http/http.dart'as http;

import '../main.dart';
class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({Key key}) : super(key: key);

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {


bool isLoding=true;
  DisclaimerDataModel disclaimerDataModel;
  Future<void> disclaimerData() async {
    setState(() {
      isLoding =true;
    });
    var request = http.Request('GET', Uri.parse('$SERVER_ADDRESS/api/setting'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var Result = await response.stream.bytesToString();
      final finalResult = DisclaimerDataModel.fromJson(json.decode(Result));
      setState(() {
        disclaimerDataModel = finalResult;
      });
      setState(() {
        isLoding=false;
      });
    }
    else {
    print(response.reasonPhrase);
    }



  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    disclaimerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white ,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text('Disclaimer ',style: TextStyle(color:Colors.black,fontSize:20,fontWeight: FontWeight.bold),),
      ),
      body:isLoding==false?Column(
        children: [
          disclaimerDataModel.data==""||disclaimerDataModel.data==null? Center(child: Text("Not Data Found ",style: TextStyle(color: Colors.red),)):Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: disclaimerDataModel.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left:10.0,right: 10,top:20),
                  child: Container(
                    height: MediaQuery.of(context).size.height/1,
                    width:MediaQuery.of(context).size.width/1,
                    child: Text('${disclaimerDataModel.data[index].disclaimer}',style: TextStyle(fontWeight: FontWeight.w500,),),
                  ),
                );
                // priceCard(index, healthPackage.data);
              },
            ),
          ),
        ],
      ):Center(child: CircularProgressIndicator())
    );
  }
}
