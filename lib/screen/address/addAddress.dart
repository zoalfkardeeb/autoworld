import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/font_size.dart';
import 'package:automall/constant/images/imagePath.dart';
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
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _aprController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  String autocompletePlace = "null";

  @override
  void initState() {
    // TODO: implement initState

    _titleController.text = widget.address.title??'';
    _noteController.text = widget.address.notes??'';
    _buildingController.text = widget.address.building??'';
    _areaController.text = widget.address.floor??'';
    _aprController.text = widget.address.appartment??'';
    _streetController.text = widget.address.street??'';
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
          Container(
            height: AppHeight.h90,
            alignment: Alignment.topCenter,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topBar(curve),
                MyWidget(context).textFiledAddress(_titleController, AppLocalizations.of(context)!.translate('Title')),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:AppWidth.w8),
                  child: Row(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppWidth.w2),
                            ),
                            padding: EdgeInsets.symmetric(vertical: curve/3*0, horizontal: curve/2),
                          ),
                          onPressed: () async => await _showPlacePicker(),
                          child: Icon(Icons.my_location_sharp)),
                      Expanded(child: MyWidget(context).bodyText1(_noteController.text.isEmpty?AppLocalizations.of(context)!.translate('Pick from map'):_noteController.text, color: MyColors.bottomCon, scale: 1.1, padding: AppWidth.w2, align: TextAlign.start),),
                    ],
                  ),
                ),
                SizedBox(height: AppHeight.h2,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:AppWidth.w8, vertical: AppHeight.h1),
                  child: MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Enter your address manually'), color: MyColors.bottomCon, scale: 1.1, padding: AppWidth.w2, align: TextAlign.start),
                ),
                Flexible(
                  child: MyWidget.shadowContainer(
                      margin: AppWidth.w8,
                      padding: AppWidth.w4,
                      child: Container(
                        padding: EdgeInsets.all(AppWidth.w1),
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(AppWidth.w2),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width:AppWidth.w80,
                                padding: EdgeInsets.all(AppWidth.w2),
                                decoration: BoxDecoration(
                                  color: MyColors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(AppWidth.w2),
                                    topRight: Radius.circular(AppWidth.w2),
                                  ),
                                ),
                                child: _addressStyle(text: AppLocalizations.of(context)!.translate('Unit No:'), controller: _aprController),
                              ),
                              SizedBox(height: AppWidth.w2,),
                              Container(
                                width:AppWidth.w80,
                                padding: EdgeInsets.all(AppWidth.w2),
                                decoration: const BoxDecoration(
                                  color: MyColors.blue,
                                ),
                                child: _addressStyle(text: AppLocalizations.of(context)!.translate('Building No:'), controller: _buildingController),
                              ),
                              SizedBox(height: AppWidth.w2,),
                              Container(
                                width:AppWidth.w80,
                                decoration: BoxDecoration(
                                  color: MyColors.blue,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(AppWidth.w2),
                                    bottomLeft: Radius.circular(AppWidth.w2),
                                  ),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _addressStyle(text: AppLocalizations.of(context)!.translate('Zone:'), controller: _areaController),
                                      ),
                                      VerticalDivider(color: MyColors.white, thickness: AppWidth.w2,),
                                      Expanded(
                                        flex: 3,
                                        child: _addressStyle(text: AppLocalizations.of(context)!.translate('Street:'), controller: _streetController),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:  MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0 ? _m.bottomContainer(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _m.raisedButton(curve*1.2, AppWidth.w80, AppLocalizations.of(context)!.translate('Save Address'), null, ()=> _saveAddress())
                  ],
                ),
                curve*1.2, bottomConRati: 0.1): SizedBox(),
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
    if (_titleController.text.isNotEmpty && _titleController.text.isNotEmpty && _buildingController.text.isNotEmpty && _areaController.text.isNotEmpty && _streetController.text.isNotEmpty) {
      widget.address.notes = _noteController.text;
      widget.address.title = _titleController.text;
      widget.address.lat = position.latitude.toString();
      widget.address.lng = position.longitude.toString();
      widget.address.building = _buildingController.text;
      widget.address.appartment = _aprController.text;
      widget.address.floor = _areaController.text;
      widget.address.floor = _streetController.text;
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
      await myAPI.flushBar('please, fill all fields');
    }
  }

  LatLng position = LatLng(25.3407106, 52.9036987);

  _showPlacePicker() async {
    setState(() {
      pleaseWait = true;
    });
    await getCurrentLocation();
    setState(() {
      pleaseWait = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return GoogleMapLocationPicker(
            apiKey: Strings.mapKey,
            //popOnNextButtonTaped: true,
            currentLatLng: currentLocation == null ? const LatLng(25.2741744, 51.4872171)
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

  }

  Widget _addressStyle({required text, required controller}){
    return  Padding(
      padding: EdgeInsets.all(AppWidth.w2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyWidget(context).headText(text,scale: 0.5, color: MyColors.white, align: TextAlign.start),
          SizedBox(height: AppWidth.w1,),
          TextFormField(
            textAlign: TextAlign.start,
            obscureText: false,
            keyboardType: TextInputType.text,
            controller: controller,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            style: TextStyle(
                fontFamily: 'GESS',
                color: MyColors.white,
                fontSize: FontSize.s18
            ),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppWidth.w2),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: AppWidth.w1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppWidth.w2),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: AppWidth.w1,
                ),
              ),
              filled: true,
              fillColor: MyColors.blue,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
