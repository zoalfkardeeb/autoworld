import 'package:automall/color/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart' as p;
class PhotoView extends StatelessWidget {
  var networkImage;

  PhotoView({Key? key, required this.networkImage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding:EdgeInsets.all(40), child: GestureDetector(child: Icon(Icons.close, color: MyColors.white,),onTap: ()=>Navigator.pop(context))),
        Expanded(
            child: p.PhotoView(
              imageProvider: networkImage,
            )
        ),
      ],
    );
  }
}
