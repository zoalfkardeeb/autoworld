// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/CarRentDetails.dart';
import 'package:flutter/material.dart';

import '../MyWidget.dart';
// ignore: camel_case_types
class CarRentOffers extends StatefulWidget {

  final String barTitle;
  const CarRentOffers({Key? key, required this.barTitle}) : super(key: key);

  @override
  State<CarRentOffers> createState() => _CarRentOffersState();
}

class _CarRentOffersState extends State<CarRentOffers> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  ImageProvider? image;

  var _tapNum = 1;

  final TextEditingController _searchController = TextEditingController();
  List _foundOffers = offers.where((element) => true).toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      _state = cityController.text;
    }catch(e){}
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isEmpty) {
          _foundOffers = offers.where((element) => true).toList();
        } else {
          _foundOffers = offers.where((element) => element['supplier']['fullName'].toString().toLowerCase().contains(_searchController.text.toLowerCase())).toList();
          //clearAll();
        }
      });
    });

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
                top: MediaQuery.of(context).size.height / 40*0,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
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

                  Expanded(
                    flex: 1,
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/40, horizontal: MediaQuery.of(context).size.width/40),
                      itemCount: _foundOffers.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.54,
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: _m!.cardOffers(curve,logo: _foundOffers[index]['supplier']['user']['imagePath'], toolImage: _foundOffers[index]['offerImg'],toolName: lng==2?_foundOffers[index]['arTitle']:_foundOffers[index]['title'],companyName: _foundOffers[index]['supplier']['fullName'], scale: 0.8),
                         // child: _m!.cardRent(curve, open: ()=> _selectCard(index), phone: _foundOffers[index]['supplier']['whatsappNumber'], message:'', logo: _foundOffers[index]['supplier']['user']['imagePath'], toolImage: _foundOffers[index]['offerImg'],toolName: lng==2?_foundOffers[index]['arTitle']:_foundOffers[index]['title'],companyName: _foundOffers[index]['supplier']['fullName']),
                          onTap: () => _selectCard(index),
                        )
                        ;
                      },
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

  _setState() {
    setState(() {

    });
  }

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
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/120)
                :*/
            const SizedBox()
            ,
          ],
        )
    );
  }

  _selectCard(index) async{
    if(guestType){
      _m!.guestDialog();
      return;
    }else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  CarRentDetails(index, barTitle: widget.barTitle,),
        ));
    }
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
