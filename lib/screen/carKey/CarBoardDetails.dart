// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';

import '../../MyWidget.dart';
import 'dart:ui' as ui;

// ignore: camel_case_types

class CarBoardDetails extends StatefulWidget {
  var indexCarBoard = 0;
  CarBoardDetails({Key? key, required this.indexCarBoard}) : super(key: key);

  @override
  _CarBoardDetailsState createState() => _CarBoardDetailsState(indexCarBoard);
}

class _CarBoardDetailsState extends State<CarBoardDetails> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late var _indexCarBoard = 0;

  _CarBoardDetailsState(this._indexCarBoard);
  final _country = 'Qatar';
  var _state = 'state';

  List<Widget> imageList = [];
  var name = "name",view = " ", price='200000', venName='', venNotes='', venPhone='963 03254132', venLocation='123355';
  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    view = carBroadKeyList[_indexCarBoard]['viewCount'].toString();
    name = carBroadKeyList[_indexCarBoard]['carKeyNum'].toString();
    price = formatter.format(carBroadKeyList[_indexCarBoard]['price']).toString();
    venName = carBroadKeyList[_indexCarBoard]['user']['name'].toString();
    venPhone = carBroadKeyList[_indexCarBoard]['user']['mobile'].toString();
    venLocation = '${carBroadKeyList[_indexCarBoard]['user']['country']['name']}, ${carBroadKeyList[_indexCarBoard]['user']['city']['name']}';
     try{
      _state = cityController.text;
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    var width = MediaQuery.of(context).size.width / 1.2;
    var height = MediaQuery.of(context).size.height / 5;
    var vSpace = MediaQuery.of(context).size.height/70;
    var scale =0.95;
    _m = MyWidget(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      //appBar: _m!.appBar(barHight, _scaffoldKey),
      drawer: _m!.drawer(() => _setState(), ()=> _tap(2), ()=> _tap(1), _scaffoldKey),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height*(1-bottomConRatio),
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery.of(context).size.height / 40*0,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                //  SizedBox(height: hSpace/2,),
                  _carBoardCard(curve, scale, name),
                 // SizedBox(height: hSpace/4,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: curve),
                    child: Row(
                      children: [
                        _carBoardCard(curve, scale * 0.3, name),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _m!.headText(name, scale: 0.8),
                            SizedBox(height: hSpace/9,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.remove_red_eye_rounded, color: MyColors.bodyText1, size: MediaQuery.of(context).size.height/50, ),
                                _m!.bodyText1('$view ${AppLocalizations.of(context)!.translate('View')}', scale: 0.9, padding: 0.5, padV: 2.0),
                              ],
                            ),

                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            //Icon(Icons.price_check_outlined, color: MyColors.mainColor,),
                            //SizedBox(width: AppWidth.w2,),
                            _m!.headText(price, scale: 0.8, color: MyColors.mainColor),
                            _m!.headText(AppLocalizations.of(context)!.translate("currency"), scale: 0.7, color: MyColors.mainColor),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(height: hSpace/8,),
                  Expanded(
                    flex: 1,
                    child: Padding(
                       padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: hSpace/8),
                       child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(curve/4),
                              margin: EdgeInsets.only(bottom: curve/2, left: 2, right: 2),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: MyColors.black,
                                      offset: Offset(0, 0.8),
                                      blurRadius: 0.8,
                                    ),
                                  ],
                                  color: MyColors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(curve))
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2*0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _m!.headText(AppLocalizations.of(context)!.translate('Vendor Information'),scale: 0.6, paddingV: curve/2),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                _m!.iconText('assets/images/ic_red_user.svg', venName, MyColors.black, imageScale: 0.5, scale: scale, paddingH: 0.2),
                                                SizedBox(height: hSpace/10,),
                                                venNotes.isNotEmpty?_notes(venNotes, curve/2, scale):const SizedBox(),
                                                SizedBox(height: hSpace/4,),
                                                _m!.iconText('assets/images/ic_red_phone.svg', venPhone, MyColors.black, imageScale: 0.5, scale: scale, paddingH: 0.2),
                                                SizedBox(height: hSpace/4,),
                                                _m!.iconText('assets/images/ic_red_location.svg', venLocation, MyColors.black, imageScale: 0.5, scale: scale, paddingH: 0.2),
                                                SizedBox(height: hSpace/8,),
                                              ],
                                            )),
                                       ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child:
                                        _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Call '), 'assets/images/phone.svg', ()=> launchPhone(phone: venPhone, context: context), height: MediaQuery.of(context).size.width/9),),
                                        SizedBox(width: hSpace/4,),
                                        _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Whatsapp'), 'assets/images/whatsapp.svg', ()=> launchWhatsApp(phone: venPhone, message: '', context: context), color: MyColors.green, height: MediaQuery.of(context).size.width/9)
                                      ],
                                    ),
                                    SizedBox(height: hSpace/8,),
                                  ],
                                ),
                              ),
                            ),
                          ],

                        ),
                       ),
                    ),
                  ),
                  SizedBox(height: hSpace/2,),
                ],
              )
                  :
              _m!.userInfoProfile(_topBar(curve), hSpace, curve, () => _setState()),
            ),
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

  _setState() {
    setState(() {
    });
  }

  _search() {}

  _topBar(curve) {
    return Container(
      //centerTitle: true,
      //height: barHight,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: const [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Align(
                      alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    onPressed: ()=> Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.titleText1(
                      AppLocalizations.of(context)!.translate('name')),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.notificationButton(),
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


  _tap(num) async{
    if(num == _tapNum) return;
    setState(() {
      _tapNum = num;
    });
    if(num == 2){
      await MyAPI(context: context).readUserInfo(userData['id']);
    }
    setState(() {});
  }

  String? path ;

  _notes(text, curve, scale) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(curve),
            margin: EdgeInsets.only(top: curve, left: MediaQuery.of(context).size.width/60, right: MediaQuery.of(context).size.width/60),
            decoration: BoxDecoration(
                border: Border.all(
                  color: MyColors.bodyText1,
                  width: 1,
                ),
                color: MyColors.white,
                borderRadius: BorderRadius.all(Radius.circular(curve))
            ),
            width: MediaQuery.of(context).size.width,
            child: _m!.bodyText1(text, align: TextAlign.start, padding: 0.0, scale: scale),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/60+0.5, right: MediaQuery.of(context).size.width/60+0.5),
            child: CustomPaint( //                       <-- CustomPaint widget
              size: Size(curve*3, curve),
              painter: MyPainter(curve),
            ),
          ),

      ],
    );
  }

  _carBoardCard(curve, scale, keyNum){
    var color = MyColors.qatarColor;
    var width = MediaQuery.of(context).size.width/1.2*scale;
    var height = MediaQuery.of(context).size.height/4*scale;
    curve*=scale;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(curve),
      padding: EdgeInsets.only(left:curve ),
      decoration: BoxDecoration(
       //color: color,
        borderRadius: BorderRadius.all(Radius.circular(curve/2)),
        //border: Border.all(color: color, width: 2),
        image: const DecorationImage(image: AssetImage("assets/images/board.png"), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _m!.headText(AppLocalizations.of(context)!.translate('Car Panel'), paddingH: width/20, scale: scale*1.4, paddingV: curve/4, align: TextAlign.center),
          _m!.headText(keyNum, scale: scale*1.4, align: TextAlign.center, paddingH: width/20, paddingV: 0.0),
        ],
      )
      ,
    );
  }

}

class MyPainter extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;
    final points = [
      Offset(curve, curve),
      const Offset(0, 0),
      Offset(0, curve*2),
    ];
    final paint = Paint()
      ..color = MyColors.bodyText1
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTRB(0, curve, curve*2, curve*3);
    const startAngle = 3.14;
    const sweepAngle = 3.14/2;
    const useCenter = false;
    final paintArc = Paint()
      ..color = MyColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paintArc);
    canvas.drawPoints(pointMode, points, paint);

  }

  double curve = 0.0;
  MyPainter(this.curve);
  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}