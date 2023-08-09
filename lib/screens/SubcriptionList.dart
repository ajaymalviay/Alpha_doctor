import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complete_women_care/modals/SubscriptionListClass.dart';
import 'package:complete_women_care/screens/ChatList.dart';
import 'package:complete_women_care/screens/PlaceHolderScreen.dart';

import '../AllText.dart';
import '../main.dart';

class SubcriptionList extends StatefulWidget {
  @override
  _SubcriptionListState createState() => _SubcriptionListState();
}

class _SubcriptionListState extends State<SubcriptionList> {
  SubscriptionListClass subscriptionListClass;
  int userId;
  bool isLoading = true;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');




  @override
  void initState()
  {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      userId = value.getInt("id");
      if (userId != null) {
        fetchSubscriptions();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: AppBar(
          backgroundColor: WHITE,
          flexibleSpace: header(),
          leading: Container(),
        ),
        body:body(),
      ),
    );
  }

  header() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                InkWell(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: BLACK,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatList()));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  MY_SUBCRIPTIONS,
                  style: TextStyle(
                      color: BLACK, fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  body() {
    return isLoading
        ? Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    )
        : subscriptionListClass == null || subscriptionListClass == ""
        ? PlaceHolderScreen(
      iconPath: "assets/placeholders/subscription_holder.png",
      description: YOUR_SUBSCRIPTIONS_WILL_BE_DISPLAYED_HERE,
      message: NO_SUBSCRIPTIONS_FOUND,
    )
        : ListView.builder(
      itemCount: subscriptionListClass.results.data.length,
      itemBuilder: (context, index) {
        return subscriptionCard(index);
      },
    );
  }

  subscriptionCard(int index) {

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 2),
      decoration: BoxDecoration(
        color: LIGHT_GREY,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subscriptionListClass.results.data[index].name.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              // Container(
              //   height: 22,
              //   width: 70,
              //   decoration: BoxDecoration(
              //     color: Colors.green,
              //     borderRadius: BorderRadius.circular(5),
              //   ),
              //   child: Center(
              //     child: Text(
              //       subscriptionListClass.results.data[index].status=="5"?Text('Completed'): subscriptionListClass.results.data[index].status=="6"?Text('Refund'):
              //       subscriptionListClass.results.data[index].status=="4"?Text('Inprogress'):subscriptionListClass.results.data[index].status=="3"?Text('Cancel'):
              //       subscriptionListClass.results.data[index].status=="2"?Text('Accept'):subscriptionListClass.results.data[index].status=="1"?Text('Received')
              //
              //       style: TextStyle(color: WHITE, fontSize: 10),
              //     ),
              //   ),
              // )
            ],
          ),
          SizedBox(
            height: 13,
          ),
          Row(
            children: [
              Image.asset(
                "assets/subscriptionList/calender.png",
                height: 15,
                width: 15,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                subscriptionListClass.results.data[index].date.toString(),
                style: TextStyle(color: NAVY_BLUE, fontSize: 10),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "assets/subscriptionList/clock.png",
                height: 15,
                width: 15,
                fit: BoxFit.fill,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                subscriptionListClass.results.data[index].time.toString(),
                style: TextStyle(color: NAVY_BLUE, fontSize: 10),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                "$CURRENCY${ subscriptionListClass.results.data[index].amount}/month",
                style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 13),
              ),
              SizedBox(width: 20,),
              subscriptionListClass.results.data[index].packagedata?.time==null||subscriptionListClass.results.data[index].packagedata?.time==""?Text('Not found'):
              Text(
                "${subscriptionListClass.results.data[index].packagedata?.time}",
                style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 13),
              ),
              subscriptionListClass.results.data[index].packagedata?.time==null||subscriptionListClass.results.data[index].packagedata?.time==""?SizedBox():
              Text(
                "${subscriptionListClass.results.data[index].packagedata?.type}",
                style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 13),
              ),
              SizedBox(width: 10,),
              Text(
                "Expire :",
                style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 13),
              ),
              SizedBox(width: 10,),
              subscriptionListClass.results.data[index].packagedata?.time==null||subscriptionListClass.results.data[index].expire==""?Text('Not found'):
              Container(
                width:110,
                height: 20,
                child: Text(
                  "${subscriptionListClass.results.data[index].expire}",
                  style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 13),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
  DateTime myExpireDate;
  var currDate;
  bool PlayVideo = false;
  fetchSubscriptions() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/mysubscription?user_id=$userId"));
    print("ssssss ${response.request.url}");
    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      setState(() {
        subscriptionListClass = SubscriptionListClass.fromJson(jsonResponse);
      });

      List <Data> ExpireData = subscriptionListClass.results?.data;
      for(var i=0; i<ExpireData.length;i++){
        myExpireDate = ExpireData[i].expire;
        if(myExpireDate.isAfter(DateTime.now())){
          setState(() {
            PlayVideo = true;
          });

        }else{
          setState(() {
            PlayVideo = false;
          });
        }
        print('77777777777777777${myExpireDate}');
        //if()
      }
      SharedPreferences prefer = await SharedPreferences.getInstance();
      prefer.setString('play_video',PlayVideo.toString());

      print('--------------playyyy-------------${PlayVideo}');

    } else {
      print("ERROR : $jsonResponse");
    }
    setState(() {
      isLoading = false;
    });
  }





}
