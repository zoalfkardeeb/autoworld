import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/cartScreen.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/main.dart';
import 'package:flutter/material.dart';

class TopBarEShop extends StatelessWidget {
  final title;
  late bool navCart = true;
  TopBarEShop({key, required this.title, navCart}): super(key:key){
   navCart??=true;
   this.navCart = navCart;
  }

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
                SizedBox(width: AppWidth.w4,)
              ],
            ),
          ],
        )
    );
  }
  Widget _cartIcon() {
    return GestureDetector(
      onTap: ()=>cartProductList==null? null: navCart && cartProductList!.data!.length > 0 ? MyApplication.navigateTo(navigatorKey.currentContext!, CartScreen()) : null,
        child: Column(
          children: [
            MyWidget(navigatorKey.currentContext!).bodyText1(cartProductList==null?"0":cartProductList!.data!.length.toString(), color: MyColors.mainColor, padding: 0.0, padV: 0.0),
            Icon(Icons.shopping_cart_outlined,),
          ],
        ),
    );
  }

}
