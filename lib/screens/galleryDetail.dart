import 'package:flutter/material.dart';
import 'package:complete_women_care/modals/GalleryModel.dart';

class GalleryDetail extends StatefulWidget {

  List<Gallery> galleryModel;

  GalleryDetail({this.galleryModel});

  @override
  State<GalleryDetail> createState() => _GalleryDetailState();
}

class _GalleryDetailState extends State<GalleryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
        child: widget.galleryModel == null ? Center(child: CircularProgressIndicator(),) : widget.galleryModel.length == 0 ? Center(child: Text("No data to show"),) :  GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: widget.galleryModel.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFullView(image: widget.galleryModel[index].image.toString(),)));
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network("${widget.galleryModel[index].image}",fit: BoxFit.fill,))
                  ),
                ),
              );
            }),
      ),
    );
  }
}



class ImageFullView extends StatefulWidget {
  
   String image;
   ImageFullView({this.image});
   
  @override
  State<ImageFullView> createState() => _ImageFullViewState();
}

class _ImageFullViewState extends State<ImageFullView> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.network("${widget.image}"),
        ),
      ),
    );
  }
}
