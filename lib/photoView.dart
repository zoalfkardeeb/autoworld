import 'package:automall/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart' as p;
import 'package:photo_view/photo_view_gallery.dart';
class PhotoView extends StatelessWidget {
  var networkImage;
  List<GalarryItems>? networkImageList;

  PhotoView({Key? key, required this.networkImage, this.networkImageList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding:EdgeInsets.all(40), child: GestureDetector(child: Icon(Icons.close, color: MyColors.white,),onTap: ()=>Navigator.pop(context))),
        Expanded(
            child: networkImageList==null? p.PhotoView(imageProvider: networkImage,):
                _listPhoto()
          ,
        ),
      ],
    );
  }
  _listPhoto(){
    return Container(
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
          //backgroundDecoration: widget.backgroundDecoration,
          //pageController: widget.pageController,
          //onPageChanged: onPageChanged,
        )
    );
  }
}
class GalarryItems{
  String image;
      int id;
      GalarryItems({required this.image, required this.id});
}
