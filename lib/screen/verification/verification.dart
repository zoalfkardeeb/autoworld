import 'package:automall/api.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/font_size.dart';
import 'package:automall/screen/singnIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:get/get.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../MyWidget.dart';
import '../../localizations.dart';


bool chVer = false;
// ignore: must_be_immutable
class Verification extends StatefulWidget {
  String value;
  String email;
  String password;
  String verCode;

//  Data":[{"Id":"ec9316ec-d4c7-478b-10f4-08da195f8290","Name":"omar hsn","LastName":"last name","Mobile":"+97493802534","Email":"omar.suhail.hasan@gmail.com","Password":"123456","VerificationCode":"241280","IsVerified":false,"Type":0,"Dob":null,"ImagePath":null,"File":null,"EventDate":null,"FBKey":null,"Lang":null,"GroupUsers":[]}],"Total":1,"AggregateResults":null,"Errors":null

  Verification({required this.value, required this.email, required this.password, required this.verCode});
  @override
  _VerificationState createState() =>
      _VerificationState(value, email, password, verCode);
}

class _VerificationState extends State<Verification> {
  String value;
  String email;
  String password;
  bool newPassword = false;

  _VerificationState(this.value, this.email, this.password, this.verCode){
    password  == ''? newPassword = true: newPassword = false;
  }

  int codeLength = 0;
  String code = "";
  var verCode;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var requiredValidator = RequiredValidator(errorText: 'Required'.tr);
  final bool _secureText = true;

  MyAPI? myAPI;
  MyWidget? _m;

  @override
  void initState() {
    super.initState();
    chVer = false;
  }

  @override
  Widget build(BuildContext context) {
    myAPI = MyAPI(context: context);
    requiredValidator = RequiredValidator(errorText: AppLocalizations.of(context)!.translate('Required'));
    _m = MyWidget(context);
    var curve = MediaQuery.of(context).size.height/30;
    Null Function()? active;
    if (codeLength == 6) {
      active = () {
        print(value);
        ver();
      };
    } else {
      active = null;
    }
    var heightSpace = MediaQuery.of(context).size.height/40;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/images/background.png"), fit: BoxFit.cover)),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/40, horizontal: MediaQuery.of(context).size.width/20),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !newPassword?
                        SvgPicture.asset(
                          'assets/images/Logo1.png',
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.height/3,
                        ):
                        Container(
                          //height: MediaQuery.of(context).size.height/30,
                          child: Column(
                            children: [
                              /*Image.asset(
                                'assets/images/code.png',
                                width: MediaQuery.of(context).size.width/5,
                                height: MediaQuery.of(context).size.height/7,
                              ),*/
                              SizedBox(
                                height: heightSpace*2,
                              ),
                              Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height/70),
                                child: buildContainerPassword(passwordController, AppLocalizations.of(context)!.translate('newPassword'),
                                    TextInputType.visiblePassword, requiredValidator),
                              ),
                              // SizedBox(
                              //   height: 20.0,
                              // ),
                              Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height/70),
                                child: buildContainerConfirmPassword(
                                    confirmPasswordController,
                                    AppLocalizations.of(context)!.translate('Confirm Password'),
                                    TextInputType.visiblePassword),
                              ),
                              SizedBox(
                                height: heightSpace*2,
                              ),
                            ],
                          ),
                        ),
                        /*Expanded(
                        flex:2,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(
                              vertical: 0, horizontal: MediaQuery.of(context).size.width/20),
                          child: Text(
                            AppLocalizations.of(context)!.translate("Enter the 6-digit code sent to your phone"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/20,
                                color: MyColors.White,
                                fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),*/
                        SizedBox(
                          height: heightSpace*2,
                        ),
                        Column(
                          //height: MediaQuery.of(context).size.height/5,
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(
                                  vertical: 0, horizontal: MediaQuery.of(context).size.width/20),
                              child: _m!.headText(
                                  AppLocalizations.of(context)!.translate("Enter the 6-digit code sent to your email"),
                                  scale: 0.8
                              ),
                            ),
                            SizedBox(
                              height: heightSpace,
                            ),
                            buildCodeBox(first: true, last: false),
                          ],
                        ),
                        //Expanded(child: Container()),
                        SizedBox(
                          height: heightSpace*9,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _m!.bodyText1(
                                AppLocalizations.of(context)!.translate("Didn't receive the code?"),
                                padding: 0.0
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              onTap: ()=> resend(),
                              child: _m!.headText(
                                  AppLocalizations.of(context)!.translate('Resend'),
                                  scale: 0.8
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: heightSpace,
                        ),
                        _m!.raisedButton(curve, MediaQuery.of(context).size.width/1.4, AppLocalizations.of(context)!.translate('Confirm'), 'assets/images/user_profile.svg', active),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: chVer?
                  _m!.progress()
                      :
                  const SizedBox(),
                )
              ],
            ),
            snackBar:  SnackBar(
            content: Text(AppLocalizations.of(context)!.translate('Tap back again to leave')),
          ),
        ),
      ),
    ),
    );
  }

  Widget buildCodeBox({required bool first, last}) {
    return Center(
      child: PinCodeTextField(
        appContext: context,
        textStyle: TextStyle(
            fontSize: FontSize.s18,
            color: MyColors.mainColor,
            fontFamily: 'Gotham'
        ),
        pastedTextStyle: TextStyle(fontSize: FontSize.s16, color: Colors.green.shade600, fontWeight: FontWeight.bold, fontFamily: 'BCArabicB'),
        length: 6,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(shape: PinCodeFieldShape.box, borderRadius: BorderRadius.circular(AppWidth.w1), fieldHeight: AppWidth.w12, fieldWidth: AppWidth.w12, inactiveColor: MyColors.mainColor, selectedColor: MyColors.mainColor, selectedFillColor: MyColors.mainColor, inactiveFillColor: Colors.transparent, activeFillColor: MyColors.white, borderWidth: 12),
        cursorColor: MyColors.black,
        animationDuration: const Duration(milliseconds: 2),
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (pin) {
          codeLength = pin.length;
          code = pin;
          },
        onCompleted: (pin) {},
      ),
    );
    /*return Center(
        child: OTPTextField(
          keyboardType: TextInputType.number,
          otpFieldStyle: OtpFieldStyle(
            borderColor: MyColors.gray,
            focusBorderColor: MyColors.mainColor,
            disabledBorderColor: MyColors.gray,
            enabledBorderColor: MyColors.gray,
          ),
          length: 6,
          width: MediaQuery.of(context).size.width,
          textFieldAlignment: MainAxisAlignment.center,
          fieldWidth:  MediaQuery.of(context).size.width/9,
          spaceBetween: MediaQuery.of(context).size.width*((1-6/9)/10),
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: MediaQuery.of(context).size.height/90,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width/15,
            color: MyColors.mainColor,
            fontFamily: 'Gotham'
          ),
          onChanged: (pin) {
            codeLength = pin.length;
            code = pin;
          },
          onCompleted: (pin) {
          },

        )

      /*TextField(
          autofocus: true,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          textInputAction: TextInputAction.next,
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2,color: Colors.white),
              borderRadius: BorderRadius.circular(12),

            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2,color: Colors.yellow),
              borderRadius: BorderRadius.circular(12),
            )
          ),
        ),*/

    );*/
  }

  Future ver() async {
    setState(() => chVer = true);
    if(newPassword){
      _newPasswordVer(passwordController.text);
    }else{
      _firstVer();
    }
  }

  _firstVer() async{
    http.Response response = await myAPI!.ver(value, code);

    if (response.statusCode == 200) {
      print(response.body);
/*      try {
        if (jsonDecode(response.body)["Data"][0]['txtParam'].toString() ==
            code) {

          http.Response response = await http.post(
              Uri.parse('https://mr-service.online/api/Auth/login'),
              body: jsonEncode({"UserName": email, "Password": password}),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json",
              });
          if (response.statusCode == 200) {
            print(response.body);
            setState(() {
              if (jsonDecode(response.body)['error_des'] == "") {
               var tokenn =
                    jsonDecode(response.body)["content"]["Token"].toString();
                getServiceData(tokenn);

              }
            });
          }




        }
      } catch (e) {
        if (jsonDecode(response.body)['success'].toString() == "false") {
          setState(() => chVer = false);

          Flushbar(
            icon: Icon(
              Icons.error_outline,
              size: 32,
              color: Colors.white,
            ),
            duration: Duration(seconds: 3),
            shouldIconPulse: false,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            backgroundColor: Colors.grey.withOpacity(0.5),
            barBlur: 20,
            message: 'Wrong Code'.tr,
          ).show(context);
        }
      }*/
      // Navigator.of(context).pushNamed('sign_in');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder:(context)=>Sign_in(false)));
    } else {
      //Navigator.of(context).pushNamed('main_screen');
      print(response.statusCode);
      print('A network error occurred');
    }
    setState(() => chVer = false);
  }

  _newPasswordVer(String newPassword) async{
    //curl -X POST "https://mr-service.online/Main/SignUp/ResetPassword?UserEmail=www.osh.themyth2%40gmail.com&code=160679&password=0938025347" -H "accept: */*"
    var apiUrl = Uri.parse('https://mr-service.online/Main/SignUp/ResetPassword?UserEmail=$email&code=$code&password=$newPassword');
/*
    http.Response response = await http.post(apiUrl, headers: {
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      print("we're good");
      //userData = jsonDecode(response.body);
      setState(() {
        if (jsonDecode(response.body)['Errors'] == "") {
          Navigator.of(context).pushNamed('sign_in');
          //isLogIn = true;
          //token = jsonDecode(response.body)["content"]["Token"].toString();
          //updateUserInfo(userData["content"]["Id"]);
        } else {
          //setState(() => chLogIn = false);
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
          chVer = false;
        }
      });
    }
    else {
      print(response.statusCode);
      print('A network error occurred');
    }
*/
  }

  SizedBox buildContainerPassword(TextEditingController controller, String labelText,
      TextInputType type, RequiredValidator requiredValidator ) {
    return SizedBox(
      // alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.height/12,

      child: TextFormField(
        obscureText: _secureText,
        keyboardType: type,
        controller: controller,
        validator: requiredValidator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        /*style: TextStyle(color: MyColors.White, fontSize: MediaQuery.of(context).size.width/25),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
            icon: Icon(
              Icons.remove_red_eye,
              color: _secureText? Colors.grey : MyColors.White,
              size: MediaQuery.of(context).size.height/33,
            ),
            onPressed: () {
              setState(() {
                _secureText = !_secureText;
              });
            },
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width/20,
            color: MyColors.White,
          ),
          errorStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width/24
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
              borderSide: BorderSide(color: Colors.grey, width: 2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
            borderSide: BorderSide(color: MyColors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
            borderSide: BorderSide(color: MyColors.red, width: 2),
          ),
        ),*/
      ),
    );
  }


  SizedBox buildContainerConfirmPassword(
      TextEditingController controller, String labelText, TextInputType type) {
    return SizedBox(
      // alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.height/12,
      child: TextFormField(
        obscureText: true,
        keyboardType: type,
        controller: controller,
        validator: (val){
          if (val != passwordController.value.text){
            return AppLocalizations.of(context)!.translate('Password Do not Match');
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        /*style: TextStyle(color: MyColors.White, fontSize: MediaQuery.of(context).size.width/25),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width/20,
            color:MyColors.White,
          ),
          errorStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width/24,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
              borderSide: BorderSide(color: Colors.grey, width: 2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
            borderSide: BorderSide(color: MyColors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height/12),
            borderSide: BorderSide(color: MyColors.red, width: 2),
          ),
        ),*/
      ),
    );
  }

  void resend() async{
    setState(() => chVer = true);
    await Future.wait([
      //myAPI!.sendEmail(AppLocalizations.of(context)!.translate('Your activation code is :') +  '\n$verCode' , AppLocalizations.of(context)!.translate('Activation Code'), email),
      myAPI!.resend(email),
    ]);
    setState(() => chVer = false);
  }
}
