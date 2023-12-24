import 'package:automall/MyWidget.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/cartScreen.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/main.dart';
import 'package:flutter/material.dart';

class TopBarEShop extends StatelessWidget {
  final title;
  const TopBarEShop({key, required this.title}): super(key:key);

  @override
  Widget build(BuildContext context) {
    var curve = AppWidth.w4*1.5;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: const [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppHeight.h4,),
            Row(
              children: [
                IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios)),
                Expanded(
                  child: MyWidget(context).titleText1(title),
                ),
                _cartIcon(),
              ],
            ),
          ],
        )
    );
  }
  Widget _cartIcon() {
    return IconButton(onPressed: ()=> MyApplication.navigateTo(navigatorKey.currentContext!, CartScreen()), icon: const Icon(Icons.shopping_cart_outlined));
  }

}
