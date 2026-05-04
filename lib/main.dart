import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truebroker/coins/coins.dart';
import 'package:truebroker/login/login.dart';
import 'package:truebroker/shorts/post.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF444444),
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messages App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B1FA2)),
        useMaterial3: true,
      ),
      home: CreditCoinPlansScreen(),
    );
  }
}
