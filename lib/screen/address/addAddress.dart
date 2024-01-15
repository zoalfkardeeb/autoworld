import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/string/Strings.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/localizations.dart';
import 'package:automall/location/location.dart';
import 'package:automall/model/request/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:geocoding/geocoding.dart';


class AddAddress extends StatefulWidget {
  AddressRequest address;
  AddAddress({Key? key, required this.address}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late MyWidget _m;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _aprController = TextEditingController();
  String autocompletePlace = "null";

  @override
  void initState() {
    // TODO: implement initState

    _titleController.text = widget.address.title??'';
    _noteController.text = widget.address.notes??'';
    _buildingController.text = widget.address.building??'';
    _floorController.text = widget.address.floor??'';
    _aprController.text = widget.address.appartment??'';
    if(widget.address.lat != null) position = LatLng(double.parse(widget.address.lat??'25.22'), double.parse(widget.address.lng??'50.00'));
    super.initState();
  }
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
                child:
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _topBar(curve),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppWidth.w4*1.5, vertical: AppHeight.h2),
                      child: MyWidget(context).raisedButton(curve, AppWidth.w80, AppLocalizations.of(context)!.translate('Pick from map'),
                          null, () async => await _showPlacePicker()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppWidth.w4),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          Expanded(child: MyWidget(context).bodyText1(_noteController.text, color: MyColors.bottomCon, scale: 0.8, padding: AppWidth.w1),),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: MyColors.topCon,
                          //borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve))
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              MyWidget(context).textFiledAddress(_titleController,
                                  AppLocalizations.of(context)!.translate('Title')),
                              MyWidget(context).textFiledAddress(
                                  _buildingController,
                                  AppLocalizations.of(context)!
                                      .translate('Building number/name')),
                              MyWidget(context).textFiledAddress(_floorController,
                                  AppLocalizations.of(context)!.translate('Floor')),
                              MyWidget(context).textFiledAddress(
                                  _aprController,
                                  AppLocalizations.of(context)!
                                      .translate('Apartment number')),
                              SizedBox(height: AppHeight.h1,),
                            ],
                          ),
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
                    _m.raisedButton(curve*1.2, AppWidth.w80, AppLocalizations.of(context)!.translate('Save Address'), null, ()=> _saveAddress())
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
                IconButton(
                  icon: Align(
                    alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  onPressed: ()=> Navigator.of(context).pop(),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _m.titleText1(AppLocalizations.of(context)!.translate('name')),
                      //_m.bodyText1(AppLocalizations.of(context)!.translate('Manage Your Address'), padding: 0.0, padV: AppHeight.h1/2, scale: 0.7),
                    ],
                  ),
                ),
                _m.notificationButton(),
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

  _saveAddress() async{
    MyAPI myAPI = MyAPI(context: context);
    if(position == null){
      await myAPI.flushBar('Select location on map');
      return;
    }
    if (_titleController.text.isNotEmpty) {
      widget.address.notes = _noteController.text;
      widget.address.title = _titleController.text;
      widget.address.lat = position.latitude.toString();
      widget.address.lng = position.longitude.toString();
      widget.address.building = _buildingController.text;
      widget.address.appartment = _aprController.text;
      widget.address.floor = _floorController.text;
      setState(() {
        pleaseWait = true;
      });
      print('t');
      var result = false;
      if(widget.address.id != null && widget.address.id!.isNotEmpty) {
       result = await MyAPI.updateAddreess(widget.address);
      }else{
       result = await MyAPI.addAdreess(widget.address);
      }
      setState(() {
        pleaseWait = false;
      });
      if(!result){
        await myAPI.flushBar('Please try again later!');
        return;
      }
      await myAPI.flushBar('Address is saved');
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      await myAPI.flushBar('Title is required');
    }
  }

  LatLng position = LatLng(25.3407106, 52.9036987);

  _showPlacePicker() async {
    setState(() {
      pleaseWait = true;
    });
    await getCurrentLocation();
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return GoogleMapLocationPicker(
            apiKey: Strings.mapKey,
            //popOnNextButtonTaped: true,
            currentLatLng: currentLocation == null ? const LatLng(25.3407106, 52.9036987)
              : LatLng(currentLocation!.latitude, currentLocation!.longitude),
            onNext: (GeocodingResult? result) {
              if (result != null) {
                  position = LatLng(result.geometry.location.lat, result.geometry.location.lng);
                  _noteController.text = result.formattedAddress??'';
                  Navigator.of(context).pop();
              }
            },
            onSuggestionSelected: (Prediction? result) {
              if (result != null) {
                setState(() {
                  autocompletePlace = result.reference ?? "";
                });
              }
            },
          );
        },
      ),
    ).then((value) => _setState());
    setState(() {
      pleaseWait = false;
    });
  }

}
