// ignore_for_file: file_names
import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/carSell/AllBrandCarSells.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'ExhibtionCars.dart';
// ignore: camel_case_types
class ExhibtionScreen extends StatefulWidget {
  const ExhibtionScreen({Key? key}) : super(key: key);

  @override
  _ExhibtionScreenState createState() => _ExhibtionScreenState();
}

class _ExhibtionScreenState extends State<ExhibtionScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  ImageProvider? image;

  var _tapNum = 1;

  final TextEditingController _searchController = TextEditingController();
  List _foundExhibtion = exhibtions.where((element) => true).toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      _state = cityController.text;
    }catch(e){}
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isEmpty) {
          _foundExhibtion = offers.where((element) => true).toList();
        } else {
          _foundExhibtion = offers.where((element) => element['supplier']['fullName'].toString().toLowerCase().contains(_searchController.text.toLowerCase())).toList();
          //clearAll();
        }
      });
    });

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
                top: MediaQuery.of(context).size.height / 40*0,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize:
                          MediaQuery.of(context).size.width / 23,
                          color: MyColors.black,
                          fontFamily: 'Gotham'),
                      decoration: InputDecoration(
                        //border: InputBorder.none,
                        //labelText: titleText,
                        icon: const Icon(Icons.search),
                        hintText: AppLocalizations.of(context)!
                            .translate("Search by Supplier's name"),
                        hintStyle: TextStyle(
                            fontSize:
                            MediaQuery.of(context).size.width / 28,
                            color: MyColors.bodyText1,
                            fontFamily: 'GothamLight'),
                        errorStyle: TextStyle(
                          fontSize:
                          MediaQuery.of(context).size.width / 2400,
                        ),
                      ),
                    ),
                  ),*/
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: AppHeight.h2, horizontal: AppWidth.w4),
                      itemCount: _foundExhibtion.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          //child: _m!.cardExhibtion(curve, click: ()=> _selectCard(index), exhibtionLogo: _foundExhibtion[index]['galleryImg']/*['user']['imagePath']*/, toolImage: _foundExhibtion[index]['galleryImg'],toolName: lng==2?_foundExhibtion[index]['arTitle']:_foundExhibtion[index]['title'],companyName: lng==2?_foundExhibtion[index]['arDetails']:_foundExhibtion[index]['details']),
                          //child: _m!.cardOffers(curve,logo: _foundOffers[1]['supplier']['user']['imagePath'], toolImage: _foundOffers[1]['offerImg'],toolName: lng==2?_foundOffers[1]['arTitle']:_foundOffers[1]['title'],companyName: _foundOffers[1]['supplier']['fullName'], scale: 0.8),
                          child: MyWidget.shadowContainer(child: Image.network(_foundExhibtion[index]['galleryImg'], height: AppHeight.h16, fit: BoxFit.fitWidth,), paddingH: 0.0),
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
          )],     ),
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
                :*/
            const SizedBox()
            ,
          ],
        )
    );
  }

  _selectCard(index) async{

    setState(() {
      pleaseWait = true;
    });
    await Future.wait(
        [
          MyAPI(context: context).getBrands(),
          MyAPI(context: context).getCarType(),
          MyAPI(context: context).getCarModel(),
        ]);
    await MyAPI(context: context).getCarSell("", galleryId: _foundExhibtion[index]['id'].toString());
    setState(() {
      pleaseWait = false;
    });
    MyApplication.navigateTo(context, const AllBrandCarSells());
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