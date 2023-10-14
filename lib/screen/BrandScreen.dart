import 'package:automall/constant/app_size.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../const.dart';
import '../localizations.dart';
class BrandScreen extends StatefulWidget {
  var _country = 'Qatar';
  var garageCountry = '1';
  var _state = 'state';
  var index = 1;
  var indexGarage =1;
  String barTitle= 'Auto World';

  BrandScreen(this._state, this._country, this.index, {Key? key, required this.garageCountry, required this.indexGarage, required this.barTitle}) : super(key: key);

  @override
  _BrandScreenState createState() => _BrandScreenState(_state, _country, index, garageCountry, indexGarage);
}

class _BrandScreenState extends State<BrandScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var indexGarage =1;

  var _country = 'Qatar';
  var _state = 'state';
  var index = 1;
  var mainPart='';
  var garageCountry = '1';

  _BrandScreenState(this._state, this._country, this.index, this.garageCountry, this.indexGarage);

  List brandList = [];
  ImageProvider? image;

  var _tapNum = 1;
  var _selectedBrand = 1000;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brandList.clear();
    for(int i = 0; i<brands.length; i++){
      brandList.add({
        'image': brands[i]['logo'],
        'text': brands[i]['name'],
        'id': brands[i]['id']
      });
    }
    _state = cityController.text;
    mainPart = getGategoryName(index);
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery
        .of(context)
        .size
        .height / 17;
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
      //appBar: _m!.appBar(barHight, _scaffoldKey),
      drawer: _m!.drawer(() => _setState(), ()=> _tap(2), ()=> _tap(1), _scaffoldKey),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * (1-bottomConRatio),
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 40*0,
              ),
              child: _tapNum == 1 ?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: MyColors.topCon,
                        //borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve))
                      ),
                      padding: EdgeInsets.symmetric(horizontal: curve),
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(vertical:1),
                        itemCount: brandList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.8,
                            crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return _brandCard(index, hSpace, _selectedBrand == index? true : false);
                        },
                      ),
                    ),

                  ),
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
                _m!.mainChildrenBottomContainer(
                    curve, () => _tap(1), () => _tap(2), () => _tap(3),
                    _tapNum),
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

  _brandCard(index, hSpace, show){
    if(pleaseWait) show=false;
    _child(){
      return GestureDetector(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    color: /*show? MyColors.white.withOpacity(0.5):*/ Colors.transparent,
            child: MyWidget.myNetworkImage(brandList[index]['image'],
               MediaQuery.of(context).size.width / 5,
              MediaQuery.of(context).size.width / 5,
            ),),
            /*brandList[index]['image'].toString().contains('https://automallonline.info')?
            Image.network(brandList[index]['image'], width: MediaQuery
                    .of(context)
                    .size
                    .width / 5, fit: BoxFit.contain,):
            Image.asset(
                  'assets/images/profile.png', width: MediaQuery
                    .of(context)
                    .size
                    .width / 5, fit: BoxFit.contain,)),*/
                SizedBox(height: hSpace / 3,),
                _m!.headText(
                  brandList[index]['text'], scale: 0.5,),
                SizedBox(height: hSpace / 3,),
              ]
            //color: MyColors.white,
          ),
        onTap: () => _selectBrand(index),
      );
    }
    return
      SimpleTooltip(
        tooltipTap: () {
          print("Tooltip tap");
        },
          ballonPadding: EdgeInsets.symmetric(horizontal: hSpace/20,vertical: hSpace/20),
          animationDuration: const Duration(milliseconds: 500),
          show: show,
          tooltipDirection:index<3?TooltipDirection.down:TooltipDirection.up,
          customShadows: const [BoxShadow(color: MyColors.white, blurRadius: 4, spreadRadius: 2)],
          backgroundColor: MyColors.black,
          borderColor: MyColors.black,
        //tooltipDirection: TooltipDirection.up,
          child: _child(),
          content: SizedBox(
            height: hSpace*1.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _m!.tooltibText(AppLocalizations.of(context)!.translate('Original'), ()=>_navigate(index, true)),
                SizedBox(height: hSpace/5,),
                Container(width: MediaQuery.of(context).size.width/3.3, height: 2, color: Colors.grey,),
                SizedBox(height: hSpace/5,),
                _m!.tooltibText(AppLocalizations.of(context)!.translate('After Market'), ()=>_navigate(index, false))
            ],
          ),
        )
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
                      _m!.titleText1(widget.barTitle),
                      _m!.bodyText1(AppLocalizations.of(context)!.translate('Select Your Brand'), padding: 0.0, padV: AppHeight.h1/2, scale: 0.7),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.notificationButton(),
                ),
              ],
            ),
            // SizedBox(height: MediaQuery.of(context).size.height/40,),
            /*_tapNum == 1 ?
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery
                .of(context)
                .size
                .height / 120)
                :
            const SizedBox()
            ,*/
          ],
        )
    );
  }

  _selectBrand(index) async{
    setState(() {
      (_selectedBrand == index) ? _selectedBrand = 10000000000 : _selectedBrand = index;
    });
   /* Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubSelectScreen(_state, _country, index),
        ));*/
  }

  _navigate(index, original) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).getSupliers(brandList[index]['id'], mainPart, original: original, afterMarket: !original, indexGarage: indexGarage, perBrand: true);
    setState(() {
      pleaseWait = false;
      _selectedBrand =1000;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuplierScreen(brandList[index]['id'], this.index, original, indexGarage: indexGarage, barTitle: widget.barTitle,),
        ));
  }

  _tap(num) {
    if (num == 2) {
      //MyAPI(context: context).updateUserInfo(userData['id']);
    }
    setState(() {
      _tapNum = num;
    });
  }

  String? path;

  _selectImageProfile() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
    path = xFile!.path;
    print(path);
    setState(
          () {
        //  image = FileImage(File(path!));
      },
    );
  }

}