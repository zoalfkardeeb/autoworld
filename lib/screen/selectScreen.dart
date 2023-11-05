// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/constant/images/imagePath.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/BrandScreen.dart';
import 'package:automall/screen/companyOffersScreen.dart';
import 'package:automall/screen/garageBody.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../MyWidget.dart';
import 'dart:io';

import 'carKey/FeaturedBoards.dart';
import 'carSell/CarForSeller.dart';
import '../helper/boxes.dart';
import 'exhibtion/ExhibtionScreen.dart';
// ignore: camel_case_types

class SelectScreen extends StatefulWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var _country = 'Qatar';
  var _state = 'state';

  List imageList = [];
  ImageProvider? image;

  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message.notification!.title.toString(),style: TextStyle(fontSize: MediaQuery.of(context).size.width/25),),
                subtitle: Text(message.notification!.body.toString(),style: TextStyle(fontSize: MediaQuery.of(context).size.width/20)),
              ),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => {
                      setState(() {
                        /*_selectedIndex = 1;
                        _initialOrderTab = 1;
                        new Timer(Duration(seconds:2), ()=>setState(() {}));*/
                        Navigator.pop(context);
                      }),
                    },
                    child: const Icon(
                      Icons.check,
                      color: MyColors.mainColor,
                    ))
              ],
            ));
      }

      //LocalNotificationService.display(message);
    });

    _read();
    try{
     _state = cityController.text;
    }catch(e){}
  }

  _read() async {
    var box = Boxes.getTransactions();
    transactions = box.values.toList();
    if(transactions!.isEmpty) {
      addTransaction();
    } else{
      cities = transactions![0].cities;
      offers = transactions![0].offers;
      brands = transactions![0].brands;
      brandsCountry = transactions![0].brandsCountry;
      suplierList = transactions![0].suplierList;
      ordersList = transactions![0].ordersList;
      userData = transactions![0].userData;
      userInfo = transactions![0].userInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    _country = AppLocalizations.of(context)!.translate('Qatar');
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    imageList.clear();
    imageList.add({'image': ImagePath.spareParts, 'text': AppLocalizations.of(context)!.translate('Spare Parts'), 'id':0});
    imageList.add({'image': ImagePath.carForSell, 'text': AppLocalizations.of(context)!.translate('Car for Sell'), 'id':20});
    imageList.add({'image': ImagePath.garages, 'text': AppLocalizations.of(context)!.translate('Garages'), 'id':1});
    imageList.add({'image': ImagePath.batteriesAndTyres, 'text': AppLocalizations.of(context)!.translate('Batteries & tyres'), 'id':2});
    imageList.add({'image': ImagePath.motorVanService, 'text': AppLocalizations.of(context)!.translate('Motor Service Van'), 'id':3});
    imageList.add({'image': ImagePath.offers, 'text': AppLocalizations.of(context)!.translate('Offers'), 'id':4});
    imageList.add({'image': ImagePath.scrapParts, 'text': AppLocalizations.of(context)!.translate('Scrape Parts'), 'id':5});
    imageList.add({'image': ImagePath.rentACar, 'text': AppLocalizations.of(context)!.translate('Rent a Car'), 'id':6});
    imageList.add({'image': ImagePath.breakDownService, 'text': AppLocalizations.of(context)!.translate('Breakdown Service'), 'id':7});
    imageList.add({'image': ImagePath.carCare, 'text': AppLocalizations.of(context)!.translate('Car Modifications'), 'id':8});
    imageList.add({'image': ImagePath.accessories, 'text': AppLocalizations.of(context)!.translate('Accessories'), 'id':9});
    imageList.add({'image': ImagePath.customisation, 'text': AppLocalizations.of(context)!.translate('Customisation'), 'id':10});
    imageList.add({'image': ImagePath.featuredBoards, 'text': AppLocalizations.of(context)!.translate('Featured boards'), 'id':11});
    imageList.add({'image': ImagePath.exhibition, 'text': AppLocalizations.of(context)!.translate('exhibition'), 'id':12});
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
              padding: const EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                //top: MediaQuery.of(context).size.height / 40,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  const SizedBox(height: 3,),
                  Expanded(
                    flex: 1,
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40),
                        itemCount: imageList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.9,
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(imageList[index]['image'], width: MediaQuery.of(context).size.width/2.5, fit: BoxFit.contain,),
                                  SizedBox(height: hSpace/3,),
                                  _m!.headText(imageList[index]['text'], scale: 0.5, ),
                                  SizedBox(height: hSpace/3,),
                                ]
                              //color: MyColors.white,
                            ),
                            onTap: () => _selectCard(index),
                          )
                            ;
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
        boxShadow: const [BoxShadow(
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
          _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/120, align: TextAlign.start)
              :
              const SizedBox(),*/

        ],
      )
    );
  }

  _selectCard(index) async{
     //await MyAPI(context: context).getBrandsCountry();
    if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Garages')) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  GarageBody(barTitle: imageList[index]['text'],),
          ));
      return;
//      await MyAPI(context: context).getGarageBrands();
    }
    if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Car for Sell')) {
      setState(() {
        pleaseWait = true;
      });

      await Future.wait(
          [
        MyAPI(context: context).getBrands(),
        MyAPI(context: context).getCarType(),
        MyAPI(context: context).getCarModel(),
      ]);
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const CarForSeller(),
          ));
      return;
//      await MyAPI(context: context).getGarageBrands();
    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Spare Parts')){
      setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getBrands();
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  BrandScreen(_state, _country, index, garageCountry: '', indexGarage: 0, barTitle: imageList[index]['text'],),
          )
      );

    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Offers') ){
      setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getOffers();
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const CompanyOffersScreen(),
          )
      );

    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('exhibition') ){
      setState(() {
        pleaseWait = true;
      });
    //  await MyAPI(context: context).getOffers();
      await MyAPI(context: context).getExhibtion();
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const ExhibtionScreen(),
          )
      );

    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Customisation')){
      setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getSupliers(0.1, 'GaragCustomization', original: false, afterMarket: false, indexGarage: 3);
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  SuplierScreen(0.1, 1, false, indexGarage: 3, barTitle: imageList[index]['text'], withoutQutation: true,),)
      );
      /*setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getBrandsCountry();
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  GarageCountry(3),
          )
      );*/
    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Rent a Car')){
      setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getSupliers(0.1, 'CarRents', original: false, afterMarket: false);
      //await MyAPI(context: context).getOffers(num: 2);
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  SuplierScreen(0.1, 6, false, barTitle: imageList[index]['text'], withoutQutation: true,),));
      /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  CarRentOffers( barTitle: imageList[index]['text'],),
          )
      );*/
    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Car Modifications')){
      setState(() {
        pleaseWait = true;
      });
      //await MyAPI(context: context).getOffers(num: 1);
      await MyAPI(context: context).getSupliers(0.1, 'CarCare', original: false, afterMarket: false);
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  SuplierScreen(0.1, 8, false, barTitle: imageList[index]['text'], withoutQutation: true,),));
      /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  CarRentOffers(barTitle: imageList[index]['text'],),
          )
      );*/
    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Breakdown Service')){
      setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getSupliers(0.1, getGategoryName(imageList[index]['id']), original: false, afterMarket: false, indexGarage: 0);
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) =>  BrandScreen(_state, _country, 1, garageCountry: '', indexGarage: 0,),
            builder: (context) =>  SuplierScreen(0.1, imageList[index]['id'], false, indexGarage: 0, withoutQutation: true, barTitle: imageList[index]['text'],),
          )
      );
    }
    else if(imageList[index]['text'] == AppLocalizations.of(context)!.translate('Featured boards')){

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  FeaturedBoards(barTitle: imageList[index]['text'],),
          ));
      return;
    }
    else {
      setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getSupliers(0.1, getGategoryName(imageList[index]['id']), original: false, afterMarket: false, indexGarage: 0);
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) =>  BrandScreen(_state, _country, 1, garageCountry: '', indexGarage: 0,),
            builder: (context) =>  SuplierScreen(0.1, imageList[index]['id'], false, indexGarage: 0, barTitle: imageList[index]['text'],),
          )
      );
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

  _selectImageProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    path = xFile!.path;
    print(path);
    setState(
          () {
       image = FileImage(File(path!));
      },
    );
  }

}