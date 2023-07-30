// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:automall/localization_service.dart';
import 'package:automall/screen/SupplierOffersScreen.dart';
import 'package:automall/screen/SupplierOrder.dart';
import 'package:automall/screen/notificationScreen.dart';
import 'package:automall/screen/resetPassword.dart';
import 'package:automall/screen/singnIn.dart';
import 'package:automall/screen/termAndConitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gradient_progress_indicator/widget/gradient_progress_indicator_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'api.dart';
import 'color/MyColors.dart';
import 'const.dart';
import 'localizations.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
class MyWidget{
  BuildContext context;
  MyWidget(this.context);

  guestDialog() {
    var curve = MediaQuery.of(context).size.width/20;
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(curve),), //this right here
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(curve)),
          color: MyColors.bottomCon,
        ),
        height: MediaQuery.of(context).size.width/2,
        width: MediaQuery.of(context).size.width/3*2,
        padding: EdgeInsets.all(curve),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: MyColors.white, size: MediaQuery.of(context).size.width/10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    child: bodyText1(AppLocalizations.of(context)!.translate('You should signIn to get this service'), maxLine: 2, color: MyColors.white, scale: 1),
                  )
                ],
              ),
            ),
            Row(
              children: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                    child: bodyText1(AppLocalizations.of(context)!.translate('Later!'),  color: MyColors.white)),
                Expanded(child: SizedBox()),
                TextButton(onPressed: () {
                  guestType = true;
                  //editTransactionGuestType();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Sign_in(false)));
                },
                    child: bodyText1(AppLocalizations.of(context)!.translate('SignIn'), color: MyColors.mainColor))
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  showSDialog(title, optionchild1, optionChild2,){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(title,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/22,
                    color: MyColors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gotham'),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      optionchild1,
                      const Expanded(child: SizedBox()),
                      optionChild2,
                      /*
                    SimpleDialogOption(
                      onPressed: () {},
                      child: const Text('Pick From Gallery'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {},
                      child: const Text('Take A New Picture'),
                    ),
                    */
                    ],
                  ),
                ),

              ]);
        });
  }

  headText(text,{double? scale, color, paddingV, paddingH, align, maxLine}){
    scale ??= 1.0;
    color ??= MyColors.headText;
    paddingV ??= 0.0;
    paddingH ??= 0.0;
    align ??= TextAlign.center;

    return Padding(
        padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
//        softWrap: false,
        //textDirection: TextDirection.rtl,
        textAlign: align, maxLines: maxLine,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width/15 * scale,
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: lng==2?'GESS':'Gotham'),
      ),
    );
  }

  fieldText(text,{double? scale}){
    scale ??= 1.0;
    return Text(
      text,
      textAlign: TextAlign.center, maxLines: 1,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/25 * scale,
          color: MyColors.fieldText,
          fontFamily: lng==2?'GESS':'Gotham'),
    );
  }

  bodyText1(text,{double? scale, padding, padV, maxLine,bool? baseLine, color, align}){
    scale ??= 1.0;
    padding??= MediaQuery.of(context).size.width/20;
    maxLine??=2;
    baseLine??=false;
    padV??=0.0;
    color??= MyColors.bodyText1;
    align ??= TextAlign.center;
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padV),
          child: Text(
            text,
            overflow: TextOverflow.visible,
            maxLines: maxLine,
            //textDirection: TextDirection.ltr,
            textAlign:align,
            softWrap: true,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25 * scale,
                color: color,
                decoration: baseLine? TextDecoration.lineThrough: TextDecoration.none,
                fontFamily: lng==2?'GESS':'Gotham',
            ),
          ),
    )
     ;
  }

  titleText1(text,{double? scale, align}){
    scale ??= 1.0;
    align ??= Alignment.center;
    return Align(
        alignment: align,
        child:
        Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/25 * scale,
          color: MyColors.titleText,
          fontFamily: lng==2?'GESS':'Gotham'),
    ),);
  }

  dialogText1(text,{double? scale, align}){
    scale ??= 1.0;
    align ??= Alignment.center;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
        child: Text(text,
         // textAlign: TextAlign.center,
          maxLines: 5,
          style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/23 * scale,
          color: MyColors.white,
          fontFamily: lng==2?'GESS':'Gotham'),
    ),);
  }

  bodyText2(text){
    return Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
      child: Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/35,
          color: MyColors.red,
          fontFamily: lng==2?'GESS':'Gotham'),
    ),
    )
      ;
  }

  tooltibText(text, Function() tap){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/50*0),
      child: GestureDetector(
        child: Text(
          text,
          style: TextStyle(
              decoration: TextDecoration.none,
              //backgroundColor: MyColors.red,
              fontStyle: FontStyle.normal,
              fontSize: MediaQuery.of(context).size.width/22,
              color: MyColors.white,
              fontFamily: lng==2?'GESS':'Gotham'),
        ),
        onTap: ()=> tap(),
      ),
    )
      ;
  }

  suplierNameText(text){
    return Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20*0),
      child: Text(
      text,
      style: TextStyle(
          fontSize: MediaQuery.of(context).size.width/20,
          color: MyColors.red,
          fontFamily: lng==2?'GESS':'Gotham'),
    ),
    )
      ;
  }

  suplierDesText1(text,{double? scale, padding, maxLine,bool? baseLine, color, align}){
    scale ??= 1.0;
    padding??= 0.0;
    maxLine??=1;
    baseLine??=false;
    color??= MyColors.bodyText1;
    align ??= TextAlign.center;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        text,
        maxLines: maxLine,
        textAlign:align,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width/25 * scale,
            color: color,
            decoration: baseLine? TextDecoration.lineThrough: TextDecoration.none,
            fontFamily: lng==2?'GESS':'Gotham',
          fontStyle: FontStyle.italic
        ),
      ),
    );
  }

  appBar(barHight, _scaffoldKey){
    return AppBar(
      centerTitle: true,
      toolbarHeight: barHight,
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(MediaQuery.of(context).size.height / 80 * 3),
            bottomLeft: Radius.circular(MediaQuery.of(context).size.height / 80 * 3)),
      ),*/
      leading: IconButton(
        icon: Padding(padding: EdgeInsets.symmetric(horizontal: barHight/10), child: Image.asset('assets/images/drawer.png', height: barHight/4, fit: BoxFit.contain,),),
        onPressed: () => _scaffoldKey.currentState!.openDrawer(),
      ),
      //backgroundColor: MyColors.backGround,
      title: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 80 * 3),
        child: titleText1(AppLocalizations.of(context)!.translate('name')),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notification_add_outlined, color: MyColors.black,),
          // ignore: avoid_returning_null_for_void
          onPressed: () => null,
        )
      ],
    );
  }

  drawerButton(_scaffoldKey){
    return IconButton(
      icon: Align(
        alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
        child: SvgPicture.asset('assets/images/drawer.svg', height: MediaQuery.of(context).size.width/30, fit: BoxFit.contain,),),
      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
    );
  }

  notificationButton(){
    _onPress(){
      if(guestType){
        guestDialog();
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=> NotificationScreen()));
    }
    return Align(
        alignment: lng==2?Alignment.centerLeft:Alignment.centerRight,
        child: IconButton(
          icon: Icon(Icons.notification_add_outlined, color: thereNotification? MyColors.mainColor :MyColors.black,),
          // ignore: avoid_returning_null_for_void
          onPressed: () => _onPress(),
        ),);
  }

  driver({padH, color, padV}){
    padH??= MediaQuery.of(context).size.width/10;
    padV??= MediaQuery.of(context).size.height/100;
    color??= Colors.grey;
    return Container(
      height: MediaQuery.of(context).size.height/400,
      margin: EdgeInsets.symmetric(horizontal: padH, vertical: MediaQuery.of(context).size.height/100),
      color: color,
    );

  }

  drawer(Function() _setState, Function() _personal, Function() _home, _scaffoldKey) {
    var height = MediaQuery.of(context).size.height/7;
    var radius = MediaQuery.of(context).size.height / 80 * 3;
    _iconText(click, icon, text){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/100),
        child:
            GestureDetector(
              onTap: ()=> click!(),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //textDirection: TextDirection.rtl,
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, size: MediaQuery.of(context).size.width/10, color: MyColors.mainColor,),
                  SizedBox(width: MediaQuery.of(context).size.width/80,),
                  bodyText1(text, scale: 1.1, padding: 0.0)
                ],
              ),
            )
        ,
      );
    }
    _language(){
      Widget _no(){
        return IconButton(
            onPressed: ()=> Navigator.of(context).pop(), icon: const Icon(Icons.close_outlined, color: MyColors.mainColor,));
      }
      Widget _ok(){
        return IconButton(
          onPressed: ()=> {
            Navigator.of(context).pop(),
            changeLang(() => _setState(), lng == 0?2:0),
            pleaseWait == true,
            _setState(),
            MyAPI(context: context).userLang(lng == 0?2:0, userInfo['id']),
            pleaseWait == false,
            _setState(),
          }, icon: const Icon(Icons.check, color: MyColors.mainColor,),
        );
      }
      showSDialog(AppLocalizations.of(context)!.translate('Are you sure? change Language'), _no(), _ok());
      //_setState();
    }
    _info(){
      if(guestType){
        guestDialog();
        return;
      }
      Navigator.of(context).pop();
      _personal();
    }
    _hom(){
      Navigator.of(context).pop();
      _home();
    }
    return Drawer(
      width: MediaQuery.of(context).size.width/5*4,
        child: Container(
            height: double.infinity,
            color: MyColors.backGround,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/40,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        logoContainer(userInfo['imagePath'] == 'https://automallonline.info//ProfilesFiles/${userInfo["id"]} ' ? null : userInfo['imagePath'], MediaQuery.of(context).size.width/6, isPicker: true),
                        /*CircleAvatar(
                          backgroundImage: image == null ? (userInfo['imagePath'] == 'https://automallonline.info//ProfilesFiles/${userInfo["id"]} ' ? const AssetImage('assets/images/profile.png') as ImageProvider
                              : NetworkImage(userInfo['imagePath'])) : image as ImageProvider,
                          radius: MediaQuery.of(context).size.width/10,
                        ),*/
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              headText(userInfo['name'], paddingV: MediaQuery.of(context).size.height/60*0, align: TextAlign.start, paddingH: MediaQuery.of(context).size.width/20, maxLine:1, scale: 0.7),
                              bodyText1(userInfo['email'], align: TextAlign.start, padV: MediaQuery.of(context).size.height/80, scale: 0.8),
                              //Expanded(child: SizedBox()),
                              //iconButton(hSpace, 'assets/images/user.svg', () => _selectImageProfile())
                            ],
                          ),
                          width: MediaQuery.of(context).size.width*0.87-MediaQuery.of(context).size.width/5*2,
                          height: MediaQuery.of(context).size.width/5*2,
                        )
                      ],
                    ),
                  ),
                  _iconText(()=>_terms(), Icons.menu_book_outlined, AppLocalizations.of(context)!.translate('Terms and conditions')),
                  _iconText(()=>_language(), Icons.language, AppLocalizations.of(context)!.translate('Language')),
                  driver(),
                  _iconText(()=>_hom(), Icons.home_outlined, AppLocalizations.of(context)!.translate('HOME')),
                  _iconText(()=>_info(), Icons.person_outline, AppLocalizations.of(context)!.translate('Personal info')),
                  driver(),
                  userInfo['type'] == 0 ? SizedBox()
                  :_iconText(()=> Navigator.of(context).push(MaterialPageRoute(builder:(context)=> SupplierOrdesr())), Icons.local_offer_outlined, AppLocalizations.of(context)!.translate('SupplierOrders')),
                  _iconText(()=> guestType ? guestDialog() : Navigator.of(context).push(MaterialPageRoute(builder:(context)=> NotificationScreen())), Icons.bookmark_outline, AppLocalizations.of(context)!.translate('My Orders')),
                  driver(),
                  _iconText(()=>changePassword(()=> _resetPass(() => _setState(), _scaffoldKey)), Icons.password_outlined, AppLocalizations.of(context)!.translate('Change Password?')),
                  _iconText(()=>_logout(), Icons.logout_outlined, AppLocalizations.of(context)!.translate('Log out')),
                  //raisedButton(1.0, AppLocalizations.of(context)!.translate('about'), () => Navigator.pushNamed(context, 'about')),
                  /*Expanded(
                  child: myFarms.isEmpty? Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),
                    child: headText(AppLocalizations.of(context)!.translate('add new chicken to appear here')),
                  ):ListView.builder(
                    itemCount: myFarms.length,
                    itemBuilder: (context, index) {
                      return serviceRow(myFarms[index],0.75,_setState);
                    },
                    addAutomaticKeepAlives: false,
                  ),
                ),*/
                ],
              ),
            ),
        ),
    );
  }

  _terms(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  TermsAndConditions(drawer: true),
        ));
  }

  _logout() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
 //   sharedPreferences.setString('email', _emailController.text);
    sharedPreferences.setString('password', '');
    sharedPreferences.setBool('isLogin', false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Sign_in(true),),
          (Route<dynamic> route) => false,
    );
  }

  changeLang(Function() _setState, int _lng) async {
    pleaseWait = true;
    _setState;
    await LocalizationService().changeLocale(_lng, context);
    pleaseWait = false;
    _setState;
  }

  changePassword(Function() restPassword) {
    if(guestType){
      guestDialog();
    }
    else{
      Widget _no(){
        return IconButton(
            onPressed: ()=> Navigator.of(context).pop(), icon: const Icon(Icons.close_outlined, color: MyColors.mainColor,));
      }
      Widget _ok(){
        return IconButton(
          onPressed: ()=> {
            Navigator.of(context).pop(),
            restPassword(),
          }, icon: const Icon(Icons.check, color: MyColors.mainColor,),

        );
      }

      showSDialog(AppLocalizations.of(context)!.translate('Change Your Password?'), _no(), _ok());
    }
  }

  _resetPass(Function() _setState, _scaffoldKey) async{

    _scaffoldKey.currentState!.closeDrawer();
    pleaseWait = true;
    _setState();
    var response = await MyAPI(context: context).requestResetPassword(userInfo['email']);
    if(response[0]){
      //var value = jsonDecode(x)["data"][0]["id"].toString();
      var verCode = response[1].toString();
      // final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      // sharedPreferences.setString('Id',response.body[1].toString());
      //
      // if(sharedPreferences.getString('Id') != null){
      bool sent = await MyAPI(context: context).sendEmail(AppLocalizations.of(context)!.translate('Your activation code is :') +  '\n$verCode' , AppLocalizations.of(context)!.translate('Activation Code'),  userInfo['email']);
      pleaseWait = false;
      _setState();
      if(!sent){
        return;
      }
      //_save();
      Navigator.of(context).push(MaterialPageRoute(builder:(context)=> ResetPassword(userInfo['email'], verCode: response[1].toString(),)));
    }else{
      pleaseWait = false;
      _setState();
    }
    pleaseWait = false;
    _setState();
  }

  toast(String text) {

  }

  textFiled(curve, Color containerColor,Color textColor,TextEditingController controller, hintText, icon, { height, click ,bool? number, bool? password, double? width, double? blurRaduis, bool? boxShadow, RequiredValidator? requiredValidator, String? val,bool? withoutValidator, bool? readOnly, bool? newLineAction, fontSize}){
    newLineAction??=false;
    readOnly??=false;
    withoutValidator??=false;
    requiredValidator??= RequiredValidator(errorText: AppLocalizations.of(context)!.translate('required'));
    password??= false;
    boxShadow??= false;
    number??= false;
    width??= MediaQuery.of(context).size.width/1.2;
    blurRaduis??= 5.0;
    var errorText = AppLocalizations.of(context)!.translate('Required');
    val??= '';
    if(val != '') errorText = "text didn't match";
    bool error = true;
    if(controller.text != '') error = false;
    if(val != '' && controller.text != val) error = true;
    height??=  MediaQuery.of(context).size.width/6.5;
    fontSize??= MediaQuery.of(context).size.width/25;

    if(withoutValidator) error = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              alignment: Alignment.center,
              width: width,
              height: height,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/10*0, right: MediaQuery.of(context).size.width/10*0, top: curve/2, bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
              decoration: BoxDecoration(
                color: containerColor.withOpacity(0.8),
                /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                border: Border.all(
                  color: error ? MyColors.red : boxShadow? containerColor: MyColors.card,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(curve/2),
              ),
              child: GestureDetector(
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      obscureText: password,
                      readOnly: readOnly,
                      maxLines: password? 1: null,
                      //validator: requiredValidator,
                      //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,

                      keyboardType: password? TextInputType.visiblePassword: number?  TextInputType.number : newLineAction? TextInputType.multiline: TextInputType.text,
                      controller: controller,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          fontFamily: lng==2?'GESS':'Gotham'),
                      textInputAction: newLineAction? TextInputAction.newline : TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,

                        //labelText: titleText,
                        hintText: hintText,
                        hintStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/28,
                            color: textColor.withOpacity(0.5),
                            fontFamily: 'GothamLight'),
                        errorStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/2400,
                        ),
                      ),

                    ),),
                    icon != null?
                    IconButton(
                      icon: Icon(icon, color: textColor,),
                      onPressed: ()=> click(),
                    ): SizedBox(),
                  ],
                ),
                onTap: ()=>{
                  if(readOnly == true){
                    click(),
                  }else null
                },
              ),

          ),
          error? bodyText2(errorText): const SizedBox(height: 0,),
        ],
      )
      ;
  }

  ProfiletextFiled(curve, Color containerColor, textColor,TextEditingController controller, {click ,bool? number, bool? password, double? width, double? blurRaduis, bool? boxShadow, RequiredValidator? requiredValidator, String? val,bool? withoutValidator, bool? readOnly}){
    readOnly??=false;
    number??= false;
    width??= MediaQuery.of(context).size.width/1.2;
    blurRaduis??= 5.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(curve/2), topLeft: Radius.circular(curve/2)),
            child: Container(
                alignment: Alignment.center,
                width: width,
                height: MediaQuery.of(context).size.width/6.5,
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, right: MediaQuery.of(context).size.width/10, top: 0),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                decoration: BoxDecoration(
                  color: containerColor.withOpacity(0.8),
                  /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                  border: Border.all(
                    color: containerColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(curve/2), topLeft: Radius.circular(curve/2)),
                ),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      readOnly: readOnly,
                      //validator: requiredValidator,
                      //autovalidateMode: requiredValidator.errorText == ''? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
                      keyboardType: number? const TextInputType.numberWithOptions() : TextInputType.text,
                      controller: controller,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/25,
                          color: textColor,
                          fontFamily: lng==2?'GESS':'Gotham'),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        //labelText: titleText,
                        errorStyle: TextStyle(fontSize: MediaQuery.of(context).size.width/2400,),
                      ),

                    ),),
                  ],
                )
            ),
          ),
          Container(
            width: width,
            height: MediaQuery.of(context).size.height/150,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, right: MediaQuery.of(context).size.width/10, top: 0, bottom: curve),
            color: !readOnly? MyColors.mainColor: containerColor,
          )
        ],
      )
      ;
  }

  listTextFiled(curve, controller, Function() pressIcon, containerColor, textColor, hintText, iconColor, {width, bool? boxShadow, bool? withOutValidate}){
    withOutValidate??=true;
    width??= MediaQuery.of(context).size.width/1.6;
    boxShadow??=false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textFiled(curve, containerColor, textColor, controller, hintText, Icons.search, width: width, blurRaduis: 0, boxShadow: true, withoutValidator: withOutValidate, readOnly: true),
        SizedBox(width: MediaQuery.of(context).size.width/50,),
        iconButton(MediaQuery.of(context).size.height/35, 'assets/images/filter.svg', () => pressIcon(), curve: curve, color: containerColor, iconColor: iconColor),
      ],
    );

  }

  raisedButton(double curve, double width, String text, icon, click,{double? iconHight, height, color, borderSide, container}) {
    height??= MediaQuery.of(context).size.width/6.5;
    iconHight??=height/1.9;
    color??= MyColors.mainColor;
    borderSide??= color;
    container??= false ;
    return ElevatedButton(
            style: ElevatedButton.styleFrom(
              //color: MyColors.yellow,
                minimumSize: Size(width, height),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(curve/2),
                side: BorderSide(color: borderSide),
              ),
              padding: EdgeInsets.symmetric(vertical: curve/3*0, horizontal: curve/2),
              primary: color,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon == null? const SizedBox(width: 0,) :SvgPicture.asset(icon, height: iconHight,/* color: MyColors.white,*/),
                SizedBox(width: icon == null? 0 :curve/2,),
                Text(text, style: TextStyle(
                  color: MyColors.buttonText,
                  fontSize: min(width/6.5, MediaQuery.of(context).size.width/22),
                  fontFamily: lng==2?'GESS':'Gotham',
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            onPressed: click,
          );
  }

  copyLangButton(double curve, double width, String text, Function() _setState,{double? iconHight, height, color, borderSide, container}) {
    height??= MediaQuery.of(context).size.width/9;
    iconHight??=height/1.9;
    color??= MyColors.mainColor;
    borderSide??= color;
    container??= false ;

    return
       ButtonTheme(
         padding: EdgeInsets.all(0.0),
        minWidth: width,
        height: height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(curve/2),
                side: BorderSide(color: borderSide),
              ),
              padding: EdgeInsets.symmetric(vertical: curve/3*0, horizontal: curve/2),
              primary: color,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.language_outlined, size: iconHight, color: MyColors.white,),
                SizedBox(width: curve/2,),
                Text(text, style: TextStyle(
                  color: MyColors.buttonText,
                  fontSize: min(width/6.5, MediaQuery.of(context).size.width/22),
                  fontFamily: lng==2?'GESS':'Gotham',
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            onPressed: ()=> changeLang(() => _setState, lng == 0?2:0),
          ),
      )
      ;
  }

  iconButton(double height, icon, Function() click, {width, double? curve, color, iconColor}) {
    width??= height;
    curve??= 0.0;
    color??= MyColors.black;
    iconColor??= MyColors.white;
    return Padding(padding: EdgeInsets.only(top: curve, bottom: 0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width/6.7,
        padding: EdgeInsets.symmetric(vertical: height/3, horizontal: height/3),
        height: MediaQuery.of(context).size.width/6.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width/6.5, MediaQuery.of(context).size.width/6.7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height/2)
            ),
            primary: color,
          ),
        child: SvgPicture.asset(icon, height: height, width: height, fit: BoxFit.contain, color: iconColor,),
        onPressed: () {
          click();
        },
      ),
    ),
    )
      ;
  }

  iconText(assets, text, color, {double? scale,double? imageScale, bool? vertical, paddingH, revers, Function()? click}){
    scale??=1;
    scale= scale*1.1;
    imageScale??=1;
    vertical??= false;
    paddingH??= MediaQuery.of(context).size.width/20;
    paddingH *= scale;
    revers??= false;
    if(!vertical) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: MediaQuery.of(context).size.height/100*0),
        child: !revers?
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
        //textDirection: TextDirection.rtl,
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: ()=> click!(),
              child: SvgPicture.asset(assets ,height: MediaQuery.of(context).size.width/13*scale* imageScale, fit: BoxFit.contain,),
            ),
            SizedBox(width: MediaQuery.of(context).size.width/40*scale*scale*scale*scale,),
            bodyText1(text, scale: 0.8*scale, padding: 0.0, maxLine: 2)
          ],
        ):
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //textDirection: TextDirection.rtl,
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headText(text, scale: 0.4 * scale, paddingV: 0.0, color: color),
            SizedBox(width: MediaQuery.of(context).size.width/80*scale,),
            SvgPicture.asset(assets ,height: MediaQuery.of(context).size.width/22*scale* imageScale, fit: BoxFit.cover,),
          ],
        )
        ,
      );
    } else{
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingH,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //textDirection: TextDirection.rtl,
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(assets ,height: MediaQuery.of(context).size.width/20*scale * imageScale, fit: BoxFit.contain,),
            SizedBox(width: MediaQuery.of(context).size.height/80*scale,),
            headText(text, scale: 0.5*scale, color: color, paddingV: MediaQuery.of(context).size.width/40, maxLine: 1),
          ],
        ),
      );
    }
  }

  _navigateFarmList(farms){
    /*if(farms.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FarmList(farms[0]['Type']),),);
    } else {
      toast(AppLocalizations.of(context)!.translate('first add new farm'));
    }*/
  }

  dialog(text) async{
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(text, textAlign: TextAlign.right,
                style: const TextStyle(color: MyColors.bodyText1, fontSize: 18),),
              /*actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context)!.translate('no'),
                    style: const TextStyle(color: MyColors.mainColor, fontSize: 18),),
                  onPressed: () {
                    Navigator.of(context).pop;
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context)!.translate('yesExit'),
                    style: const TextStyle(color: MyColors.mainColor, fontSize: 18),),
                  onPressed: (){
                    Navigator.of(context).pop;
                  },
                ),
              ],*/
            );
          }
      );
      return value == true;
  }

  bottomContainer(_child, curve, {bottomConRati,}){
    bottomConRati??= bottomConRatio;
    if(bottomConRati == 0.0) {
      return const SizedBox(height: 0,);
    } else {
      return Container(
      padding: EdgeInsets.symmetric(horizontal: curve),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * bottomConRati,
      width: double.infinity,
      //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
      decoration: BoxDecoration(
          color: MyColors.bottomCon,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
         ),
      child: _child,

    );
    }
  }

  mainChildrenBottomContainer(curve, Function() clickT1, Function() clickT2, Function() clickT3, tapNumber){

    return ToggleSwitch(
      radiusStyle: true,
      animate: true,
      curve: Curves.fastOutSlowIn,
      minWidth: MediaQuery.of(context).size.width/2.4,
      fontSize: MediaQuery.of(context).size.width/20,
      iconSize: MediaQuery.of(context).size.width/13,
      initialLabelIndex: tapNumber-1,
      cornerRadius: 20.0,
      activeFgColor: Colors.white,
      inactiveBgColor: MyColors.bottomCon,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: [tapNumber == 1? AppLocalizations.of(context)!.translate('HOME'): '',tapNumber==2? AppLocalizations.of(context)!.translate('Profile'): ''],
      icons: const [Icons.home_outlined,  Icons.person_outline],
      activeBgColors: const [[MyColors.mainColor],[MyColors.mainColor]],
      onToggle: (index) {
        if(index==0){
          clickT1();
        }
        if(index==1){
          clickT2();
        }
        print('switched to: $index');
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: tapNumber == 1 ? raisedButton(curve, MediaQuery.of(context).size.width / 4,
              AppLocalizations.of(context)!.translate('HOME'),
              'assets/images/home.svg', () => clickT1(),
              //iconHight: MediaQuery.of(context).size.height / 18,
              height: MediaQuery.of(context).size.width/10
          ): GestureDetector(
            child: SvgPicture.asset('assets/images/home.svg'),
            onTap: ()=> clickT1(),
          ),
        ),
        Expanded(
          flex: 1,
          child: tapNumber == 2 ? raisedButton(curve, MediaQuery.of(context).size.width / 4,
              '',
              'assets/images/true_bag.svg', () => clickT2(),
              height: MediaQuery.of(context).size.width / 10):
          GestureDetector(
            child: SvgPicture.asset('assets/images/true_bag.svg'),
            onTap: ()=> clickT2(),
          ),
        ),
        Expanded(
          flex: 1,
          child: tapNumber == 3 ? raisedButton(curve, MediaQuery.of(context).size.width / 4,
              '',
              'assets/images/user_profile.svg', () => clickT3(),
              height: MediaQuery.of(context).size.width / 10):
              GestureDetector(
                child: SvgPicture.asset('assets/images/user_profile.svg'),
                onTap: ()=> clickT3(),
              ),
        ),
      ],
    );
  }

  cardMaterial(curve, height, _starRate, bool favorait, materialName, materialType, _salePrice, price, Function() _select){
    var width = height*0.63-4;
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: MyColors.card,
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
        color: MyColors.white,
        borderRadius: BorderRadius.all(Radius.circular(curve),),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: curve/2, vertical: curve/2),
                  height: height/5*3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MyColors.white,
                        MyColors.metal,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          miniContainer(iconText('assets/images/star.svg', _starRate, MyColors.white, revers: true, paddingH: 0.0, scale: 0.8), MediaQuery.of(context).size.height/35),
                          const Expanded(
                            child: Align(

                            ),
                          ),
                          favorait? SvgPicture.asset('assets/images/heart_red.svg', color: MyColors.mainColor, height: curve,):SvgPicture.asset('assets/images/heart.svg', color: MyColors.black,)

                        ],
                      ),
                      Expanded(child: SvgPicture.asset('assets/images/group2.svg'))
                    ],
                  ),
                ),
                //SizedBox(height: curve/2+1,),
                Container(
                  padding: EdgeInsets.only(left: curve/2, right: curve/2, top: curve, bottom: curve/2,),
                  height: height/5*2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                          child: bodyText1(materialName,scale: 0.7,color: MyColors.mainColor, padding: 0.0, align: TextAlign.start),
                      ),
                      Expanded(
                        flex: 3,
                          child: Align(alignment: Alignment.centerLeft,
                            child: bodyText1(materialType,scale: 0.5, padding: 0.0, align: TextAlign.start),
                          )
                      ),
                      //SizedBox(height: curve/4,),
                      Expanded(
                        flex: 2,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                headText('\$' + _salePrice.toString(),scale: 0.5),
                                bodyText1('\$' + price.toString(),scale: 0.6, padding: MediaQuery.of(context).size.width/60, align: TextAlign.start, baseLine: true),
                              ],
                            ),
                          )
                      ),


                    ],
                  ),
                ),
              ],
            )
          ),
          Align(
           alignment: Alignment.centerRight,
           child: Padding(
             padding: EdgeInsets.symmetric(horizontal: curve/2),
             child: iconButton(curve, 'assets/images/shopping_cart_add.svg', () => _select(), curve: height/5, color: MyColors.mainColor,),
           )
         ),
        ],
      ),
    );
  }

  miniContainer(_child, height){
    var curve = height / 4;
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
      decoration: BoxDecoration(
        color: MyColors.gray,
        borderRadius: BorderRadius.all(Radius.circular(curve)),
      ),
      child: _child,
    );
  }

  progress(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), fit: BoxFit.cover, opacity: 0.7)),
      //color: MyColors.red,
      child: GradientProgressIndicator(
        radius: MediaQuery.of(context).size.width/4,
        duration: 3,
        strokeWidth: 12,// MediaQuery.of(context).size.width/40,
        gradientStops: const [
          0.2,
          0.8,
        ],
        gradientColors: const [
          Color(0xffE50019),
          Color(0xff6E000F),
        ],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            JumpingText(AppLocalizations.of(context)!.translate('please Wait...'),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/22,
                color: MyColors.mainColor,
                fontFamily: 'Gotham',
             // fontStyle: FontStyle.italic,
            ),
            ),
          ],
        ),
      ),
    );
  }

  starRow(raduis, _starNum, {marginLeft}){
    marginLeft??=raduis*1.1;
    return Container(
      margin: EdgeInsets.only(left: marginLeft),
      padding: EdgeInsets.symmetric(horizontal: raduis/16*0, vertical: raduis/30),
      width: raduis/5*5.7,
      //alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_starNum < 1 ? Icons.star_outline : _starNum >= 2  ? Icons.star: Icons.star_half,color:  MyColors.white,/*: MyColors.gray,*/ size: raduis/5,),
          Icon(_starNum < 3 ? Icons.star_outline : _starNum >= 4  ? Icons.star: Icons.star_half,color:  MyColors.white,/*: MyColors.gray,*/ size: raduis/5,),
          Icon(_starNum < 5 ? Icons.star_outline : _starNum >= 6  ? Icons.star: Icons.star_half,color:  MyColors.white,/*: MyColors.gray,*/ size: raduis/5,),
          Icon(_starNum < 7 ? Icons.star_outline : _starNum >= 8  ? Icons.star: Icons.star_half,color:  MyColors.white,/*: MyColors.gray,*/ size: raduis/5,),
          Icon(_starNum < 9 ? Icons.star_outline : _starNum >= 10 ? Icons.star: Icons.star_half,color:  MyColors.white,/*: MyColors.gray,*/ size: raduis/5,),
        ],
      ),
      decoration: BoxDecoration(
        color: MyColors.mainColor,
        borderRadius: BorderRadius.circular(raduis/7),
      ),
    );
  }

  userInfoProfile(_topBar, hSpace, curve, Function() setState){
    nameController.text = userInfo['name'];
    mobileController.text = userInfo['mobile']; //userInfo['mobile'];
    cityController.text = userInfo['city']['name']; //userInfo['city'];
    _selectImageProfile() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30, maxWidth: 2000, maxHeight: 2000);
      path = xFile!.path;
      print(path);
      image = FileImage(File(path!));
      setState();
    }
    _save()async{
      pleaseWait = true;
      setState();
      await MyAPI(context:context).updateProfile();
      editProfile = false;
      pleaseWait = false;
      setState();
    }
    _edit(){
      editProfile = !editProfile;
      setState();
    }
    return Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topBar,
          Expanded(
            child: ListView(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.height/1000),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    logoContainer(userInfo['imagePath'] == 'https://automallonline.info//ProfilesFiles/${userInfo["id"]} ' ? null : userInfo['imagePath'], MediaQuery.of(context).size.width/2.5, isPicker : true),
                    /*CircleAvatar(
                      backgroundImage: image == null ? (userInfo['imagePath'] == 'https://automallonline.info//ProfilesFiles/${userInfo["id"]} ' ? const AssetImage('assets/images/profile.png') as ImageProvider
                          : NetworkImage(userInfo['imagePath'])) : image as ImageProvider,
                      radius: MediaQuery.of(context).size.width/5,
                    ),*/
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          headText(userInfo['name'], paddingV: MediaQuery.of(context).size.height/60*0, align: TextAlign.start, paddingH: MediaQuery.of(context).size.width/20, maxLine:1),
                          bodyText1(userInfo['email'], align: TextAlign.start, padV: MediaQuery.of(context).size.height/80),
                          const Expanded(child: SizedBox()),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => _selectImageProfile(),
                                  icon: Icon(Icons.add_a_photo_outlined, size: MediaQuery.of(context).size.width/15,)),

                              const Expanded(child: SizedBox()),
                              raisedButton(curve*2, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Save'), null, ()=> _save(), height: MediaQuery.of(context).size.width/10),
                            ],
                          )
                          //iconButton(hSpace, 'assets/images/user.svg', () => _selectImageProfile())
                        ],
                      ),
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/5*2,
                    )
                  ],
                ),
              ),
              SizedBox(height: hSpace/2,),
              Row(
                children: [
                  bodyText1(AppLocalizations.of(context)!.translate('Personal information'), align: TextAlign.start, padV: hSpace/4, scale: 1.2),
                  const Expanded(child: SizedBox()),
                  IconButton(
                      onPressed: () => _edit(),
                      icon: Icon(editProfile?Icons.edit_off_outlined :Icons.edit_outlined, size: MediaQuery.of(context).size.width/15,)),
                  SizedBox(width: MediaQuery.of(context).size.width/20,),
                ],
              ),
              bodyText1(AppLocalizations.of(context)!.translate('Full Name'), align: TextAlign.start, padding: MediaQuery.of(context).size.width/10,padV: hSpace/7),
              ProfiletextFiled(curve, MyColors.white, MyColors.black, nameController, readOnly: !editProfile),
              bodyText1(AppLocalizations.of(context)!.translate('Mobile'), align: TextAlign.start, padding: MediaQuery.of(context).size.width/10,padV: hSpace/7),
              ProfiletextFiled(curve, MyColors.white, MyColors.black, mobileController, readOnly: true),
              bodyText1(AppLocalizations.of(context)!.translate('City'), align: TextAlign.start, padding: MediaQuery.of(context).size.width/10,padV: hSpace/7),
              ProfiletextFiled(curve, MyColors.white, MyColors.black, cityController, readOnly: true),
            ],),
          ),
        ],
    );
  }

  showImage(src){
    showImageViewer(
        context, src
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  pickFileAsBase64String() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'png'],
      type: FileType.custom
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      final bytes = await File(file.path!).readAsBytesSync();
      String vbase= await base64Encode(bytes);
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      if(file.extension == 'pdf') await createPdf(vbase.toString());
      return {'base':vbase.toString(), 'name': file.path.toString().split('/').last};
    } else {
      // User canceled the picker
      return null;
    }
  }

  cardOffers(curve, {logo, toolImage, disacount, toolName, companyName, scale}){
    var raduis = MediaQuery.of(context).size.width/13;
    disacount??= '40';
    toolName??= 'motors and vans';
    companyName??= 'Hasan engineering';
    scale??=1.0;
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: curve*6.2*scale,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(top: raduis*4/3,left: raduis/4, right: raduis/4),
                /*child: CircleAvatar(
                  child: headText(disacount.toString() + '%', color: MyColors.white, scale: 0.6),
                  radius: curve,
                  backgroundColor: MyColors.mainColor,
                ),*/
                decoration: BoxDecoration(
                    image: DecorationImage(image: toolImage == null || toolImage == ''? AssetImage("assets/images/background.png") : NetworkImage(toolImage) as ImageProvider, fit: BoxFit.contain),
                  //color: containerColor.withOpacity(0.8),
                  /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                  border: Border.all(
                    color: MyColors.mainColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(curve*scale/2),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundImage: logo.toString().endsWith(' ')
                    ? const AssetImage('assets/images/Logo1.png') as ImageProvider
                    : NetworkImage(logo),
                child: ClipOval(
                  child: logo == null
                      ? Image.asset('assets/images/Logo1.png')
                      : Image.network(logo, width: raduis*2, height: raduis*2, fit: BoxFit.cover,),
                ),
                radius: raduis,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
        headText(toolName /*+ AppLocalizations.of(context)!.translate(' Kit ') + disacount.toString() + ' % ' + AppLocalizations.of(context)!.translate('OFF')*/,scale: 0.45*scale, maxLine: 2, paddingV: MediaQuery.of(context).size.height/100, paddingH: raduis/4),
        bodyText1(companyName.toString(),color: MyColors.red, scale: scale),
      ],
    )
      ;

  }

  cardExhibtion(curve, {exhibtionLogo, toolImage, disacount, toolName, companyName, scale, required Function() click}){
    var raduis = MediaQuery.of(context).size.width/13;
    disacount??= '40';
    toolName??= 'motors and vans';
    companyName??= 'Hasan engineering';
    scale??=1.0;
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                //alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(top: raduis/3,left: raduis/4, right: raduis/4),
                padding: EdgeInsets.only(top:curve/2),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: exhibtionLogo.toString().endsWith(' ')
                          ? const AssetImage('assets/images/Logo1.png') as ImageProvider
                          : NetworkImage(exhibtionLogo),
                      child: ClipOval(
                        child: exhibtionLogo == null
                            ? Image.asset('assets/images/Logo1.png')
                            : Image.network(exhibtionLogo, width: raduis*2, height: raduis*2, fit: BoxFit.cover,),
                      ),
                      radius: raduis,
                      backgroundColor: Colors.transparent,
                    ),
                    headText(companyName.toString(),color: MyColors.black, scale: scale*0.6, maxLine: 2, paddingV: MediaQuery.of(context).size.height/80,),
                    headText(toolName /*+ AppLocalizations.of(context)!.translate(' Kit ') + disacount.toString() + ' % ' + AppLocalizations.of(context)!.translate('OFF')*/,scale: 0.45*scale, maxLine: 2,  paddingH: raduis/4, color: MyColors.bodyText1),
                    SizedBox(height: curve/4,),
                    SizedBox(width: MediaQuery.of(context).size.width/4,
                    child: raisedButton(curve, MediaQuery.of(context).size.width/4.5, AppLocalizations.of(context)!.translate('Visit'), 'assets/images/ic_street_view.svg', ()=>click(), iconHight: curve/1.4 ,height: MediaQuery.of(context).size.height/16),
                    ),
                    SizedBox(height: curve/4,),
                  ],
                ),
                decoration: BoxDecoration(
                  /*image: DecorationImage(image: toolImage == null || toolImage == ''? AssetImage("assets/images/background.png") : NetworkImage(toolImage) as ImageProvider, fit: BoxFit.contain),*/
                  color: MyColors.white,
                  //color: containerColor.withOpacity(0.8),
                  /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                  border: Border.all(
                    color: MyColors.white,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(curve*scale),
                ),
              ),
            ),

          ],
        ),
      ],
    )
    ;
  }

  cardRent(curve, {Function()? open, logo, toolImage, disacount, toolName, companyName, scale, phone, message}){
    var raduis = MediaQuery.of(context).size.width/20;
    disacount??= '40';
    toolName??= 'motors and vans';
    companyName??= 'Hasan engineering';
    scale??=1.0;
    return Container(
      margin: EdgeInsets.only(top: raduis*4/3,left: raduis, right: raduis),
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
        color: MyColors.white
      ),
      child: Column(
        children: [
          Container(
              height: curve*3*scale,
              alignment: Alignment.bottomRight,
              //margin: EdgeInsets.only(top: raduis*4/3,left: raduis/4, right: raduis/4),
              /*child: CircleAvatar(
                  child: headText(disacount.toString() + '%', color: MyColors.white, scale: 0.6),
                  radius: curve,
                  backgroundColor: MyColors.mainColor,
                ),*/
              decoration: BoxDecoration(
                image: DecorationImage(image: toolImage == null || toolImage == ''? AssetImage("assets/images/background.png") : NetworkImage(toolImage) as ImageProvider, fit: BoxFit.cover),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
            child: Row(
              children: [
                headText(companyName ,scale: 0.7*scale, maxLine: 2, paddingV: MediaQuery.of(context).size.height/100, paddingH: raduis/4),
                Expanded(child: Center()),
                IconButton(
                    onPressed: ()=> launchWhatsApp(phone: phone, message: message, context: context),
                    icon: SvgPicture.asset('assets/images/whatsapp.svg'),
                ),
                IconButton(
                    onPressed: ()=> open!(),
                    icon: SvgPicture.asset('assets/images/eyeCircle.svg'),
                ),
              ],
            ),
          ),
          SizedBox(height: curve/2,),
          // bodyText1(companyName.toString(),color: MyColors.red, scale: scale),
        ],
      ),
    );
  }

  cardRentDetails(curve, {logo, toolImage, disacount, toolName, companyName, scale, phone, message}){
    var raduis = MediaQuery.of(context).size.width/20;
    disacount??= '40';
    toolName??= 'motors and vans';
    companyName??= 'Hasan engineering';
    scale??=1.0;
    return Container(
      //height: MediaQuery.of(context).size.height/7*scale,
      margin: EdgeInsets.only(top: raduis*4/3,left: raduis, right: raduis),
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.white,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          color: MyColors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         // SizedBox(height: curve/2,),
          headText(companyName ,scale: 0.8*scale, maxLine: 2, paddingV: curve/2, paddingH: raduis/1),
          Container(
              height: curve*14*scale,
              alignment: Alignment.bottomRight,
              //margin: EdgeInsets.only(top: raduis*4/3,left: raduis/4, right: raduis/4),
              /*child: CircleAvatar(
                  child: headText(disacount.toString() + '%', color: MyColors.white, scale: 0.6),
                  radius: curve,
                  backgroundColor: MyColors.mainColor,
                ),*/
              decoration: BoxDecoration(
                image: DecorationImage(image: toolImage == null || toolImage == ''? AssetImage("assets/images/background.png") : NetworkImage(toolImage) as ImageProvider, fit: BoxFit.contain),
              ),
            ),
          SizedBox(height: curve/2,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
            child:
            raisedButton(curve, MediaQuery.of(context).size.width/1.3, AppLocalizations.of(context)!.translate('Call Via Phone'), 'assets/images/phone.svg', ()=> launchPhone(phone: phone, context: context)),
          ),
          SizedBox(height: curve/2,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
            child: raisedButton(curve, MediaQuery.of(context).size.width/1.3, AppLocalizations.of(context)!.translate('Connect With Whatsapp'), 'assets/images/whatsapp.svg', ()=> launchWhatsApp(phone: phone, message: message, context: context), color: MyColors.green)
          ),

          SizedBox(height: curve/2,)

         // bodyText1(companyName.toString(),color: MyColors.red, scale: scale),
        ],
      ),
    );
  }

  createPdf(base64String) async {
    var bytes = base64Decode(base64String.replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/lastOpenedOffer.pdf");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    doc = await PDFDocument.fromFile(file);
    //return file;
  }

  String getBase64FileType(String base64String) {
    print('ccc');
    switch (base64String.characters.first) {
      case '/':
      //return 'jpeg';
        return _typeImage;
      case 'i':
      //return 'png';
        return _typeImage;
      case 'R':
      //return 'gif';
        return _typeImage;
      case 'U':
        return 'webp';
      case 'J':
      //return 'pdf';
        return _typePdf;
      default:
        return 'unknown';
    }
  }

  static const _typeImage = 'image';
  static const _typePdf = 'pdf';

  viewFileBase64(base64String) {
    widget(String type){
      switch (type) {
        case _typeImage:{
          var src = Image.memory(base64Decode(base64String),fit: BoxFit.cover,);
          return Container( width: double.infinity,child: src,);
        }
        case _typePdf:{
          return Center(child: PDFViewer(document: doc));
        }
      }
    }
    return widget(getBase64FileType(base64String));
  }

  getFile(httpString) async{
    var type = _typeImage;
    if(!httpString.toString().toLowerCase().contains('http')) return;
    switch (httpString.toString().split('.').last) {
      case 'jpeg':
      case 'jpg':
        type = _typeImage;
        break;
      case 'png':
        type = _typeImage;
        break;
      case 'gif':
        type = _typeImage;
        break;
      case 'pdf':{
        type = _typePdf;
        try{
          doc = await PDFDocument.fromURL(httpString);
        }catch(e){
          print(e.toString());
          MyAPI(context: context).flushBar(e.toString());
          return;
        }
      }
      break;
      default:
        type = 'unknown';
    }
  }
  viewFile(httpString){
    if(httpString == 'null'|| httpString == '') return SizedBox();
    var type = _typeImage;
    switch (httpString.toString().split('.').last) {
      case 'jpeg':
      case 'jpg':
        type = _typeImage;
        break;
      case 'png':
        type = _typeImage;
        break;
      case 'gif':
        type = _typeImage;
        break;
      case 'pdf':{
        type = _typePdf;
      }
      break;
      default:
        type = 'unknown';
    }
    _open(){
      switch (type) {
        case _typeImage:{
          var src = Image.network(httpString).image;
          showImage(src);
          return;
        }
        case _typePdf:{
          // Load from URL
          //doc = await PDFDocument.fromURL('https://www.ecma-international.org/wp-content/uploads/ECMA-262_12th_edition_june_2021.pdf');
          Navigator.of(context).restorablePush(_dialogBuilder);
          return;
        }
      }
    }
    widget(String type) {
      switch (type) {
        case _typeImage:{
          return  Image.network(httpString,fit: BoxFit.cover,);
        }
        case _typePdf:{
          try{
            print(doc.count.toString());
            if(httpString.toString().toLowerCase().contains('http')) return Center(child: PDFViewer(document: doc));
          }catch(e){
            print(e.toString());
            return SizedBox();
          }
        }
      }
    }
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width/1.3,
        height: MediaQuery.of(context).size.width/2,
        child: widget(type),
      ),
      onTap: ()=> _open(),
    );
  }

  showNetworkFile(httpString) async{
    var type = _typeImage;
    switch (httpString.toString().split('.').last) {
      case 'jpeg':
      case 'jpg':
        type = _typeImage;
        break;
      case 'png':
        type = _typeImage;
        break;
      case 'gif':
        type = _typeImage;
        break;
      case 'pdf':
        type = _typePdf;
        break;
      default:
        type = 'unknown';
    }
    switch (type) {
        case _typeImage:{
          var src = Image.network(httpString).image;
          showImage(src);
          return;
        }
        case _typePdf:{
          // Load from URL
          //doc = await PDFDocument.fromURL('https://www.ecma-international.org/wp-content/uploads/ECMA-262_12th_edition_june_2021.pdf');
          try{
            doc = await PDFDocument.fromURL(httpString);
          }catch(e){
            print(e.toString());
            MyAPI(context: context).flushBar(e.toString());
            return;
          }
          Navigator.of(context).restorablePush(_dialogBuilder);
          return;
        }
    }
  }

  static Route<Object?>  _dialogBuilder(BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
          Dialog(child: PDFViewer(document: doc)),
    );
  }

  logoContainer(logo, width, {isSupp, isPicker}){
    isSupp??= false;
    isPicker??= false;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: image == null || !isPicker? (logo == null ? (!isSupp ? AssetImage('assets/images/profile.png') : AssetImage('assets/images/Logo1.png')) as ImageProvider
              : NetworkImage(logo)) : image as ImageProvider,
        ),
        //color: MyColors.white,
        border: Border.all(color: MyColors.metal, width: width/50),
        borderRadius: BorderRadius.all(Radius.circular(width/5)),
      ),
      height: width,
      width: width,
      //padding: EdgeInsets.all(width/20),
/*      child: logo == null && isSupp && image == null? Image.asset('assets/images/Logo1.png', height: width - width/20, width: width- width/20,)
          : logo == null && !isSupp && image == null? Image.asset('assets/images/profile.png', height: width- width/20, width: width- width/20,)
          //: logo == null && image != null? Image.file(image!., height: width- width/20, width: width- width/20,)
        : Image.network(logo.toString(),height: width, width: width, fit: BoxFit.contain,),*/
    );
  }

  lableValue(_lable, _value){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: headText(_lable, scale: 0.45, align: TextAlign.start),
              ),
              Flexible(
                flex: 7,
                child: bodyText1(_value, scale: 1, maxLine: 111, padding: 0.0),
              ),
            ],
          ),
          driver(color: MyColors.metal, padH: 0.0),
        ],
      ),
    )
      ;
  }

  getGategoryName(id){
    switch(id){
      case 0:
        return AppLocalizations.of(context)!.translate('Spare Parts');
      case 1:
        return AppLocalizations.of(context)!.translate('Garages');
      case 2:
        return AppLocalizations.of(context)!.translate('Batteries & tyres');
      case 3:
        return AppLocalizations.of(context)!.translate('Motor Service Van');
      case 4:
        return AppLocalizations.of(context)!.translate('Offers');
      case 5:
        return AppLocalizations.of(context)!.translate('Scrape Parts');
      case 6:
        return AppLocalizations.of(context)!.translate('Rent a Car');
      case 7:
        return AppLocalizations.of(context)!.translate('Breakdown Service');
      case 8:
        return AppLocalizations.of(context)!.translate('Car Modifications');
      case 9:
        return AppLocalizations.of(context)!.translate('Accessories');
      case 10:
        return AppLocalizations.of(context)!.translate('Customisation');
       case 11:
        return AppLocalizations.of(context)!.translate('Featured boards');
       case 12:
        return AppLocalizations.of(context)!.translate('exhibition');
    }

  }

  brandCard(image, hSpace, text){
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Image.network(image,
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.width / 5,
                  fit: BoxFit.contain,
                ),
              SizedBox(height: hSpace / 3,),
              headText(text, scale: 0.5,),
              SizedBox(height: hSpace / 3,),
            ]
          //color: MyColors.white,
        );
  }

  selectFromTheListDrop(/*text,*/ curve, controller, Function() press, hintText, firstOpen, _dropDown,{fontSize}){
    var width = MediaQuery.of(context).size.width/1.2;
    fontSize??= MediaQuery.of(context).size.width/25;
    return Stack(
                  children: [
                    Align(
                      child: textFiled(curve/2, MyColors.white, MyColors.black, controller, hintText, Icons.keyboard_arrow_down_outlined, width: width, withoutValidator: firstOpen, readOnly: true, click: ()=> press(), fontSize: fontSize, height: MediaQuery.of(context).size.width/8,),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: curve/2, right: curve /*MediaQuery.of(context).size.width/6.5 + MediaQuery.of(context).size.width/50*/, left: curve,),
                        //padding: EdgeInsets.all(0.0),
                        child: _dropDown,
                      ),
                    )
                  ],
                );
  }

  networkImage(netImage, width, {crossAlign, mainAlign, height}){
    crossAlign??=CrossAxisAlignment.start;
    mainAlign??=MainAxisAlignment.center;
    height ??= width;
    if(netImage.toString().isNotEmpty) {
      return Column(
          mainAxisAlignment: mainAlign,
          crossAxisAlignment: crossAlign,
          children: [
      ClipRRect(
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/20),
    child:
    Image.network(netImage,
              width: width,
              height: height,
              fit: BoxFit.fitWidth,),
            )
          ],
        )
     ;
    } else{
      return
        Column(
        mainAxisAlignment: mainAlign,
        crossAxisAlignment: crossAlign,
        children: [
          Image.asset('assets/images/Logo1.png',
            width: width,
            //height: MediaQuery.of(context).size.width / 5,
            fit: BoxFit.cover,
          )
        ],
      );
    }
      }

  carSellerHCard(mainImage, brandImage, typeName, model, kelometrag, cylenders, price, gearBox, productionYear, view, fromUser, isNew){
   var vSpace = MediaQuery.of(context).size.height/70;
   var hSpace = MediaQuery.of(context).size.width/50;
   var hImages = MediaQuery.of(context).size.width/12;
   var curve = MediaQuery.of(context).size.width/20;

   var scale = 0.72;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(curve/2),
            margin: EdgeInsets.only(bottom: curve, left: 2, right: 2),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.black,
                    offset: Offset(0, 0.8),
                    blurRadius: 0.8,
                  ),
                ],
                color: MyColors.white,
                borderRadius: BorderRadius.all(Radius.circular(curve))
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: networkImage(mainImage, MediaQuery.of(context).size.height / 7.8),
                          ),

                          Align(
                            alignment: lng == 2? Alignment.topLeft:Alignment.topRight,
                            child: Container(
                              padding: EdgeInsets.all(curve/4),
                              //margin: EdgeInsets.only(bottom: curve, left: 2, right: 2),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColors.black,
                                    offset: Offset(0, 0.8),
                                    blurRadius: 0.8,
                                  ),
                                ],
                                color:  isNew? MyColors.red: MyColors.gray,
                                borderRadius:lng != 2?
                                BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width/40), topLeft: Radius.circular(MediaQuery.of(context).size.width/20)):
                                BorderRadius.only(bottomLeft: Radius.circular(MediaQuery.of(context).size.width/40), topRight: Radius.circular(MediaQuery.of(context).size.width/20)),
                              ),
                              child: bodyText1(
                                  isNew?AppLocalizations.of(context)!.translate('New'):AppLocalizations.of(context)!.translate('Sold'),
                                  color: MyColors.white, padding: MediaQuery.of(context).size.width/80, scale: scale),
                              //child: Icon(Icons.open_with_outlined, color: MyColors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: hSpace,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove_red_eye_rounded, color: MyColors.bodyText1, size: MediaQuery.of(context).size.height/55, ),
                          bodyText1(view, scale: scale, padding: 0.5, padV: 2.0),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: lng == 2? 0.0: MediaQuery.of(context).size.width/40*0, right: lng == 2?  MediaQuery.of(context).size.width/40*0:0.0),
                              child: networkImage(brandImage, hImages),
                            ),

                            Column(
                              children: [
                                headText(typeName + "  " + model, scale: scale*scale, maxLine: 2,),
                                // bodyText1(model),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: hSpace/2,),
                        Container(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: [
                                    SizedBox(height: vSpace,),
                                    iconText("assets/images/ic_km.svg", kelometrag, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                    SizedBox(height: vSpace,),
                                    iconText("assets/images/gear_automatic.svg", gearBox, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                    SizedBox(height: vSpace,),
                                    iconText("assets/images/ic_pr_year.svg", productionYear, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                  ],
                                ),
                              ),

                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: [
                                    SizedBox(height: vSpace,),
                                    iconText("assets/images/ic_price.svg", price, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                    SizedBox(height: vSpace,),
                                    iconText("assets/images/ic_engine.svg", cylenders, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                    SizedBox(height: vSpace,),
                                    iconText(fromUser?"assets/images/ic_red_user.svg":"assets/images/ic-shop.svg", fromUser? AppLocalizations.of(context)!.translate('From User'): AppLocalizations.of(context)!.translate('From User'), MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          height: MediaQuery.of(context).size.width / 15 * 3 +hSpace*2,
                          width: MediaQuery.of(context).size.width / 5 * 2.8,
                        ),
                        /*   Container(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        iconText("assets/images/ic_km.svg", kelometrag, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                        SizedBox(width: MediaQuery.of(context).size.width/40,),
                        iconText("assets/images/ic_price.svg", price, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                      ],
                    ),
                    height: MediaQuery.of(context).size.width / 15,
                    width: MediaQuery.of(context).size.width / 5 * 2.7,
                  ),
                  Container(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        iconText("assets/images/gear_automatic.svg", gearBox, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                        iconText("assets/images/ic_price.svg", cylenders, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                      ],
                    ),
                    height: MediaQuery.of(context).size.width/15,
                    width: MediaQuery.of(context).size.width/5*2.7,
                  ),
                  Container(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        iconText("assets/images/ic_pr_year.svg", productionYear, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                      ],
                    ),
                    height: MediaQuery.of(context).size.width/15,
                    width: MediaQuery.of(context).size.width/5*2,
                  ),
*/
                      ],
                    ),
                  ),
                ]
              //color: MyColors.white,
            ),
          ),
        ),
        Align(
          alignment: lng == 2? Alignment.bottomLeft:Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.all(curve/4),
            margin: EdgeInsets.only(bottom: curve, left: 2, right: 2),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.black,
                    offset: Offset(0, 0.8),
                    blurRadius: 0.8,
                  ),
                ],
                color: MyColors.red,
                borderRadius:lng != 2?
                BorderRadius.only(bottomRight: Radius.circular(curve), topLeft: Radius.circular(curve/2)):
                BorderRadius.only(bottomLeft: Radius.circular(curve), topRight: Radius.circular(curve/2)),
            ),
            //child: bodyText1('text', color: MyColors.white, padding: 0.01),
            child: Icon(Icons.open_with_outlined, color: MyColors.white),

          ),
        ),
      ],
    ) ;
  }

  carSellerHCardAds(mainImage, brandImage, typeName, model, kelometrag, cylenders, price, gearBox, productionYear, view, fromUser, isNew, {required status, required id, required Function() delete, required Function() markAsSell}){
    var state = 'pending';
    switch (status){
      case 0:
        state = AppLocalizations.of(context)!.translate('Pending');
        break;
      case 1:
        state = AppLocalizations.of(context)!.translate('Accepted');
        break;
      case 2:
        state = AppLocalizations.of(context)!.translate('Special');
        break;
      case 3:
        state = AppLocalizations.of(context)!.translate('Refused');
        break;

    }
    var vSpace = MediaQuery.of(context).size.height/70;
    var hSpace = MediaQuery.of(context).size.width/50;
    var hImages = MediaQuery.of(context).size.width/12;
    var curve = MediaQuery.of(context).size.width/20;


    var scale = 0.72;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(curve/2),
            margin: EdgeInsets.only(bottom: curve, left: 2, right: 2),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.black,
                    offset: Offset(0, 0.8),
                    blurRadius: 0.8,
                  ),
                ],
                color: MyColors.white,
                borderRadius: BorderRadius.all(Radius.circular(curve))
            ),
            child: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: networkImage(mainImage, MediaQuery.of(context).size.height / 7.8),
                              ),

                              Align(
                                alignment: lng == 2? Alignment.topLeft:Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.all(curve/4),
                                  //margin: EdgeInsets.only(bottom: curve, left: 2, right: 2),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: MyColors.black,
                                        offset: Offset(0, 0.8),
                                        blurRadius: 0.8,
                                      ),
                                    ],
                                    color:  isNew? MyColors.red: MyColors.gray,
                                    borderRadius:lng != 2?
                                    BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width/40), topLeft: Radius.circular(MediaQuery.of(context).size.width/20)):
                                    BorderRadius.only(bottomLeft: Radius.circular(MediaQuery.of(context).size.width/40), topRight: Radius.circular(MediaQuery.of(context).size.width/20)),
                                  ),
                                  child: bodyText1(
                                      isNew? state : AppLocalizations.of(context)!.translate('Sold'),
                                      color: MyColors.white, padding: MediaQuery.of(context).size.width/80, scale: scale),
                                  //child: Icon(Icons.open_with_outlined, color: MyColors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: hSpace,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.remove_red_eye_rounded, color: MyColors.bodyText1, size: MediaQuery.of(context).size.height/55, ),
                              bodyText1(view, scale: scale, padding: 0.5, padV: 2.0),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: hSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: lng == 2? 0.0: MediaQuery.of(context).size.width/40*0, right: lng == 2?  MediaQuery.of(context).size.width/40*0:0.0),
                                  child: networkImage(brandImage, hImages),
                                ),

                                Column(
                                  children: [
                                    headText(typeName + "  " + model, scale: scale*scale, maxLine: 2,),
                                    // bodyText1(model),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: hSpace/2,),
                            Container(
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        SizedBox(height: vSpace,),
                                        iconText("assets/images/ic_km.svg", kelometrag, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                        SizedBox(height: vSpace,),
                                        iconText("assets/images/gear_automatic.svg", gearBox, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                        SizedBox(height: vSpace,),
                                        iconText("assets/images/ic_pr_year.svg", productionYear, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                      ],
                                    ),
                                  ),

                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        SizedBox(height: vSpace,),
                                        iconText("assets/images/ic_price.svg", price, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                        SizedBox(height: vSpace,),
                                        iconText("assets/images/ic_engine.svg", cylenders, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                        SizedBox(height: vSpace,),
                                        iconText(fromUser?"assets/images/ic_red_user.svg":"assets/images/ic-shop.svg", fromUser? AppLocalizations.of(context)!.translate('From User'): AppLocalizations.of(context)!.translate('From User'), MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              height: MediaQuery.of(context).size.width / 15 * 3 +hSpace*2,
                              width: MediaQuery.of(context).size.width / 5 * 2.8,
                            ),
                            /*   Container(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            iconText("assets/images/ic_km.svg", kelometrag, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                            SizedBox(width: MediaQuery.of(context).size.width/40,),
                            iconText("assets/images/ic_price.svg", price, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                          ],
                        ),
                        height: MediaQuery.of(context).size.width / 15,
                        width: MediaQuery.of(context).size.width / 5 * 2.7,
                      ),
                      Container(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            iconText("assets/images/gear_automatic.svg", gearBox, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                            iconText("assets/images/ic_price.svg", cylenders, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                          ],
                        ),
                        height: MediaQuery.of(context).size.width/15,
                        width: MediaQuery.of(context).size.width/5*2.7,
                      ),
                      Container(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            iconText("assets/images/ic_pr_year.svg", productionYear, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                          ],
                        ),
                        height: MediaQuery.of(context).size.width/15,
                        width: MediaQuery.of(context).size.width/5*2,
                      ),
*/
                          ],
                        ),
                      ),
                    ]
                  //color: MyColors.white,
                ),
                raisedButton(curve, 100,
                    isNew? AppLocalizations.of(context)!.translate('Mark as sell'):AppLocalizations.of(context)!.translate('Sold')
                    , null, isNew? markAsSell:null, height: MediaQuery.of(context).size.height/20)
              ],
            ),
          ),
        ),
        Align(
          alignment: lng == 2? Alignment.bottomLeft:Alignment.bottomRight,
          child: GestureDetector(
            onTap: delete,
            child: Container(
              padding: EdgeInsets.all(curve/4),
              margin: EdgeInsets.only(bottom: curve, left: 2, right: 2),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.black,
                    offset: Offset(0, 0.8),
                    blurRadius: 0.8,
                  ),
                ],
                color: MyColors.red,
                borderRadius:lng != 2?
                BorderRadius.only(bottomRight: Radius.circular(curve), topLeft: Radius.circular(curve/2)):
                BorderRadius.only(bottomLeft: Radius.circular(curve), topRight: Radius.circular(curve/2)),
              ),
              //child: bodyText1('text', color: MyColors.white, padding: 0.01),
              child: Icon(Icons.delete_forever_outlined, color: MyColors.white),

            ),
          ),
        ),
      ],
    ) ;

  }

  carSellerVCard(mainImage, brandImage, typeName, model, kelometrag, cylenders, price, gearBox, productionYear, view, fromUser,isNew){
    var vSpace = MediaQuery.of(context).size.height/100;
    var hSpace = MediaQuery.of(context).size.width/50;
    var hImages = MediaQuery.of(context).size.width/12;
    var curve = MediaQuery.of(context).size.width/20;
    var scale = 0.75;

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            //width: MediaQuery.of(context).size.width/3,
            padding: EdgeInsets.all(curve/2),
            margin: EdgeInsets.only(bottom: curve, left: MediaQuery.of(context).size.width/50, right: MediaQuery.of(context).size.width/50),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.black,
                    offset: Offset(0, 0.8),
                    blurRadius: 0.8,
                  ),
                ],
                color: MyColors.white,
                borderRadius: BorderRadius.all(Radius.circular(curve))
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: networkImage(mainImage, MediaQuery.of(context).size.width / 2.75, height: MediaQuery.of(context).size.width / 3.3),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 4.6, right: MediaQuery.of(context).size.width / 47, left: MediaQuery.of(context).size.width / 47),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: MyColors.white,),
                              Expanded(child: SizedBox()),
                              Icon(Icons.remove_red_eye_rounded, color: MyColors.white,),
                              bodyText1(view, color: MyColors.white, padding: 0.2),
                            ],
                          )
                      ),
                    ),
                    isNew?
                    Align(
                      alignment: lng == 2? Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(curve/4),
                        margin: EdgeInsets.only(bottom: curve*0, left: 2, right: 2),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: MyColors.black,
                              offset: Offset(0, 0.8),
                              blurRadius: 0.8,
                            ),
                          ],
                          color: MyColors.red,
                          borderRadius:lng != 2?
                          BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width/40), topLeft: Radius.circular(MediaQuery.of(context).size.width/20)):
                          BorderRadius.only(bottomLeft: Radius.circular(MediaQuery.of(context).size.width/40), topRight: Radius.circular(MediaQuery.of(context).size.width/20)),
                        ),
                        child: bodyText1(AppLocalizations.of(context)!.translate('New'), color: MyColors.white, padding: MediaQuery.of(context).size.width/80, scale: scale),
                        //child: Icon(Icons.open_with_outlined, color: MyColors.white),
                      ),
                    ):SizedBox()
                  ],
                ),
                SizedBox(height: vSpace/3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    networkImage(brandImage, hImages),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3.5,
                          child: headText(typeName + "  " + model, scale: scale*scale, maxLine: 2, align: TextAlign.start),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: vSpace,),
                    iconText("assets/images/ic_km.svg", kelometrag, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),
                    SizedBox(height: vSpace,),
                    iconText("assets/images/ic_pr_year.svg", productionYear, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                    SizedBox(height: vSpace,),
                    iconText("assets/images/ic_price.svg", price, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                    SizedBox(height: vSpace,),
                    iconText("assets/images/gear_automatic.svg", gearBox, MyColors.red, scale: scale, imageScale: 0.5, paddingH: 0.2),

                  ],
                )
              ],
              //color: MyColors.white,
            ),
          ),
        ),
        Align(
          alignment: lng == 2? Alignment.bottomLeft:Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.all(curve/4),
            margin: EdgeInsets.only(bottom: curve, left: MediaQuery.of(context).size.width/50, right: MediaQuery.of(context).size.width/50),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: MyColors.black,
                  offset: Offset(0, 0.8),
                  blurRadius: 0.8,
                ),
              ],
              color: MyColors.red,
              borderRadius:lng != 2?
              BorderRadius.only(bottomRight: Radius.circular(curve), topLeft: Radius.circular(curve/2)):
              BorderRadius.only(bottomLeft: Radius.circular(curve), topRight: Radius.circular(curve/2)),
            ),
            //child: bodyText1('text', color: MyColors.white, padding: 0.01),
            child: Icon(Icons.open_with_outlined, color: MyColors.white),
          ),
        ),
      ],
    )
     ;
  }

  carBroadKeyCard(keyNum, keyUser, keyPrice, keyView){
    var vSpace = MediaQuery.of(context).size.height/100;
    var hSpace = MediaQuery.of(context).size.width/50;
    var curve = MediaQuery.of(context).size.width/20;
    var scale = 0.75;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            //width: MediaQuery.of(context).size.width/3,
            padding: EdgeInsets.all(curve/2),
            margin: EdgeInsets.only(bottom: curve, left: MediaQuery.of(context).size.width/50, right: MediaQuery.of(context).size.width/50),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: MyColors.black,
                    offset: Offset(0, 0.8),
                    blurRadius: 0.8,
                  ),
                ],
                color: MyColors.white,
                borderRadius: BorderRadius.all(Radius.circular(curve))
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: vSpace*1.5,),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width/6,
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.only(bottom: curve/2, left: hSpace, right: hSpace),
                  decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(curve/1.5)),
                    border: Border.all(color: MyColors.qatarColor, width: 2),
                  ),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      Image.asset('assets/images/board_key.png', width: hSpace*3.5, height: MediaQuery.of(context).size.width/6, fit: BoxFit.cover,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          headText(AppLocalizations.of(context)!.translate('Car Panel'), paddingH: hSpace/2, scale: scale*0.85, paddingV: vSpace/3, align: TextAlign.center),
                          headText(keyNum, scale: scale*0.85, align: TextAlign.center, paddingH: hSpace/2),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: vSpace/3,),
                Expanded(child: headText(keyUser, scale: scale)),
                Row(
                  children: [
                    iconText("assets/images/ic_price.svg", keyPrice, MyColors.gray, scale: scale, imageScale: 0.5, paddingH: 0.2),
                    SizedBox(width: hSpace/2,),
                    Icon(Icons.remove_red_eye_rounded, color: MyColors.gray,size: curve/1.3,),
                    bodyText1(keyView, color: MyColors.gray, padding: 0.2, scale: scale*0.9),
                  ],
                ),
              ],
              //color: MyColors.white,
            ),
          ),
        ),
        Align(
          alignment: lng == 2? Alignment.bottomLeft:Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.all(curve/7),
            margin: EdgeInsets.only(bottom: curve, left: MediaQuery.of(context).size.width/50, right: MediaQuery.of(context).size.width/50),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: MyColors.black,
                  offset: Offset(0, 0.8),
                  blurRadius: 0.8,
                ),
              ],
              color: MyColors.red,
              borderRadius:lng != 2?
              BorderRadius.only(bottomRight: Radius.circular(curve), topLeft: Radius.circular(curve/2)):
              BorderRadius.only(bottomLeft: Radius.circular(curve), topRight: Radius.circular(curve/2)),
            ),
            //child: bodyText1('text', color: MyColors.white, padding: 0.01),
            child: Icon(Icons.open_with_outlined, color: MyColors.white),
          ),
        ),
      ],
    )
    ;
  }

  imageSlider(listImage){
    return ImageSlideshow(

      /// Width of the [ImageSlideshow].
      width: double.infinity,

      /// Height of the [ImageSlideshow].
      height: MediaQuery.of(context).size.height/3.5,

      /// The page to show when first creating the [ImageSlideshow].
      initialPage: 0,

      /// The color to paint the indicator.
      indicatorColor: MyColors.red,

      /// The color to paint behind th indicator.
      indicatorBackgroundColor: Colors.grey,

      /// The widgets to display in the [ImageSlideshow].
      /// Add the sample image file into the images folder
      children: listImage,/*[
        Image.asset(
          'images/sample_image_1.jpg',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'images/sample_image_2.jpg',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'images/sample_image_3.jpg',
          fit: BoxFit.cover,
        ),
      ],*/

      /// Called whenever the page in the center of the viewport changes.
      onPageChanged: (value) {
        print('Page changed: $value');
      },

      /// Auto scroll interval.
      /// Do not auto scroll with null or 0.
      autoPlayInterval: null,

      /// Loops back to first slide.
      isLoop: true,
    );
  }

  scrollIndicator(header, List value){
    var selectedMin = value[0];
    var selectedMax = value.last;

    var width = MediaQuery.of(context).size.width/1.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bodyText1(header),
        bodyText1(selectedMin + "->" + selectedMax),
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/400,
              width: width,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: MediaQuery.of(context).size.height/100),
              color: MyColors.card,
            ),
            Container(
              height: MediaQuery.of(context).size.height/400,
              margin: EdgeInsets.symmetric(horizontal: width, vertical: MediaQuery.of(context).size.height/100),
              color: MyColors.red,
            ),

          ],
        )
      ],
    );
  }
}
