// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/color/MyColors.dart';
import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/garageCountry.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:automall/screen/carSell/AddSellCarScreen.dart';
import 'package:flutter/material.dart';

import '../../MyWidget.dart';
import 'BoardSelect.dart';
// ignore: camel_case_types

class FeaturedBoards extends StatefulWidget {
  @override
  _FeaturedBoardsState createState() => _FeaturedBoardsState();
}

class _FeaturedBoardsState extends State<FeaturedBoards> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';


  List broadListImageType = [];
  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      broadListImageType.clear();
      for(int i = 0; i<4; i++){
        broadListImageType.add({
          'image': "assets/images/key_type$i.png",
          //'text': brands[i]['name'],
          'id': i.toString(),
        });
      }

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
                  SizedBox(height: hSpace/2,),
                  _towRowIcos(),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.topCon,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(curve*2), right: Radius.circular(curve*2)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: curve),
                      child: GridView.builder(
                        itemCount: broadListImageType.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: ()=> _goToOfferCarsBrand(broadListImageType[index]['id']),
                            child: Padding(
                              padding: EdgeInsets.all(curve/3),
                              child: Image.asset(broadListImageType[index]['image'], fit: BoxFit.contain,),
                            ),
                          );
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

  _carBoardCard(curve, scale, keyNum){
    var color = MyColors.red;
    var width = MediaQuery.of(context).size.width/1.2*scale;
    var height = MediaQuery.of(context).size.height/4*scale;
    curve*=scale;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(curve),
      padding: EdgeInsets.all(curve * 1.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(curve/2)),
        border: Border.all(color: color, width: 2),
      ),
      child: Expanded(
        child: Container(
          child: Row(
            children: [
              Image.asset('assets/images/background.png', width: (height-curve*2)/4, height: height-curve*2, fit: BoxFit.cover,),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: curve/2,),
                      _m!.headText(AppLocalizations.of(context)!.translate('Car Panel'), paddingH: width/20, scale: scale*0.85, paddingV: curve/2, align: TextAlign.center),
                      _m!.headText(keyNum, scale: scale*0.85, align: TextAlign.center, paddingH: width/20, paddingV: 0.0),
                    ],
                  )
              )
            ],
          ),
          color: MyColors.white,
        ),
      )
      ,
    );
  }


  _brandCard(index, hSpace){

    return GestureDetector(
      child: MyWidget(context).brandCard(broadListImageType[index]['image'], hSpace, broadListImageType[index]['text']),
      onTap: ()=> _goToOfferCarsBrand(broadListImageType[index]['id']),

    );
  }

  _towRowIcos(){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /*GestureDetector(
            child: MyWidget(context).iconText("assets/images/ic_sell_car.svg", AppLocalizations.of(context)!.translate('Sell your car'), MyColors.black, vertical: true, scale: 1.4, imageScale: 1.6),
            onTap: ()=> _goToSellCar(),
          ),*/

          GestureDetector(
            child: MyWidget(context).iconText("assets/images/ic_all_brand.svg", AppLocalizations.of(context)!.translate('All type number'), MyColors.black, vertical: true, scale: 1.3, imageScale: 2),
            onTap: ()=> _goToOfferCarsBrand(''),

          ),

        ],
      ),
    );
  }

  _goToOfferCarsBrand(_boardId) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).getCarBroadKey(_boardId);
    setState(() {
      pleaseWait = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  BoardSelect(),
        ));
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
                  child: _m!.drawerButton(_scaffoldKey),
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
}