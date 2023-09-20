//import 'dart:html';

import 'package:automall/constant/app_size.dart';
import 'package:automall/screen/requestScreen.dart';
import 'package:automall/screen/suplierInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../const.dart';
import '../localizations.dart';

class SuplierScreen extends StatefulWidget {
  var brandId, gategoryId, originalOrNot, indexGarage;
  var withoutQutation;
  final String barTitle;

  SuplierScreen(this.brandId, this.gategoryId, this.originalOrNot,
      {Key? key, this.indexGarage, this.withoutQutation, required this.barTitle})
      : super(key: key);

  @override
  _SuplierScreenState createState() =>
      _SuplierScreenState(brandId, gategoryId, originalOrNot, indexGarage, withoutQutation);
}

class _SuplierScreenState extends State<SuplierScreen> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var brandId, gategoryId, originalOrNot, indexGarage;
  var _withoutQutation;

  _SuplierScreenState(this.brandId, this.gategoryId, this.originalOrNot, this.indexGarage, this._withoutQutation){

  }

  final _country = 'Qatar';
  var _state = 'state';

  final List _suplierListCheck = [];

  ImageProvider? image;

  var _tapNum = 1;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List _foundSupliers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _state = cityController.text;
    _foundSupliers = suplierList.toList();
    _foundSupliers.removeWhere((element) => element['id']==userInfo['id']);
    for (int i = 0; i < _foundSupliers.length; i++) {
      _suplierListCheck.add(false);
    }
    animateList(_scrollController);
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isEmpty) {
          _foundSupliers = suplierList.toList();
        } else {
          _foundSupliers = suplierList.where((element) => element['fullName'].toString().toLowerCase().contains(_searchController.text.toLowerCase())).toList();
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    //_foundSupliers = suplierList;
    //_foundSupliers[1]['fullName'] = 'Absi';
    //_foundSupliers[1]['id'] = '4';
    //_foundSupliers[3]['fullName'] = 'Samir';
    _m = MyWidget(context);
    var _bR = 0.1;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      //appBar: _m!.appBar(barHight, _scaffoldKey),
      drawer: _m!.drawer(() => _setState(), () => _tap(2), ()=> _tap(1), _scaffoldKey),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * (1-_bR),
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: 0*MediaQuery.of(context).size.height / 40,
              ),
              child: _tapNum == 1
                  ? Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _topBar(curve),
                        /*SizedBox(
                          height: hSpace / 2,
                        ),
                        _m!.bodyText1(
                            AppLocalizations.of(context)!.translate("Supplier's list of your area"),
                            scale: 1.1,
                            padding: 0.0),
                        SizedBox(
                          height: hSpace / 5,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: curve / 1.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _m!.raisedButton(
                                  curve * 2,
                                  MediaQuery.of(context).size.width / 4,
                                  AppLocalizations.of(context)!
                                      .translate('SelectAll'),
                                  null,
                                  () => selectAll(),
                                  height:
                                      MediaQuery.of(context).size.width / 10),
                              SizedBox(
                                width: curve,
                              ),
                              _m!.raisedButton(
                                  curve * 2,
                                  MediaQuery.of(context).size.width / 4,
                                  AppLocalizations.of(context)!
                                      .translate('ClearAll'),
                                  null,
                                  () => clearAll(),
                                  height:
                                      MediaQuery.of(context).size.width / 10),
                            ],
                          ),
                        ),*/
                        SizedBox(
                          height: hSpace / 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: curve),
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
                        ),
                        //_m!.textFiled(curve, MyColors.backGround, MyColors.bodyText1, _searchController, AppLocalizations.of(context)!.translate("Supplier's list of your area"), Icons.filter_list, withoutValidator: true),
                        /*Container(
                    height: hSpace/20,
                    margin: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2*0),
                    color: Colors.grey,
                  ),*/
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _foundSupliers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: _suplierContainerNew(index, curve),
                                //color: MyColors.white,
                                onTap: () => _selectCard(index),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: hSpace / 3,
                        ),
                        /*_m!.raisedButton(
                            curve,
                            MediaQuery.of(context).size.width / 1.2,
                            AppLocalizations.of(context)!
                                .translate('Quotation'),
                            'assets/images/car.svg',
                            () => search()),
                        SizedBox(
                          height: hSpace / 3,
                        ),*/
                      ],
                    )
                  : _m!.userInfoProfile(
                      _topBar(curve), hSpace, curve, () => _setState()),
            ),
          ),
          /*Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery.of(context).viewInsets.bottom == 0
                ? _m!.bottomContainer(
                    _m!.mainChildrenBottomContainer(curve, () => _tap(1),
                        () => _tap(2), () => _tap(3), _tapNum),
                    curve)
                : const SizedBox(
                    height: 0.1,
                  ),
          )*/
          Align(
        alignment: Alignment.bottomCenter,
        child: _withoutQutation!=null? SizedBox() : MediaQuery.of(context).viewInsets.bottom == 0
            ? _m!.bottomContainer(
            _m!.raisedButton(
                curve,
                MediaQuery.of(context).size.width / 1.2,
                AppLocalizations.of(context)!
                    .translate('Quotation'),
                'assets/images/car.svg',
                    () => search()),
            curve, bottomConRati: _bR)
            : const SizedBox(
          height: 0.1,
        ),),
        ],
      ),
    );
  }

  _setState() {
    setState(() {});
  }

  _search() {}

  _topBar(curve) {
    return Container(
        //centerTitle: true,
        //height: barHight,
        padding: EdgeInsets.symmetric(
            horizontal: curve,
            vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(curve),
              bottomRight: Radius.circular(curve)),
          boxShadow: [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Align(
                      alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
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
                :
            SizedBox()
            ,*/
          ],
        ));
  }

  _selectCard(index) {
/*    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  SubSelectScreen(_state, _country, index),
        ));
*/
  }

  _tap(num) {
    if (num == 2) {
      //MyAPI(context: context).updateUserInfo(userData['id']);
    }
    setState(() {
      _tapNum = num;
    });
  }

  String? path;

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

  _suplierContainerNew(index, curve){
    var bbbb = '';
    brandId == 0.1? bbbb = '' : bbbb = brands[brands.indexWhere((element) => element['id'] == brandId)]['name'];
    var raduis = AppHeight.h12;
    var _starNum, _suplierName, _suplierDetails, _suplierImagePath;
    _suplierName = _foundSupliers[index]['fullName'];
    _suplierImagePath = _foundSupliers[index]['user']['imagePath'];
    if(_suplierImagePath.toString().endsWith(' ') || _suplierImagePath.toString()== '') {
      _suplierImagePath = null;
    }
    try {
      _starNum = _foundSupliers[index]['rating'];
      //_suplierDetails = _foundSupliers[index]['sub'];
      //_suplierImagePath = _foundSupliersindex]['image'];
    } catch (e) {
      _starNum = 0;
      _suplierDetails = 'New to the list';
    }
    _starNum ??= 0;
    _suplierDetails ??= _m!.getGategoryName(gategoryId) +
        ', ' +
        bbbb;
    curve = MediaQuery.of(context).size.height / 30 / 2;
    suplierName() {
      return Container(
        height: raduis,
        padding: EdgeInsets.symmetric(vertical: raduis/10),
        margin: lng==2?EdgeInsets.only(right: 1.5):EdgeInsets.only(left: 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _m!.suplierNameText(_suplierName,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Icon(Icons.star_border, color: MyColors.mainColor,size: AppWidth.w10,),
                    //MyWidget(context).bodyText1(_starNum.toString(),padding: AppWidth.w10/3, padV: AppWidth.w10/6),
                  ],
                ),
              ],
            ),
            _m!.suplierDesText1(_suplierDetails, scale: 0.8, padding: 0.0),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () => _explore(index),
      child: Container(
        margin: EdgeInsets.only(left: AppWidth.w4, right: AppWidth.w4, bottom: AppHeight.h2*1.5),
        padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppWidth.w1),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.all(Radius.circular(AppWidth.w4)),
          boxShadow: const [BoxShadow(
            color: MyColors.black,
            offset: Offset(1, 2),
            blurRadius: 4,
          )],
        ),
        child: Row(
          children: [
            _m!.logoContainer(_suplierImagePath, raduis, isSupp: true),
            SizedBox(width: AppWidth.w2,),
            Expanded(child: suplierName()),
            _withoutQutation == null?
            GestureDetector(
              onTap: () => _check(suplierList.indexOf(_foundSupliers[index])),
              child: Image.asset(_suplierListCheck[suplierList.indexOf(_foundSupliers[index])]
                  ? 'assets/images/check.png'
                  : 'assets/images/check-not.png', width: AppWidth.w8,),
            ):SizedBox(),
            _withoutQutation != null?
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: curve * 0, vertical: raduis / 6 * 0),
              child: GestureDetector(
                onTap: () => launchWhatsApp(phone: _foundSupliers[index]['whatsappNumber'].toString(), message: ' ', context: context),
                child: SvgPicture.asset('assets/images/whatsapp.svg'),
              ),
            ):
            SizedBox(),
            _withoutQutation != null?
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: curve * 0, vertical: raduis / 6 * 0),
              child: GestureDetector(
                onTap: () => launchPhone(phone: _foundSupliers[index]['whatsappNumber'].toString(), context: context),
                child: SvgPicture.asset('assets/images/phone.svg', color: MyColors.bodyText1),
              ),
            ):
            SizedBox(),
          ],
        ),
      ),
    );
  }
  _suplierListContainer(index, curve) {
    var bbbb = '';
    brandId == 0.1? bbbb = ''
    : bbbb = brands[brands.indexWhere((element) => element['id'] == brandId)]['name'];

    var raduis = MediaQuery.of(context).size.width / 7;
    var _starNum, _suplierName, _suplierDetails, _suplierImagePath;
    _suplierName = _foundSupliers[index]['fullName'];
    _suplierImagePath = _foundSupliers[index]['user']['imagePath'];
    if(_suplierImagePath.toString().endsWith(' ') || _suplierImagePath.toString()== '') {
      _suplierImagePath = null;
    }
    try {
      _starNum = _foundSupliers[index]['rating'];
      //_suplierDetails = _foundSupliers[index]['sub'];
      //_suplierImagePath = _foundSupliersindex]['image'];
    } catch (e) {
      _starNum = 0;
      _suplierDetails = 'New to the list';
    }
    _starNum ??= 0;
    _suplierDetails ??= _m!.getGategoryName(gategoryId) +
        ', ' +
        bbbb;
    curve = MediaQuery.of(context).size.height / 30 / 2;
    suplierName() {
      return Container(
        margin: lng==2?EdgeInsets.only(right: raduis * 1.5):EdgeInsets.only(left: raduis * 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _m!.suplierNameText(_suplierName),
            SizedBox(
              height: raduis / 20*0,
            ),
            _m!.suplierDesText1(_suplierDetails, scale: 0.8),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _check(suplierList.indexOf(_foundSupliers[index])),
      child: Container(
        height: raduis * 7 / 5,
        padding:
            EdgeInsets.symmetric(horizontal: curve * 2, vertical: raduis / 6),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: curve * 0, vertical: raduis / 6 * 0),
              child: SvgPicture.asset(_suplierListCheck[suplierList.indexOf(_foundSupliers[index])]
                  ? 'assets/images/check.svg'
                  : 'assets/images/check-not.svg'),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
                    child: Padding(
                      padding: lng==2?EdgeInsets.only(right: curve * 1.5):EdgeInsets.only(left: curve * 1.5),
                      child: _m!.logoContainer(_suplierImagePath, raduis, isSupp: true),
                    ),
                  ),
                  Align(
                    alignment: lng==2?Alignment.bottomRight:Alignment.bottomLeft,
                    child: Padding(
                      padding: lng==2?EdgeInsets.only(right: curve * 1.5+raduis/2):EdgeInsets.only(left: 0.0 ),
                      child: _m!.starRow(raduis, _starNum),
                    ),
                  ),
                  Align(
                    alignment: lng==2?Alignment.topRight:Alignment.topLeft,
                    child: suplierName(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: curve /2),
              child: GestureDetector(
                onTap: () => _explore(index),
                child: SvgPicture.asset('assets/images/eyeCircle.svg'),
              ),
            ),
            _withoutQutation != null?
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: curve * 0, vertical: raduis / 6 * 0),
              child: GestureDetector(
                onTap: () => launchWhatsApp(phone: _foundSupliers[index]['whatsappNumber'].toString(), message: ' ', context: context),
                child: SvgPicture.asset('assets/images/whatsapp.svg'),
              ),
            ):
            SizedBox(),
            _withoutQutation != null?
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: curve * 0, vertical: raduis / 6 * 0),
              child: GestureDetector(
                onTap: () => launchPhone(phone: _foundSupliers[index]['whatsappNumber'].toString(), context: context),
                child: SvgPicture.asset('assets/images/phone.svg', color: MyColors.bodyText1),
              ),
            ):
            SizedBox(),
          ],
        ),
      ),
    );
  }

  _explore(index) {
    if(guestType){
      _m!.guestDialog();
      return;
    }
    else
    {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuplierInfo(index, barTitle: widget.barTitle),
          ));
    }
  }

  selectAll() {
    for (int i = 0; i < _suplierListCheck.length; i++) {
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
    if(!_suplierListCheck[index]){
    //if(!_suplierListCheck[2]){
      int i = 0;
      i = _suplierListCheck.where((element) => element == true).length;
      print(i.toString());
      if(i >= 3){
        MyAPI(context: context).flushBar("Max supplier's number is three (3)");
        return;
      }
    }
    _suplierListCheck[index] = !_suplierListCheck[index];
    setState(() {});
  }

  search() {
    if(guestType){
      _m!.guestDialog();
      return;
    }
    List checkedSupplier = [];
    for (int i = 0; i < _suplierListCheck.length; i++) {
      if (_suplierListCheck[i] == true) {
        checkedSupplier.add(suplierList[i]);
      }
    }
    if (checkedSupplier.isEmpty) {
      MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate(
          'You should to select at least one supplier before search'));
      return;
    }
    pleaseWait = false;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RequestScreen(
            brandId,
            gategoryId,
            originalOrNot,
            checkedSupplier,
            indexGarage: indexGarage, barTitle: widget.barTitle,
          ),
        ));
  }
}
