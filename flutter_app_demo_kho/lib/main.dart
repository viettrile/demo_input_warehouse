import 'package:flutter/material.dart';
import 'package:flutter_app_demo_kho/configs/config.dart';
import 'package:flutter_app_demo_kho/routes/routes.dart';
import 'package:flutter_app_demo_kho/screens/home/menu.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.light,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      home: MainMenuScreen(),
    );
  }
}
