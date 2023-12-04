// ignore_for_file: file_names
import 'dart:convert';
import 'package:automall/constant/app_size.dart';
import 'package:automall/helper/launchUrlHelper.dart';
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/string/Strings.dart';
import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/selectScreen.dart';
import 'package:automall/screen/singnIn.dart';
import 'package:automall/screen/termAndConitions.dart';
import 'package:automall/screen/verification/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:async';

import '../MyWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';
// ignore: camel_case_types

class Register extends StatefulWidget {
  bool animate, autoVer;
  Map? mapDate;
  Register(this.animate, this.autoVer, {Key? key, this.mapDate}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState(autoVer, ani: animate, mapDate: mapDate);
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final _stateController = TextEditingController();

  var requiredValidator = RequiredValidator(errorText: 'Required');
  final bool _secureText = true;
  bool chLogIn = false;
  String value="";
  int doubleBackToExitPressed = 1;
  bool _autoVer = false;
  Map? mapDate;
  _RegisterState(this._autoVer, {required this.ani, this.mapDate});

  bool passwordTextStyle = true;
  var type = 0;

  // ignore: empty_constructor_bodies
  MyWidget? _m;
  MyAPI? myAPI;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _firstOpen = true;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
    if(_autoVer){
      _fullNameController.text = mapDate!['Name'];
      _emailController.text = mapDate!['Email'];
      _mobileController.text = mapDate!['Mobile'];
    }
    startTime();
    MyAPI(context: context).getCities();
    showAll = ani;
    _passwordConfirmController.addListener(() {setState(() {});});
    _emailController.addListener(() {setState(() {});});
    _fullNameController.addListener(() {setState(() {});});
    _passwordController.addListener(() {setState(() {});});
  }

  startTime() async {
    var duration = const Duration(milliseconds:500);
    return Timer(duration, ()=> setState(() {
      ani = true;
      startAni();
    }));
  }
  startAni() async {
    return Timer(Duration(milliseconds: (duration.inMilliseconds/1.2).round()), ()=> setState(() {
      showAll = true;
    }));
  }
  bool ani = false;
  bool showAll = false;
  var duration = const Duration(milliseconds: 700);

  late var verificationPhoneID;


  @override
  Widget build(BuildContext context) {
    myAPI = MyAPI(context: context);
    requiredValidator = RequiredValidator(errorText: AppLocalizations.of(context)!.translate('Required'));
    _m = MyWidget(context);
    var hSpace = MediaQuery.of(context).size.height/20;
    var curve = MediaQuery.of(context).size.height/30;

    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          body:
          Stack(
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
                  MediaQuery.of(context).viewInsets.bottom == 0?
                  (Matrix4.identity()
                    ..translate(-0.0000001, -MediaQuery.of(context).size.height/2 + MediaQuery.of(context).size.width/7 + hSpace)
                      //..scale(1/3.5, 1/3.5*MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)
                  ):
                  (Matrix4.identity()
                    ..translate(-0.0000001, -MediaQuery.of(context).size.height/2 + MediaQuery.of(context).size.width/7 + hSpace + MediaQuery.of(context).viewInsets.bottom/2)
                      //..scale(1/3.5, 1/3.5*MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)
                  ),
                  child: GestureDetector(
                    child: Image.asset(
                      'assets/images/Logo1.png',
                      height: MediaQuery.of(context).size.width/3.5,
                      width: MediaQuery.of(context).size.width/3.5,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: duration,
                  transform: !ani? (Matrix4.identity()
                    ..translate(0.0000001, - MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).size.width/3.5)
                  ):
                  MediaQuery.of(context).viewInsets.bottom == 0?
                  (Matrix4.identity()
                    ..translate(-0.0000001, - MediaQuery.of(context).size.height + MediaQuery.of(context).size.width/3.5 + hSpace + MediaQuery.of(context).size.width/9)
                  ):
                  (Matrix4.identity()
                    ..translate(-0.0000001, - MediaQuery.of(context).size.height + MediaQuery.of(context).size.width/3.5 + hSpace + MediaQuery.of(context).size.width/9 + MediaQuery.of(context).viewInsets.bottom)
                  ),
                  child: GestureDetector(
                    child: _m!.headText(AppLocalizations.of(context)!.translate('name'),),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: showAll?
                    Form(
                      key: _formKey,
                        child: Container(
                          height: MediaQuery.of(context).size.height*9/10 - (hSpace*1.5 + MediaQuery.of(context).size.width/3.5 + MediaQuery.of(context).size.width/6),
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            //left: MediaQuery.of(context).size.width/20,
                            //right: MediaQuery.of(context).size.width/20,
                            top: MediaQuery.of(context).size.height/30*0,
                          ),
                          margin: EdgeInsets.only(top: hSpace*1.5 + MediaQuery.of(context).size.width/3.5 + MediaQuery.of(context).size.width/6),
                          child: SingleChildScrollView(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //SizedBox(height: hSpace*1.5 + MediaQuery.of(context).size.width/3.5 + MediaQuery.of(context).size.width/6,),
                                //SizedBox(height: hSpace,),
                                _m!.bodyText1(AppLocalizations.of(context)!.translate('Complete your personal information')),
                                _m!.textFiled(curve, MyColors.black, MyColors.white, _fullNameController, AppLocalizations.of(context)!.translate('Full Name'), Icons.person_outline, requiredValidator: requiredValidator, withoutValidator: _firstOpen),
                                Padding(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, right: MediaQuery.of(context).size.width/10, top:  MediaQuery.of(context).size.width/20),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: IntlPhoneField(
                                      countries: const ["QA",],
                                      //keyboardType: TextInputType.number,
                                      //validator: requiredValidator,
                                      invalidNumberMessage: '',
                                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                                      //controller: phoneController,
                                      style: TextStyle(color: MyColors.black, fontSize: MediaQuery.of(context).size.width/20),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.translate('Mobile Number'),
                                        hintStyle: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width/25,
                                          color: MyColors.gray,
                                        ),
                                        errorStyle: TextStyle(
                                            fontSize:MediaQuery.of(context).size.width/24
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(curve/2),
                                            borderSide: const BorderSide(color: Colors.grey, width: 2)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(curve/2),
                                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(curve/2),
                                          borderSide: const BorderSide(color: Colors.red, width: 2),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(curve/2),
                                          borderSide: const BorderSide(color: MyColors.red, width: 2),
                                        ),
                                      ),
                                      initialCountryCode: "QA",
                                      onChanged: (phone) {
                                        _mobileController.text =  phone.completeNumber;
                                        print(phone.completeNumber);
                                      },
                                    ),
                                  ),
                                  /* buildContainer(phoneController, AppLocalizations.of(context)!.translate('Phone Number'),
                                      TextInputType.number, requiredValidator,false),*/
                                ),

                                _selectFromTheList(AppLocalizations.of(context)!.translate('Select the State'), curve, _stateController, () => _openList()),
                                //_dropDown(),
                                SizedBox(height: hSpace/2,),
                                _m!.bodyText1(AppLocalizations.of(context)!.translate('Log in credentals')),
                                SizedBox(height: hSpace/2,),
                                _selectType(),
                                _m!.textFiled(curve, MyColors.black, MyColors.white, _emailController, AppLocalizations.of(context)!.translate('Enter Your Email'), Icons.email_outlined, requiredValidator: requiredValidator, withoutValidator: _firstOpen),
                                _m!.textFiled(curve, MyColors.white, MyColors.black, _passwordController, AppLocalizations.of(context)!.translate('Enter Your Password'), !passwordTextStyle? Icons.lock_open_outlined: Icons.lock_outline, requiredValidator: requiredValidator, password: passwordTextStyle, withoutValidator: _firstOpen, click: ()=> _changePasswordStyle()),
                                _m!.textFiled(curve, MyColors.white, MyColors.black, _passwordConfirmController, AppLocalizations.of(context)!.translate('Confirm Your Password'), !passwordTextStyle? Icons.lock_open_outlined: Icons.lock_outline, requiredValidator: requiredValidator, val: _passwordController.text, password: passwordTextStyle, withoutValidator: _firstOpen, click: ()=> _changePasswordStyle()),
                                SizedBox(height: hSpace/2,),
                                _m!.iconText(termsAndConditions?'assets/images/check.svg':'assets/images/check-not.svg', AppLocalizations.of(context)!.translate("I've read and confirmed the terms and conditions"), MyColors.bodyText1, click: ()=> _acceptTerms()),
                                SizedBox(height: hSpace,),
                              ],
                            ),
                          )
                          ,
                        ),
                    )
                :
                const SizedBox(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MediaQuery.of(context).viewInsets.bottom != 0 || !showAll?
                const SizedBox(height: 0.1,)
                    :
                _m!.bottomContainer(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _m!.iconButton(
                            curve, 'assets/images/read.svg', () => _terms()),
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width / 40,),
                        _m!.raisedButton(curve, MediaQuery
                            .of(context)
                            .size
                            .width / 2.2, AppLocalizations.of(context)!.translate(
                            'Sign up'), null, () =>
                            _register()),
                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width / 40,),
                        _m!.iconButton(
                            curve, 'assets/images/contact.png', () => LaunchUrlHelper.makePhoneCall(Strings.contactNum), ispng: true),
                      ],
                    ), curve * 1.1, bottomConRati: 0.1),
              ),
              Align(
                alignment: Alignment.center,
                child: chLogIn?
                _m!.progress()
                    :
                const SizedBox(),
              )
            ],
          ),
        ),

    );
  }

  _register() async{
    setState(() {
//241280
    });

    if(!termsAndConditions) {
      myAPI!.flushBar(AppLocalizations.of(context)!.translate('Please check the terms and conditions!!'));
      return null;
    }
    if(_fullNameController.text.isEmpty || _passwordController.text.isEmpty || _emailController.text.isEmpty || _passwordConfirmController.text.isEmpty || _mobileController.text.isEmpty || _stateController.text.isEmpty){
      setState((){});
      return;
    }

    //if(!_formKey.currentState!.validate()) return;
    //if(_fullNameController.text == '' || _emailController.text == '' || _passwordController.text == '' || _passwordConfirmController.text == '' || _mobileController.text == '') return;
    setState(()=> chLogIn = true);

    var response = await myAPI!.register(_fullNameController.text, _mobileController.text, _emailController.text, _passwordController.text, cityId, type);
    print(response.body);
    String x= response.body;
    if (response.statusCode == 200) {
       if(jsonDecode(x)["errors"] == '' || jsonDecode(x)["errors"] == null){
         if(type == 1){
           //bool sent = await myAPI!.sendEmail(AppLocalizations.of(context)!.translate('We Have sent your information to the Management.\nplease keep your phone available \nand review your email inbox'), AppLocalizations.of(context)!.translate('Welcome Supplier'),  _emailController.text);
           setState(()=> chLogIn = false);
           _save();
           Navigator.pushAndRemoveUntil(
               context,
               MaterialPageRoute(
                 builder: (context) => Sign_in(true),
               ),
               ModalRoute.withName("")
           );  return;
         }
        value =jsonDecode(x)["data"][0]["id"].toString();
        var verCode = jsonDecode(x)["data"][0]["verificationCode"].toString();
        // final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
        // sharedPreferences.setString('Id',response.body[1].toString());
        //
        // if(sharedPreferences.getString('Id') != null){
        /*bool sent = await myAPI!.sendEmail(AppLocalizations.of(context)!.translate('Your activation code is :') +  '\n$verCode' , AppLocalizations.of(context)!.translate('Activation Code'),  _emailController.text);
        setState(()=> chLogIn = false);
        if(!sent){
          return;
        }*/
        _save();
        if(!_autoVer || _emailController.text != mapDate!['Email']) {
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Verification(value: value ,email: _emailController.text, password: _passwordController.text,  verCode: verCode,),));
        } else {
          setState(()=> chLogIn = true);
          await myAPI!.ver(jsonDecode(response.body)["data"][0]["Id"], jsonDecode(response.body)["data"][0]["verificationCode"]);
          setState(()=> chLogIn = false);
          setState(()=> chLogIn = true);
          var res = await myAPI!.login(_emailController.text, _passwordController.text);
          setState(()=> chLogIn = false);
          if(res){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectScreen(),));
          }
        }
      }
      else{
        setState(()=> chLogIn = false);
        await myAPI!.flushBar(jsonDecode(x)["errors"]);
      }
    }
    else if (response.statusCode == 500) {
    setState(()=> chLogIn = false);
    //await myAPI!.flushBar(AppLocalizations.of(context)!.translate('Server is busy try again later'));
    await myAPI!.flushBar(jsonDecode(x)["Errors"]);
    print(response.statusCode);
    print('A network error occurred');
    }
    else{
    setState(()=> chLogIn = false);
    await myAPI!.flushBar(jsonDecode(x)["Errors"]);
   /* await Flushbar(
    icon: Icon(Icons.error_outline,size: MediaQuery.of(context).size.width/18,color: MyColors.white,),
    shouldIconPulse: false,
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height/37)),
    backgroundColor: Colors.grey.withOpacity(0.5) ,
    barBlur: 20,
    message: AppLocalizations.of(context)!.translate('This Email Already Existed'),
    messageSize:MediaQuery.of(context).size.width/22 ,
    // ignore: deprecated_member_use
    mainButton: FlatButton(
    onPressed: () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder:(context)=>Sign_in(false)));
    },
    child: Text(AppLocalizations.of(context)!.translate('Log in Now'),style: TextStyle(
    color: MyColors.white,
    fontSize:MediaQuery.of(context).size.width/22 ,
    ),),
    ),

    ).show(context);*/
    }
  }

  _terms() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  TermsAndConditions(drawer: false),
        ));

  }

  FirebaseAuth auth = FirebaseAuth.instance;

  _phoneAuth() async{
    // set this to remove reCaptcha web
    auth.setSettings(appVerificationDisabledForTesting: true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      //timeout: Duration(hours: 1),

      phoneNumber: '+963 968 972 569',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        //await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        print(e.phoneNumber);
        print(e.message);
        print(e.code);

        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        //String smsCode = 'xxxx';
        verificationPhoneID = verificationId;

        // Create a PhoneAuthCredential with the code
        //PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        //await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationPhoneID = verificationId;
      },
    );
  }

  _verifyPhone()async{

    //PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationPhoneID, smsCode: smsCode);
    //await auth.signInWithCredential(credential);

  }
  var cityId = 1;
  var cityName = '';
  final GlobalKey _dropDownKey = GlobalKey();

  _dropDown(width, curve){
    List<String> citiesName = <String>[];
    for(int i = 0; i<cities.length; i++){
      citiesName.add(lng == 2?cities[i]['arName']??'':cities[i]['name']??'');
    }
    if(citiesName.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
          key: _dropDownKey,
          underline: DropdownButtonHideUnderline(child: Container(),),
          icon: const Icon(Icons.search, size: 0.000001,),
          dropdownColor: MyColors.gray.withOpacity(0.9),
          //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: citiesName.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.white,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
            return citiesName.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _stateController.text = chosen.toString();
                var index = cities.indexWhere((element) => element['name']==chosen);
                cityId = cities[index]['id'];
                print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
        ;
    }
    /*return
    Container(
      child: EnhancedDropDown.withData(
        dropdownLabelTitle: '',
        dataSource: citiesName,
        defaultOptionText: "Dawha",
        valueReturned: (chosen) {
          _stateController.text = chosen;
          var index = cities.indexWhere((element) => element['name']==chosen);
          cityId = cities[index]['id'];
          print(chosen);
        },

      ),
    );*/
  }

  void _afterLayout(Duration timeStamp) {
    if(!_autoVer)_read();
    Timer(const Duration(seconds: 3), ()=> {
      _firstOpen = false,
      duration = const Duration(microseconds: 0),
    });
  }

  _save() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', _emailController.text);
    sharedPreferences.setString('password', _passwordController.text);
    sharedPreferences.setString('name', _fullNameController.text);
    sharedPreferences.setString('phone', _mobileController.text);
  }

  _read() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _emailController.text = sharedPreferences.getString('email')!;
    //_passwordController.text = sharedPreferences.getString('password')!;
    _fullNameController.text = sharedPreferences.getString('name')!;
    _mobileController.text = sharedPreferences.getString('phone')!;

  }

  _changePasswordStyle() {
    setState(() {
      passwordTextStyle = !passwordTextStyle;
    });
  }

  _selectFromTheList(text, curve, controller, Function() press){
    var width = AppWidth.w80;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40*0),
      child: Stack(
        children: [
          Align(
            child: Column(
              children: [
                _m!.bodyText1(text,scale: 1.1, padding: 0.0),
                Stack(
                  children: [
                    Align(
                      child: _m!.listTextFiled(curve, controller, () => press(), MyColors.black, MyColors.white, AppLocalizations.of(context)!.translate('Select from the list'), MyColors.white, width: width, withOutValidate: _firstOpen),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: curve/2, right: AppWidth.w4, left: AppWidth.w4),
                        child: _dropDown(width, curve/2),
                      ),

                    )
                  ],
                )
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
          ),
        ],
      ),

    );
  }

  _openList() {
    if(cities.isEmpty){
      myAPI!.getCities();
      return;
    }
    _dropDownKey.currentContext?.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
              //return false;
            });
          }
        });
      }
    });
  }

  _acceptTerms()async{
    setState((){
      termsAndConditions = !termsAndConditions;
    });
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('terms', termsAndConditions);
  }

  _selectType(){
    _type(type, text){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //textDirection: TextDirection.rtl,
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: ()=> setState(() {
              type = type;
              print(type.toString());
            }),
            child: SvgPicture.asset(type == type?'assets/images/check.svg':'assets/images/check-not.svg' ,height: MediaQuery.of(context).size.width/13, fit: BoxFit.contain,),
          ),
          SizedBox(width: MediaQuery.of(context).size.width/40,),
          Column(
            children: [
              _m!.headText(text, scale: 0.7, paddingH: 0.0),
            ],
          )
        ],
      )
        ;
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _m!.iconText(termsAndConditions?'assets/images/check.svg':'assets/images/check-not.svg', AppLocalizations.of(context)!.translate("Customer"), MyColors.bodyText1, click: ()=> _acceptTerms()),
              ],
            ),),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _m!.iconText(termsAndConditions?'assets/images/check.svg':'assets/images/check-not.svg', AppLocalizations.of(context)!.translate('Supplier'), MyColors.bodyText1, click: ()=> _acceptTerms()),
              ],
            ),),

        ],
      );

    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _type(0, AppLocalizations.of(context)!.translate("Customer")),
        ),
        Expanded(
          flex: 1,
          child: _type(1, AppLocalizations.of(context)!.translate("Supplier")),
        ),
      ],
    );
  }
/*
  signIn(String email, String password) async {
    setState(() => chLogIn = true);
    http.Response? response;
    response = await apiService.login(email, password);
    // ignore: unnecessary_null_comparison
    if(response == null) {
      setState(() => chLogIn = false);
    }
    if (response!.statusCode == 200) {
      print("we're good");
      userData = jsonDecode(response.body);
      editTransactionUserData(transactions![0], userData);
      setState(() {
        if (jsonDecode(response!.body)['error_des'] == "") {
          isLogIn = true;
          token = jsonDecode(response.body)["content"]["Token"].toString();
          updateUserInfo(userData["content"]["Id"]);
        } else {
          isLogIn = false;
          setState(() => chLogIn = false);
          Flushbar(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 30),
            icon: Icon(
              Icons.error_outline,
              size: MediaQuery.of(context).size.height / 30,
              color: MyColors.White,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: jsonDecode(response.body)['error_des'],
            messageSize: MediaQuery.of(context).size.height / 37,
          ).show(context);
        }
      });
    } else {
      print('A network error occurred');
    }

    if (isLogIn) {
      getServiceData();
    }
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', token);
  }

  void updateUserInfo(var id) async {
    print("flag1");
    print(id);
    var url = Uri.parse("https://mr-service.online/Main/Users/SignUp_Read?filter=Id~eq~'$id'");

    http.Response response = await http.get(url, headers: {"Authorization": token,});
    if (response.statusCode == 200) {
      print("flag2");
      userInfo = jsonDecode(response.body)['result']['Data'][0];
      editTransactionUserUserInfo(transactions![0], userInfo);
      print(jsonDecode(response.body));
      print("flag3");
    } else {
      print("flag4");
      print(response.statusCode);
    }
    print("flag5");
    //await Future.delayed(Duration(seconds: 1));
  }
  List service = [];

  void getServiceData() async {
    //var url = Uri.parse('https://mr-service.online/Main/Services/Services_Read?filter=IsMain~eq~true');
    var url = Uri.parse('https://mr-service.online/Main/Services/Services_Read?filter=ServiceParentId~eq~null');
    //var url = Uri.parse('https://mr-service.online/Main/Services/Services_Read?');
    http.Response response = await http.get(url, headers: {
      "Authorization": token,
    });
    print("we're here now");
    if (response.statusCode == 200) {
      var item = json.decode(response.body)["result"]['Data'];
      setState(() {
        editTransactionService(transactions![0], service);
        /*for(int i =0; i<item.length; i++){
          if(item[i]['ServiceParentId']==null){
            item.removeAt(i);
            i--;
          }
        }*/
        service = item;
      });
      setState(() => chLogIn = false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainScreen(
            token: token,
            service: service,selectedIndex: 0,
            initialOrderTab: 0,
          )));
    } else {
      setState(() {
        service = [];
      });
    }
  }

  Future registration() async{
    setState(()=>chLogIn =true);

    var  apiUrl =Uri.parse('https://mr-service.online/Main/SignUp/SignUp_Create');
    Map mapDate = {
      "Name": firstNameController.text,
      "LastName": lastNameController.text,
      "Mobile": phoneController.text,
      "Email": emailController.text,
      "Password": passwordController.text,
    };

    http.Response response = await http.post(apiUrl,body:jsonEncode(mapDate),headers: {
      "Accept-Language": LocalizationService.getCurrentLocale().languageCode,
      "Accept": "application/json",
      "content-type": "application/json",
    });
    print('Req: ------------------------');
    print(jsonEncode(mapDate));

    print('ResAll: ------------------------');
    print(response);

    print('Res: ------------------------');
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      String x= response.body;
      if(jsonDecode(x)["Errors"] == '' || jsonDecode(x)["Errors"] == null){
        value =jsonDecode(x)["Data"][0]["Id"].toString();
        // final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
        // sharedPreferences.setString('Id',response.body[1].toString());
        //
        // if(sharedPreferences.getString('Id') != null){
        setState(()=> chLogIn = false);
        _save();
        if(!_autoVer || emailController.text != this.mapDate!['Email']) Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Verification(value: value ,email: emailController.text, password: passwordController.text, ),));
        else {
          await ver(jsonDecode(response.body)["Data"][0]["Id"], jsonDecode(response.body)["Data"][0]["VerificationCode"]);
          await signIn(emailController.text, passwordController.text);
        }
        // }
      }else{
        setState(()=> chLogIn = false);
        await Flushbar(
          icon: Icon(Icons.error_outline,size: MediaQuery.of(context).size.width/18,color: MyColors.White,),
          shouldIconPulse: false,
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height/37)),
          backgroundColor: Colors.grey.withOpacity(0.5) ,
          barBlur: 20,
          message: jsonDecode(x)["Errors"],
          messageSize:MediaQuery.of(context).size.width/22 ,
          // ignore: deprecated_member_use
          mainButton: FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder:(context)=>SignIn()));
            },
            child: Text(AppLocalizations.of(context)!.translate('Log in Now'),style: TextStyle(
              color: MyColors.White,
              fontSize:MediaQuery.of(context).size.width/22 ,
            ),),
          ),

        ).show(context);
      }
    } else if (response.statusCode == 500) {
      setState(()=> chLogIn = false);
      await Flushbar(
        icon: Icon(Icons.error_outline,size: MediaQuery.of(context).size.width/18,color: MyColors.White,),
        duration: Duration(seconds: 5),
        shouldIconPulse: false,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height/37)),
        backgroundColor: Colors.grey.withOpacity(0.5) ,
        barBlur: 20,
        message: AppLocalizations.of(context)!.translate('Server is busy try again later'),
        messageSize:MediaQuery.of(context).size.width/22 ,
      ).show(context);
      print(response.statusCode);
      print('A network error occurred');
    }
    else{
      setState(()=> chLogIn = false);
      await Flushbar(
        icon: Icon(Icons.error_outline,size: MediaQuery.of(context).size.width/18,color: MyColors.White,),
        shouldIconPulse: false,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height/37)),
        backgroundColor: Colors.grey.withOpacity(0.5) ,
        barBlur: 20,
        message: AppLocalizations.of(context)!.translate('This Email Already Existed'),
        messageSize:MediaQuery.of(context).size.width/22 ,
        // ignore: deprecated_member_use
        mainButton: FlatButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder:(context)=>SignIn()));
          },
          child: Text(AppLocalizations.of(context)!.translate('Log in Now'),style: TextStyle(
            color: MyColors.White,
            fontSize:MediaQuery.of(context).size.width/22 ,
          ),),
        ),

      ).show(context);
    }
  }
*/
}
