import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/helper/launchUrlHelper.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    var curve = MediaQuery
        .of(context)
        .size
        .height / 30;
    _m = MyWidget(context);
    /*brandList.add({
      'image': 'assets/images/group1.png',
      'text': AppLocalizations.of(context)!.translate('Spare Parts')
    });
    brandList.add({
      'image': 'assets/images/group2.png',
      'text': AppLocalizations.of(context)!.translate('Garages')
    });
    brandList.add({
      'image': 'assets/images/group3.png',
      'text': AppLocalizations.of(context)!.translate('Batteries & tyres')
    });
    brandList.add({
      'image': 'assets/images/group4.png',
      'text': AppLocalizations.of(context)!.translate('Motor Service Van')
    });
    brandList.add({
      'image': 'assets/images/group5.png',
      'text': AppLocalizations.of(context)!.translate('Offers')
    });
    brandList.add({
      'image': 'assets/images/group6.png',
      'text': AppLocalizations.of(context)!.translate('Scrape Parts')
    });*/
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.topCon,
      key: _scaffoldKey,
      //drawer: _m!.drawer(() => _setState(), ()=> _tap(2), ()=> _tap(1), _scaffoldKey),
      body:  Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBar(curve),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _container('image', AppLocalizations.of(context)!.translate('Instagram')),
                _container('image', AppLocalizations.of(context)!.translate('Facebook')),
                _container('image', AppLocalizations.of(context)!.translate('WhatsApp')),
              ],
            ),
          ),
        ],
      )
    );
  }

  _topBar(curve) {
    return Container(
      //centerTitle: true,
      //height: barHight,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve),
              bottomRight: Radius.circular(curve)),
          boxShadow: [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],   ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height / 30,),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Align(
                      alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    onPressed: ()=> Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _m!.titleText1(AppLocalizations.of(context)!.translate('Support')),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.notificationButton(),
                ),
              ],
            ),
          ],
        )
    );
  }

  _container(image, text, {url}){
    return Container(
      padding: EdgeInsets.all(AppWidth.w4),
      margin: EdgeInsets.all(AppWidth.w4),
      decoration: BoxDecoration(
        color: MyColors.topCon,
        borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4),),
        boxShadow: const [BoxShadow(
          color: MyColors.black,
          offset: Offset(1, 3),
          blurRadius: 3,
        )],
      ),
      child: GestureDetector(
        onTap: ()=> LaunchUrlHelper.launchInBrowser(url),
        child: Row(
          children: [
            _m!.headText(text, scale: 0.8)
          ],
        ),
      ),
    );
  }

}