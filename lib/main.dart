import 'dart:io';

import 'package:automall/eShop/worker/mainScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:automall/screen/SplachScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:automall/eShop/eShopMainScreen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
//import 'boxes.dart';
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
  var initializationSettingsIOs = const DarwinInitializationSettings();
  var initSetttings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
  flutterLocalNotificationsPlugin.initialize(initSetttings);
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


Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

  });

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding, );
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
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'AR'),
            Locale('fr', 'FR'),
            Locale('tr', 'TR'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale!.languageCode && supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          title: 'Auto World',
          theme: ThemeData(
            useMaterial3: false,
            primaryColor: Colors.red,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red,
            ),
          ),
          home: const SplashScreen(),
          routes: const {
          },
        );
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

