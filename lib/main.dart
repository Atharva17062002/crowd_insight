import 'package:crowd_insight/provider/auth_provider.dart';
import 'package:crowd_insight/screens/imp_info_screen.dart';
import 'package:crowd_insight/screens/map_screen.dart';
import 'package:crowd_insight/screens/owner_dashboard.dart';
import 'package:crowd_insight/screens/phonenumber_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyDhzFJey37V8bpR5DGaN2l0S401WZ8eY0U",
    appId: "1:912055235803:android:3b467233b579b193bc88fe",
    messagingSenderId: "912055235803",
    projectId: "crowdsense-6ee39",
  ),
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

class CoordinateData extends ChangeNotifier {
  List<List<String>> coordinates = [];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CoordinateData())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: PhoneScreen(),
      ),
    );
  }
}

