import 'package:flutter/material.dart';
import 'package:flutter_prepared/db/userDB.dart';
import 'package:toast/toast.dart';
import '../utils/currentUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  UserUtils user = UserUtils();
  final userid = TextEditingController();
  final password = TextEditingController();
  bool isValid = false;
  int formState = 0;
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    chk2(String userchk, String passwordchk) async {
      await user.open("user.db");
      Future<List<User>> allUser = user.getAllUser();
      Future isUserValid(String userid, String password) async {
        var userList = await allUser;
        for (var i = 0; i < userList.length; i++) {
          print(i);
          if (userchk == userList[i].userid &&
              passwordchk == userList[i].password) {
            CurrentUser.ID = userList[i].id;
            CurrentUser.USERID = userList[i].userid;
            CurrentUser.NAME = userList[i].name;
            CurrentUser.AGE = userList[i].age;
            CurrentUser.PASSWORD = userList[i].password;
            CurrentUser.QUOTE = userList[i].quote;
            this.isValid = true;
            sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("username", userList[i].userid);
            sharedPreferences.setString("password", userList[i].password);
            break;
          }
        }
      }

      isUserValid(userchk, passwordchk);
      print(this.isValid);
      if (this.isValid == true) {
        return Navigator.pushReplacementNamed(context, '/home');
      }
    }

    getCredential() async {
      sharedPreferences = await SharedPreferences.getInstance();
      String userchk = sharedPreferences.getString('username');
      String passwordchk = sharedPreferences.getString('password');
      if (userchk != "" && userchk != null) {
        chk2(userchk, passwordchk);
      }
      print(userchk);
    }

    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      chk2(String userchk, String passwordchk) async {
        await user.open("user.db");
        Future<List<User>> allUser = user.getAllUser();
        Future isUserValid(String userid, String password) async {
          var userList = await allUser;
          for (var i = 0; i < userList.length; i++) {
            print('${userid} == ${userList[i].userid} ${password} == ${userList[i].password}');
            if (userid == userList[i].userid &&
                password == userList[i].password) {
              CurrentUser.ID = userList[i].id;
              CurrentUser.USERID = userList[i].userid;
              CurrentUser.NAME = userList[i].name;
              CurrentUser.AGE = userList[i].age;
              CurrentUser.PASSWORD = userList[i].password;
              CurrentUser.QUOTE = userList[i].quote;
              this.isValid = true;
              sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString("username", userList[i].userid);
              sharedPreferences.setString("password", userList[i].password);
              return Navigator.pushReplacementNamed(context, '/home');
              break;
            }
          }
        }
        isUserValid(userchk, passwordchk);
      }

      getCredential() async {
        sharedPreferences = await SharedPreferences.getInstance();
        String userchk = sharedPreferences.getString('username');
        String passwordchk = sharedPreferences.getString('password');
        if (userchk != "" && userchk != null) {
          chk2(userchk, passwordchk);
        }
        print(userchk);
      }

      getCredential();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            Image.asset(
              "assets/banner.jpg",
              width: 200,
              height: 200,
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "UserId",
                  icon: Icon(Icons.account_box, size: 40, color: Colors.grey),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("Login"),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {
                    if (userid == userList[i].userid &&
                        password == userList[i].password) {
                      CurrentUser.ID = userList[i].id;
                      CurrentUser.USERID = userList[i].userid;
                      CurrentUser.NAME = userList[i].name;
                      CurrentUser.AGE = userList[i].age;
                      CurrentUser.PASSWORD = userList[i].password;
                      CurrentUser.QUOTE = userList[i].quote;
                      this.isValid = true;
                      sharedPreferences = await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          "username", userList[i].userid);
                      sharedPreferences.setString(
                          "password", userList[i].password);
                      break;
                    }
                  }
                }

                if (this.formState != 2) {
                  Toast.show("Please fill out this form", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  this.formState = 0;
                } else {
                  this.formState = 0;
                  await isUserValid(userid.text, password.text);
                  if (!this.isValid) {
                    Toast.show("Invalid user or password", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                    userid.text = "";
                    password.text = "";
                  }
                }

                Future showAllUser() async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {}
                }

                showAllUser();
              },
            ),
            FlatButton(
              child: Container(
                child: Text("register new user", textAlign: TextAlign.right),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 180.0),
            ),
          ],
        ),
      ),
    );
  }
}
