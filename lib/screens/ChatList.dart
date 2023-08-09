

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../AllText.dart';
import '../main.dart';
import '../modals/BlogsModel.dart';
import '../modals/GetBlogsNewModel.dart';
import '../modals/GetCatModel.dart';
import 'ChatScreen.dart';
import 'package:http/http.dart' as http;
import 'PlaceHolderScreen.dart';
import 'SubscriptionPlansScreen.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool loding = false;
  String selectedValue = "All Block";
  int selectedInt;
  // List<ChatListDetails> chatListDetails = [];
  // List<ChatListDetails> chatListSearch = [];
  // List<ChatListDetails> chatListDetailsPA = [];
  var ds;
  String PlayVideo;
  String userId;
  String keyword = "";
  bool isSearchClicked = false;
  FocusNode focusNode = FocusNode();
  String current_index ;
  bool _isNetworkAvail = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    super.initState();
    // current_index = CatModelNew.data[0].id.toString();
    //getBlogApi();
    videoPermission();
    Future.delayed(Duration(seconds: 1),(){
      return  getCatApi();

    });

    // SharedPreferences.getInstance().then((value) {
    //   setState(() {
    //     uid = value.getString("uid");
    //   });
    //   if (uid != null && (value.getBool("isLoggedIn") ?? false)) {
    //     loadChatList();
    //   }
    // });
    Future<Null> _refresh() {
      return callApi();
    }
  }

  videoPermission() async {
     SharedPreferences prefer = await SharedPreferences.getInstance();
     PlayVideo = prefer.getString('play_video');
     print('------play-------------${PlayVideo}');

  }


  Future<bool> isNetworkAvailable() async {

  }
  Future<Null> callApi() async {

    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getCatApi();
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }

    return null;
  }

  @override
  void dispose() {
    super.dispose();
    // ds.cancel();
  }
  String curentIndex;

  GetBlogsNewModel blogsdata;
  GetCatModel CatModelNew;
  List<VideoPlayerController> _vController = [];
  VideoPlayerController _videoController;

  getCatApi() async {
    setState(() {
      loding =true;
    });
    var request = http.MultipartRequest('GET', Uri.parse('${SERVER_ADDRESS}/api/get-categories'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var CatData = GetCatModel.fromJson(jsonDecode(result));
      print("this is a data===>${CatData.toString()}");
      setState(() {
        CatModelNew = CatData;
        current_index = CatModelNew.data[0].id.toString();
      });
      getBlogNewApi(CatModelNew.data[0].id.toString());
    }

    else {
      print(response.reasonPhrase);
    }
    setState(() {
      loding==false;
    });

  }

  List<bool> isPlayed = [

  ];
  getBlogNewApi(String id) async {
    SharedPreferences pref =await SharedPreferences.getInstance();
    userId = await pref.getInt("id").toString();
   // var request = http.Request('GET', Uri.parse('${SERVER_ADDRESS}/api/blogs?category_id=${id}&user_id=${userId}'));
    Map<String, dynamic> param ={
      "category_id":id,
      "user_id":userId,
    };
    print("this is a parameter======>${userId}");
    var response =await http.get(Uri.parse("${SERVER_ADDRESS}/api/blogs").replace(queryParameters: param));
   // http.StreamedResponse response = await request.send();
    print("mmmmmmmmmmmm ${Uri.parse("https://completewomencares.com/api/blogs").replace(queryParameters: param)}");
    if (response.statusCode == 200) {
      final result = response.body;
      var ResultData = GetBlogsNewModel.fromJson(jsonDecode(result));
      print("this is a------------------->${ResultData}");
      setState(() {
        blogsdata = ResultData;
      });
      print('my video77777777${blogsdata.data.first.video}');
      print("blog data here ${blogsdata} and ${blogsdata.data[0].isActive} and ${blogsdata.data[0].isPaid}");
      for(var i=0;i< blogsdata.data.length;i++){
        _vController.add(VideoPlayerController.network(blogsdata.data[i].video.toString())..initialize().then((value){
         ;
        }));
        setState(() {
          loding==false;
        });
        isPlayed.add(false);
      }

      // for(var i=0;i<blogsdata.data.length;i++){
      //   // _vController.add(VideoPlayerController.network(jsonResponse.data![i].video.toString()));
      //   _vController.add(VideoPlayerController.network(blogsdata.data[0].video.toString())..initialize().then((value){
      //     setState(() {
      //     });
      //   }));
      //   isPlayed.add(false);
      //   print("video controller length ${_vController.length}");
      // }

      // if (!error) {
      //   var data = getdata["data"];
      //   bannerVideo = data;
      //   video =
      //   "${blogsdata.data[0].video}";
      //   _videoController = VideoPlayerController.network('$video')
      //     ..initialize().then((_) {
      //       setState(() {
      //         //   if (_controller.value.isPlaying) {
      //         //     _controller.pause();
      //         //   } else {
      //         //     // If the video is paused, play it.
      //         //     _controller.play();
      //         //   }
      //         // });
      //         // scroll_visibility == false ? _videoController!.pause() :
      //         _videoController.play();
      //         _videoController.setVolume(0);
      //         _videoController.setLooping(true);
      //       });
      //     });
      //   //video = "https://alphawizztest.tk/plumbing_bazzar/${bannerVideo[0]['video']}";
      //   print("this is my video ^^ ${bannerVideo[0]['video']}");
      //   // catList =
      //   //     (data as List).map((data) => new Product.fromCat(data)).toList();
      //   //
      //   // if (getdata.containsKey("popular_categories")) {
      //   //   var data = getdata["popular_categories"];
      //   //   popularList =
      //   //       (data as List).map((data) => new Product.fromCat(data)).toList();
      //   //
      //   //   if (popularList.length > 0) {
      //   //     Product pop =
      //   //     new Product.popular("Popular", imagePath + "popular.svg");
      //   //     catList.insert(0, pop);
      //   //     context.read<CategoryProvider>().setSubList(popularList);
      //   //   }
      //   //}
      // } else {
      //   // setSnackbar("", context);
      //
      // }
    }
    else {
      print(response.reasonPhrase);
    }

    // var request = http.MultipartRequest('GET', Uri.parse('${SERVER_ADDRESS}/api/blogs'));
    // request.fields.addAll({
    //   'category_id': '${id}'
    // });
    // print("this is a catId______________>${request.fields}");
    // http.StreamedResponse response = await request.send();
    // if (response.statusCode == 200) {
    //   final result = await response.stream.bytesToString();
    //   var ResultData = GetBlogsNewModel.fromJson(jsonDecode(result));
    //   print("this is a------------------->${ResultData}");
    //   setState(() {
    //           blogsdata = ResultData;
    //         });
    // }
    // else {
    // print(response.reasonPhrase);
    // }

  }

  // getBlogApi() async {
  //   var request = http.Request('GET', Uri.parse('${SERVER_ADDRESS}/api/blogs'));
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final result = await response.stream.bytesToString();
  //     var finalData1 = BlogsModel.fromJson(jsonDecode(result));
  //     print("this is a data===>${finalData1.toString()}");
  //     setState(() {
  //       blogsdata = finalData1;
  //     });
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: AppBar(
          flexibleSpace: header(),
          backgroundColor: WHITE,
        ),
        body: blogsdata==null ? Center(child: CircularProgressIndicator()): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("Categories",style: TextStyle(color: BLACK,fontWeight: FontWeight.bold,fontSize: 18),),
            ),
            SizedBox(height: 5,),
            CatModelNew == null ? Center(child: CircularProgressIndicator()): CatModelNew.data.isEmpty ? Center(child: Text('Data not found'),) :Container(
              height: 50,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  itemCount: CatModelNew.data.length ?? 0,
                  // scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CatModelNew.data[index].status==1? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            current_index = CatModelNew.data[index].id.toString();
                            getBlogNewApi(CatModelNew.data[index].id.toString());
                          });
                        },
                        child: Container(
                          height: 20,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            color:current_index == CatModelNew.data[index].id.toString() ? LIME :Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text("${CatModelNew.data[index].name}",style: TextStyle(color: WHITE),)),
                              )

                            ],
                          ),
                        ),
                      ),
                    ):SizedBox.shrink();
                  }),
            ),
                          blogsdata == "" ?Center(child: Text("No Item Found")): Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 10,),
                  ListView.builder(
                      shrinkWrap: true,
                      // scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: blogsdata.data.length,
                      // scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        print("gggggggg${blogsdata.data[index].isPaid}");
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: WHITE,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${blogsdata.data[index].title}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${blogsdata.data[index].createdAt}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 110,
                                        width:double.infinity,
                                        decoration: BoxDecoration(),
                                        child: blogsdata.data[index].image == null ||
                                            blogsdata.data[index].image == ''
                                            ? Image.asset(
                                            "assets/splashScreen/icon.png")
                                            : ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            child: Image.network(
                                              "${blogsdata.data[index].image}",fit: BoxFit.fill,)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text("${blogsdata.data[index].description}"),
                                    // ),
                                    blogsdata.data[index].video == "" || blogsdata.data[index].video == null ? SizedBox.shrink() : Container(
                                      // margin: EdgeInsets.only(bottom: 10),
                                      child: Stack(
                                        children: [
                                          // Container(
                                          //     width: MediaQuery.of(context).size.width,
                                          //     height: 200,
                                          //     child: bannerVideo.isNotEmpty
                                          //         ?
                                          //     //widget.video.isNotEmpty ?
                                          //     VideoPlayer(_videoController!)
                                          //         : Center(
                                          //       child: CircularProgressIndicator(
                                          //         color: colors.primary,
                                          //       ),
                                          //     )
                                          //
                                          //   //     : VideoPlayer(
                                          //   //     _viController
                                          //   // )
                                          // ),
                                          Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: LIME,
                                              ),
                                              child: Column(
                                                children: [

                                                  Container(
                                                      height:150,
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: AspectRatio(aspectRatio: _vController[index].value.aspectRatio,child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10),
                                                          child: VideoPlayer(_vController[index])),)),
                                                  // Container(
                                                  //   height: 30,
                                                  //   padding: EdgeInsets.only(left: 10,top: 10),
                                                  //   width: MediaQuery.of(context).size.width,
                                                  //   decoration: BoxDecoration(
                                                  //       color: LIME,
                                                  //       borderRadius: BorderRadius.only(
                                                  //         bottomLeft: Radius.circular(10),
                                                  //         bottomRight: Radius.circular(10),
                                                  //       )
                                                  //   ),
                                                  //   child: Row(
                                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                                  //     children: [
                                                  //       Text("Feed Mart: ${videoModel!.data![0].title}")
                                                  //     ],),
                                                  // ),
                                                ],
                                              )),
                                          // blogsdata.data[index].isPaid ==  "1" ? Icon(Icons.lock) :
                                          // Positioned(
                                          //     bottom: 10,
                                          //     width: MediaQuery.of(context).size.width,
                                          //     child: VideoProgressIndicator(
                                          //       _vController[index],
                                          //       allowScrubbing: false,
                                          //       colors: VideoProgressColors(
                                          //           backgroundColor: Colors.blueGrey,
                                          //           bufferedColor: Colors.blueGrey,
                                          //           playedColor: Colors.blueAccent),
                                          //     )),
                                           PlayVideo=="true" ?
                                           Positioned(
                                               left: 1,right: 1,
                                               top: 1,
                                               bottom: 1,
                                               //alignment: Alignment.center,
                                               child:  _vController[index].value.isPlaying == true ? InkWell(
                                                   onTap: (){
                                                     setState(() {
                                                       // curentIndex = blogsdata.data[index].id.toString();
                                                       _vController[index].pause();
                                                     });
                                                   },
                                                   child: Icon(Icons.pause,color: Colors.white,)) : InkWell(
                                                   onTap: (){
                                                     setState(() {
                                                       //   curentIndex = blogsdata.data[index].id.toString();
                                                       _vController[index].play();
                                                     });
                                                   },
                                                   child: Icon(Icons.play_arrow,color: Colors.white,))):
                                          Positioned(
                                              left: 1,right: 1,
                                              top: 1,
                                              bottom: 1,
                                              //alignment: Alignment.center,
                                              child:   InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      // setSnackbar("Please take subscription", context);
                                                       Fluttertoast.showToast(msg: 'Please take subscription');
                                                      // curentIndex = blogsdata.data[index].id.toString();
                                                      //  _vController[index].pause();
                                                    });
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionPlansScreen()));
                                                  },
                                                  child: Icon(Icons.lock,color: Colors.white,)) )

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                ],
              ),
            )
          ],
        )
      // Column(
      //   children: [
      //
      //     // AnimatedContainer(
      //     //   duration: Duration(milliseconds: 300),
      //     //   curve: Curves.easeIn,
      //     //   height: isSearchClicked ? 50 : 0,
      //     //   margin: EdgeInsets.all(10),
      //     //   child: isSearchClicked
      //     //       ? TextField(
      //     //           focusNode: focusNode,
      //     //           decoration: InputDecoration(
      //     //             filled: true,
      //     //             hintText: SEARCH_HERE_NAME,
      //     //           ),
      //     //           onChanged: (val) {
      //     //             setState(() {
      //     //               keyword = val;
      //     //             });
      //     //           },
      //     //           onSubmitted: (val) {},
      //     //         )
      //     //       : Container(),
      //     // ),
      //     // Expanded(
      //     //   child:
      //     //   // chatListDetails.isEmpty
      //     //   //     ? PlaceHolderScreen(
      //     //   //         message: NO_CHATS,
      //     //   //         description: YOUR_CHATS_WILL_BE_DISPLAYED_HERE,
      //     //   //         iconPath: "assets/placeholders/message_holder.png",
      //     //   //       )
      //     //   //     :
      //     //   Column(
      //     //           mainAxisAlignment: MainAxisAlignment.start,
      //     //           children: [
      //     //             Expanded(
      //     //               child: Padding(
      //     //                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      //     //                 child: ListView.builder(
      //     //                   shrinkWrap: true,
      //     //                   padding: EdgeInsets.zero,
      //     //                   physics: ClampingScrollPhysics(),
      //     //                   itemCount: chatListDetails.length,
      //     //                   itemBuilder: (context, index) {
      //     //                     print("chatListDetails.length ${chatListDetails.length}");
      //     //                     return StreamBuilder(
      //     //                       stream: FirebaseDatabase.instance
      //     //                           .reference()
      //     //                           .child(chatListDetails[index].userUid.toString())
      //     //                           .onValue,
      //     //                       builder: (context,
      //     //                           AsyncSnapshot<Event> snapshot) {
      //     //                         if (snapshot.hasData) {
      //     //                           print("new stream" +
      //     //                               snapshot.data.snapshot.value['name']
      //     //                                   .toString());
      //     //                           return messageCard(
      //     //                               isNewMessage: chatListDetails[index]
      //     //                                           .messageCount >
      //     //                                       0
      //     //                                   ? true
      //     //                                   : false,
      //     //                               name: snapshot
      //     //                                   .data.snapshot.value['name']
      //     //                                   .toString(),
      //     //                               message:
      //     //                                   chatListDetails[index].message,
      //     //                               count: chatListDetails[index]
      //     //                                   .messageCount,
      //     //                               image: SERVER_ADDRESS +
      //     //                                   "/public/upload/" +
      //     //                                   snapshot.data.snapshot
      //     //                                       .value['profile']
      //     //                                       .toString().replaceAll(SERVER_ADDRESS +
      //     //                                       "/public/upload/", ""),
      //     //                               time: chatListDetails[index].time,
      //     //                               type: chatListDetails[index].type,
      //     //                               uid: chatListDetails[index].userUid,
      //     //                               isSearching: isSearchClicked);
      //     //                         } else {
      //     //                           return Container();
      //     //                         }
      //     //                       },
      //     //                     );
      //     //                   },
      //     //                 ),
      //     //               ),
      //     //             )
      //     //           ],
      //     //         ),
      //     // ),
      //   ],
      // )),
    );
  }

  header() {
    return SafeArea(
      child: Container(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [


                  Text(CHAT,
                    // isSearchClicked ?:SizedBox.shrink(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  // IconButton(
                  //   icon: isSearchClicked
                  //       ? Icon(
                  //           Icons.cancel_outlined,
                  //           color: LIGHT_GREY_TEXT,
                  //           size: 30,
                  //         )
                  //       : Image.asset(
                  //           "assets/chatScreen/google.png",
                  //           height: 25,
                  //           width: 25,
                  //         ),
                  //   onPressed: () {
                  //     setState(() {
                  //       isSearchClicked = !isSearchClicked;
                  //       if (isSearchClicked) {
                  //         focusNode.requestFocus();
                  //       }
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
//
//   messageCard(
//       {bool isNewMessage,
//       String name,
//       int count,
//       String message,
//       String image,
//       String time,
//       int type,
//       String uid,
//       bool isSearching}) {
//     return isSearching
//         ? name.toLowerCase().contains(keyword.toLowerCase())
//             ? Container(
//                 padding: EdgeInsets.all(15),
//                 margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: isNewMessage ? LIME : LIGHT_GREY,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ChatScreen(name, uid)));
//                   },
//                   child: Row(
//                     children: [
//                       Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(25),
//                             child: CachedNetworkImage(
//                               height: 50,
//                               width: 50,
//                               fit: BoxFit.cover,
//                               imageUrl: image,
//                               progressIndicatorBuilder:
//                                   (context, url, downloadProgress) => Container(
//                                       height: 75,
//                                       width: 75,
//                                       child: Center(
//                                           child: Icon(
//                                         Icons.account_circle,
//                                         size: 50,
//                                         color: isNewMessage
//                                             ? WHITE
//                                             : LIGHT_GREY_TEXT,
//                                       ))),
//                               errorWidget: (context, url, error) => Container(
//                                 height: 75,
//                                 width: 75,
//                                 child: Center(
//                                   child: Icon(
//                                     Icons.account_circle,
//                                     size: 50,
//                                     color:
//                                         isNewMessage ? WHITE : LIGHT_GREY_TEXT,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           StreamBuilder<Event>(
//                               stream: FirebaseDatabase.instance
//                                   .reference()
//                                   .child(uid)
//                                   .child('presence')
//                                   .onValue,
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState ==
//                                     ConnectionState.none) {
//                                   return Container();
//                                 } else {
//                                   return snapshot.data != null
//                                       ? (snapshot.data.snapshot.value ?? true)
//                                           ? Container(
//                                               height: 50,
//                                               width: 50,
//                                               child: Align(
//                                                 alignment: Alignment.topRight,
//                                                 child: Image.asset(
//                                                   "assets/chatScreen/status.png",
//                                                   height: 15,
//                                                   width: 15,
//                                                   fit: BoxFit.contain,
//                                                 ),
//                                               ),
//                                             )
//                                           : Container()
//                                       : Container();
//                                 }
//                               })
//                           // StreamBuilder<Event>(
//                           //     stream: FirebaseDatabase.instance
//                           //         .reference()
//                           //         .child(uid)
//                           //         .child('presence')
//                           //         .onValue,
//                           //     builder: (context, snapshot) {
//                           //       if (snapshot.connectionState ==
//                           //           ConnectionState.none) {
//                           //         return Container();
//                           //       } else {
//                           //         return snapshot.data != null
//                           //             ? snapshot.data.snapshot.value
//                           //                 ? Container(
//                           //                     height: 50,
//                           //                     width: 50,
//                           //                     child: Align(
//                           //                       alignment: Alignment.topRight,
//                           //                       child: Image.asset(
//                           //                         "assets/chatScreen/status.png",
//                           //                         height: 15,
//                           //                         width: 15,
//                           //                         fit: BoxFit.contain,
//                           //                       ),
//                           //                     ),
//                           //                   )
//                           //                 : Container()
//                           //             : Container();
//                           //       }
//                           //     })
//                         ],
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     name,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: isNewMessage
//                                             ? FontWeight.w800
//                                             : FontWeight.w700),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Text(
//                                   messageTiming(
//                                       DateTime.parse(time).toLocal() ?? "-"),
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: isNewMessage
//                                           ? NAVY_BLUE
//                                           : LIGHT_GREY_TEXT),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 6,
//                             ),
//                             typeToWidget(
//                                 int.parse(type.toString()), message, count),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             : Container()
//         : Container(
//             padding: EdgeInsets.all(15),
//             margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//                 color: isNewMessage ? LIME : LIGHT_GREY,
//                 borderRadius: BorderRadius.circular(10)),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ChatScreen(name, uid)));
//               },
//               child: Row(
//                 children: [
//                   Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(25),
//                         child: CachedNetworkImage(
//                           height: 50,
//                           width: 50,
//                           fit: BoxFit.cover,
//                           imageUrl: image,
//                           progressIndicatorBuilder:
//                               (context, url, downloadProgress) => Container(
//                                   height: 75,
//                                   width: 75,
//                                   child: Center(
//                                       child: Icon(
//                                     Icons.account_circle,
//                                     size: 50,
//                                     color:
//                                         isNewMessage ? WHITE : LIGHT_GREY_TEXT,
//                                   ))),
//                           errorWidget: (context, url, error) => Container(
//                             height: 75,
//                             width: 75,
//                             child: Center(
//                               child: Icon(
//                                 Icons.account_circle,
//                                 size: 50,
//                                 color: isNewMessage ? WHITE : LIGHT_GREY_TEXT,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       StreamBuilder<Event>(
//                           stream: FirebaseDatabase.instance
//                               .reference()
//                               .child(uid)
//                               .child('presence')
//                               .onValue,
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.none) {
//                               return Container();
//                             } else {
//                               return snapshot.data != null
//                                   ? (snapshot.data.snapshot.value ?? true)
//                                       ? Container(
//                                           height: 50,
//                                           width: 50,
//                                           child: Align(
//                                             alignment: Alignment.topRight,
//                                             child: Image.asset(
//                                               "assets/chatScreen/status.png",
//                                               height: 15,
//                                               width: 15,
//                                               fit: BoxFit.contain,
//                                             ),
//                                           ),
//                                         )
//                                       : Container()
//                                   : Container();
//                             }
//                           })
//                     ],
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 name,
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     color: isNewMessage ? WHITE : BLACK,
//                                     fontWeight: isNewMessage
//                                         ? FontWeight.w800
//                                         : FontWeight.w700),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             Text(
//                               messageTiming(
//                                   DateTime.parse(time).toLocal() ?? "-"),
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: isNewMessage
//                                       ? WHITE.withOpacity(0.8)
//                                       : LIGHT_GREY_TEXT),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 6,
//                         ),
//                         typeToWidget(
//                             int.parse(type.toString()), message, count),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//   }
//
//   loadChatList() async {
//     ds = FirebaseDatabase.instance
//         .reference()
//         .child(uid.toString())
//         .onValue
//         .listen((event) {
//       print("chat list : " + event.snapshot.value['chatlist'].toString());
//       setState(() {
//         chatListDetailsPA.clear();
//         print("testing : " + "data retrievd from firebase");
//       });
//       try {
//         Map<dynamic, dynamic>.from(event.snapshot.value['chatlist'])
//             .forEach((key, values) {
//           setState(() {
//             print(key.toString());
//             if (values['last_msg'] != null) {
//               print("testing : " + "last message is not equal to null");
//               chatListDetailsPA.add(ChatListDetails(
//                 channelId: values['channelId'],
//                 message: values['last_msg'],
//                 messageCount: values['messageCount'],
//                 time: values['time'],
//                 type: int.parse(values['type'].toString()),
//                 userUid: key.toString(),
//               ));
//             }
//           });
//         });
//       } catch (e) {}
//
//       if (chatListDetailsPA.length > 1) {
//         chatListDetailsPA.sort((a, b) => b.time.compareTo(a.time));
//       }
//       setState(() {
//         print("testing : " + "data added to chat list");
//         chatListDetails.clear();
//         chatListDetails.addAll(chatListDetailsPA);
//       });
//
//       for (int i = 0; i < chatListDetails.length; i++) {
//         print("testing : " + chatListDetails[i].toString());
//       }
//     });
//   }
//
//   typeToWidget(int type, String msg, int count) {
//     if (type == 1) {
//       return Row(
//         children: [
//           Icon(
//             Icons.photo,
//             size: 15,
//             color: count > 0 ? WHITE.withOpacity(0.8) : Colors.grey.shade700,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             "Photo",
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w100,
//                 color: count > 0 ? WHITE.withOpacity(0.8) : LIGHT_GREY_TEXT),
//           ),
//         ],
//       );
//     } else if (type == 2) {
//       return Row(
//         children: [
//           Icon(
//             Icons.videocam,
//             size: 15,
//             color: count > 0 ? WHITE.withOpacity(0.8) : Colors.grey.shade700,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             "Video",
//             style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w100,
//                 color: count > 0 ? WHITE.withOpacity(0.8) : LIGHT_GREY_TEXT),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       );
//     } else {
//       return Text(
//         msg,
//         style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w100,
//             color: count > 0 ? WHITE.withOpacity(0.8) : LIGHT_GREY_TEXT),
//         overflow: TextOverflow.ellipsis,
//       );
//     }
//   }
//
//   String messageTiming(DateTime dateTime) {
//     if (DateTime.now().difference(dateTime).inDays == 0) {
//       return "${dateTime.hour} : ${dateTime.minute < 10 ? "0" + dateTime.minute.toString() : dateTime.minute}";
//     } else if (DateTime.now().difference(dateTime).inDays == 1) {
//       return "yesterday";
//     } else {
//       return DateTime.now().difference(dateTime).inDays.toString() +
//           " days ago";
//     }
//   }
// }
//
// class ChatListDetails {
//   String message;
//   String time;
//   int type;
//   String channelId;
//   int messageCount;
//   String userUid;
//
//   ChatListDetails(
//       {this.message,
//       this.time,
//       this.type,
//       this.channelId,
//       this.messageCount,
//       this.userUid});
}
