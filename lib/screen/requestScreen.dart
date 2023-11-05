import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:automall/screen/selectScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

//import '../const.dart';
import '../const.dart';
import '../localizations.dart';
class RequestScreen extends StatefulWidget {
  var brandId, gategoryId, originalOrNot=true , indexGarage;
  List supplier = [];
  final String barTitle;
  RequestScreen(this.brandId, this.gategoryId, this.originalOrNot, this.supplier, {Key? key, this.indexGarage, required this.barTitle}) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState(brandId, gategoryId, originalOrNot, supplier, indexGarage);
}

class _RequestScreenState extends State<RequestScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var brandId, gategoryId, originalOrNot, indexGarage;
   List supplier = [];
  _RequestScreenState(this.brandId, this.gategoryId, this.originalOrNot, this.supplier, this.indexGarage){
      print("$brandId\n $gategoryId \n $originalOrNot \n $supplier");
  }

  final _vinNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _carNameController = TextEditingController();
  final _remarksController = TextEditingController();
  final _country = 'Qatar';
  var _state = 'state';

  List<ImageProvider?> imageList = [];
  List attach = [];

  var _tapNum = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _state = cityController.text;
    super.initState();
    _carNameController.addListener(() {setState(() {});});
    _vinNumberController.addListener(() {setState(() {});});
    _modelController.addListener(() {setState(() {});});
    _remarksController.addListener(() {setState(() {});});
    animateList(_scrollController);
    //startTime();
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
    active = () {
      //print(value);
      _showDialog();
    };
    /*
    if(gategoryId != 0 && _remarksController.text != ''){
      active = () {
        //print(value);
        _showDialog();
      };
    }
    else if (_vinNumberController.text=='' || _carNameController.text == '' || _modelController.text == '' || _remarksController.text == '') {
      active = null;
    }else{
      active = () {
        //print(value);
        _showDialog();
      };
    }
    */
    var br = 0.1;
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
              height: MediaQuery.of(context).size.height*(1-br),
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
                  SizedBox(height: hSpace/2,),
                  _m!.bodyText1(AppLocalizations.of(context)!.translate("Fill up the request form below to have the suitable parts for your car."), scale: 1.2, padding: MediaQuery.of(context).size.width/7, maxLine: 3),
                  Expanded(
                      child: ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10),
                        children: [
                          //SizedBox(height: hSpace/3,),
                          gategoryId==0?_m!.textFiled(curve, Colors.white, MyColors.bodyText1, _vinNumberController, AppLocalizations.of(context)!.translate('Enter VIN Number'), Icons.edit_outlined,number: false, withoutValidator: true)
                              : const SizedBox(height: 0,),
                          gategoryId==0?_m!.textFiled(curve, Colors.white, MyColors.bodyText1, _carNameController, AppLocalizations.of(context)!.translate('Enter Car Name'), Icons.edit_outlined, withoutValidator: true)
                              : const SizedBox(height: 0,),
                          gategoryId==0?_m!.textFiled(curve, Colors.white, MyColors.bodyText1, _modelController, AppLocalizations.of(context)!.translate('Enter Model'), Icons.edit_outlined, withoutValidator: true)
                              : const SizedBox(height: 0,),
                          _m!.textFiled(curve, Colors.white, MyColors.bodyText1, _remarksController, AppLocalizations.of(context)!.translate('remarks'), Icons.edit_outlined, height: MediaQuery.of(context).size.width/6.5*2, withoutValidator: true, newLineAction: false),
                          SizedBox(height: hSpace/2,),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('upload files instead'), scale: 1, padding: MediaQuery.of(context).size.width/20, maxLine: 5),
                          GridView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: imageList.length == 6 ? imageList.length : imageList.length+1,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.2,
                                    crossAxisCount: 2
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Container(
                                      //height: MediaQuery.of(context).size.width/2.5,
                                      //width: MediaQuery.of(context).size.width/2.5,
                                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40,vertical: MediaQuery.of(context).size.width/40),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(image: imageList.length == index? const AssetImage("assets/images/background.png") : imageList[index] as ImageProvider, fit: BoxFit.cover),
                                        color: Colors.grey,
                                        /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                                        border: Border.all(
                                          color: MyColors.card,
                                          width: 1,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.circular(curve/2),
                                      ),
                                      child: Icon(Icons.camera_alt, color: MyColors.white,size: MediaQuery.of(context).size.width/10,),
                                    ),
                                    onTap: () => selectPhoto(index),
                                  )
                                  ;
                                },
                              ),

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
                curve, bottomConRati: br)
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
          )],    ),
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
                      child: const Icon(Icons.arrow_back_ios),
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

  String path = '' ;

  _selectImageProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    path = xFile!.path;
    print(path);
    setState(
          () {
        //  image = FileImage(File(path!));
      },
    );
  }

  selectPhoto(int index) {
    Widget camera(){
      return GestureDetector(
        onTap: ()=> _addImage(index, ImageSource.camera),
        child: Row(
        children: [
         const Icon(Icons.camera_outlined, color: MyColors.mainColor,),
          _m!.bodyText1(AppLocalizations.of(context)!.translate("Camera"),align: TextAlign.start),
        ],
      ),
      );
    }
    Widget gallery(){
      return GestureDetector(
        onTap: ()=> _addImage(index, ImageSource.gallery),
        child: Row(
          children: [
            const Icon(Icons.photo, color: MyColors.mainColor,),
            _m!.bodyText1(AppLocalizations.of(context)!.translate("Gallery"),align: TextAlign.start),
          ],
        ),
      );
    }

    _m!.showSDialog(AppLocalizations.of(context)!.translate('Open?'), camera(), gallery());
  }

  _addImage(int index, source) async{
    Navigator.of(context).pop();
    final ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: source, imageQuality: 50, maxHeight: 2000,maxWidth: 2000);
    /*for(int i =50; i>10; i-5){
     var kbite = await xFile!.length()/1042;
     if(kbite>200){
       i = i-40;
       xFile = await _picker.pickImage(source: source, imageQuality: i);
       kbite = await xFile!.length()/1042;
       if(i<=10 && kbite>200){
         xFile = await _picker.pickImage(source: source, imageQuality: 5);
         kbite = await xFile!.length()/1042;
         print(kbite.toString());
         if(kbite>200) MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('Image size is too large!'));
         //return;
       }
     }else{
       print(kbite.toString());
       i = 10;
     }
      //if()
    }*/
    /*var kbite = await xFile!.length()/1042;
    if(kbite>200){
      //kbite = await xFile!.length()/1042;
      print(kbite.toString());
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('Image size is too large!'));
      return;
    }*/
    path = xFile!.path;
    print(path);
    setState(
          () {
            if(index>= imageList.length){
              var file = File(path);
              String base64Image = base64Encode(file.readAsBytesSync());
              //String fileName = file.path.split("/").last;
              imageList.add(FileImage(File(path)));
              attach.add({'base': base64Image, 'name':file.path.split("/").last});
            }else {
              imageList[index] = FileImage(File(path));
              var file = File(path);
              String base64Image = base64Encode(file.readAsBytesSync());
              attach[index] = {'base': base64Image, 'name':file.path.split("/").last};
              //String fileName = file.path.split("/").last;
            }
      },
    );
  }


  _showDialog(){
    if(_remarksController.text.isEmpty && imageList.isEmpty){
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('Please fill the remark or add an image'));
      return;
    }
    var curve = MediaQuery.of(context).size.height / 30;
    _undo(){
      Navigator.of(context).pop();
    }
    _okay() async{
      Navigator.of(context).pop();
      setState(() {pleaseWait = true;});
      var add = await MyAPI(context: context).orderCreate(userInfo['id'], gategoryId, brandId, _vinNumberController.text, _carNameController.text, _modelController.text, _remarksController.text, attach, supplier, indexGarage);
      //var add = false;
      if(add) await MyAPI(context: context).getOrders(userInfo['id']);
      setState(() {
        pleaseWait = false;
      });
      if(add){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SelectScreen(),),
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
                  child: _m!.dialogText1(AppLocalizations.of(context)!.translate('You have just submitted a search order!')),
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