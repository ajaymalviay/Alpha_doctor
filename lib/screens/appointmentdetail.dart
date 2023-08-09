import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:complete_women_care/AllText.dart';
import 'package:complete_women_care/main.dart';
import 'package:complete_women_care/modals/UpcomingAppointmrnts.dart';
import 'package:complete_women_care/modals/ViewPrescription.dart';
import 'package:complete_women_care/screens/ChatScreen.dart';
import 'package:http/http.dart'as http;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modals/DocterProfileModel.dart';
import 'CustomButtonWithIcon.dart';

class AppointmentDetailScreen extends StatefulWidget {
  InnerData upcomingList;
  AppointmentDetailScreen({this.upcomingList});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1),(){
      return getProfile();
    });
  }

  DocterProfileModel  homeDocterProfile;

  getProfile() async {
    var request = http.Request('GET', Uri.parse('${SERVER_ADDRESS}/api/profile'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var NewResponce = DocterProfileModel.fromJson(jsonDecode(result));
      print("this is a responce1111111===========>${NewResponce.toString()}");
      setState(() {
        homeDocterProfile = NewResponce;
        //print("this is a new==========>${homeDocterProfile.data.email}");
      });
    }
    else {
      print(response.reasonPhrase);
    }

  }

  downloadFile(String url, String filename, ) async {
    FileDownloader.downloadFile(
        url:  "${url}",
        //'https://completewomencares.com/public/upload/1686124273.pdf',
        name: "${filename}",
        onDownloadCompleted: (path) {
          print(path);
          String tempPath = path.toString().replaceAll("Download", "Alpha Doctor");
          final File file = File(tempPath);
          print("path here ${file}");
        //  setSnackbar("File Downloaded successfully!", context);
          var snackBar = SnackBar(
            backgroundColor: LIME,
            content: Text('File Download Successfully'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //This will be the path of the downloaded file
        });
  }

  viewFile(String url, String filename) async {
    FileDownloader.downloadFile(
        url:  "${url}",
        //'https://completewomencares.com/public/upload/1686124273.pdf',
        name: "${filename}",
        onDownloadCompleted: (path) {
          print(path);
          String tempPath = path.toString().replaceAll("Download", "CompleteWomen'sCare");
          final File file = File(tempPath);
          print("path here ${file}");
          displayPDF(url);
          //  setSnackbar("File Downloaded successfully!", context);
          var snackBar = SnackBar(
            backgroundColor: LIME,
            // content: Text('File Download Successfully '),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //This will be the path of the downloaded file
        });
  }




  // Widget timingSlotsList(int index) {
  //   print(index);
  //   return GridView.count(
  //     crossAxisCount: 3,
  //     padding: EdgeInsets.all(10),
  //     shrinkWrap: true,
  //     crossAxisSpacing: 5,
  //     mainAxisSpacing: 5,
  //     childAspectRatio: 1.8,
  //     physics: ClampingScrollPhysics(),
  //     children: List.generate(
  //        widget.upcomingList.time,
  //             (ind) =>
  //             timingSlotsCard(ind, makeAppointmentClass!.data[index].slottime)),
  //   );
  // }
  // Widget timingSlotsCard(int i, List<Slottime> list) {
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         print(list[i].id);
  //         if (list[i].isBook == "1") {
  //           Toast.show(NO_SLOT_AVAILABLE, duration: 2);
  //         } else {
  //           slotId = list[i].id.toString();
  //           slotName = list[i].name;
  //           print("previousSelectedTimingSlot : " +
  //               (previousSelectedTimingSlot > list.length
  //                   ? 0
  //                   : previousSelectedTimingSlot)
  //                   .toString());
  //           selectedTimingSlot[previousSelectedTimingSlot > list.length
  //               ? 0
  //               : previousSelectedTimingSlot] = false;
  //           selectedTimingSlot[i] = !selectedTimingSlot[i];
  //           previousSelectedTimingSlot = i;
  //         }
  //       });
  //     },
  //     borderRadius: BorderRadius.circular(20),
  //     child: Container(
  //       height: 90,
  //       margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
  //       decoration: BoxDecoration(
  //           color: list[i].isBook == "1"
  //               ? Colors.grey.withOpacity(0.1)
  //               : selectedTimingSlot[i]
  //               ? AMBER
  //               : WHITE,
  //           borderRadius: BorderRadius.circular(15)),
  //       padding: EdgeInsets.all(10),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Image.asset(
  //             list[i].isBook == "1"
  //                 ? "assets/makeAppointmentScreenImages/time_unactive.png"
  //                 : selectedTimingSlot[i]
  //                 ? "assets/makeAppointmentScreenImages/time_active.png"
  //                 : "assets/makeAppointmentScreenImages/time_unactive.png",
  //             height: 15,
  //             width: 15,
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Text(
  //             list[i].name!,
  //             style: GoogleFonts.poppins(
  //               fontWeight: FontWeight.w500,
  //               color: list[i].isBook == "0"
  //                   ? selectedTimingSlot[i]
  //                   ? WHITE
  //                   : BLACK
  //                   : Colors.grey.withOpacity(0.5),
  //               fontSize: 12,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  String pdfUrl = 'https://example.com/path/to/document.pdf';
  Future<void>  displayPDF(String url) async {
    Dio dio = Dio();

    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String appDocPath = directory.path;
      String fileName = 'document.pdf';
      String filePath = '$appDocPath/$fileName';

      await dio.download(url, filePath);

      // Open PDF using FlutterPdfView plugin
      if (await File(filePath).exists()) {
        print('This is file path is here------${filePath}');
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('PDF Viewer'),
              ),
              body: PDFView(
                filePath: filePath,
              ),
            ),
          ),
        );
      } else {
        print('Failed to download the PDF file.');
      }
    } catch (e) {
      print('Error occurred while downloading the PDF: $e');
    }
  }





  Future<String> createFolderInAppDocDir(String folderNames) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.accessMediaLocation,
       // Permission.manageExternalStorage,
      Permission.storage,
    ].request();
    print("this is permission request ===== ${PermissionStatus.granted} and ${Permission.accessMediaLocation.status.isGranted.toString()}");
    // var manage = await Permission.manageExternalStorage.status;
    var media = await Permission.accessMediaLocation.status;
    if(media==PermissionStatus.granted){

      print(statuses[Permission.location]);
      //Get this App Document Directory

      // final Directory? _appDocDir = await getTemporaryDirectory();
      // //App Document Directory + folder name
      // final Directory _appDocDirFolder =
      // Directory('${_appDocDir!.path}/$folderName/');
      //
      // if (await _appDocDirFolder.exists()) {
      //   //if folder already exists return path
      //   print("checking directory path ${_appDocDirFolder.path} and ${_appDocDirFolder}");
      //   return _appDocDirFolder.path;
      // } else {
      //   //if folder not exists create folder and then return its path
      //   final Directory _appDocDirNewFolder =
      //   await _appDocDirFolder.create(recursive: true);
      //   print("checking directory path 1111 ${_appDocDirFolder.path} and ${_appDocDirFolder}");
      //   return _appDocDirNewFolder.path;
      // }
      final folderName = folderNames;
      final path= Directory("storage/emulated/0/$folderName");
      final path1 =  await getExternalStorageDirectory();
      print("ssdsds ${path1}");
      print("11111111111 ${path}");
      var status = await Permission.storage.status;
      print("mmmmmmmmmmm ${status} and ${status.isGranted}");
      if (!status.isGranted) {
        print("chacking status ${status.isGranted}");
        await Permission.storage.request();
      }
      print(" path here ${path} and ${await path.exists()}");
      if ((await path.exists())) {
        // final taskId = await FlutterDownloader.enqueue(
        //   url: '${widget.model.user.resume}/report.pdf',
        //   headers: {}, // optional: header send with url (auth token etc)
        //   savedDir: '$path',
        //   showNotification: true, // show download progress in status bar (for Android)
        //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        // );
        // print("okokko ${taskId}");
        print("here path is ${path}");
        // var dir = await DownloadsPathProvider.
        print("ooooooooo and $path/$folderNames");
        // await Dio().download(
        //     widget.model.user.resume.toString(),
        //     '$path/$folderNames/',
        //     onReceiveProgress: (received, total) {
        //       print("kkkkkkkk ${received} and $path/$folderNames");
        //       if (total != -1) {
        //        // print((received / total * 100).toStringAsFixed(0) + "%");
        //       }
        //     });
        return path.path;
      } else {
        print("here path is 1 ${path}");
        path.create();
        return path.path;
      }}else{
      print("permission denied");
    }
    return "";
  }
  @override
  Widget build(BuildContext context) {
    print("service name here ${widget.upcomingList.serviceName}");
    return widget.upcomingList == null
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
                            widget.upcomingList.doctorName,
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     InkWell(
                //       onTap: () =>  _callNumber(),
                //       // launch('${homeDocterProfile.data.phoneNo}'),
                //       child: Image.asset(
                //         "assets/doctordetails/Phone.png",
                //         height: 40,
                //         width: 40,
                //         fit: BoxFit.fill,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 5,
                //     ),
                //     // InkWell(
                //     //  onTap: () => openEmail(),
                //     //      // launch('${homeDocterProfile.data.email}'),
                //     //   // {
                //     //   //    _sendEmail(doctorDetail.data.email);
                //     //   // },
                //     //   child: Image.asset(
                //     //     "assets/doctordetails/email.png",
                //     //     height: 40,
                //     //     width: 40,
                //     //     fit: BoxFit.fill,
                //     //   ),
                //     // ),
                //   ],
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // openwhatsapp() async {
  //   var whatsapp = "${homeDocterProfile.data.phoneNo}";
  //   // var whatsapp = "+919644595859";
  //   var whatsappURl_android = "whatsapp://send?phone=" + whatsapp +
  //       "&text=Hello, I am messaging from Complete Womans Care App, I am interested in your products, Can we have chat? ";
  //   var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  //   if (Platform.isIOS) {
  //     // for iOS phone only
  //     if (await canLaunch(whatappURL_ios)) {
  //       await launch(whatappURL_ios, forceSafariVC: false);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: new Text("Whatsapp does not exist in this device")));
  //     }
  //   } else {
  //     // android , web
  //     if (await canLaunch(whatsappURl_android)) {
  //       await launch(whatsappURl_android);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: new Text("Whatsapp does not exist in this device")));
  //     }
  //   }
  // }

  // _callNumber() async{
  //   var number = "${homeDocterProfile.data.phoneNo}"; //set the number here
  //   bool res = await FlutterPhoneDirectCaller.callNumber(number);
  // }
  openEmail() async {
    // Android and iOS
    const uri =
        'mailto:test@example.org?subject=Greetings&body=Hello%20World';
    if (await canLaunch("${homeDocterProfile.data.email}")) {
      await launch("${homeDocterProfile.data.email}");
    } else {
      throw 'Could not launch $uri';
    }
  }
  // var whatsapp = "${homeDocterProfile.data.email}";
  // // var whatsapp = "+919644595859";
  // var whatsappURl_android = "whatsapp://send?phone=" + whatsapp +
  //     "&text=Hello, I am messaging from Complete Womans Care App, I am interested in your products, Can we have chat? ";
  // var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  // if (Platform.isIOS) {
  //   // for iOS phone only
  //   if (await canLaunch(whatappURL_ios)) {
  //     await launch(whatappURL_ios, forceSafariVC: false);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: new Text("Whatsapp does not exist in this device")));
  //   }
  // } else {
  //   // android , web
  //   if (await canLaunch(whatsappURl_android)) {
  //     await launch(whatsappURl_android);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: new Text("Whatsapp does not exist in this device")));
  //   }
  // }
  //}

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
        //bottomButtons(),
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
                    imageUrl: Uri.parse(widget.upcomingList.image).toString(),
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
              Expanded(
                child: Container(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.upcomingList.doctorName,
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // SizedBox(height: 8,),
                          Text(
                            widget.upcomingList.departmentName,
                            style: TextStyle(color: NAVY_BLUE, fontSize: 10),
                          ),
                          SizedBox(height: 7,),
                         Row(
                           children: [
                             Text("Booking date :"),
                             SizedBox(width:5,),
                             Container(
                               width: 70,
                               height: 15,
                               child: Text(
                                 widget.upcomingList.createdAt.toString(),
                                 style: TextStyle(color: NAVY_BLUE, fontSize: 11),
                               ),
                             ),
                           ],
                         ),
                          SizedBox(height: 6,),
                          Container(
                            height: 15,
                            width: 50,
                            decoration: BoxDecoration(
                              color: LIME,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                widget.upcomingList.status,
                                style: TextStyle(color: WHITE, fontSize: 8),
                              ),
                            ),
                          )
                        ],
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => ReviewScreen(
                      //                 doctorDetail.data.userId.toString())));
                      //   },
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Image.asset(
                      //             doctorDetail.data.ratting > 0
                      //                 ? "assets/doctordetails/star_active.png"
                      //                 : "assets/doctordetails/star_unactive.png",
                      //             height: 12,
                      //             width: 12,
                      //
                      //           ),
                      //           SizedBox(
                      //             width: 5,
                      //           ),
                      //           Image.asset(
                      //             doctorDetail.data.ratting > 1
                      //                 ? "assets/doctordetails/star_active.png"
                      //                 : "assets/doctordetails/star_unactive.png",
                      //             height: 12,
                      //             width: 12,
                      //           ),
                      //           SizedBox(
                      //             width: 5,
                      //           ),
                      //           Image.asset(
                      //             doctorDetail.data.ratting > 2
                      //                 ? "assets/doctordetails/star_active.png"
                      //                 : "assets/doctordetails/star_unactive.png",
                      //             height: 12,
                      //             width: 12,
                      //           ),
                      //           SizedBox(
                      //             width: 5,
                      //           ),
                      //           Image.asset(
                      //             doctorDetail.data.ratting > 3
                      //                 ? "assets/doctordetails/star_active.png"
                      //                 : "assets/doctordetails/star_unactive.png",
                      //             height: 12,
                      //             width: 12,
                      //           ),
                      //           SizedBox(
                      //             width: 5,
                      //           ),
                      //           Image.asset(
                      //             doctorDetail.data.ratting > 4
                      //                 ? "assets/doctordetails/star_active.png"
                      //                 : "assets/doctordetails/star_unactive.png",
                      //             height: 12,
                      //             width: 12,
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 2,
                      //       ),
                      //       Text(
                      //         "See all reviews",
                      //         style:
                      //         TextStyle(color: LIGHT_GREY_TEXT, fontSize: 10),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Row(
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         _launchURL(doctorDetail.data.facebookId);
                      //       },
                      //       child: Image.asset(
                      //         "assets/doctordetails/facebook.png",
                      //         height: 15,
                      //         width: 15,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 7,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         _launchURL(doctorDetail.data.twitterId);
                      //       },
                      //       child: Image.asset(
                      //         "assets/doctordetails/twitter.png",
                      //         height: 15,
                      //         width: 15,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 7,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         _launchURL(doctorDetail.data.googleId);
                      //       },
                      //       child: Image.asset(
                      //         "assets/doctordetails/google+.png",
                      //         height: 15,
                      //         width: 15,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 7,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         _launchURL(doctorDetail.data.instagramId);
                      //       },
                      //       child: Image.asset(
                      //         "assets/doctordetails/instagram.png",
                      //         height: 15,
                      //         width: 15,
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Text(
          //   doctorDetail.data.aboutUs,
          //   style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 11),
          //   textAlign: TextAlign.justify,
          // ),
        ],
      ),
    );
  }
  Future _launchURL(String pdfValue) async {
    var url = '${pdfValue}';
    print("url value ${url}");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  workingTimeAndServiceCard() {
    print("checking here now ${widget.upcomingList.serviceName} and ${widget.upcomingList.serviceName}");
    return Container(
      color: WHITE,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TIME_SLOT,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            SizedBox(
              height: 5,
            ),
          Row(children: [
            Text("Date-"),
            Text(
              widget.upcomingList.date.toString(),
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
            ),
            SizedBox(width: 10,),
            Text("Time-"),
            Text(
              widget.upcomingList.time.toString(),
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
            ),
          ],),
            SizedBox(
              height: 5,
            ),
            Text(
              NAME,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.upcomingList.name,
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Age :",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            SizedBox(
              height: 5,
            ),
              widget.upcomingList.age==null||widget.upcomingList.age==""?Text('Not Found'): Text(
              widget.upcomingList.age.toString(),
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
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
              widget.upcomingList.serviceName.toString(),
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              DEPARTMENTS,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.upcomingList.departmentName.toString(),
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              MESSAGE,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.upcomingList.messages.toString(),
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              STATUS,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.upcomingList.status.toString(),
              style: TextStyle(fontSize: 13, color: LIGHT_GREY_TEXT),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 15,),
            Text(
              "Prescription",
              style: TextStyle(fontSize: 18, color: BLACK),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10,),
             widget.upcomingList.prescription == "" ? Center(child: Text("No prescription to show"),) :  InkWell(
              onTap: () {
                viewFile("${widget.upcomingList.prescription}", "File",);
                //downloadPdf();
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: LIME
                ),
                width: double.infinity,
                child: Center(
                  child: Text("View Your Prescription",
                    style: TextStyle(
                        color: WHITE,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            ),
            // widget.upcomingList.p
            SizedBox(height: 15),
           widget.upcomingList.prescription == "" ? SizedBox.shrink() :  InkWell(
            onTap: () {
              downloadFile("${widget.upcomingList.prescription}", "File");
              //downloadPdf();
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: LIME
              ),
              width: double.infinity,
              child: Center(
                child: Text("Download Doctor Prescription",
                  style: TextStyle(
                      color: WHITE,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ),
            // Align(
            //   child: CustomButtonWithIcon(buttonText: "Prescription", buttonIcon: Image.asset('assets/dow.png', color: LIME, scale: 1.4,),onTap: (){
            //     createFolderInAppDocDir('Complete Womens Care');
            //     downloadFile("${widget.upcomingList.prescription}", "File");
            //   },),
            // ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  bottomButtons() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   width: 10,
          // ),
          InkWell(
            onTap: () {
              print("upcomingList ${widget.upcomingList}");
              print("doctorDetail.data.userId ${widget.upcomingList.userId}");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          widget.upcomingList.doctorName,
                          widget.upcomingList.departmentId.toString())));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(6, 5, 12, 15),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: LIME,
              ),
              child: Center(
                child: Text(
                  CHAT_WITH_DOCTOR,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: WHITE),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }






}


