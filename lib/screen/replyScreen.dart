import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:automall/screen/SupplierOrder.dart';
import 'package:automall/screen/selectScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

//import '../const.dart';
import '../const.dart';
import '../localizations.dart';
class ReplyScreen extends StatefulWidget {
  var foundOrder;
  final String barTitle;

  ReplyScreen(this.foundOrder, {Key? key, required this.barTitle}) : super(key: key);

  @override
  _ReplyScreenState createState() => _ReplyScreenState(this.foundOrder);
}

class _ReplyScreenState extends State<ReplyScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var foundOrder;
  _ReplyScreenState(this.foundOrder);

  final _remarksController = TextEditingController();
  final _country = 'Qatar';
  var _state = 'state';
  var _custumerName = 'Oamr';
  var _custumerEmail = 'omar.suhail.hasan@gmail.com';
  var _custumerMobile = '+963938025347';

  List<ImageProvider?> imageList = [];
  List attach = [];

  var _customerImagePath = null;
  var _tapNum = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _state = cityController.text;
    super.initState();
    _remarksController.addListener(() {setState(() {});});
    animateList(_scrollController);
    //startTime();
    _custumerName = foundOrder['user']['name'];
    _custumerMobile = foundOrder['user']['mobile'];
    _custumerEmail = foundOrder['user']['email'];
    _customerImagePath = foundOrder['user']['imagePath'];
    if(_customerImagePath.toString().contains(' ')|| _customerImagePath.toString()=='') _customerImagePath = null;
  }

  startTime() async {
    var duration = const Duration(milliseconds: 200);
    return Timer(duration, ()=> setState(() {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    Null Function()? active;
    if(_remarksController.text != ''){
      active = () {
        //print(value);
        _showDialog();
      };
    }
    else {
      active = null;
    }
    var _br = 0.1;
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
                        Expanded(
                          child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: hSpace/2,),
                              _m!.logoContainer(_customerImagePath, MediaQuery.of(context).size.width/3),
                              _m!.headText(_custumerName, paddingV: MediaQuery.of(context).size.height/80, align: TextAlign.start, paddingH: MediaQuery.of(context).size.width/30),
                              SizedBox(height: MediaQuery.of(context).size.height/40,),
                              /*Row(
                                children: [
                                  _m!.headText(AppLocalizations.of(context)!.translate("Reply"), scale: 0.9, paddingH: MediaQuery.of(context).size.width/7, maxLine: 3, paddingV: 0.0, align: TextAlign.start),
                                ],
                              ),*/
                              _m!.textFiled(curve, Colors.white, MyColors.bodyText1, _remarksController, AppLocalizations.of(context)!.translate('remarks'), Icons.edit_outlined, height: MediaQuery.of(context).size.width/6*2, newLineAction: false),
                              SizedBox(height: hSpace/2,),
                              _m!.bodyText1(AppLocalizations.of(context)!.translate('Upload your offer file as Pdf or Image'), scale: 1.2, padding: MediaQuery.of(context).size.width/7, maxLine: 3),
                              GridView.builder(
                                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/60, horizontal: MediaQuery.of(context).size.width/15),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: 1,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2,
                                    crossAxisCount: 1
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Container(
                                        alignment: Alignment.center,
                                        //height: MediaQuery.of(context).size.width/2.5,
                                        //width: MediaQuery.of(context).size.width/2.5,
                                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40*0,vertical: MediaQuery.of(context).size.width/40),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(image: imageList.length == index? const AssetImage("assets/images/background.png") : imageList[index] as ImageProvider, fit: BoxFit.cover),
                                          color: Colors.grey,
                                          border: Border.all(
                                            color: MyColors.card,
                                            width: 1,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius: BorderRadius.circular(curve/2),
                                        ),
                                        child: Stack(
                                          children: [
                                            attach.length > 0? _m!.viewFileBase64(attach[0]['base'].toString()) : SizedBox(),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Icon(Icons.file_open, color: MyColors.bodyText1,size: MediaQuery.of(context).size.width/7,),
                                            )
                                          ],
                                        )
                                    ),
                                    onTap: ()async => await selectPhoto(index),
                                  )
                                  ;
                                },
                              ),
                            ],

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
              //_m!.mainChildrenBottomContainer(curve, () => _tap(1), () => _tap(2), () => _tap(3), _tapNum),
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Send Offer'), 'assets/images/car.svg', active),
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
                  child: SizedBox(),//_m!.notificationButton(),
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

  String path = '' ;

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

  selectPhoto(int index) async{
      attach.clear();
      var s = await _m!.pickFileAsBase64String();
      print(s);
      if (s == null) return;
      attach.add(s);
    setState(() {

    });
  }

  _addImage(int index, source) async{
    Navigator.of(context).pop();
    final ImagePicker _picker = ImagePicker();
    final XFile? xFile = await _picker.pickImage(source: source, imageQuality: 50);
    path = xFile!.path;
    print(path);
    setState(
          () {
        if(index>= imageList.length){
          var file = File(path);
          String base64Image = base64Encode(file.readAsBytesSync());
          //String fileName = file.path.split("/").last;
          imageList.add(FileImage(File(path)));
          attach.add(base64Image);
        }else {
          imageList[index] = FileImage(File(path));
        }
      },
    );
  }

  _showDialog(){
    var curve = MediaQuery.of(context).size.height / 30;
    var ii = ordersListSupplier.indexWhere((element) => element['orders']==foundOrder);
    _undo(){
      Navigator.of(context).pop();
    }
    _okay() async{
      Navigator.of(context).pop();
      setState(() {pleaseWait = true;});
      var add = await MyAPI(context: context).orderSupplierUpdate(ordersListSupplier[0]['supplierId'], foundOrder['id'], _remarksController.text, attach, isWinner: ordersListSupplier[ii]['isWinner'], score: ordersListSupplier[ii]['score'], scoreNote: ordersListSupplier[ii]['scoreNote'], statue: 1, costomerFBkey: foundOrder['user']['fbKey'], orderSerial: foundOrder['serial']);
      if(add) await MyAPI(context: context).getOrders(userInfo['id']);
      setState(() {
        pleaseWait = false;
      });
      if(add){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SupplierOrdesr(barTitle: AppLocalizations.of(context)!.translate('name'),),),
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
                  child: _m!.dialogText1(AppLocalizations.of(context)!.translate('You have just sent your offer to the costumer! the offer will evaluate.')),
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
