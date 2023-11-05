import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

//import '../const.dart';
import '../const.dart';
import '../localizations.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
class OfferScreen extends StatefulWidget {
  var foundOffer;
  var orderId , orderSerial;
  bool finished;
  final String barTitle;

  OfferScreen( {Key? key,this.foundOffer, this.orderId, this.orderSerial, required this.finished, required this.barTitle}) : super(key: key);

  @override
  _OfferScreenState createState() => _OfferScreenState(foundOffer, orderId, finished, orderSerial);
}

class _OfferScreenState extends State<OfferScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var foundOffer;
  var gategoryId = 1;
  var orderId, orderSerial;
  _OfferScreenState(this.foundOffer, this.orderId, this.finished, this.orderSerial);

  final _vinNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _carNameController = TextEditingController();
  final _remarksController = TextEditingController();
  final _country = 'Qatar';
  var _state = 'state';
  var _supplierName = 'Oamr';
  var _suplierEmail = 'omar.suhail.hasan@gmail.com';
  final _suplierMobile = '+963938025347';

  List<ImageProvider?> imageList = [];
  List attach = [];

  var _supluerImagePath;
  int _tapNum = 1, _rating = 3;
  //final ScrollController _scrollController = ScrollController();
  bool finished = false, _scored = false, isWinner = false;

  @override
  void initState() {
    // TODO: implement initState
    _state = cityController.text;
    super.initState();
    _remarksController.text = foundOffer['supplierNotes'].toString();
    //animateList(_scrollController);
    _supplierName = foundOffer['supplier']['fullName'];
    _supluerImagePath = foundOffer['supplier']['user']['imagePath'];
    _suplierEmail = foundOffer['supplier']['user']['email'];
    if(_supluerImagePath == "") _supluerImagePath = null;

    if(foundOffer['supplier']['rating'] == null || foundOffer['supplier']['rating'] == 0) {
      _rating = 3;
    }
    else{
      _rating = (foundOffer['supplier']['rating'] / 2).round();
    }
    if(foundOffer['score'] == null || foundOffer['score'] == 0) {
      _scored = false;
    }else{
      _scored = true;
    }
    if(foundOffer['status'] == 2)finished = true;
    isWinner = foundOffer['isWinner'];
    //startTime();
  }

  startTime() async {
    /*var duration = const Duration(milliseconds: 200);
    return Timer(duration, ()=> setState(() {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
    }));*/
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    Null Function()? active;
    if(!finished){
      active = () {
        //print(value);
        _showDialog();
      };
    }
    else if(isWinner && !_scored) {
      active = (){
        _evaluate();
      };
    }
    else{
      active = null;
    }
    var br = 0.1,
        suplierStarNum=_rating.round();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      //appBar: _m!.appBar(barHight, _scaffoldKey),
     // drawer: _m!.drawer(() => _setState(), ()=> _tap(2), _scaffoldKey),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(curve),
                  SizedBox(height: hSpace/2,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/40*0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _m!.logoContainer(_supluerImagePath, MediaQuery.of(context).size.width/2.5, isSupp: true),
                        /*CircleAvatar(
                          backgroundImage: _supluerImagePath == null ?  const AssetImage('assets/images/Logo1.png') as ImageProvider
                              : NetworkImage(_supluerImagePath),
                          /*child: ClipOval(
                            child: _supluerImagePath == null ?  Image.asset('assets/images/Logo1.png')
                                : Image.network(_supluerImagePath),
                          )*/
                          radius: MediaQuery.of(context).size.width/5,
                          backgroundColor: Colors.transparent,
                        ),*/
                        SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.width/5*2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _m!.headText(_supplierName, paddingV: MediaQuery.of(context).size.height/160, align: TextAlign.start, paddingH: MediaQuery.of(context).size.width/40, scale: 0.8),
                              SizedBox(height: MediaQuery.of(context).size.height/60,),
                              _m!.bodyText1(_suplierEmail, align: TextAlign.start),
                              const Expanded(child: SizedBox()),
                              _m!.starRow(MediaQuery.of(context).size.width/4, suplierStarNum*2, marginLeft: MediaQuery.of(context).size.width/20)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/30,),
                  _m!.headText(AppLocalizations.of(context)!.translate("The Supplier Notes:"), scale: 0.7, paddingH: MediaQuery.of(context).size.width/10, maxLine: 3, align: TextAlign.start),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: curve/4),
                    padding: EdgeInsets.all(curve/2),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: MyColors.white,
                              /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                              border: Border.all(
                                color: MyColors.white,
                                width: 0.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(curve/2),
                            ),
                            padding: EdgeInsets.all(curve/2),
                            //color: ,
                            child: _m!.bodyText1(_remarksController.text, align: TextAlign.start, padding: 0.0, maxLine: 15, scale: 1.2),
                          ),
                          SizedBox(height: hSpace/3,),
                          _m!.viewFile(foundOffer['replyAttachment'].toString()),
                          //_m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Open the Offer'), null, ()=> _openOffer(), color: MyColors.gray),
                        ],
                      ),
                    ),
                  ),
/*
                  SizedBox(height: hSpace/3,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10),
                    child:
                    _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, AppLocalizations.of(context)!.translate('Open the Offer'), null, ()=> _openOffer(), color: MyColors.gray),

                  ),*/
                  // SizedBox(height: hSpace/3,),
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
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2, !finished? AppLocalizations.of(context)!.translate('Submit'): _scored? AppLocalizations.of(context)!.translate('Evaluated'): AppLocalizations.of(context)!.translate('Evaluate'), 'assets/images/car.svg', active),
                curve, bottomConRati: br)
                : const SizedBox(height: 0.1,),
          ),
          Align(
            alignment: Alignment.center,
            child: /*false?*/pleaseWait?
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
          )],   ),
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
                      alignment: lng==2? Alignment.centerRight: Alignment.centerLeft,
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
                const Expanded(
                  flex: 1,
                  child: SizedBox(),// _m!.notificationButton(),
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
    final XFile? xFile = await picker.pickImage(source: source, imageQuality: 50);
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
    _undo(){
      Navigator.of(context).pop();
    }
    _okay() async{
      Navigator.of(context).pop();
      setState(() {pleaseWait = true;});
      var add = await MyAPI(context: context).orderSupplierWin(orderId, foundOffer['supplierId'], foundOffer['supplier']['user']['fbKey'], orderSerial);
      /*var add = await MyAPI(context: context).orderSupplierUpdate(foundOffer['supplierId'], orderId, foundOffer['supplierNotes'], [
        {'name': foundOffer['replyAttachment'].toString().split(' ').last,'base': foundOffer['replyAttachment']}
          ],isWinner: true, scoreNote:foundOffer['scoreNote'], score: _rating, statue: 2);*/
      if(add) {
        await MyAPI(context: context).getOrders(userInfo['id']);
        finished = true;
        isWinner = true;
      }
      setState(() {
        pleaseWait = false;
      });
      //if(add) Navigator.of(context!).pop();

    }
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(curve)), //this right here
      backgroundColor: MyColors.dialogColor,
      child: Container(
        //color: MyColors.gray,
        padding: EdgeInsets.symmetric(horizontal: curve/1.4, vertical: curve),
        height: MediaQuery.of(context).size.width/1.6,
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
                  child: _m!.dialogText1(AppLocalizations.of(context)!.translate('You will finish the order, by selecting this offer and supplier'), scale: 1),
                )
              ],
            )),
            //SizedBox(height: curve/2,),
            /*RatingStars(
              value: _rating,
              onValueChanged: (v) {
                //
                Navigator.of(context).pop();
                setState(() {
                  _rating = v;
                });
                _showDialog();
              },
              starBuilder: (index, color) => Icon(
                Icons.star,
                color: color,
              ),
              starCount: 5,
              starSize: MediaQuery.of(context).size.width/9,
              valueLabelColor: const Color(0xff9b9b9b),
              valueLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              valueLabelRadius: 10,
              maxValue: 5,
              starSpacing: 2,
              maxValueVisibility: false,
              valueLabelVisibility: false,
              animationDuration: Duration(milliseconds: 500),
              valueLabelPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              valueLabelMargin: const EdgeInsets.only(right: 8),
              starOffColor: MyColors.white,
              starColor: MyColors.mainColor,
            ),*/
            SizedBox(height: curve/2,),
            Row(
              children: [
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2/2.6, AppLocalizations.of(context)!.translate('Undo'), null, ()=> _undo(), color: MyColors.dialogColor, borderSide: MyColors.white),
                const Expanded(child: SizedBox()),
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2/2.6, AppLocalizations.of(context)!.translate('Finish'), null, ()async=> await _okay())
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  _openOffer() async{
    print(foundOffer['replyAttachment'].toString());
    if(foundOffer['replyAttachment'] == null) {
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('No file is uploaded'));
      return;
    }
    pleaseWait = true;
    _setState();
    await _m!.showNetworkFile(foundOffer['replyAttachment'].toString());
    pleaseWait = false;
    _setState();
    print(foundOffer['replyAttachment'].toString());
  }

  void _evaluate() {
    var curve = MediaQuery.of(context).size.height / 30;
    _undo(){
      Navigator.of(context).pop();
    }
    _okay() async{
      Navigator.of(context).pop();
      setState(() {pleaseWait = true;});
      var add = await MyAPI(context: context).orderRate(orderId, _rating*2.round().toInt(), foundOffer['supplier']['user']['fbKey']);
      if(add) {
        await MyAPI(context: context).getOrders(userInfo['id']);
        _scored = true;
      }
      setState(() {
        pleaseWait = false;
      });
      //if(add) Navigator.of(context!).pop();

    }
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(curve)), //this right here
      backgroundColor: MyColors.dialogColor,
      child: Container(
        //color: MyColors.gray,
        padding: EdgeInsets.symmetric(horizontal: curve/1.4, vertical: curve),
        height: MediaQuery.of(context).size.width/1.6,
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
                  child: _m!.dialogText1(AppLocalizations.of(context)!.translate('Evaluate this offer!'), scale: 1),
                )
              ],
            )),
            //SizedBox(height: curve/2,),
            RatingStars(
              value: _rating+0.0,
              onValueChanged: (v) {
                //
                Navigator.of(context).pop();
                setState(() {
                  _rating = v.round();
                });
                _evaluate();
              },
              starBuilder: (index, color) => Icon(
                Icons.star,
                color: color,
              ),
              starCount: 5,
              starSize: MediaQuery.of(context).size.width/9,
              valueLabelColor: const Color(0xff9b9b9b),
              valueLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              valueLabelRadius: 10,
              maxValue: 5,
              starSpacing: 2,
              maxValueVisibility: false,
              valueLabelVisibility: false,
              animationDuration: const Duration(milliseconds: 500),
              valueLabelPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              valueLabelMargin: const EdgeInsets.only(right: 8),
              starOffColor: MyColors.white,
              starColor: MyColors.mainColor,
            ),
            SizedBox(height: curve/2,),
            Row(
              children: [
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2/2.6, AppLocalizations.of(context)!.translate('Undo'), null, ()=> _undo(), color: MyColors.dialogColor, borderSide: MyColors.white),
                const Expanded(child: SizedBox()),
                _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.2/2.6, AppLocalizations.of(context)!.translate('OK'), null, ()async=> await _okay())
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

}
