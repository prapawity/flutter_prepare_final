import 'package:flutter/material.dart';
import './ui/registerPage.dart';
import './ui/loginPage.dart';
import './ui/homePage.dart';
import './ui/profilePage.dart';
import './ui/friendPage.dart';

void main() => runApp(MyApp());
const MaterialColor white = const MaterialColor(
  0xFF303f9f,
  const <int, Color>{
    50: const Color(0xFF303f9f),
    100: const Color(0xFF303f9f),
    200: const Color(0xFF303f9f),
    300: const Color(0xFF303f9f),
    400: const Color(0xFF303f9f),
    500: const Color(0xFF303f9f),
    600: const Color(0xFF303f9f),
    700: const Color(0xFF303f9f),
    800: const Color(0xFF303f9f),
    900: const Color(0xFF303f9f),
  },
);
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Prepared',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: white,
        
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => HomePage(),
        "/profile": (context) => ProfilePage(),
        "/friend": (context) => FriendPage(),
      },
    );
  }
}
