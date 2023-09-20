import 'package:automall/constant/app_size.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../const.dart';
import '../localizations.dart';

class GarageCountry extends StatefulWidget {
  var indexGarage =1;
  final String barTitle;
  GarageCountry(this.indexGarage, {Key? key, required this.barTitle}) : super(key: key);

  @override
  _GarageCountryState createState() => _GarageCountryState(indexGarage);
}

class _GarageCountryState extends State<GarageCountry> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var indexGarage =1;

  final _country = 'Qatar';
  var _state = 'state';

  List imageList = [];
  ImageProvider? image;

  var _tapNum = 1;
  _GarageCountryState(this.indexGarage);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i =0; i< brandsCountry.length; i++){
      imageList.add({'image': brandsCountry[i]['logo']??'https://flagsapi.com/AE/shiny/64.png', 'text': lng==2?brandsCountry[i]['arName']:brandsCountry[i]['name'], 'id':brandsCountry[i]['id']});
    }
    try{
      _state = cityController.text;
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
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
                  _m!.bodyText1(AppLocalizations.of(context)!.translate('Select the Country'), padding: 0.0, padV: hSpace/2, scale: 1.2),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: imageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColors.topCon,
                              borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4)),
                              boxShadow: const [BoxShadow(
                                color: MyColors.black,
                                offset: Offset(1, 2),
                                blurRadius: 4,
                              )],  ),
                            margin: EdgeInsets.only(left: AppWidth.w4, right: AppWidth.w4, bottom: AppHeight.h4),
                            padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppWidth.w1),
                            child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRect(
                                    child: imageList[index]['image'].toString().toLowerCase().contains('.svg')?
                                    SvgPicture.network(imageList[index]['image'], fit: BoxFit.fill,
                                      height: AppHeight.h8,
                                      width: AppHeight.h8,
                                    ):
                                    Image.network(imageList[index]['image'], fit: BoxFit.fill,
                                      height: AppHeight.h8,
                                      width: AppHeight.h8,
                                    ),
                                  )
                                  ,
                                  SizedBox(width: AppWidth.w4,),
                                  Expanded(
                                    flex: 1,
                                    child: _m!.headText(imageList[index]['text'], scale: 0.7, align: TextAlign.start, paddingV: MediaQuery.of(context).size.height/80),
                                  ),
                                ]
                              //color: MyColors.white,
                            ),
                          ),
                          onTap: () => _selectCard(index),
                        );
                      },
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
                  child:
                  IconButton(
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
                      widget.barTitle),
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

  _selectCard(index) async{
    setState(() {
      pleaseWait = true;
    });
    //if(index != 0) await MyAPI(context: context).getBrandsCountry();
    //await MyAPI(context: context).getGarageBrands();
    //await MyAPI(context: context).getBrands(country: imageList[index]['text']);
    await MyAPI(context: context).getSupliers(0.1, 'garages', original: false, afterMarket: false, indexGarage: indexGarage);
    setState(() {
      pleaseWait = false;
    });
      Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) =>  BrandScreen(_state, _country, 1, garageCountry: '', indexGarage: indexGarage,),
            builder: (context) =>  SuplierScreen(0.1, 1, false, indexGarage: indexGarage, barTitle: '${widget.barTitle}, '+ imageList[index]['text'],),
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
}
class MyClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double y = size.height;
    double x = size.width;
    double w = 0.0;

    var path = Path();
    var rect = Rect.fromLTRB(0, 0, x, y);
    path.addOval(rect);
    var rect2 = Rect.fromLTRB(0 + w, 0 + w, x - w, y - w);
    path.addOval(rect2);
    //path.lineTo(0, height);
   // path.quadraticBezierTo(width, height, width/2, height/2);
   // path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}