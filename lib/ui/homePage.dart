import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/currentUser.dart';

SharedPreferences sharedPreferences;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String data = '';
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> readcontent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      this.data = contents;
      print(data);
      return this.data;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }

  @override
  void setState(fn) {
    super.setState(fn);
    readcontent();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      readcontent();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            ListTile(
              title: Text('Hello ${CurrentUser.NAME}'),
              subtitle: Text(
                  'this is my quote "${CurrentUser.QUOTE != null ? CurrentUser.QUOTE == '' ? 'ยังไม่มีการระบุข้อมูล' : data == '' ? CurrentUser.QUOTE : data : 'ยังไม่มีการระบุข้อมูล'}"'),
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed('/friend');
                Navigator.of(context).pushNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                test() async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setString('username','');
                  sharedPreferences.setString('password','');
                }

                test();
                CurrentUser.USERID = null;
                CurrentUser.NAME = null;
                CurrentUser.AGE = null;
                CurrentUser.PASSWORD = null;
                CurrentUser.QUOTE = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
