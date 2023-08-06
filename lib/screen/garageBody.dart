// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/color/MyColors.dart';
import 'package:automall/const.dart';
import 'package:automall/images/imagePath.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/garageCountry.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:flutter/material.dart';

import '../MyWidget.dart';
// ignore: camel_case_types

class GarageBody extends StatefulWidget {
  @override
  _GarageBodyState createState() => _GarageBodyState();
}

class _GarageBodyState extends State<GarageBody> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  List imageList = [];
  ImageProvider? image;

  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      _state = cityController.text;
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    imageList.clear();
    imageList.add({'image': ImagePath.body, 'text': AppLocalizations.of(context)!.translate('Body')});
    imageList.add({'image': ImagePath.mechanical, 'text': AppLocalizations.of(context)!.translate('Mechanical')});
    imageList.add({'image': ImagePath.electrical, 'text': AppLocalizations.of(context)!.translate('Electrical')});
    //imageList.add({'image': 'assets/images/customGarage.png', 'text': AppLocalizations.of(context)!.translate('Customisation')});
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
                  SizedBox(height: hSpace/2,),
                  _m!.bodyText1(AppLocalizations.of(context)!.translate('Select Your Service'), padding: 0.0, padV: 0.0, scale: 1.3),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: imageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20, right: MediaQuery.of(context).size.width/20,
                            bottom: MediaQuery.of(context).size.height/20),
                            child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset(imageList[index]['image'], width: MediaQuery.of(context).size.width/3, height: MediaQuery.of(context).size.height/7, fit: BoxFit.contain,),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width/40,),
                                  Expanded(
                                    flex: 3,
                                    child: _m!.headText(imageList[index]['text'], scale: 0.6, align: TextAlign.start,paddingH: 0.0),
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

  _selectCard(index) async{
    setState(() {
      pleaseWait = true;
    });
    if(index != 0) {
      await MyAPI(context: context).getBrandsCountry();
    } else {
      //await MyAPI(context: context).getBrands();
      await MyAPI(context: context).getSupliers(0.1, 'garages', original: false, afterMarket: false, indexGarage: 0);
    }
    setState(() {
      pleaseWait = false;
    });
    if(index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) =>  BrandScreen(_state, _country, 1, garageCountry: '', indexGarage: 0,),
            builder: (context) =>  SuplierScreen(0.1, 1, false, indexGarage: 0,),
          )
      );
    }
    else{
      {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  GarageCountry(index),
            )
        );
      }
    }
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