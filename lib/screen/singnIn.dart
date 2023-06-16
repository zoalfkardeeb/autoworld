// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/color/MyColors.dart';
import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/SupplierOrder.dart';
import 'package:automall/screen/register.dart';
import 'package:automall/screen/selectScreen.dart';
import 'package:automall/screen/termAndConitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../MyWidget.dart';

import 'resetPassword.dart';
// ignore: camel_case_types
class Sign_in extends StatefulWidget {
  bool animate;
  Sign_in(this.animate, {Key? key, }) : super(key: key);

  @override
  _Sign_inState createState() => _Sign_inState(ani: animate);
}

// ignore: camel_case_types
class _Sign_inState extends State<Sign_in> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _Sign_inState({required this.ani});
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
    startTime();
    showAll = ani;
    _emailController.addListener(() {setState(() {});});
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
  bool ani = false, chLogIn = false;
  bool showAll = false;
  var duration = const Duration(milliseconds: 700);

  var requiredValidator = RequiredValidator(errorText: 'Required');

  bool passwordTextStyle = true;

  @override
  Widget build(BuildContext context) {
    _m = MyWidget(context);
    myAPI = MyAPI(context: context);
    requiredValidator = RequiredValidator(errorText: AppLocalizations.of(context)!.translate('Required'));
    var hSpace = MediaQuery.of(context).size.height/20;
    var curve = MediaQuery.of(context).size.height/30;

    return Container(
        decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: Stack(
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
              )
                  :
              (Matrix4.identity()
                ..translate(-0.0000001, -MediaQuery.of(context).size.height/2 + MediaQuery.of(context).size.width/7 + hSpace + MediaQuery.of(context).viewInsets.bottom/2)
                  //..scale(1/3.5, 1/3.5*MediaQuery.of(context).size.width/MediaQuery.of(context).size.height)
              ),
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/images/Logo1.svg',
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
            child: showAll? Container(
              height: MediaQuery.of(context).size.height*9/10 - (hSpace*1.5 + MediaQuery.of(context).size.width/3.5 + MediaQuery.of(context).size.width/6),
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: hSpace*1.5 + MediaQuery.of(context).size.width/3.5 + MediaQuery.of(context).size.width/6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //SizedBox(height: hSpace*1.5 + MediaQuery.of(context).size.width/3.5 + MediaQuery.of(context).size.width/6,),
                    //SizedBox(height: hSpace,),
                    _m!.bodyText1(AppLocalizations.of(context)!.translate('Please log in to start your experience'),padV: 0.0),
                    _m!.textFiled(curve, MyColors.black, MyColors.white, _emailController, AppLocalizations.of(context)!.translate('Enter Your Email'), Icons.email_outlined, requiredValidator: requiredValidator, withoutValidator: _firstOpen),
                    _m!.textFiled(curve, MyColors.white, MyColors.black, _passwordController, AppLocalizations.of(context)!.translate('Enter Your Password'),!passwordTextStyle? Icons.lock_open_outlined: Icons.lock_outline, password: passwordTextStyle, requiredValidator: requiredValidator, withoutValidator: _firstOpen, click: ()=> _changePasswordStyle()),
                    SizedBox(height: hSpace/4,),
                    GestureDetector(
                      onTap: ()=> _m!.changePassword(()=>_resetPass()),
                      child: _m!.headText(AppLocalizations.of(context)!.translate('Forget Password?'),align: TextAlign.start,color: MyColors.mainColor, scale: 0.6),
                    ),
                    SizedBox(height: hSpace/2,),
                    _m!.bodyText1(AppLocalizations.of(context)!.translate('New to the app? Get Your free account!')),
                    SizedBox(height: hSpace/3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*_signUpCard(curve, 'assets/images/facebook.svg', AppLocalizations.of(context)!.translate('Sign up with Facebook'), () async => await _faceBookLogIn()),
                        SizedBox(width: MediaQuery.of(context).size.width/30,),
                        _signUpCard(curve, 'assets/images/google.svg', AppLocalizations.of(context)!.translate('Sign up with Google'), () async => await _googleLogIn()),
                        SizedBox(width: MediaQuery.of(context).size.width/30,),*/
                        _signUpCard(curve, 'assets/images/user_plus.svg', AppLocalizations.of(context)!.translate('Sign up Manually'),  ()=> _register()),
                      ],
                    ),
                    SizedBox(height: hSpace/2,),
                    GestureDetector(
                      onTap: ()=> _countinueAsGuest(),
                      child: _m!.bodyText1(AppLocalizations.of(context)!.translate('Continue As Guest'), align: TextAlign.start, color: MyColors.mainColor, scale: 1),
                    ),
                    SizedBox(height: hSpace/4,),
                    _m!.copyLangButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('copy lang'), ()=> setState((){})),
                    //SizedBox(height: hSpace/2,),
                  ],
                ),
              )
              ,
            ):
            const SizedBox(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery.of(context).viewInsets.bottom != 0 || !showAll?
            const SizedBox(height: 0.1,)
                :
            _m!.bottomContainer(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*_m!.iconButton(
                        curve, 'assets/images/read.svg', () => _terms()),
                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width / 40,),*/
                    _m!.raisedButton(curve, MediaQuery.of(context).size.width / 1.2, AppLocalizations.of(context)!.translate(
                        'Start surfing'), 'assets/images/user_bag.svg', () =>
                        _startSurfing())
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

  _signUpCard(curve, icon, text, Function() click){
    return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width/3.6,
          height: MediaQuery.of(context).size.width/3.8,
          //margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/10*0, right: MediaQuery.of(context).size.width/10, top: MediaQuery.of(context).size.height/80, bottom: 0),
          //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
          // color: Color(0x00000000),
          decoration: BoxDecoration(
            color: MyColors.white.withOpacity(0.5),// color: MyColors.white,
            border: Border.all(
              color: MyColors.card,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(curve/2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: curve/2,),
              SvgPicture.asset(icon, height: MediaQuery.of(context).size.height/28, fit: BoxFit.contain,),
              //Icon(icon, color: MyColors.mainColor,),
              const Expanded(child: SizedBox()),
              _m!.bodyText1(text, scale: 0.8, padding: 0.0),
              SizedBox(height: curve/2,)
            ],
          ),
        ),
        onTap: ()=> click(),

    );

  }

  _startSurfing() async{
    if(_emailController.text == '' || _passwordController.text == ''){
        setState(() {
        });
        return;
    }
    setState(() {
      chLogIn = true;
    });
    bool response = await myAPI!.login(_emailController.text, _passwordController.text);
    if(response) {
      guestType = false;
      _save();
      await MyAPI(context: context).getOrders(userInfo['id']);
    }

    setState(() {
      chLogIn = false;
    });
    if(response){
      if(userInfo['type'] == 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SelectScreen(),
            )
        );
      } else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SupplierOrdesr(),
            )
        );
      }
    }
  }

  _countinueAsGuest() async{
    /*if(_emailController.text == '' || _passwordController.text == ''){
        setState(() {
        });
        return;
    }
    setState(() {
      chLogIn = true;
    });

    setState(() {
      chLogIn = false;
    });*/
    guestType = true;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectScreen(),
        )
    );
  }

  _terms() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  TermsAndConditions(drawer: false),
        ));
  }

  _register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Register(false, false),
        ));

  }

  Map userobj = {};//for facebookSignIn

  _faceBookLogIn() async{
    fbLog()async {
      try {
        FacebookAuth.instance.getUserData().then((userData111) async {
          setState(() {
            userobj = userData111;
            chLogIn = true;
          });
          //setState(()=>chLogIn =true);
          var apiUrl = Uri.parse(
              'https://mr-service.online/Main/SignUp/SignUp_Create');
          var password = "FB_P@ssw0rd_FB";
          var mobile;
          mobile = userobj["phone"] ??= '';
          Map mapDate = {
            "Name": userobj["name"].toString(),
            "LastName": userobj["name"].toString().split(' ')[1],
            "Mobile": mobile,
            "Email": userobj["email"],
            "Password": password,
          };
          setState(() => chLogIn = false);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register(false, true, mapDate: mapDate,)));
          /*http.Response response = await http.post(apiUrl,body:jsonEncode(mapDate),headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      });
      print('Req: ------------------------');
      print(jsonEncode(mapDate));

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      print(response.body);
      if(jsonDecode(response.body)['Errors'] == '' || jsonDecode(response.body)['Errors'] == null){
        ver(jsonDecode(response.body)["Data"][0]["Id"], jsonDecode(response.body)["Data"][0]["VerificationCode"]);
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('facebookEmail', userobj["email"].toString());
        sharedPreferences.setString('email', userobj["email"].toString());
        signIn(userobj["email"], password);
      }else{
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
          message: jsonDecode(response.body)['Errors'],
          messageSize: MediaQuery.of(context).size.height / 37,
        ).show(context);
        /*final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('facebookEmail', userobj["email"].toString());
        sharedPreferences.setString('email', userobj["email"].toString());
        signIn(userobj["email"], password);*/
      }*/
          //setState(()=>chLogIn =false);
        });
      } catch (e) {
        myAPI!.flushBar(e.toString());
      }
    }
    FacebookAuth.instance.login(permissions: [
      "public_profile", "email"
    ]).then((value) async {
      if (value.status.index == 1) {
        myAPI!.flushBar(AppLocalizations.of(context)!.translate(
            "Sign in doesn't complete"));
        return;
      } else if (value.status.index == 0) {
        await fbLog();
      } else {
        myAPI!.flushBar(value.message.toString());
        return;
      }
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late GoogleSignInAccount? userObjg; //for google

  _googleLogIn() async{
    // FacebookAuth.instance.getUserData().then((userData) async {
    try{
      _googleSignIn.signIn().then((userData111) async{
        setState(() {
          //isLogIn = true;
          userObjg = userData111!;
          chLogIn = true;
        });
        if (userObjg == null) {
          myAPI!.flushBar(AppLocalizations.of(context)!.translate("Sign in doesn't complete"));
          setState(() => chLogIn = false);
          return;
        }
        //setState(()=>chLogIn =true);
        var password = "GM_P@ssw0rd_GM";
        String mobile;
        mobile = '';
        Map mapDate = {
          "Name": userObjg!.displayName.toString(),
          "LastName": userObjg!.displayName.toString().split(' ')[1],
          "Mobile": mobile,
          "Email": userObjg!.email,
          "Password": password,
        };
        setState(() => chLogIn = false);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register(false, true, mapDate: mapDate,)));
/*
        http.Response response = await http.post(apiUrl,body:jsonEncode(mapDate),headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      });
      print('Req: ------------------------');
      print(jsonEncode(mapDate));

      print('ResAll: ------------------------');
      print(response);

      print('Res: ------------------------');
      print(response.body);
      if(jsonDecode(response.body)['Errors'] == '' || jsonDecode(response.body)['Errors'] == null){
        await ver(jsonDecode(response.body)["Data"][0]["Id"], jsonDecode(response.body)["Data"][0]["VerificationCode"]);
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('facebookEmail', userobj["email"].toString());
        sharedPreferences.setString('email', userobj["email"].toString());
        signIn(userObjg!.email, password);
      }else{
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
          message: jsonDecode(response.body)['Errors'],
          messageSize: MediaQuery.of(context).size.height / 37,
        ).show(context);
        /*final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('facebookEmail', userobj["email"].toString());
        sharedPreferences.setString('email', userobj["email"].toString());
        signIn(userobj["email"], password);*/
      }*/
        //setState(()=>chLogIn =false);
      });
    }catch(e){
      myAPI!.flushBar(e.toString());
    }
  }

  void _afterLayout(Duration timeStamp) {
    _read();
    Timer(const Duration(seconds: 3), ()=> {
      _firstOpen = false,
    duration = const Duration(microseconds: 0),
    });
  }

  _acceptTerms()async{
    setState((){
      termsAndConditions = !termsAndConditions;
    });
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('terms', termsAndConditions);
  }

  _changePasswordStyle() {
    setState(() {
      passwordTextStyle = !passwordTextStyle;
    });
  }

  _read() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _emailController.text = sharedPreferences.getString('email')!;
    _passwordController.text = sharedPreferences.getString('password')!;
    var isLogInLast = false;
    try{
      termsAndConditions = sharedPreferences.getBool('terms')!;
      isLogInLast = sharedPreferences.getBool('isLogin')!;
    }catch(e){
      print(e);
    }

    if(isLogInLast) _startSurfing();
  }

  _save() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', _emailController.text);
    sharedPreferences.setString('password', _passwordController.text);
    sharedPreferences.setString('token', token.toString());
    sharedPreferences.setBool('terms', termsAndConditions);
    sharedPreferences.setBool('isLogin', true);

  }

  _resetPass() async{
    setState(() {
      chLogIn = true;
    });
    var response = await MyAPI(context: context).requestResetPassword(_emailController.text);
    if(response[0]){
      //var value = jsonDecode(x)["data"][0]["id"].toString();
      var verCode = response[1].toString();
      // final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      // sharedPreferences.setString('Id',response.body[1].toString());
      //
      // if(sharedPreferences.getString('Id') != null){
      bool sent = await myAPI!.sendEmail(AppLocalizations.of(context)!.translate('Your activation code is :') +  '\n$verCode' , AppLocalizations.of(context)!.translate('Activation Code'),  _emailController.text);
      setState(()=> chLogIn = false);
      if(!sent){
        return;
      }
      //_save();
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=> ResetPassword(_emailController.text, verCode: response[1].toString(),)));
    }else{
      setState(() {
        chLogIn = false;
      });
    }
    setState(() {
      chLogIn = false;
    });
  }
}
