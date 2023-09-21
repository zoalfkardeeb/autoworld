import 'package:automall/api.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/font_size.dart';
import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../MyWidget.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../localizations.dart';
class ResetPassword extends StatefulWidget {
  String email, verCode;

  ResetPassword(this.email,{Key? key, required this.verCode}) : super(key: key);
  @override
  _ResetPasswordState createState() => _ResetPasswordState(email, verCode);
}

class _ResetPasswordState extends State<ResetPassword> {
  String email;
  bool newPassword = true;
  final _formKey = GlobalKey<FormState>();

  _ResetPasswordState(this.email, this.verCode);

  int codeLength = 0;
  String code = "";
  var verCode;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var requiredValidator = RequiredValidator(errorText: 'Required'.tr);
  bool _secureText = true;

  MyAPI? myAPI;
  MyWidget? _m;
  bool chVer = false;

  @override
  void initState() {
    super.initState();
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
      //  print(value);
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
                  child: Form(
                    key: _formKey,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/40, horizontal: MediaQuery.of(context).size.width/20),
                        child: ListView(
                         children: [
                            Container(
                              //height: MediaQuery.of(context).size.height/30,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: heightSpace*2,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(MediaQuery.of(context).size.height/70),
                                    child: buildContainerPassword(passwordController, AppLocalizations.of(context)!.translate('newPassword'),
                                        TextInputType.visiblePassword, requiredValidator),
                                  ),
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
                                      scale: 0.8, maxLine: 2
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
                      ))
                  ,
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
    if(!_formKey.currentState!.validate()) return;
    setState(() => chVer = true);
    MyAPI(context: context).newPasswordVer(passwordController.text, email, code);

    _newPasswordVer(passwordController.text);
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
      height: MediaQuery.of(context).size.height/10,

      child: TextFormField(

        obscureText: _secureText,
        keyboardType: type,
        controller: controller,
        validator: requiredValidator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(color: MyColors.black, fontSize: MediaQuery.of(context).size.width/25),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
            icon: Icon(
              Icons.remove_red_eye,
              color: _secureText? Colors.grey : MyColors.black,
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
            color: MyColors.black,
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
        ),
      ),
    );
  }

  SizedBox buildContainerConfirmPassword(
      TextEditingController controller, String labelText, TextInputType type) {
    return SizedBox(
      // alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.height/10,
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
        style: TextStyle(color: MyColors.black, fontSize: MediaQuery.of(context).size.width/25),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width/20,
            color:MyColors.black,
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
        ),
      ),
    );
  }

  void resend() async{
    setState(() => chVer = true);
    bool sent = await myAPI!.sendEmail(AppLocalizations.of(context)!.translate('Your activation code is :') +  '\n$verCode' , AppLocalizations.of(context)!.translate('Activation Code'), email);
    setState(() => chVer = false);
  }
}
