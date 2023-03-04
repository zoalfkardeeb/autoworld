import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:automall/screen/selectScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../MyWidget.dart';
import '../../api.dart';
import '../../color/MyColors.dart';
//import '../const.dart';
import '../../const.dart';
import '../../localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
class AddSellCarScreen extends StatefulWidget {
  AddSellCarScreen({Key? key, }) : super(key: key);

  @override
  _AddSellCarScreenState createState() => _AddSellCarScreenState();
}

class _AddSellCarScreenState extends State<AddSellCarScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var brandId, gategoryId, originalOrNot, indexGarage;
   List supplier = [];
  /*_AddSellCarScreenState(this.brandId, this.gategoryId, this.originalOrNot, this.supplier, this.indexGarage){
      print("$brandId\n $gategoryId \n $originalOrNot \n $supplier");
  }*/

  final _typeController = TextEditingController();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _numOfCylYearController = TextEditingController();
  final _productionYearController = TextEditingController();
  final _gearBoxTypeController = TextEditingController();
  final _motorTypeController = TextEditingController();
  final _keloMetrageController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _country = 'Qatar';
  var _state = 'state';

  List<ImageProvider?> imageList = [];
  //List<ImageObject> _imgObjs = [];
  List attach = [];

  var _tapNum = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _state = cityController.text;
    super.initState();
    _typeController.addListener(() {setState(() {});});
    _brandController.addListener(() {setState(() {});});
    _modelController.addListener(() {setState(() {});});
    _numOfCylYearController.addListener(() {setState(() {});});
    _productionYearController.addListener(() {setState(() {});});
    _gearBoxTypeController.addListener(() {setState(() {});});
    _motorTypeController.addListener(() {setState(() {});});
    _keloMetrageController.addListener(() {setState(() {});});
    _priceController.addListener(() {setState(() {});});
    _descController.addListener(() {setState(() {});});
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
    var width = MediaQuery.of(context).size.width / 1.2;
    _m = MyWidget(context);
    Null Function()? active;
    if(_typeController.text.isNotEmpty & _brandController.text.isNotEmpty &
    _modelController.text.isNotEmpty & _numOfCylYearController.text.isNotEmpty &
    _productionYearController.text.isNotEmpty & _gearBoxTypeController.text.isNotEmpty & _motorTypeController.text.isNotEmpty &
    _keloMetrageController.text.isNotEmpty & _priceController.text.isNotEmpty ) {
      active = () {
      //print(value);
      _showDialogForSubmit();
    };
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
                  //SizedBox(height: hSpace/2,),
                 // _m!.bodyText1(AppLocalizations.of(context)!.translate("Fill up the request form below to have the suitable parts for your car."), scale: 1.2, padding: MediaQuery.of(context).size.width/7, maxLine: 3),
                  Expanded(
                      child: ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10),
                        children: [
                          //SizedBox(height: hSpace/3,),
                          _m!.selectFromTheListDrop(curve, _typeController, () => _openList(_dropDownKeyType), AppLocalizations.of(context)!.translate('Type'), true, _dropDownType(width,curve)),
                          _m!.selectFromTheListDrop(curve, _brandController, () => _openList(_dropDownKeyBrand), AppLocalizations.of(context)!.translate('Brand'), true, _dropDownBrand(width,curve)),
                          _m!.selectFromTheListDrop(curve, _modelController, () => _openList(_dropDownKeyModel), AppLocalizations.of(context)!.translate('Model'), true, _dropDownModel(width,curve)),
                          _m!.selectFromTheListDrop(curve, _numOfCylYearController, () => _openList(_dropDownKeyNumOfCyl), AppLocalizations.of(context)!.translate('Number of cylinders'), true, _dropDownNumOfSyl(width,curve)),
                          _m!.textFiled(curve, MyColors.white, MyColors.black, _productionYearController, AppLocalizations.of(context)!.translate('production Year'), Icons.keyboard_arrow_down_outlined, withoutValidator: true, readOnly: true, click: ()=> _yearPicker()),
                          //_m!.selectFromTheListDrop(curve, _productionYearController, () => _openList(_dropDownKeyProductionYear), AppLocalizations.of(context)!.translate('production Year'), true, _dropDownProductionYear(width,curve)),
                          _m!.selectFromTheListDrop(curve, _gearBoxTypeController, () => _openList(_dropDownKeyGearBox), AppLocalizations.of(context)!.translate('Gear Box Type'), true, _dropDownGearBoxType(width,curve)),
                          _m!.selectFromTheListDrop(curve, _motorTypeController, () => _openList(_dropDownKeyMotorType), AppLocalizations.of(context)!.translate('Motor Type'), true, _dropDownMotorType(width,curve)),
                         _m!.textFiled(curve, Colors.white, MyColors.bodyText1, _keloMetrageController, AppLocalizations.of(context)!.translate('Kelometrage'), Icons.edit_outlined, withoutValidator: true, newLineAction: true, number: true),
                          _m!.textFiled(curve, Colors.white, MyColors.bodyText1, _priceController, AppLocalizations.of(context)!.translate('Price'), Icons.edit_outlined, withoutValidator: true, newLineAction: true, number: true),
                          _m!.textFiled(curve, Colors.white, MyColors.bodyText1, _descController, AppLocalizations.of(context)!.translate('Remarks'), Icons.edit_outlined, withoutValidator: true, newLineAction: true, height: MediaQuery.of(context).size.height/7),
                          SizedBox(height: hSpace/2,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              _m!.bodyText1(AppLocalizations.of(context)!.translate('Additional features'), scale: 1.2, padding: MediaQuery.of(context).size.width/20, maxLine: 3, align: TextAlign.start),

                            ],
                          ),
                          checkBoxAluminum(AppLocalizations.of(context)!.translate('Alluminium Tiers')),
                          checkBoxRoofWindow( AppLocalizations.of(context)!.translate('Roof window')),
                          checkLeatherSeats(AppLocalizations.of(context)!.translate('Leather seats')),
                          checkNavigationSystem( AppLocalizations.of(context)!.translate('Navigation system')),
                          checkRearScreen(AppLocalizations.of(context)!.translate('Rear screens')),
                          checkCameras(AppLocalizations.of(context)!.translate('Cameras')),
                          SizedBox(height: hSpace/2,),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Upload some files to demonstrate'), scale: 1.2, padding: MediaQuery.of(context).size.width/7, maxLine: 3),
                          GridView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: imageList.length == 7 ? imageList.length : imageList.length+1,
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

  /*_selectImageProfile() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);
    path = xFile!.path;
    print(path);
    setState(
          () {
        //  image = FileImage(File(path!));
      },
    );
  }*/

  Future<bool> _checkPermission(BuildContext context) async {
    //FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    if (isGranted) {
      //openCameraGallery();
      //_openDialog(context);
    }
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print("Location Permission is granted");
    }else{
      print("Location Permission is denied.");
    }

    bool isPermanentlyDenied =
        statusCamera == PermissionStatus.permanentlyDenied ||
            statusStorage == PermissionStatus.permanentlyDenied ||
            statusPhotos == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      return false;
      //_showSettingsDialog(context);
    }
    return false;
  }

  selectPhoto(int index) async{
   /* var t  = true;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      /*if(!await Permission.videos.isGranted) {
        await Permission.videos.request();
      }*/
      if(!await Permission.photos.isGranted) {
        await Permission.photos.request();
      }
    } else {
      if(!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
    }
    
    if(!await Permission.camera.isGranted && Platform.isAndroid) {
      await Permission.camera.request();
    }
    if(!await Permission.photos.isGranted && Platform.isIOS) {
      await Permission.photos.request();
    }
    if (androidInfo.version.sdkInt >= 33) {
      if(!await Permission.photos.isGranted) {
        t=false;
      }
    } else {
      if(!await Permission.storage.isGranted) {
        t = false;
      }
    }
    if(!await Permission.camera.isGranted && Platform.isAndroid) {
      t = false;
    }
    if(!await Permission.photos.isGranted && Platform.isIOS) {
      t = false;
    }


    if(t){
      final List<ImageObject>? objects = await Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return const ImagePicker(maxCount: 1);
      }));
      if ((objects?.length ?? 0) > 0) {
        setState(() {
          _imgObjs = objects!;
          path = objects[0]!.modifiedPath;
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
        });

      };
    }*/
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
    final ImagePicker _picker = ImagePicker();
    XFile? xFile = await _picker.pickImage(source: source, imageQuality: 50, maxHeight: 2000,maxWidth: 2000);

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

  _showDialogForSubmit(){
    var curve = MediaQuery.of(context).size.height / 30;
    _undo(){
      Navigator.of(context).pop();
    }
    _okay() async{
      Navigator.of(context).pop();
      setState(() {pleaseWait = true;});
      //var add = await MyAPI(context: context).sendSellCar(userInfo['id'], gategoryId, brandId, _vinNumberController.text, _carNameController.text, _modelController.text, _remarksController.text, attach, supplier, indexGarage);
      var add = await MyAPI(context: context).sendSellCar(userInfo['id'], listCarType[listCarType.indexWhere((element) => element['name']==_typeController.text)]['id'],
          brands[brands.indexWhere((element) => element['name']==_brandController.text)]['id'],
          carModelList[carModelList.indexWhere((element) => element['name']==_modelController.text)]['id'],
          int.parse(_productionYearController.text), attach,
          int.parse(_numOfCylYearController.text),
          listGearBoxCarType[listGearBoxCarType.indexWhere((element) => element['name']==_gearBoxTypeController.text)]['id'],
          double.parse(_keloMetrageController.text),
          double.parse(_priceController.text), _descController.text, alaminumTires, roofWindow, leatherSeats, navigationSystem, rearScreen,cameras,
        listCarMotorType[listCarMotorType.indexWhere((element) => element['name']==_motorTypeController.text)]['id'],
      );
      //var add = false;
      //if(add) await MyAPI(context: context).getCarSell();
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
                  child: _m!.dialogText1(AppLocalizations.of(context)!.translate('You will just submit to sell car!')),
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

  _showDialogForError(){
    var curve = MediaQuery.of(context).size.height / 30;
    _okay() async{
      Navigator.of(context).pop();

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
                  child: _m!.dialogText1(AppLocalizations.of(context)!.translate('please! Fill all fields.')),
                )
              ],
            ))
            ,
            Row(
              children: [
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2/3, AppLocalizations.of(context)!.translate('Okay'), null, ()=> _okay())
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);

  }
  final GlobalKey _dropDownKeyType = GlobalKey();
  final GlobalKey _dropDownKeyBrand = GlobalKey();
  final GlobalKey _dropDownKeyModel = GlobalKey();
  final GlobalKey _dropDownKeyNumOfCyl = GlobalKey();
  final GlobalKey _dropDownKeyProductionYear = GlobalKey();
  final GlobalKey _dropDownKeyGearBox = GlobalKey();
  final GlobalKey _dropDownKeyMotorType = GlobalKey();

  List<String> listNumOfCyl = <String>[
    '2',
    '3',
    '4',
    '6',
    '8'
  ];
  List<String> listProductionYear = <String>[];
  _dropDownType(width, curve){
    List<String> listType = [];
    for(int i=0; i<listCarType.length; i++){
      listType.add(listCarType[i]['name']);
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyType,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _typeController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }
  _dropDownBrand(width, curve){
    if(brands.isEmpty) MyAPI(context: context).getBrands();
    List<String> listType = [];
    for(int i=0; i<brands.length; i++){
      listType.add(brands[i]['name']);
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyBrand,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _brandController.text = chosen.toString();
                _modelController.text = '';
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }
  _dropDownModel(width, curve){
    List<String> listType = [];
    if(_brandController.text.isNotEmpty){
      if(carModelList.isEmpty) MyAPI(context: context).getCarModel();
      for(int i=0; i<carModelList.length; i++){
        if(carModelList[i]['brandId'] == brands[brands.indexWhere((element) => element['name']==_brandController.text)]['id']) {
          listType.add(carModelList[i]['name']);
        }
      }
    }
    if(listType.isEmpty) {
      //if(_brandController.text.isEmpty) MyAPI(context: context).flushBar('select Brand before Model');
      //else MyAPI(context: context).flushBar("there isn't model assign selected Brand!");
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyModel,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _modelController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }
  _dropDownNumOfSyl(width, curve){
    List<String> listType = listNumOfCyl;
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyNumOfCyl,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _numOfCylYearController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }
  _dropDownProductionYear(width, curve){
    List<String> listType = this.listProductionYear;
    for(int i = 1990; i<DateTime.now().year; i++){
      listType.add(i.toString());
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyProductionYear,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _productionYearController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }
  _dropDownGearBoxType(width, curve){
    List<String> listType = [];
    for(int i=0; i<listGearBoxCarType.length; i++){
      listType.add(listGearBoxCarType[i]['name']);
    }if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyGearBox,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _gearBoxTypeController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }
  _dropDownMotorType(width, curve){
    List<String> listType = [];
    for(int i=0; i<listCarMotorType.length; i++){
      listType.add(listCarMotorType[i]['name']);
    }if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyMotorType,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _motorTypeController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }
  _openList(dropDownKey) {
    /*if(cities.isEmpty){
      myAPI!.getCities();
      return;
    }*/
    dropDownKey.currentContext?.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
              //return false;
            });
          }
        });
      }
    });
  }

  bool alaminumTires = false;
  bool roofWindow = false;
  bool leatherSeats = false;
  bool navigationSystem = false;
  bool rearScreen = false;
  bool cameras = false;

  checkBoxAluminum(title){
    return CheckboxListTile(
      title: _m!.bodyText1(title, padding: 0.1, align: TextAlign.start),
      value: alaminumTires,
      shape: const CircleBorder(),
      checkboxShape: CircleBorder(),
      onChanged: (newValue) {
        setState(() {
          alaminumTires = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
  checkBoxRoofWindow(title){
    return CheckboxListTile(
      title: _m!.bodyText1(title, padding: 0.1, align: TextAlign.start),
      value: roofWindow,
      shape: const CircleBorder(),
      checkboxShape: CircleBorder(),
      onChanged: (newValue) {
        setState(() {
          roofWindow = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
  checkLeatherSeats(title){
    return CheckboxListTile(
      title: _m!.bodyText1(title, padding: 0.1, align: TextAlign.start),
      value: leatherSeats,
      shape: const CircleBorder(),
      checkboxShape: CircleBorder(),
      onChanged: (newValue) {
        setState(() {
          leatherSeats = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
  checkNavigationSystem(title){
    return CheckboxListTile(
      title: _m!.bodyText1(title, padding: 0.1, align: TextAlign.start),
      value: navigationSystem,
      shape: const CircleBorder(),
      checkboxShape: CircleBorder(),
      onChanged: (newValue) {
        setState(() {
          navigationSystem = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
  checkRearScreen(title){
    return CheckboxListTile(
      title: _m!.bodyText1(title, padding: 0.1, align: TextAlign.start),
      value: rearScreen,
      shape: const CircleBorder(),
      checkboxShape: CircleBorder(),
      onChanged: (newValue) {
        setState(() {
          rearScreen = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }
  checkCameras(title){
    return CheckboxListTile(
      title: _m!.bodyText1(title, padding: 0.1, align: TextAlign.start),
      value: cameras,
      shape: const CircleBorder(),
      checkboxShape: CircleBorder(),
      onChanged: (newValue) {
        setState(() {
          cameras = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    );
  }

  _yearPicker(){
    //1 -> from
    //2 -> to
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.translate('Select Year')),
            content: Container( // Need to use container to add size constraint.
              width: MediaQuery.of(context).size.height/4,
              height: MediaQuery.of(context).size.width/1.2,
              child: YearPicker(
                firstDate: DateTime(1940, 1),
                lastDate: DateTime(DateTime.now().year, 1),
                initialDate: DateTime.now(),
                // save the selected date to _selectedDate DateTime variable.
                // It's used to set the previous selected date when
                // re-showing the dialog.
                selectedDate: DateTime.now(),
                onChanged: (DateTime dateTime) {
                  // close the dialog when year is selected.
                  _productionYearController.text = dateTime.year.toString();
                  if(DateFormat('yyyy').parse(_productionYearController.text).compareTo(dateTime) > 0){
                    _productionYearController.text = dateTime.year.toString();
                  }
                  Navigator.pop(context);
                  // Do something with the dateTime selected.
                  // Remember that you need to use dateTime.year to get the year
                },
              ),
            ),
          );
        });
  }
}