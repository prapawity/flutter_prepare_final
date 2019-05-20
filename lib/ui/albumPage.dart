import 'package:flutter/material.dart';
import 'package:flutter_prepared/ui/photoPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Albums>> fetchTodos(int userid) async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users/${userid}/albums');

  List<Albums> todoApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var todo = Albums.fromJson(body[i]);
      print(todo);
      if(todo.userid == userid){
        todoApi.add(todo);
      }
    }
    return todoApi;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}


class Albums {
  final int userid;
  final int id;
  final String title;

  Albums({this.userid, this.id, this.title});

  factory Albums.fromJson(Map<String, dynamic> json) {
      return Albums(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class AlbumsFriend extends StatelessWidget {
  // Declare a field that holds the Todo
  final int id;
  // In the constructor, require a Todo
  AlbumsFriend({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // RaisedButton(
            //   child: Text("BACK"),
            //   onPressed: (){
            //     Navigator.pop(context);
            //   },
            // ),
            FutureBuilder(
              future: fetchTodos(this.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError){
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
            
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Albums> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height:100,
            margin: EdgeInsets.all(5),
            child: new Card(
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PhotosFriend(id: this.id,albumid: values.elementAt(index).id)));
                },
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${(values[index].id).toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5),),
                  Text(
                    values[index].title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
              ),
            ),
          );
        },
      ),
    );
  }

}