import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_model/notification_model.dart';
import '../main.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String userId;
bool isLoding=true;

  GetNotificationModel getNotificationData;

  Future<void> getNotification ()async {
    setState(() {
      isLoding=true;
    });
    var request = http.MultipartRequest('GET', Uri.parse('$SERVER_ADDRESS/api/userNotification?user_id=${userId}'));
    request.fields.addAll({
      'user_id': '${userId}'
    });
    print('==============${request.fields}');
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var Result = await response.stream.bytesToString();
      final finalResult = GetNotificationModel.fromJson(json.decode(Result));
      setState(() {
        getNotificationData = finalResult;
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
    SharedPreferences.getInstance().then((value) {
      userId = value.getInt("id").toString();
      print('-------------${userId}');
      getNotification ();
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Colors.white,
        leading: InkWell(
            onTap: () {
             Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text("Notification",style: TextStyle(color: Colors.black),),
      ),
      body:getNotificationData?.results==''|| getNotificationData?.results==null? Center(child: Text('Data not found')):Column(
        children: [
          isLoding==false?ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: getNotificationData.results.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left:10.0,right: 10,top:20),
                child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text('Id :',style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
                              SizedBox(width: 10,),
                              Text('${getNotificationData.results[index].id}',style: TextStyle(fontWeight: FontWeight.w500,),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                              width: MediaQuery.of(context).size.width/1,
                              child: Text('${getNotificationData.results[index].message}',overflow:TextOverflow.ellipsis,maxLines:4,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),)),
                          SizedBox(height: 10,),
                        ],
                      ),
                    )),
              );
              // priceCard(index, healthPackage.data);
            },
          ):Center(child: CircularProgressIndicator())
        ],
      )
    );
  }
}
