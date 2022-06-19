// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wts_support_engineer/helping/appStringFile.dart';
import 'package:wts_support_engineer/routes.dart';
import 'package:wts_support_engineer/util/my_shared_preparence.dart';
import 'package:wts_support_engineer/view/screen/splash_screen.dart';

import 'helping/app_translation.dart';


//
// flutter build apk --release --no-sound-null-safety
//
// flutter build apk --split-per-abi --no-sound-null-safety
void main() async {

//  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //...........................fcm source...........................
  // https://github.com/Amanullahgit/FCM_Flutter-Notification
  String lang = (await MySharedPreference.getLanguage());
  runApp(MyApp(lang: lang));
}

class MyApp extends StatelessWidget {
  String lang;

  MyApp({this.lang});
  void fcmSubscribe() {
    FirebaseMessaging.instance.subscribeToTopic('support');
    print(
        '..........................fcmSubscribe...............................');
  }

  void fcmUnSubscribe() {
    FirebaseMessaging.instance.unsubscribeFromTopic('support');
    print(
        '..........................unsubscribeFromTopic...............................');
  }
  @override
  Widget build(BuildContext context) {
    fcmSubscribe();
    return GetMaterialApp(
      theme: new ThemeData(
          primarySwatch: Colors.green, canvasColor: Colors.white),
      // theme: new ThemeData(
      //     primarySwatch: Colors.grey,
      //     primaryTextTheme:
      //         TextTheme(headline6: TextStyle(color: Colors.white))),
      debugShowCheckedModeBanner: false,
      translations: AppTranslation(),
      title: AppStringKey.app_name,
      locale: lang == 'bn' ? Locale('bn', 'BD') : Locale('en', 'US'),
      // Get.locale
      fallbackLocale: Locale('en', 'US'),
      initialRoute: SplashScreen.pageId,
      getPages: appPages,
    );
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

