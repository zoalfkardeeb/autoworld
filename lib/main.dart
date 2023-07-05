import 'dart:io';

import 'package:automall/color/MyColors.dart';
import 'package:automall/screen/SplachScreen.dart';
import 'package:automall/screen/singnIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
//import 'boxes.dart';
import 'const.dart';
import 'localizations.dart';
//import 'model/transaction.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'model/transaction.dart';
import 'notification_ontroller.dart';
const myTask = "syncWithTheBackEnd";
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
Future onSelectNotification(String? payload) async {
  /*Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));*/
}

showNotification(channelId, channelName, id, title, body, payload) async{
  var android = AndroidNotificationDetails(
    channelId,
    channelName,
    enableVibration: true,
    importance: Importance.high,
  );
  // ignore: prefer_const_constructors
  var ios = DarwinNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: ios);
  await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platform,
      payload: payload
  );
}

showNotificationDateTime(channelId, channelName, id, title, body, payload, Duration duration) async{
  var initializationSettingsAndroid = const AndroidInitializationSettings('flutter_devs');
  var initializationSettingsIOs = DarwinInitializationSettings();
  var initSetttings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
  flutterLocalNotificationsPlugin.initialize(initSetttings,
      /*onDidReceiveNotificationResponse : onSelectNotification*/);
  //LocalNotificationService.initialize(context);
  var scheduleNotificationDateTime = DateTime.now().add(duration);
  var android = AndroidNotificationDetails(
    channelId,
    channelName,
    icon: 'flutter_devs',
    enableVibration: true,
    importance: Importance.high,
  );
  // ignore: prefer_const_constructors
  var ios =  DarwinNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: ios);
  await flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      body,
      scheduleNotificationDateTime,
      platform, payload: payload);
}
/*
void callbackDispatcher() {
// this method will be called every hour
  Workmanager().executeTask((task, inputdata) async {
    switch (task) {
      case myTask:
        print("this method was called from native!");
        //showNotificationDateTime('channelId', 'channelName', 0, 'title', 'body', 'payload', const Duration(hours: 1));
        showNotification('channelId', 'channelName', 0, 'title', 'body', 'payload');
        _backMethod();
        Fluttertoast.showToast(msg: "this method was called from native!");
        break;
      case Workmanager.iOSBackgroundTask:
        //showNotificationDateTime('channelId', 'channelName', 0, 'title', 'body', 'payload', const Duration(hours: 1));
        showNotification('channelId', 'channelName', 0, 'title', 'body', 'payload');
        _backMethod();
        print("iOS background fetch delegate ran");
        break;
    }
    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}
*/




Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  //essential for old Android versions
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  NotificationController notificationController = Get.put(NotificationController());

  await Hive.initFlutter();

  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');


  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: [SystemUiOverlay.top]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  ///forground work
  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification != null) {
      print(message.notification!.body);
      print(message.notification!.title);

    }

    //LocalNotificationService.display(message);
  });
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  FlutterNativeSplash.remove();

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    /*final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.red;
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'external_image_editor_1',
        icon: Icons.edit_rounded,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'external_image_editor_2',
        icon: Icons.edit_attributes,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));

    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
        DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75)
      ];
    };
    configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return 'Cloud dummy ocr text';
      } else {
        return 'Dummy ocr text';
      }
    };

    // Example about custom stickers
    configs.customStickerOnly = true;
    configs.customStickers = [
      'assets/icon/cus1.png',
      'assets/icon/cus2.png',
      'assets/icon/cus3.png',
      'assets/icon/cus4.png',
      'assets/icon/cus5.png'
    ];*/
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: const [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files0
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      /*When you want programmatically to change the current locale in your app, you can do it in the following way:*/
      //AppLocalizations.load(Locale('en', ''));
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'AR'),
        Locale('fr', 'FR'),
        Locale('tr', 'TR'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        //should to be in the bottom
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
      },
      title: 'Auto World',
      theme: ThemeData(
        /*textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: MediaQuery.of(context).size.width/20,
              color: MyColors.yellow,
              fontFamily: 'SegoeUI'),
          headline2: TextStyle(
              fontSize: MediaQuery.of(context).size.width/25,
              color: MyColors.yellow,
              fontFamily: 'SegoeUI'),
          bodyText1: TextStyle(
              fontSize: MediaQuery.of(context).size.width/20,
              color: MyColors.yellow,
              fontFamily: 'SegoeUI'),
          button: TextStyle(
              fontSize: MediaQuery.of(context).size.width/20,
              color: MyColors.yellow,
              fontFamily: 'SegoeUI'),
          subtitle1: TextStyle(
              fontSize: MediaQuery.of(context).size.width/20,
              color: MyColors.yellow,
              fontFamily: 'SegoeUI'),
        ),*/
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: Sign_in(false),
      routes: const {
        //'about': (context)=> about(),
      },
    );
  }
}

//essential for old Android versions
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 15
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

