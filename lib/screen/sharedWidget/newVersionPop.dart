import 'package:automall/MyWidget.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/font_size.dart';
import 'package:automall/helper/launchUrlHelper.dart';
import 'package:automall/constant/string/Strings.dart';
import 'package:automall/localizations.dart';
import 'package:automall/target.dart';
import 'package:flutter/material.dart';
class NewVersionPopUp extends StatelessWidget {
  Function() later;
  NewVersionPopUp({Key? key, required this.later}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.bottomCenter,
      height: AppHeight.h100,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.3),
      ),
      child: Container(
        height: AppPadding.p20*3 + AppHeight.h6 + FontSize.s16*2,
        decoration: BoxDecoration(
            color: AppColors.bottomCon,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppWidth.w10),
              topLeft: Radius.circular(AppWidth.w10),
            )
        ),
        child: Column(
          children: [
            MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('New version!'), padV: AppPadding.p20, color: AppColors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyWidget.elevatedButton(text: AppLocalizations.of(context)!.translate('Update'), press: ()=> _update(), backcolor: AppColors.mainColor, width: AppWidth.w35, height: AppHeight.h6),
                MyWidget.elevatedButton(text: AppLocalizations.of(context)!.translate('Later'), press: ()=> later(), backcolor: AppColors.mainColor, width: AppWidth.w35, height: AppHeight.h6),
              ],),
            SizedBox(height: AppPadding.p20,),
          ],
        ),
      ),
    );
  }

  _update() {
    isAndroid()?
    LaunchUrlHelper.launchInBrowser(Uri.parse(Strings.androidLink)):
    LaunchUrlHelper.launchInBrowser(Uri.parse(Strings.iosLink));
  }


}

