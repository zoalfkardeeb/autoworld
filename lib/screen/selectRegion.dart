// ignore_for_file: file_names
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/selectScreen.dart';
import 'package:flutter/material.dart';

import '../MyWidget.dart';
// ignore: camel_case_types

class SelectRegionScreen extends StatefulWidget {
  final String barTitle;
  const SelectRegionScreen({Key? key, required this.barTitle}) : super(key: key);

  @override
  _SelectRegionScreenState createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var barHight = MediaQuery.of(context).size.height / 10;
    _m = MyWidget(context);
    var hSpace = MediaQuery.of(context).size.height/17;
    var curve = MediaQuery.of(context).size.height/30;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      //appBar: _m!.appBar(barHight, _scaffoldKey),
     // drawer: _m!.drawer(()=> _setState(), ()=> _tap(2)),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height*7/8,
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery.of(context).size.height/30,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(),
                  //SizedBox(height: hSpace,),
                  _m!.headText(AppLocalizations.of(context)!.translate('select your region')),
                  SizedBox(height: hSpace,),
                  _m!.bodyText1(AppLocalizations.of(context)!.translate('select region explain'), maxLine: 6, scale: 1.1),
                  SizedBox(height: hSpace,),
                  _selectFromTheList(AppLocalizations.of(context)!.translate('Select the Country'), curve, _countryController, () => null),
                  SizedBox(height: hSpace,),
                  _selectFromTheList(AppLocalizations.of(context)!.translate('Select the State'), curve, _stateController, () => null),
                  SizedBox(height: hSpace/2,),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height*7/8,
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery.of(context).size.height/30,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(),
                  //SizedBox(height: hSpace,),
                  Expanded(
                    flex: 1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _m!.headText(AppLocalizations.of(context)!.translate('select your region')),
                            SizedBox(height: hSpace,),
                            _m!.bodyText1(AppLocalizations.of(context)!.translate('select region explain'), maxLine: 6, scale: 1.1),
                            SizedBox(height: hSpace,),
                            _selectFromTheList(AppLocalizations.of(context)!.translate('Select the Country'), curve, _countryController, () => null),
                            SizedBox(height: hSpace,),
                            _selectFromTheList(AppLocalizations.of(context)!.translate('Select the State'), curve, _stateController, () => null),
                            SizedBox(height: hSpace/2,),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery.of(context).viewInsets.bottom == 0?
            _m!.bottomContainer(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _m!.raisedButton(curve, MediaQuery.of(context).size.width-curve*2, AppLocalizations.of(context)!.translate('Search'), 'assets/images/car.svg', () => _search(), iconHight: MediaQuery.of(context).size.height/18)
                  ],
                ),
                curve)
                : const SizedBox(height: 0.1,),
          )
        ],
      ),
    );
  }

  _selectFromTheList(text, curve, controller, Function() press){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
      child: Column(
        children: [
          _m!.bodyText1(text,scale: 1.1, padding: 0.0),
          _m!.listTextFiled(curve, controller, () => press(), MyColors.black, MyColors.white, AppLocalizations.of(context)!.translate('Select from the list'), MyColors.white)
      /*    Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _m!.textFiled(curve, MyColors.black, MyColors.white, controller, AppLocalizations.of(context)!.translate('Select from the list'), Icons.search, width: MediaQuery.of(context).size.width/1.6),
              SizedBox(width: MediaQuery.of(context).size.width/40,),
              _m!.iconButton(MediaQuery.of(context).size.height/30, 'assets/images/filter.svg', () => press(), curve: curve),
            ],
          )
*/
        ],
      ),
    );
  }

  _setState() {}

  _search() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  const SelectScreen(),
        ));

  }

  _topBar(){
    return Container(
      //centerTitle: true,
      //height: barHight,
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height/40, vertical: MediaQuery.of(context).size.height/30),
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
                alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
                child: const Icon(Icons.arrow_back_ios),
              ),
              onPressed: ()=> Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            flex: 1,
            child: _m!.titleText1(widget.barTitle),
          ),
          Expanded(
            flex: 1,
            child: _m!.notificationButton(),
          ),
        ],
      ),
    );
  }


}
