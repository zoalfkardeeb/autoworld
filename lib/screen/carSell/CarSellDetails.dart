// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/photoView.dart';
import 'package:automall/screen/garageCountry.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:automall/screen/carSell/AddSellCarScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../MyWidget.dart';
import 'AllBrandCarSells.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

// ignore: camel_case_types

class CarSellDetails extends StatefulWidget {
  var indexCarSell = 0;
  CarSellDetails({Key? key, required this.indexCarSell}) : super(key: key);

  @override
  _CarSellDetailsState createState() => _CarSellDetailsState(indexCarSell);
}

class _CarSellDetailsState extends State<CarSellDetails> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var _indexCarSell = 0;

  _CarSellDetailsState(this._indexCarSell);
  final _country = 'Qatar';
  var _state = 'state';

  List<Widget> imageList = [];
  List<GalarryItems> imageListGallery = [];
  var name = "name",view = " ", brandLogo="", kelomtarge='2000', productionYear='2022', price='200000', venName='', venNotes='', venPhone='963 03254132', venLocation='123355', cyl = '4', gearType, motorType;
  var _tapNum = 1;
  bool _aditionalFeatures = false;
  bool _alumunimTiers = false;
  bool _roofWindow = false;
  bool _leatherSeats = false;
  bool _navigationSystem = false;
  bool _rearScreen = false;
  bool _cameras = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cyl = carSellsList[_indexCarSell]['numberOfCylindes'].toString();
    gearType = carSellsList[_indexCarSell]['gearBoxType'].toString();
    motorType = carSellsList[_indexCarSell]['motorType'].toString();
    view = carSellsList[_indexCarSell]['viewCount'].toString();
    name = listCarType[listCarType.indexWhere((element) => carSellsList[_indexCarSell]['type'].toString() == element['id'].toString() )]['name']  +
         "  "+carModelList[carModelList.indexWhere((element) => carSellsList[_indexCarSell]['carModelId'] == element['id'])]['name'].toString();
    brandLogo = brands[brands.indexWhere((element) => carSellsList[_indexCarSell]['brandId'] == element['id'])]['logo'].toString();
    kelomtarge = formatter.format(carSellsList[_indexCarSell]['kelometrage']).toString();
    productionYear = carSellsList[_indexCarSell]['productionYear'].toString();
    price = formatter.format(carSellsList[_indexCarSell]['price']).toString();
    venName = carSellsList[_indexCarSell]['user']['name'].toString();
    venPhone = carSellsList[_indexCarSell]['user']['mobile'].toString();
    venLocation = carSellsList[_indexCarSell]['user']['country']['name'].toString() + ', ' + carSellsList[_indexCarSell]['user']['city']['name'].toString();
    venNotes = carSellsList[_indexCarSell]['notes'];
    _alumunimTiers = carSellsList[_indexCarSell]['alloyWheels'];
    _roofWindow = carSellsList[_indexCarSell]['sunRoof'];
    _cameras = carSellsList[_indexCarSell]['camera'];
    _rearScreen = carSellsList[_indexCarSell]['nearScreens'];
    _navigationSystem = carSellsList[_indexCarSell]['navigationMaps'];
    _leatherSeats = carSellsList[_indexCarSell]['leatherSeats'];
    if(_alumunimTiers || _roofWindow || _cameras || _rearScreen || _navigationSystem || _leatherSeats) _aditionalFeatures = true;
    try{
      _state = cityController.text;
    }catch(e){}
    imageListGallery.clear();
    imageListGallery.add(GalarryItems(image: carSellsList[_indexCarSell]['mainAttachment'].toString(), id: 0) );
    if(carSellsList[_indexCarSell]['firstAttachment'].toString().isNotEmpty) imageListGallery.add(GalarryItems(image: carSellsList[_indexCarSell]['firstAttachment'].toString(), id: 1));
    if(carSellsList[_indexCarSell]['secondAttachment'].toString().isNotEmpty) imageListGallery.add(GalarryItems(image: carSellsList[_indexCarSell]['secondAttachment'].toString(), id: 2));
    if(carSellsList[_indexCarSell]['thirdAttachment'].toString().isNotEmpty) imageListGallery.add(GalarryItems(image: carSellsList[_indexCarSell]['thirdAttachment'].toString(), id: 3));
    if(carSellsList[_indexCarSell]['forthAttachment'].toString().isNotEmpty) imageListGallery.add(GalarryItems(image: carSellsList[_indexCarSell]['forthAttachment'].toString(), id: 4));
    if(carSellsList[_indexCarSell]['fifthAttachment'].toString().isNotEmpty) imageListGallery.add(GalarryItems(image: carSellsList[_indexCarSell]['fifthAttachment'].toString(), id: 5));
    if(carSellsList[_indexCarSell]['sixthAttachment'].toString().isNotEmpty) imageListGallery.add(GalarryItems(image: carSellsList[_indexCarSell]['sixthAttachment'].toString(), id: 6));
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    var _width = MediaQuery.of(context).size.width / 1.2;
    var _height = MediaQuery.of(context).size.height / 5;
    var vSpace = MediaQuery.of(context).size.height/70;
    var scale =0.95;
    _m = MyWidget(context);
    print(_indexCarSell.toString());
    imageList.clear();
    imageListGallery.forEach((element) {
     imageList.add(
         _m!.networkImage(element.image, _width, crossAlign: CrossAxisAlignment.center, height: _height)
     );
   });
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
                  GestureDetector(
                    onTap: ()=> _m!.showImage('src', listNetworkImage: imageListGallery, selectedIndex: _selectedImageIndex),
                    child: _imageSlider(imageList),
                  )
                  ,
                 // SizedBox(height: hSpace/4,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: curve),
                    child: Row(
                      children: [
                        _m!.networkImage(brandLogo, MediaQuery.of(context).size.height/15),
                        SizedBox(width: curve/2,),
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
                                _m!.bodyText1(view + ' ' + AppLocalizations.of(context)!.translate('View'), scale: 0.9, padding: 0.5, padV: 2.0),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: hSpace/8,),
                  Expanded(
                    flex: 1,
                    child: Padding(
                       padding: EdgeInsets.symmetric(horizontal: curve/4, vertical: hSpace/8),
                       child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(curve/4),
                              margin: EdgeInsets.only(bottom: curve/2, left: 2, right: 2, top: 3),
                              decoration: BoxDecoration(
                                  boxShadow: [
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
                                  children: [
                                    _m!.headText(AppLocalizations.of(context)!.translate('Car Information'),scale: 0.6, paddingV: curve/2),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                _m!.iconText("assets/images/ic_km.svg", kelomtarge  +  AppLocalizations.of(context)!.translate('Km'), MyColors.red, scale: scale, imageScale: 0.33, paddingH: 0.0),
                                                SizedBox(height: vSpace,),
                                                _m!.iconText("assets/images/gear_automatic.svg",
                                                    AppLocalizations.of(context)!.translate('Gear') + ": " +
                                                        listGearBoxCarType[listGearBoxCarType.indexWhere((element) => gearType == element['id'].toString())]['name'],
                                                    MyColors.red, scale: scale, imageScale: 0.55, paddingH: 2),
                                                SizedBox(height: vSpace,),
                                                _m!.iconText("assets/images/ic_pr_year.svg", AppLocalizations.of(context)!.translate('Man. Date: ') + productionYear, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                _m!.iconText("assets/images/ic_price.svg", AppLocalizations.of(context)!.translate('Price') + ": " + price, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2,),
                                                SizedBox(height: vSpace,),
                                                _m!.iconText("assets/images/ic_engine.svg", AppLocalizations.of(context)!.translate('Engine') + ": " +cyl
                                                    +AppLocalizations.of(context)!.translate("Cylinders"), MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                                SizedBox(height: vSpace,),
                                                _m!.iconText("assets/images/ic_motor_type.svg", AppLocalizations.of(context)!.translate('Type') + ": " +
                                                    listCarMotorType[listCarMotorType.indexWhere((element) => motorType == element['id'].toString())]['name'], MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      height: MediaQuery.of(context).size.width / 14 * 3,
                                      width: MediaQuery.of(context).size.width / 1.2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _aditionalFeatures? _additionalFeatursCountainer(curve, scale): SizedBox(),
                            !carSellsList[_indexCarSell]['isPaid']? Container(
                              padding: EdgeInsets.all(curve/4),
                              margin: EdgeInsets.only(bottom: curve/2, left: 2, right: 2),
                              decoration: BoxDecoration(
                                  boxShadow: [
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
                                                venNotes.isNotEmpty?_notes(venNotes, curve/2, scale):SizedBox(),
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
                            ):SizedBox(),
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
            alignment: Alignment.bottomCenter,
            child: MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0 ?
            _m!.bottomContainer(
                _m!.mainChildrenBottomContainer(curve, () => _tap(1), () => _tap(2), () => _tap(3), _tapNum),
                curve)
                : const SizedBox(height: 0.1,),
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

  int _selectedImageIndex = 0;

  _imageSlider(listImage){
    return ImageSlideshow(

      /// Width of the [ImageSlideshow].
      width: double.infinity,

      /// Height of the [ImageSlideshow].
      height: MediaQuery.of(context).size.height/3.5,

      /// The page to show when first creating the [ImageSlideshow].
      initialPage: 0,

      /// The color to paint the indicator.
      indicatorColor: MyColors.red,

      /// The color to paint behind th indicator.
      indicatorBackgroundColor: Colors.grey,

      /// The widgets to display in the [ImageSlideshow].
      /// Add the sample image file into the images folder
      children: listImage,

      /// Called whenever the page in the center of the viewport changes.
      onPageChanged: (value) {
        _selectedImageIndex = value;
        print('Page changed: $value');
      },

      /// Auto scroll interval.
      /// Do not auto scroll with null or 0.
      autoPlayInterval: null,

      /// Loops back to first slide.
      isLoop: true,
    );
  }

  _additionalFeatursCountainer(curve, scale){
    List _carSellList = [];
    if(_alumunimTiers) _carSellList.add({'image':'assets/images/ic_tiers.svg','name':AppLocalizations.of(context)!.translate('Alluminium Tiers')});
    if(_navigationSystem) _carSellList.add({'image':'assets/images/ic_navigation.svg','name':AppLocalizations.of(context)!.translate('Navigation system')});
    if(_roofWindow) _carSellList.add({'image':'assets/images/ic_roof.svg','name':AppLocalizations.of(context)!.translate('Roof window')});
    if(_rearScreen) _carSellList.add({'image':'assets/images/ic_rear_screen.svg','name':AppLocalizations.of(context)!.translate('Rear screens')});
    if(_leatherSeats) _carSellList.add({'image':'assets/images/ic_leather_seat.svg','name':AppLocalizations.of(context)!.translate('Leather seats')});
    if(_cameras) _carSellList.add({'image':'assets/images/ic_camera.svg','name':AppLocalizations.of(context)!.translate('Cameras')});

    if(_aditionalFeatures){
      return Container(
      padding: EdgeInsets.all(curve/4),
      margin: EdgeInsets.only(bottom: curve/2, left: 2, right: 2),
      decoration: BoxDecoration(
          boxShadow: [
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
          children: [
            _m!.headText(AppLocalizations.of(context)!.translate('Additional features'),scale: 0.6, paddingV: curve/2),
            Container(
              child: GridView.builder(
                padding: EdgeInsets.all(0.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: _carSellList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 6,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return _m!.iconText(_carSellList[index]['image'], _carSellList[index]['name'], MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2);
                },
              ),
              height: MediaQuery.of(context).size.width / 20 * _carSellList.length/2.round() + MediaQuery.of(context).size.width / 14,
              width: MediaQuery.of(context).size.width / 1.2,
            ),
          ],
        ),
      ),
    );
    } else return SizedBox();
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
          boxShadow: [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],
        ),
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
                      child: Icon(Icons.arrow_back_ios),
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


}

class MyPainter extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final points = [
      Offset(curve, curve),
      Offset(0, 0),
      Offset(0, curve*2),
    ];
    final paint = Paint()
      ..color = MyColors.bodyText1
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTRB(0, curve, curve*2, curve*3);
    final startAngle = 3.14;
    final sweepAngle = 3.14/2;
    final useCenter = false;
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