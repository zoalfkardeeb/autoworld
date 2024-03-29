// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/singnIn.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../MyWidget.dart';
// ignore: camel_case_types
class TermsAndConditions extends StatefulWidget {
  bool drawer = false;

  TermsAndConditions({Key? key, required this.drawer}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  _TermsAndConditionsState createState() => _TermsAndConditionsState(drawer);
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool drawer = false;
  _TermsAndConditionsState(this.drawer);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();

  }

  startTime() async {
    var duration = const Duration(milliseconds: 500);
    return Timer(duration, () =>
        setState(() async {
          ani = true;
          startAni();
         // await _read();
        }));
  }

  startAni() async {
    return Timer(
        Duration(milliseconds: (duration.inSeconds / 1.2 * 1000).round()), () =>
        setState(() {
          showAll = true;
        }));
  }

  bool ani = true;
  bool showAll = true;
  var duration = const Duration(milliseconds: 10);


  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    var hSpace = MediaQuery
        .of(context)
        .size
        .height / 20;
    var curve = MediaQuery
        .of(context)
        .size
        .height / 30;

    return Scaffold(
        //backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                //transform: Matrix4Transform().translate(x: MediaQuery.of(context).size.width/3).matrix4,
                //margin: EdgeInsets.all(10),
                duration: duration,
                transform: !ani ? (Matrix4.identity()
                  ..translate(0.0000001, 0.000001)
                ) :
                (Matrix4.identity()
                  ..translate(-0.0000001, -MediaQuery
                      .of(context)
                      .size
                      .height / 2 + MediaQuery
                      .of(context)
                      .size
                      .width / 7 + hSpace)
                    //..scale(1/3.5, 1/3.5*MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)
                ),
                child: GestureDetector(
                  child: Image.asset(
                    'assets/images/Logo1.png',
                    height: MediaQuery
                        .of(context)
                        .size
                        .width / 3.5,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3.5,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(top: hSpace*1.5 + MediaQuery.of(context).size.width/3.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _m!.headText(AppLocalizations.of(context)!.translate('name'),),
                //    SizedBox(height: MediaQuery.of(context).size.width/14),
                //    _m!.iconText('assets/images/read_black.svg', AppLocalizations.of(context)!.translate('Terms & conditions'), AppColors.black, scale: 1.3)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: MyColors.white,
                height: MediaQuery.of(context).size.height*9/10 - ( hSpace*1.5 + MediaQuery.of(context).size.width/3.5/3 + MediaQuery.of(context).size.width/3 ),
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: hSpace*1.5 + MediaQuery.of(context).size.width/3.5/3 + MediaQuery.of(context).size.width/3 ),
                padding: EdgeInsets.only(bottom: 0, left: MediaQuery.of(context).size.width/20*0, right: MediaQuery.of(context).size.width/20*0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Image.network(
                        lng == 2 ? 'https://autoworldqa.com/LEGAL_AR.png' : 'https://autoworldqa.com/LEGAL_EN.png',
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),

                      //_m!.titleText1(AppLocalizations.of(context)!.translate('term and condition')),
                      isLogin? Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppWidth.w8),
                        child: _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.4, AppLocalizations.of(context)!.translate('DeActivate account'), null, ()=> _deActivate(), height: MediaQuery.of(context).size.height/15),
                      )
                       :const SizedBox(),
                    ],
                  )
                )
                ,
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom != 0 || !showAll ?
              const SizedBox(height: 0.1,)
              :
              _m!.bottomContainer(
                 drawer?
                 _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.5 - MediaQuery.of(context).size.width/40  - curve, AppLocalizations.of(context)!.translate('Confirmed'), null, () => _confirmed())
                 :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _m!.raisedButton(curve, MediaQuery.of(context).size.width/2 - MediaQuery.of(context).size.width/40 - curve, AppLocalizations.of(context)!.translate('Rejected'), null, () => _rejected(), color: MyColors.black),
                      SizedBox(width: MediaQuery.of(context).size.width/30,),
                      _m!.raisedButton(curve, MediaQuery.of(context).size.width/2 - MediaQuery.of(context).size.width/40  - curve, AppLocalizations.of(context)!.translate('Confirmed'), null, () => _confirmed()),
                    ],
                  ), curve*1.1, bottomConRati: 0.1),
            ),
            Align(
              alignment: Alignment.center,
              child: pleaseWait?
              _m!.progress()
                  :
              const SizedBox(),
            )
          ],
        ),
    );
  }

  _confirmed() async{
    if(drawer){
      Navigator.of(context).pop();
      return;
    }
    termsAndConditions = true;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('terms', termsAndConditions);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_in(true),
        ),
        ModalRoute.withName("")
    );
  }

  _rejected() async{
    //Navigator.of(context).pop();
    termsAndConditions = false;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('terms', termsAndConditions);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_in(true),
        ),
        ModalRoute.withName("")
    );
  }

  _deActivate() async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).deActivateAccount();
    setState(() {
      pleaseWait = false;
    });
  }
}