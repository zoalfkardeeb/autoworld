import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../MyWidget.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../const.dart';
import '../localizations.dart';
class SuplierInfo extends StatefulWidget {
  var index;
  final String barTitle;
  SuplierInfo(this.index, {Key? key, required this.barTitle}) : super(key: key);

  @override
  _SuplierInfoState createState() => _SuplierInfoState(index);
}

class _SuplierInfoState extends State<SuplierInfo> {
  var index;
  _SuplierInfoState(this.index);
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  var _suplierImagePath;
  var _suplierName = 'Omar';
  var _suplierEmail= '';
  var _suplierStarNum= 6.0;
  final List _suplierListCheck = [];

  ImageProvider? image;

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _workHourController = TextEditingController();
  final _cityController = TextEditingController();
  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityController.text = suplierList[index]['user']['city']??= 'Doha';
   _state = _cityController.text??'';
   _suplierName = suplierList[index]['fullName']??'';
   _nameController.text = _suplierName??'';
   _mobileController.text = suplierList[index]['whatsappNumber']??'';
   _workHourController.text = suplierList[index]['workHour']??'';
   _suplierImagePath = suplierList[index]['user']['imagePath'];
   if(_suplierImagePath == '') _suplierImagePath = null;
   _suplierEmail = suplierList[index]['user']['email'];
   _suplierStarNum = suplierList[index]['rating']??=6.0;
  // _suplierStarNum = _suplierStarNum*2;
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
                top: 0*MediaQuery.of(context).size.height / 40,
              ),
              child: _tapNum == 1?
              Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(curve),
                    Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _m!.logoContainer(_suplierImagePath.toString().endsWith(' ')? null : _suplierImagePath, MediaQuery.of(context).size.width/2.5, isSupp: true),
                          /*CircleAvatar(
                                  backgroundImage: _suplierImagePath.toString().endsWith(' ') ?  const AssetImage('assets/images/Logo1.png') as ImageProvider
                                      : NetworkImage(_suplierImagePath),
                                  child: ClipOval(
                                    child: _suplierImagePath.toString().endsWith(' ') ?  Image.asset('assets/images/Logo1.png')
                                        : Image.network(_suplierImagePath, height: MediaQuery.of(context).size.width/5*2, width: MediaQuery.of(context).size.width/5*2, fit: BoxFit.cover,),
                                  )
                                  ,
                                  radius: MediaQuery.of(context).size.width/5,
                                  backgroundColor: Colors.transparent,
                                ),*/
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _m!.headText(_suplierName, paddingV: MediaQuery.of(context).size.height/60*0, align: TextAlign.start, paddingH: MediaQuery.of(context).size.width/20),
                                SizedBox(height: MediaQuery.of(context).size.height/60,),
                                _m!.bodyText1(_suplierEmail, align: TextAlign.start),
                                Expanded(child: Row(
                                    children:[
                                      GestureDetector(
                                        onTap: () => launchWhatsApp(phone: suplierList[index]['whatsappNumber'].toString(), message: ' ', context: context),
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/3),
                                      child: SvgPicture.asset('assets/images/whatsapp.svg'),
                                    ),
                                      ),
                                      GestureDetector(
                                        onTap: () => launchPhone(phone: suplierList[index]['whatsappNumber'].toString(), context: context),
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/3),
                                      child: SvgPicture.asset('assets/images/phone.svg', color: MyColors.bodyText1,),
                                    ),
                                      ),
                                  ]
                                )),
                                _m!.starRow(MediaQuery.of(context).size.width/4, _suplierStarNum, marginLeft: MediaQuery.of(context).size.width/20)
                              ],
                            ),
                            width: MediaQuery.of(context).size.width/2,
                            height: MediaQuery.of(context).size.width/5*2,
                          )
                        ],
                      ),
                    ),
                    _m!.bodyText1(AppLocalizations.of(context)!.translate('Personal information'), align: TextAlign.start, padV: hSpace/3, scale: 1.2),
                    Expanded(
                      child: ListView(
                       children: [
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Full Name'), align: TextAlign.start, padding: MediaQuery.of(context).size.width/10,padV: hSpace/7),
                          _m!.ProfiletextFiled(curve, MyColors.white, MyColors.black, _nameController, readOnly: true),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Work Hour'), align: TextAlign.start, padding: MediaQuery.of(context).size.width/10,padV: hSpace/7),
                          _m!.ProfiletextFiled(curve, MyColors.white, MyColors.black, _workHourController, readOnly: true),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Contact Number'), align: TextAlign.start, padding: MediaQuery.of(context).size.width/10,padV: hSpace/7),
                          _m!.ProfiletextFiled(curve, MyColors.white, MyColors.black, _mobileController, readOnly: true),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('City'), align: TextAlign.start, padding: MediaQuery.of(context).size.width/10,padV: hSpace/7),
                          _m!.ProfiletextFiled(curve, MyColors.white, MyColors.black, _cityController, readOnly: true),
                        ],
                      ),),
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
                      alignment: lng == 2 ? Alignment.centerRight : Alignment.centerLeft,
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
            _tapNum==1?
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/120)
                :
            const SizedBox()
            ,
          ],
        )
    );
  }

  _selectCard(index) {
/*    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  SubSelectScreen(_state, _country, index),
        ));
*/
  }

  _tap(num){
    if(num==2){
      //MyAPI(context: context).updateUserInfo(userData['id']);
    }
    setState(() {
      _tapNum = num;
    });
  }

  String? path ;

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

  _explore(index) {}

  selectAll() {
    for(int i = 0; i<_suplierListCheck.length; i++){
      _suplierListCheck[i] = true;
    }
    setState(() {});
  }

  clearAll() {
    for (int i = 0; i < _suplierListCheck.length; i++) {
      _suplierListCheck[i] = false;
    }
    setState(() {});
  }

  _check(index) {
    _suplierListCheck[index] = !_suplierListCheck[index];
    setState(() {});
  }


}