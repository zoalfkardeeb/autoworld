// ignore_for_file: file_names
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../MyWidget.dart';
// ignore: camel_case_types

class MaterialDescriptionScreen extends StatefulWidget {
  @override
  _MaterialDescriptionScreenState createState() => _MaterialDescriptionScreenState();
}

class _MaterialDescriptionScreenState extends State<MaterialDescriptionScreen> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var _title = 'internal intercolar valvu', _typeDate = 'Mazda 6 2016',
      _like = '1.5K', _love = '212', _shopping = '120', _image = 'assets/images/group2.svg', _starRate='4.6';
  double _price = 180.95, _priceSale = 169.95;
  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      //appBar: _m!.appBar(barHight, _scaffoldKey),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 7 / 8,
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 30,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  //SizedBox(height: hSpace,),
                  _m!.headText(_title, paddingH: MediaQuery.of(context).size.width/10, align: TextAlign.left),
                  _m!.bodyText1(_typeDate, align: TextAlign.left, padding: MediaQuery.of(context).size.width/10),
                  SizedBox(height: hSpace,),
                  Expanded(
                      child:
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                            alignment: Alignment.topCenter,
                            height: MediaQuery.of(context).size.height/2,
                            width: double.infinity,
                            //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                            decoration: BoxDecoration(
                              color: MyColors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                            ),
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 1,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: _m!.iconText('assets/images/eye.svg', _like, MyColors.gray, vertical: true, paddingH: MediaQuery.of(context).size.width/50),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: _m!.iconText('assets/images/fill_heart.svg', _love, MyColors.gray, vertical: true, paddingH: MediaQuery.of(context).size.width/50),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: _m!.iconText('assets/images/fill_heart.svg', _shopping, MyColors.gray, vertical: true, paddingH: MediaQuery.of(context).size.width/50),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(_image, width: MediaQuery.of(context).size.width/2,),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: _m!.miniContainer(_m!.iconText('assets/images/star.svg', _starRate, MyColors.white, revers: true, paddingH: 0.0, scale: 1),
                                                MediaQuery.of(context).size.height/25),
                                          ),
                                        ),
                                      ],
                                    ),

                                ),
                                _saleShow(_price, _priceSale),
                                _descriptionMaterial('descHead descHead descHead', 'descText descText descText descText descText descText descText descText'),


                              ],
                            ),

                            /*ListView(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                                  alignment: Alignment.topCenter,
                                  height: MediaQuery.of(context).size.height/3.2,
                                  width: double.infinity,
                                  //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                  decoration: BoxDecoration(
                                    color: MyColors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: _m!.iconText('assets/images/eye.svg', _like, MyColors.gray, vertical: true, paddingH: MediaQuery.of(context).size.width/50),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: _m!.iconText('assets/images/fill_heart.svg', _love, MyColors.gray, vertical: true, paddingH: MediaQuery.of(context).size.width/50),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: _m!.iconText('assets/images/fill_heart.svg', _shopping, MyColors.gray, vertical: true, paddingH: MediaQuery.of(context).size.width/50),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(_image, width: MediaQuery.of(context).size.width/2,),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: _miniContainer(_m!.iconText('assets/images/star.svg', _starRate, MyColors.white, revers: true, paddingH: 0.0, scale: 1),
                                              MediaQuery.of(context).size.height/25),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _saleShow(_price, _priceSale),
                                _descriptionMaterial('descHead descHead descHead', 'descText descText descText descText descText descText descText descText')
                                ,
                                SizedBox(height: hSpace,),
                              ],
                            ),*/
                          ),

                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0 ?
            _m!.bottomContainer(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _m!.iconButton(curve, 'assets/images/heart.svg', () => null,),
                    SizedBox(width: MediaQuery.of(context).size.width/40,),
                    _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.5, AppLocalizations.of(context)!.translate('Add to cart'), 'assets/images/add_cart.svg', () => _addToCart())
                  ],
                ),
                curve)
                : const SizedBox(height: 0.1,),
          )
        ],
      ),
    );
  }

  _miniContainer(_child, height){
    var curve = height / 4;
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
      decoration: BoxDecoration(
        color: MyColors.gray,
        borderRadius: BorderRadius.all(Radius.circular(curve)),
      ),
      child: _child,
    );
  }

  _saleShow(_price,_priceSale){
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _m!.bodyText1('\$ $_price', padding: 0.0, baseLine: true),

                    _m!.headText('\$ $_priceSale', paddingV: MediaQuery.of(context).size.height/80),
                  ],
                ),
              ),
          ),
          Expanded(
            flex: 1,
              child: Align(
                alignment: Alignment.topRight,
                child: _m!.miniContainer(_m!.headText(((_price - _priceSale)/_price * 100).round().toString()+'%', scale: 0.45, paddingV: 0.0, color: MyColors.mainColor), MediaQuery.of(context).size.height/25),
              ),
          ),
        ],
      ),
    );
  }

  _descriptionMaterial(_descHead, _descText){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _m!.bodyText1(_descHead, color: MyColors.mainColor, padding: 0.0),
        _m!.bodyText1(_descText, scale: 0.9, padding: 0.0, align: TextAlign.start),
      ],
    );
  }

  _topBar() {
    return Container(
      //centerTitle: true,
      //height: barHight,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery
          .of(context)
          .size
          .height / 40, vertical: MediaQuery
          .of(context)
          .size
          .height / 30),
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(MediaQuery.of(context).size.height / 80 * 3),
            bottomLeft: Radius.circular(MediaQuery.of(context).size.height / 80 * 3)),
      ),*/
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back_ios, size: MediaQuery.of(context).size.width/20,),
                ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            flex: 7,
              child: _m!.titleText1(_title, align: Alignment.centerLeft),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.share_outlined, color: MyColors.black, size: MediaQuery.of(context).size.width/15),
                // ignore: avoid_returning_null_for_void
                onPressed: () => _share(),
              ),),
          ),
        ],
      ),
    );
  }

  _share() {}

  _addToCart() {}

}