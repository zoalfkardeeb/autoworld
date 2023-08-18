import 'package:automall/MyWidget.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart' as p;
import 'package:photo_view/photo_view_gallery.dart';
class PhotoView extends StatelessWidget {
  var networkImage;
  List<GalarryItems>? networkImageList;
  int? imageIndex = 1;
  PageController _pageController = PageController();

  PhotoView({Key? key, required this.networkImage, this.networkImageList, this.imageIndex}) : super(key: key) {
    if(imageIndex != null) _pageController = PageController(initialPage:  imageIndex!);
  }
  @override
  Widget build(BuildContext context) {
    var curve = MediaQuery.of(context).size.height / 30;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topBar(curve, context),
          //Padding(padding:EdgeInsets.symmetric(horizontal: 40), child: GestureDetector(child: Icon(Icons.close, color: MyColors.white,),onTap: ()=>Navigator.pop(context))),
          Expanded(
              child: networkImageList==null? p.PhotoView(imageProvider: networkImage,):
                  _listPhoto(context)
            ,
          ),
        ],
      ),
    );
  }
  _listPhoto(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(networkImageList![index].image),
                    initialScale: p.PhotoViewComputedScale.contained * 0.8,
                    heroAttributes: p.PhotoViewHeroAttributes(tag: networkImageList![index].id),
                  );
                },
                itemCount: networkImageList!.length,
                enableRotation:true,
              /*  loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                    ),
                  ),
                ),
              */
                backgroundDecoration: BoxDecoration(
                  color: MyColors.white
                ),
                pageController: _pageController,
                onPageChanged: (value) =>  onPageChanged(value),
              )
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: networkImageList!.map((e) =>
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                      /*decoration: imageIndex==networkImageList!.indexOf(e)? BoxDecoration(
                        border: Border.all(color: AppColors.card),
                      ): null,*/
                      child: MyWidget(context).networkImage(e.image, 100.0, crossAlign: CrossAxisAlignment.center, height: 75.0),
                  ),
                  onTap: () => _pageController.animateToPage(networkImageList!.indexOf(e), duration: Duration(milliseconds: 100), curve: Curves.linear),
                )
            ).toList(),
          ),
        ),

      ],

    );
  }

  void onPageChanged(index) {
    imageIndex = index;
    //print('${_pageController.initialPage}  ${_pageController.position}');
    //print('${_pageController.initialPage}  ${_pageController.position}');
  }

  _topBar(curve, BuildContext context) {
    return Container(
      //centerTitle: true,
      //height: barHight,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(child:
                  Row(
                    children: [
                      Icon(Icons.close, color: MyColors.black,),
                    ],
                  ),
                      onTap: ()=>Navigator.pop(context)),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            // SizedBox(height: MediaQuery.of(context).size.height/40,),
            /*_tapNum==1?
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/120)
                :
            const SizedBox()
            ,*/
          ],
        )
    );
  }

}
class GalarryItems{
  String image;
      int id;
      GalarryItems({required this.image, required this.id});
}


