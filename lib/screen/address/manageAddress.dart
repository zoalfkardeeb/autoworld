import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
class ManageAddress extends StatefulWidget {
  const ManageAddress({Key? key}) : super(key: key);
  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  late MyWidget _m;

  @override
  Widget build(BuildContext context) {
    var hSpace = AppHeight.h5;
    var curve = AppHeight.h2*1.5;
    _m = MyWidget(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.topCon,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * (1-0.1),
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 40*0,
              ),
              child:
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        color: MyColors.topCon,
                        //borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve))
                      ),
                      padding: EdgeInsets.symmetric(horizontal: curve),
                      child: ListView(
                        children:  addressList!.data!.map((e) => _addressContainer(e.id.toString(), e.title.toString(), e.notes.toString())).toList(),
                      ),
                    ),

                  ),
                ],
              )
             ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0 ?
            _m.bottomContainer(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _m.raisedButton(curve*1.2, AppWidth.w80, AppLocalizations.of(context)!.translate('Add new Address'), null, ()=> _addAddress())
                  ],
                ),
                curve*1.2, bottomConRati: 0.1)
                : const SizedBox(height: 0.1,),
          ),
          Align(
            alignment: Alignment.center,
            child: pleaseWait?
            _m.progress()
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
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve),
              bottomRight: Radius.circular(curve)),
          boxShadow: const [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],   ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height / 30,),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _m.titleText1(AppLocalizations.of(context)!.translate('name')),
                      _m.bodyText1(AppLocalizations.of(context)!.translate('Manage Your Address'), padding: 0.0, padV: AppHeight.h1/2, scale: 0.7),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _m.notificationButton(),
                ),
              ],
            ),
            // SizedBox(height: MediaQuery.of(context).size.height/40,),
            /*_tapNum == 1 ?
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery
                .of(context)
                .size
                .height / 120)
                :
            const SizedBox()
            ,*/
          ],
        )
    );
  }

  Widget _addressContainer(id, title, notes) {
    return MyWidget.shadowContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _m.bodyText1(title, padV: AppHeight.h1/2, padding: AppWidth.w2),
                IconButton(onPressed: ()=> _editAddress(), icon: const Icon(Icons.edit_outlined, color: MyColors.mainColor,)),
              ],
            ),
            const Divider(height: 2,),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: MyColors.bottomCon,),
                _m.bodyText1(notes, scale: 0.8, color: MyColors.bottomCon, align: TextAlign.start, padV: AppHeight.h1/2, padding: 0.1),
              ],
            )
          ],
        )
    );
  }

  _editAddress() {}

  _addAddress() {}

}
