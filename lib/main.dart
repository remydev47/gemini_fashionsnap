import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:stylesnap/api_keys.dart';
import 'package:stylesnap/src/presentation/views/home_view.dart';
import 'package:stylesnap/src/utils/constants.dart';

void main() {
  Gemini.init(apiKey: ApiKeys.gemini_api_key);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPlatinumWhite,
        ),
        useMaterial3: true,
      ),
      home: HomeView(),
    );
  }
}
