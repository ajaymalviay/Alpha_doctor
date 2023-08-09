import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:complete_women_care/modals/GalleryModel.dart';
import 'package:complete_women_care/screens/galleryDetail.dart';
import '../main.dart';

class GalleryPage extends StatefulWidget {

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  GalleryModel galleryModel;
  getGalleryImage()async{
    var request = http.Request('GET', Uri.parse('${SERVER_ADDRESS}/api/gallery'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = GalleryModel.fromJson(json.decode(finalResult));
      setState(() {
        galleryModel = jsonResponse;
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
    Future.delayed(Duration(milliseconds: 200),(){
      return getGalleryImage();
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: WHITE,
        title: Text(
          "Gallery",
          style: TextStyle(color: BLACK),
        ),
        // flexibleSpace: header(),
      ),
      body: Container(
        // width: MediaQuery.of(context).size.width/3,
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
        child: galleryModel == null ? Center(child: CircularProgressIndicator(),) : galleryModel.data.length == 0 ? Center(child: Text("No data to show"),) :  GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 2.5 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: galleryModel.data.length,
            itemBuilder: (BuildContext ctx, index) {
              return
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(children: [
                    Text("${galleryModel.data[index].name}",
                      style: TextStyle(color: NAVY_BLUE, fontWeight: FontWeight.w800),textAlign: TextAlign.center),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryDetail(galleryModel: galleryModel.data[index].gallery ,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                          decoration: BoxDecoration(
                              color: NAVY_BLUE,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${galleryModel.data[index].description}",style: TextStyle(color: Colors.white, fontSize: 14),textAlign: TextAlign.center, )
                            ],
                          ),
                        ),
                      ),
                    ),
              ],
              ),
                  ),
                );
            }),
      ),
    );
  }
}
