import 'package:flutter/material.dart';
import './ui/registerPage.dart';
import './ui/loginPage.dart';
import './ui/homePage.dart';
import './ui/profilePage.dart';
import './ui/friendPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Prepared',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Color.fromARGB(11, 11, 11, 11),
        
        appBarTheme: AppBarTheme(color: Color.fromRGBO(	48, 63, 159, 1))
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
