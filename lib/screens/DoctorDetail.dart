import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complete_women_care/AllText.dart';
import 'package:complete_women_care/modals/DoctorDetails.dart';
import 'package:complete_women_care/screens/AutoselectBookAppointment.dart';
import 'package:complete_women_care/screens/ChatScreen.dart';
import 'package:complete_women_care/screens/LoginScreen.dart';
import 'package:complete_women_care/screens/ReviewScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;

import '../main.dart';
import '../modals/DocterProfileModel.dart';

class DoctorDetails extends StatefulWidget {
  final int id;

  DoctorDetails(this.id);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  DoctorDetail doctorDetail;
  List<String> weekDaysList = [
    SUNDAY,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
  ];
  bool isLoggedIn = false;
  DocterProfileModel homeDocterProfile;

  @override
  void initState() {
    super.initState();
   Future.delayed(Duration(seconds: 1),(){
     return getProfile();
   });
    fetchDoctorDetails();

    SharedPreferences.getInstance().then((value) {
      isLoggedIn = value.getBool("isLoggedIn") ?? false;
    });
  }

  getProfile() async {
    var request = http.Request('GET', Uri.parse('${SERVER_ADDRESS}/api/profile'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var NewResponce = DocterProfileModel.fromJson(jsonDecode(result));
      print("this is a responce===========>${NewResponce.toString()}");
      setState(() {
        homeDocterProfile = NewResponce;
        print("this is a new111111111==========>${homeDocterProfile.data.email}");

      });
    }
    else {
    print(response.reasonPhrase);
    }

  }

  getDocterProgile() async {
    var request = http.Request('GET', Uri.parse('${SERVER_ADDRESS}/api/profile'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var NewResponce = DocterProfileModel.fromJson(jsonDecode(result));
      print(" this is a responce===========>${NewResponce.toString()}");
      setState(() {
        homeDocterProfile = NewResponce;
        print("this is a new==========>${homeDocterProfile.data.email}");

      });
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {
    return doctorDetail == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            color: WHITE,
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: LIGHT_GREY_SCREEN_BG,
              appBar: AppBar(
                leading: Container(),
                backgroundColor: WHITE,
                flexibleSpace: header(),
              ),
              body: body(),
            ),
          );
  }

  header() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                          color: BLACK,
                        ),
                        constraints: BoxConstraints(maxWidth: 30, minWidth: 10),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.57,
                          child: Text(
                            doctorDetail.data.name,
                            style: TextStyle(
                              color: BLACK, fontSize: 22, fontWeight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: ()  =>launch('${homeDocterProfile.data.phoneNo}'),
                      // {
                      //   _makeCall(doctorDetail.data.phoneNo);
                      // },
                      child: Image.asset(
                        "assets/doctordetails/Phone.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () =>launch('${homeDocterProfile.data.email}'),
                      // {
                      //   _sendEmail(homeDocterProfile.data.email);
                      // },
                      child: Image.asset(
                        "assets/doctordetails/email.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  body() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                doctorProfileCard(),
                workingTimeAndServiceCard(),
              ],
            ),
          ),
        ),
        bottomButtons(),
      ],
    );
  }

  doctorProfileCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    height: 90,
                    width: 110,
                    fit: BoxFit.cover,
                    imageUrl: Uri.parse(doctorDetail.data.image).toString(),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                            height: 75,
                            width: 75,
                            child: Center(child: Icon(Icons.image))),
                    errorWidget: (context, url, error) => Container(
                      height: 75,
                      width: 75,
                      child: Center(
                        child: Icon(Icons.broken_image_rounded),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                height: 91,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorDetail.data.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        Text(
                          doctorDetail.data.departmentName,
                          style: TextStyle(color: NAVY_BLUE, fontSize: 10),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewScreen(
                                    doctorDetail.data.userId.toString())));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                doctorDetail.data.ratting > 0
                                    ? "assets/doctordetails/star_active.png"
                                    : "assets/doctordetails/star_unactive.png",
                                height: 12,
                                width: 12,

                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                doctorDetail.data.ratting > 1
                                    ? "assets/doctordetails/star_active.png"
                                    : "assets/doctordetails/star_unactive.png",
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                doctorDetail.data.ratting > 2
                                    ? "assets/doctordetails/star_active.png"
                                    : "assets/doctordetails/star_unactive.png",
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                doctorDetail.data.ratting > 3
                                    ? "assets/doctordetails/star_active.png"
                                    : "assets/doctordetails/star_unactive.png",
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                doctorDetail.data.ratting > 4
                                    ? "assets/doctordetails/star_active.png"
                                    : "assets/doctordetails/star_unactive.png",
                                height: 12,
                                width: 12,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "See all reviews",
                            style:
                                TextStyle(color: LIGHT_GREY_TEXT, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launchURL(doctorDetail.data.facebookId);
                          },
                          child: Image.asset(
                            "assets/doctordetails/facebook.png",
                            height: 15,
                            width: 15,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL(doctorDetail.data.twitterId);
                          },
                          child: Image.asset(
                            "assets/doctordetails/twitter.png",
                            height: 15,
                            width: 15,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL(doctorDetail.data.googleId);
                          },
                          child: Image.asset(
                            "assets/doctordetails/google+.png",
                            height: 15,
                            width: 15,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL(doctorDetail.data.instagramId);
                          },
                          child: Image.asset(
                            "assets/doctordetails/instagram.png",
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            doctorDetail.data.aboutUs,
            style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 11),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  workingTimeAndServiceCard() {
    return Container(
      color: WHITE,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            WORKING_TIME,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 3,
                mainAxisSpacing: 5),
            itemCount: doctorDetail.data.timeTabledata.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Image.asset("assets/doctordetails/free-time.png"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weekDaysList[
                            int.parse(doctorDetail.data.timeTabledata[index].day.toString()) - 1],
                            // int.parse(doctorDetail.data.timeTabledata[index].day) - 1],
                        style: TextStyle(
                            color: NAVY_BLUE,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        doctorDetail.data.timeTabledata[index].from +
                            " to " +
                            doctorDetail.data.timeTabledata[index].to,
                        style: TextStyle(
                          color: LIGHT_GREY_TEXT,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            SERVICES,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            doctorDetail.data.service,
            style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  bottomButtons() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          isLoggedIn
              ? InkWell(
                  onTap: () {
                    print("doctorDetail.data.userId ${doctorDetail.data.userId}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                doctorDetail.data.name,
                                doctorDetail.data.userId.toString())));
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.fromLTRB(0, 5, 6, 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: LIME,
                    ),
                    child: Image.asset("assets/doctordetails/review.png"),
                  ),
                )
              : Container(),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => isLoggedIn
                            ? AutoselectBookAppointment(
                                // int.parse(doctorDetail.data.departmentId),
                                doctorDetail.data.departmentId,
                                doctorDetail.data.name,
                                doctorDetail.data.departmentName,
                                // int.parse(doctorDetail.data.userId),
                                doctorDetail.data.userId,
                              )
                            : LoginScreen()));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(6, 5, 12, 15),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: LIME,
                ),
                child: Center(
                  child: Text(
                    isLoggedIn ? BOOK_APPOINTMENT : LOGIN_TO_BOOK_APPOINTMENT,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: WHITE),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  fetchDoctorDetails() async {
    final response = await get(Uri.parse("$SERVER_ADDRESS/api/doctordetails?id=${widget.id}"));
    print(Uri.parse("$SERVER_ADDRESS/api/doctordetails?id=${widget.id}"));

    print(response.request);

    final jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      setState(() {
        doctorDetail = DoctorDetail.fromJson(jsonResponse);
      });
      print("doctorDetail ${doctorDetail}");
    }
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendEmail(email) {
    launch(Uri(
      scheme: 'mailto',
      path: email,
    ).toString());
  }

  _makeCall(email) {
    launch(Uri(
      scheme: 'tel',
      path: email,
    ).toString());
  }
}
