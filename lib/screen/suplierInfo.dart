import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as h;
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../MyWidget.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../const.dart';
import '../localizations.dart';
class SuplierInfo extends StatefulWidget {
  var index;
  final String barTitle;
  SuplierInfo(this.index, {Key? key, required this.barTitle}) : super(key: key);

  @override
  _SuplierInfoState createState() => _SuplierInfoState(index);
}

class _SuplierInfoState extends State<SuplierInfo> {
  var index;
  _SuplierInfoState(this.index);
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  var _suplierImagePath;
  var _suplierName = 'Omar';
  var _suplierEmail= '';
  var _suplierStarNum= 6.0;
  final List _suplierListCheck = [];

  ImageProvider? image;
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _workHourController = TextEditingController();
  final _cityController = TextEditingController();
  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityController.text = suplierList[index]['user']['city']??= 'Doha';
   _state = _cityController.text??'';
   _suplierName = suplierList[index]['fullName']??'';
   _nameController.text = _suplierName??'';
   _mobileController.text = suplierList[index]['whatsappNumber']??'';
   _workHourController.text = suplierList[index]['workHour']??'';
   _suplierImagePath = suplierList[index]['user']['imagePath'];
   if(_suplierImagePath == '') _suplierImagePath = null;
   _suplierEmail = suplierList[index]['user']['email'];
   _suplierStarNum = suplierList[index]['rating']??=6.0;
  // _suplierStarNum = _suplierStarNum*2;
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.topCon,
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
                top: 0*MediaQuery.of(context).size.height / 40,
              ),
              child: _tapNum == 1?
              Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _topBar(curve),
                    SizedBox(height: AppHeight.h2,),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: _m!.logoContainer(_suplierImagePath.toString().endsWith(' ')? null : _suplierImagePath, AppWidth.w40, isSupp: true),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: AppWidth.w40 - FontSize.s16*3.5/2, left: AppWidth.w40-FontSize.s16*3.5/2),
                            child: Stack(
                              children: [
                                Icon(Icons.star, color: MyColors.mainColor, size: FontSize.s16*3.5,),
                                Padding(
                                  padding: EdgeInsets.only(top: FontSize.s16*3.5/2 - FontSize.s16/2, left: lng == 2 ? 0 : FontSize.s16*3.5/2-FontSize.s16/3, right: lng != 2 ? 0 : FontSize.s16*3.5/2-FontSize.s16/3),
                                  child: Text((_suplierStarNum/2).round().toString(), style: TextStyle(fontSize: FontSize.s16, color: MyColors.white), ),
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                    SizedBox(height: AppHeight.h2,),
                    _m!.headText(_suplierName, paddingV: MediaQuery.of(context).size.height/60*0, align: TextAlign.start, paddingH: MediaQuery.of(context).size.width/20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:[
                          GestureDetector(
                            onTap: () => launchPhone(phone: suplierList[index]['whatsappNumber'].toString(), context: context),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/3),
                              child: SvgPicture.asset('assets/images/phone.svg', color: MyColors.bodyText1, height: AppHeight.h6,),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => launchWhatsApp(phone: suplierList[index]['whatsappNumber'].toString(), message: ' ', context: context),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/3),
                              child: SvgPicture.asset('assets/images/whatsapp.svg', height: AppHeight.h6,),
                            ),
                          ),
                        ]
                    ),
                    suplierList[index]['details'] != null ? Container(
                      width: AppWidth.w100,
                      margin: EdgeInsets.all(AppPadding.p20),
                       decoration: BoxDecoration(
                         color: MyColors.topCon,
                         borderRadius: BorderRadius.all(Radius.circular(hSpace/3)),
                         boxShadow: const [BoxShadow(
                           color: MyColors.black,
                           offset: Offset(2, 3),
                           blurRadius: 3,
                         )],
                       ),
                     child: _htmlScreen(suplierList[index]['details']??''),
                     //child: _m!.bodyText1(unescape.convert(suplierList[index]['details']??''), align: TextAlign.start, padV: hSpace/3, scale: 1, maxLine: 100),
                   ):SizedBox(),
                  ],
                )
                  :
              _m!.userInfoProfile(_topBar(curve), hSpace, curve, () => _setState()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0 ?
            _m!.bottomContainer(
                _m!.mainChildrenBottomContainer(curve, () => _tap(1), () => _tap(2), () => _tap(3), _tapNum),
                curve)
                : const SizedBox(height: 0.1,),
          )
        ],
      ),
    );
  }

  _setState() {
    setState(() {

    });
  }

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
          )], ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child:
                  IconButton(
                    icon: Align(
                      alignment: lng == 2 ? Alignment.centerRight : Alignment.centerLeft,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    onPressed: ()=> Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.titleText1(
                      widget.barTitle),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.notificationButton(),
                ),
              ],
            ),
            // SizedBox(height: MediaQuery.of(context).size.height/40,),
            //_tapNum==1?
            //_m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/120)
            //    :
            //const SizedBox(),
          ],
        )
    );
  }

  _tap(num){
    if(num==2){
      //MyAPI(context: context).updateUserInfo(userData['id']);
    }
    setState(() {
      _tapNum = num;
    });
  }

  String? path ;

  selectAll() {
    for(int i = 0; i<_suplierListCheck.length; i++){
      _suplierListCheck[i] = true;
    }
    setState(() {});
  }

  clearAll() {
    for (int i = 0; i < _suplierListCheck.length; i++) {
      _suplierListCheck[i] = false;
    }
    setState(() {});
  }

  _htmlScreen(htmlText){
    return SingleChildScrollView(
      child: h.Html(
        data: """
        $htmlText
                """,
      ),
    );
  }
}