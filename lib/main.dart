import 'package:ebook_app/firebase_options.dart';
import 'package:ebook_app/pages/lottie_page/lottie_page.dart';
import 'package:ebook_app/pages/nav_bar_widget/nav_bar_widget.dart';
import 'package:ebook_app/services/local_strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// backgrount messaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ///
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  /// foregrount messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  /// backgrount messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();
  await Hive.openBox<String>("podcast_id");
  await Hive.openBox<String>("notifications_id");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalStrings(),
      locale: const Locale("en", "US"),
      debugShowCheckedModeBanner: false,
      title: 'Podcast App Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const LottiePage(),
      routes: {
        NavBarWidget.id: (context) => const NavBarWidget(),
      },
    );
  }
}
