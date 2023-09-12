// ignore_for_file: file_names
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/localizations.dart';
import 'package:automall/screen/matrialDscScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../MyWidget.dart';
// ignore: camel_case_types
class SubSelectScreen extends StatefulWidget {
  final _country;
  final _state;
  final _selectIndex;
  final String barTitle;
  const SubSelectScreen(this._state, this._country, this._selectIndex, {Key? key, required this.barTitle}) : super(key: key);

  @override
  _SubSelectScreenState createState() => _SubSelectScreenState(_country, _state, _selectIndex);
}

class _SubSelectScreenState extends State<SubSelectScreen> {

  final TextEditingController _searchController = TextEditingController();
  _SubSelectScreenState(this._country, this._state, this._selectIndex);
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  var _country = 'country';
  var _state = 'state';
  var _selectIndex = 1;

  List materialList = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime(_scrollController);

  }

  startTime(_scrollController) async {
    _scrolTo(){
      return Timer(const Duration(milliseconds: 1000), ()=> setState(() { _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
      }));
    }
    var duration = const Duration(milliseconds: 200);
    return Timer(duration, ()=> setState(() {
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
      _scrolTo();
    }));
  }



  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    materialList.clear();
    materialList.add({'image': 'assets/images/group1.svg', 'text': AppLocalizations.of(context)!.translate('Spare Parts')});
    materialList.add({'image': 'assets/images/group2.svg', 'text': AppLocalizations.of(context)!.translate('Garages')});
    materialList.add({'image': 'assets/images/group3.svg', 'text': AppLocalizations.of(context)!.translate('Batteries & tyres')});
    materialList.add({'image': 'assets/images/group4.svg', 'text': AppLocalizations.of(context)!.translate('Motor Service Van')});
    materialList.add({'image': 'assets/images/group5.svg', 'text': AppLocalizations.of(context)!.translate('Offers')});
    materialList.add({'image': 'assets/images/group6.svg', 'text': AppLocalizations.of(context)!.translate('Scrape Parts')});
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
              height: MediaQuery.of(context).size.height*7/8,
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery.of(context).size.height / 40,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  Expanded(
                    //flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                      child: GridView.builder(
                        itemCount: materialList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.63,
                          crossAxisCount: 2,
                          crossAxisSpacing: MediaQuery.of(context).size.width/40,
                          mainAxisSpacing: MediaQuery.of(context).size.width/10
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: _m!.cardMaterial(curve, (MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/8)/2/0.63-4,4.6.toString(), true, 'materialName materialName','materialType materialType materialType', 888, 900, () => _selectMaterial()),
                            onTap: () => null,
                          )
                          ;
                        },
                      ),
                    )
                    ,
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
                _m!.mainChildrenBottomContainer(curve, () => _tap(1), () => _tap(2), () => _tap(3), _tapNum),
                curve)
                : const SizedBox(height: 0.1,),
          )
        ],
      ),
    );
  }
  var _tapNum = 1;

  _setState() {}

  _search() {}

  _topBar(curve) {
    return Container(
      //centerTitle: true,
      //height: barHight,
      height: MediaQuery.of(context).size.height/8*2.7,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],    ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/120,),
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
                      widget.barTitle),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.notificationButton(),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/40,),
            _m!.headText('$_country, $_state', scale: 0.8),
            SizedBox(height: curve,),
            Flexible(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: materialList.length,
                    //gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: index == _selectIndex? _m!.headText(materialList[index]['text'], scale: 0.6,): _m!.bodyText1(materialList[index]['text']),

                        onTap: () => _selectCardIndex(index),
                      );
                    },
                  ),
                ),
            ),
            _m!.listTextFiled(curve, _searchController, () => press(), MyColors.white, MyColors.black, AppLocalizations.of(context)!.translate('Search Products...'), MyColors.mainColor, width: MediaQuery.of(context).size.width/1.48)

          ],
        )
    );
  }

  _selectCardIndex(index) {
    setState(() {
      _selectIndex = index;
    });
  }

  _selectMaterial() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  MaterialDescriptionScreen(),
        )
    );
  }

  press() {}

  _tap(num){
    setState(() {
      _tapNum = num;
    });
  }
}
