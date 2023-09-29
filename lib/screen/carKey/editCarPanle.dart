import 'dart:async';

import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/selectScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class EditCarPanle extends StatefulWidget {
  final String barTitle;
  var carPanel;
  EditCarPanle({Key? key, required this.barTitle, required this.carPanel}) : super(key: key);
  @override
  State<EditCarPanle> createState() => _EditCarPanleState();
}

class _EditCarPanleState extends State<EditCarPanle> {
  MyWidget? _m;
  final _numOfCarPanle = TextEditingController();
  final _priceController = TextEditingController();

  List<ImageProvider?> imageList = [];
  //List<ImageObject> _imgObjs = [];
  List attach = [];

  var _tapNum = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _numOfCarPanle.addListener(() {setState(() {});});
    _priceController.addListener(() {setState(() {});});
  }


  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    var width = MediaQuery.of(context).size.width / 1.2;
    _m = MyWidget(context);
    Null Function()? active;
    if(_numOfCarPanle.text.isNotEmpty & _priceController.text.isNotEmpty ) {
      active = () {
        //print(value);
        _showDialogForSubmit();
      };
    }
    var _br = 0.1;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.height*(1-_br),
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
                    //SizedBox(height: hSpace/2,),
                    // _m!.bodyText1(AppLocalizations.of(context)!.translate("Fill up the request form below to have the suitable parts for your car."), scale: 1.2, padding: MediaQuery.of(context).size.width/7, maxLine: 3),
                   Expanded(
                        child: ListView(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10),
                          children: [
                            //SizedBox(height: hSpace/3,),
                            _m!.textFiled(curve, Colors.white, MyColors.bodyText1, _numOfCarPanle, AppLocalizations.of(context)!.translate('Car Panel'), Icons.edit_outlined, withoutValidator: true, readOnly: true),
                            _m!.textFiled(curve, Colors.white, MyColors.bodyText1, _priceController, AppLocalizations.of(context)!.translate('Price'), Icons.edit_outlined, withoutValidator: true, number: true),
                          ],
                        )
                    ),
                    //SizedBox(height: hSpace/3,),
                    //_m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Submit'), 'assets/images/car.svg', active),
                    //SizedBox(height: hSpace/3,),
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
                //_m!.mainChildrenBottomContainer(curve, () => _tap(1), () => _tap(2), () => _tap(3), _tapNum),
                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Submit'), 'assets/images/car.svg', active),
                  curve, bottomConRati: _br)
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
                      alignment: lng==2? Alignment.centerRight:Alignment.centerLeft,
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
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/40)
                :*/
            const SizedBox()
            ,
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

  _showDialogForSubmit(){
    if(_numOfCarPanle.text.length<3||_numOfCarPanle.text.length>6){
      MyWidget(context).showSDialog( AppLocalizations.of(context)!.translate('Please, input right number [3 -> 6] digits'), SizedBox(), SizedBox());
      return;
    }
    var curve = MediaQuery.of(context).size.height / 30;
    _undo(){
      Navigator.of(context).pop();
    }
    _okay() async{
      Navigator.of(context).pop();
      print('tttttt');
      setState(() {pleaseWait = true;});
      var add = await MyAPI(context: context).sendSellCarPanle(userInfo['id'], int.parse(_priceController.text), _numOfCarPanle.text);
      //var add = await MyAPI(context: context).sendSellCar(userInfo['id'], gategoryId, brandId, _vinNumberController.text, _carNameController.text, _modelController.text, _remarksController.text, attach, supplier, indexGarage);
      setState(() {
        pleaseWait = false;
      });
      if(add){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SelectScreen(),),
              (Route<dynamic> route) => false,
        );
      }
    }
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(curve)), //this right here
      backgroundColor: MyColors.dialogColor,
      child: Container(
        //color: MyColors.gray,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
        height: MediaQuery.of(context).size.width/1.7,
        width: MediaQuery.of(context).size.width/1.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _m!.dialogText1(AppLocalizations.of(context)!.translate('name'),scale: 1.1),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/checkDialog.svg'),
                Expanded(
                  child: _m!.dialogText1(AppLocalizations.of(context)!.translate('You will just submit to sell car Panle!')),
                )
              ],
            ))
            ,
            Row(
              children: [
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2/3, AppLocalizations.of(context)!.translate('Undo'), null, ()=> _undo(), color: MyColors.dialogColor, borderSide: MyColors.white),
                const Expanded(child: SizedBox()),
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2/3, AppLocalizations.of(context)!.translate('Okay'), null, ()=> _okay())
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }
}
