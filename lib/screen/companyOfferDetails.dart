// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/color/MyColors.dart';
import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/BrandScreen.dart';
import 'package:automall/screen/garageBody.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../MyWidget.dart';
import 'dart:io';
// ignore: camel_case_types
class CompanyOfferDetails extends StatefulWidget {
 var index;
  CompanyOfferDetails(this.index,{Key? key}) : super(key: key);

  @override
  State<CompanyOfferDetails> createState() => _CompanyOfferDetailsState(index);
}

class _CompanyOfferDetailsState extends State<CompanyOfferDetails> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  ImageProvider? image;

  var _tapNum = 1;
  var index;
  _CompanyOfferDetailsState(this.index);
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
                    Container(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/20, horizontal: MediaQuery.of(context).size.width/20),
                      child: _m!.cardOffers(curve,logo: offers[index]['supplier']['user']['imagePath'], toolImage: offers[index]['offerImg'],toolName: lng==2?offers[index]['arTitle']:offers[index]['title'],companyName: offers[index]['supplier']['fullName'], scale: 1.2),
                    ),
                  Expanded(child: SingleChildScrollView(
                    child: _m!.titleText1(lng==2?offers[index]['arDetails'].toString():offers[index]['details'].toString()),
                  ),),
                  _m!. raisedButton(curve, MediaQuery.of(context).size.width/1.3, AppLocalizations.of(context)!.translate('Call Via Phone'), 'assets/images/phone.svg', ()=> launchPhone(phone: offers[index]['supplier']['whatsappNumber'].toString(), context: context)),
                  SizedBox(height: hSpace/2,),
                  _m!. raisedButton(curve, MediaQuery.of(context).size.width/1.3, AppLocalizations.of(context)!.translate('Connect With Whatsapp'), 'assets/images/whatsapp.svg', ()=> launchWhatsApp(phone: offers[index]['supplier']['whatsappNumber'].toString(), message: '', context: context), color: MyColors.green),
/*                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width/20,),
                      IconButton(
                          onPressed: ()=>null,
                          icon: Icon(Icons.call_outlined, size: MediaQuery.of(context).size.width/6.5, color: MyColors.bottomCon,)),
                      SizedBox(width: MediaQuery.of(context).size.width/20,),
                    ],
                  ),
*/
                  SizedBox(height: hSpace/2,)
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
                :*/
            const SizedBox()
            ,
          ],
        )
    );
  }

  _selectCard(index) async{
    //await MyAPI(context: context).getBrandsCountry();
    /*if(index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  GarageBody(),
          ));
      return;
//      await MyAPI(context: context).getGarageBrands();
    }
    else if(index == 0){
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
            builder: (context) =>  BrandScreen(_state, _country, index, garageCountry: '', indexGarage: 0,),
          )
      );

    }else{
      setState(() {
        pleaseWait = true;
      });
      await MyAPI(context: context).getSupliers(0.1, getGategoryName(index), original: false, afterMarket: false, indexGarage: 0);
      setState(() {
        pleaseWait = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) =>  BrandScreen(_state, _country, 1, garageCountry: '', indexGarage: 0,),
            builder: (context) =>  SuplierScreen(0.1, index, false, indexGarage: 0,),
          )
      );
    }*/
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
    final ImagePicker _picker = ImagePicker();
    final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
    path = xFile!.path;
    print(path);
    setState(
          () {
        image = FileImage(File(path!));
      },
    );
  }

}