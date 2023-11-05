// ignore_for_file: file_names

import 'package:automall/api.dart';
import 'package:automall/constant/string/Strings.dart';
import 'package:automall/screen/singnIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../MyWidget.dart';
//import '../boxes.dart';
import '../const.dart';
import '../localization_service.dart';
import '../localizations.dart';
import '../helper/boxes.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:yaml/yaml.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashScreen> {

  Future<String?> _getDeviceId() async {
    try{
      String? deviceId = await PlatformDeviceId.getDeviceId;
      return deviceId;

    }catch(e){

    }
    return null;
    /*var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.deviceInfo;
      return "androidDeviceInfo.id"; // unique ID on Android
    }*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyAPI().getCities();
    //MyAPI(context: context).getBrands();
    //MyAPI(context: context).getGarageBrands();
    //MyAPI(context: context).getSupliers(1, 'garage');
    Timer(const Duration(milliseconds:2000), ()async=> await navigate());
    DateTime date = DateTime.now();
    var duration = date.timeZoneOffset;
    timeDiff = Duration(hours: -duration.inHours, minutes: -duration.inMinutes %60);
  }
  bool _welcom = false;
  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
  _read() async {
    await MyAPI(context: context).getVersion();
    await rootBundle.loadString("pubspec.yaml").then((value) {
      Map yaml = loadYaml(value);
      getExtendedVersionNumber(yaml['version'].toString().split('+')[0]) >= getExtendedVersionNumber(Strings.version)
          ? newVersion = false
          : newVersion = true;
    });

    var d = (await _getDeviceId());
    deviceId = d ?? "";

    var box = Boxes.getTransactions();
    transactions = box.values.toList();
    if(transactions!.isEmpty) {
      await addTransaction();
    } else{
      cities = transactions![0].cities;
      offers = transactions![0].offers;
      brands = transactions![0].brands;
      brandsCountry = transactions![0].brandsCountry;
      suplierList = transactions![0].suplierList;
      ordersList = transactions![0].ordersList;
      userData = transactions![0].userData;
      userInfo = transactions![0].userInfo;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{
      _welcom = sharedPreferences.getBool('isLogin')!;
      lng = sharedPreferences.getInt('lng')!;
      LocalizationService().changeLocale(lng, context);
      token = sharedPreferences.getString('token')!;
      //welcom = false;
    }catch(e){
      _welcom = false;
      print(e);
    }
  }

  MyWidget? _m;
  @override
  Widget build(BuildContext context) {
    //_backMethod();
    _m = MyWidget(context);
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.cover)),
      child: Image.asset('assets/images/splash.gif', fit: BoxFit.cover,),
      /*Scaffold(
        backgroundColor: Colors.transparent,
        body: Image.asset('assets/images/splash.gif', fit: BoxFit.cover,),//initScreen(context),
      ),*/
    );
  }

  startTime() async {
    var duration = const Duration(seconds:1);
    return Timer(duration, ()=> setState(() {
      ani = true;
    }));
  }

  navigate() async{
    await _read();
    if(_welcom){
      // ignore: use_build_context_synchronously
      await MyAPI(context: context).getOrders(userInfo['id']);
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_in(false),
 //         builder: (context) => !_welcom ?  Sign_in(false) : userInfo['type'] == 0? SelectScreen() : SelectScreen(),
        )
    );
  }
  bool ani = false;
  var duration = const Duration(seconds: 1);

  initScreen(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: AnimatedContainer(
            //transform: Matrix4Transform().translate(x: MediaQuery.of(context).size.width/3).matrix4,
            //margin: EdgeInsets.all(10),
            duration: duration,
            transform: !ani? (Matrix4.identity()
              ..translate(0.0000001, 0.000001)
            ):
            (Matrix4.identity()
              ..translate(MediaQuery.of(context).size.width/2-MediaQuery.of(context).size.width/7, MediaQuery.of(context).size.height/2-MediaQuery.of(context).size.width/7)
              ..scale(1/3.5, 1/3.5*MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffE50019),
                    Color(0xff6E000F),
                  ],
                ),
              borderRadius: !ani?BorderRadius.zero: BorderRadius.all(Radius.elliptical(MediaQuery.of(context).size.width/10*2,MediaQuery.of(context).size.width/10*(2/MediaQuery.of(context).size.width*MediaQuery.of(context).size.height))),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedContainer(
            //transform: Matrix4Transform().translate(x: MediaQuery.of(context).size.width/3).matrix4,
            //margin: EdgeInsets.all(10),
            duration: duration,
            transform: !ani? (Matrix4.identity()
              ..translate(0.0000001, 0.000001)
            ):
            (Matrix4.identity()
              ..translate(-MediaQuery.of(context).size.width/2+MediaQuery.of(context).size.width/7, 0)
              //..scale(1/3.5, 1/3.5*MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)
            ),
            child: GestureDetector(
              child: ani? SvgPicture.asset(
                  'assets/images/car-logo.svg',
                  height: MediaQuery.of(context).size.width/3.5,
                  width: MediaQuery.of(context).size.width/3.5,
                ):const SizedBox(width: 0,),
              onTap: () {
                navigate();
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            //transform: Matrix4Transform().translate(x: MediaQuery.of(context).size.width/3).matrix4,
            //margin: EdgeInsets.all(10),
            duration: duration,
            transform: !ani? (Matrix4.identity()
              ..translate(0.0000001, 0.000001)
            ):
            (Matrix4.identity()
              ..translate(0.0000000001, - MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).size.width/3.5)
              //..scale(1/3.5, 1/3.5*MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)
            ),
            child: GestureDetector(
              child: ani? _m!.headText(AppLocalizations.of(context)!.translate('name'),)
                  :const SizedBox(width: 0,),
              onTap: () {
                navigate();
              },
            ),
          ),
        ),
      ],
    );
  }

}
