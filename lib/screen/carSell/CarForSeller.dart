// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/carSell/AddSellCarScreen.dart';
import 'package:flutter/material.dart';

import '../../MyWidget.dart';
import 'AllBrandCarSells.dart';
// ignore: camel_case_types

class CarForSeller extends StatefulWidget {
  const CarForSeller({Key? key}) : super(key: key);

  @override
  _CarForSellerState createState() => _CarForSellerState();
}

class _CarForSellerState extends State<CarForSeller> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  List imageList = [];
  ImageProvider? image;

  List brandList = [];
  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      brandList.clear();
      for(int i = 0; i<brands.length; i++){
        brandList.add({
          'image': brands[i]['logo'],
          'text': brands[i]['name'],
          'id': brands[i]['id']
        });
      }

      _state = cityController.text;
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    imageList.clear();
    imageList.add({'image': 'assets/images/bodyGarage.png', 'text': AppLocalizations.of(context)!.translate('Body')});
    imageList.add({'image': 'assets/images/mechanicalGarage.png', 'text': AppLocalizations.of(context)!.translate('Mechanical')});
    imageList.add({'image': 'assets/images/electricalGarage.png', 'text': AppLocalizations.of(context)!.translate('Electrical')});
    //imageList.add({'image': 'assets/images/customGarage.png', 'text': AppLocalizations.of(context)!.translate('Customisation')});
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.topCon,
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
                top: MediaQuery.of(context).size.height / 40*0,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  SizedBox(height: hSpace/2,),
                  _towRowIcos(),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.topCon,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(curve*2), right: Radius.circular(curve*2)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: curve),
                      child: GridView.builder(
                        itemCount: brandList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.8,
                            crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return _brandCard(index, hSpace);
                        },
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
                _m!.mainChildrenBottomContainer(curve, () => _tap(1), () => _tap(2), () => _tap(3), _tapNum),
                curve)
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

  _brandCard(index, hSpace){

    return GestureDetector(
      child: MyWidget(context).brandCard(brandList[index]['image'], hSpace, brandList[index]['text']),
      onTap: ()=> _goToOfferCarsBrand(brandList[index]['id']),

    );
  }

  _towRowIcos(){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          GestureDetector(
            child: MyWidget(context).iconText("assets/images/ic_sell_car.svg", AppLocalizations.of(context)!.translate('Sell your car'), MyColors.black, vertical: true, scale: 1.2, imageScale: 2),
            onTap: ()=> _goToSellCar(),
          ),

          GestureDetector(
            child: MyWidget(context).iconText("assets/images/ic_all_brand.svg", AppLocalizations.of(context)!.translate('All Brands'), MyColors.black, vertical: true, scale: 1.2, imageScale: 2),
            onTap: ()=> _goToOfferCarsBrand(''),

          ),

        ],
      ),
    );
  }

  _goToOfferCarsBrand(brandId) async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).getCarSell(brandId.toString());
    setState(() {
      pleaseWait = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  const AllBrandCarSells(),
        ));
  }

  _goToSellCar() async{
    if(guestType){
      _m!.guestDialog();
      return;
    }
    setState(() {
      pleaseWait = true;
    });
    await MyAPI(context: context).getCarModel();
    setState(() {
      pleaseWait = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddSellCarScreen(),
        )
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
                  child: _m!.titleText1(
                      AppLocalizations.of(context)!.translate('Car for Sell')),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.notificationButton(),
                ),
              ],
            ),
            // SizedBox(height: MediaQuery.of(context).size.height/40,),
            /*_tapNum==1?
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/120)
                :
            const SizedBox()
            ,*/
          ],
        )
    );
  }

  _tap(num) async{
    if(num == _tapNum) return;
    setState(() {
      _tapNum = num;
    });
    if(num == 2){
      await MyAPI(context: context).readUserInfo(userData['id']);
    }
    setState(() {});
  }

  String? path ;

}