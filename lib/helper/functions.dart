

import 'package:automall/navigationAnimation/fadeTransaction.dart';
import 'package:flutter/material.dart';

class MyApplication {
  // static Future<bool> checkConnection() async {
  //   var connectivityResult;

  //   connectivityResult = await (Connectivity().checkConnectivity());

  //   {
  //     return connectivityResult == ConnectivityResult.none ? false : true;
  //   }
  // }

  static void navigateToReplace(BuildContext context, Widget page) async {
//    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => page));
    Navigator.of(context).pushReplacement(FadeRoute(page: page));// MaterialPageRoute(builder: (context) => page));
  }

  static void navigateTo(BuildContext context, Widget page, {Function()? then}) async {
    Navigator.of(context).push(FadeRoute(page: page)).then((value) => then==null?then:then());//MaterialPageRoute(builder: (context) => page));
  }

  static Future<void> navigateTorePlaceUntil(BuildContext context, Widget page) async {
    await Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(page: page),//MaterialPageRoute(builder: (context) => page),
          (route) => false,
    );
  }

}
