import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Photos>> fetchTodos(int userid) async {
  final response = await http
      .get('https://jsonplaceholder.typicode.com/albums/${userid}/photos');

  List<Photos> todoApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var todo = Photos.fromJson(body[i]);
      if (todo.albumid == userid) {
        todoApi.add(todo);
      }
    }
    print(todoApi.length);
    return todoApi;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Photos {
  final int albumid;
  final int id;
  final String title;
  final String url;
  final String thumnailurl;
  Photos({this.albumid, this.id, this.url, this.thumnailurl, this.title});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
        albumid: json['albumId'],
        id: json['id'],
        url: json['url'],
        thumnailurl: json['thumnailurl'],
        title: json['title']);
  }
}

class PhotosFriend extends StatelessWidget {
  // Declare a field that holds the Todo
  final int id;
  final int albumid;
  // In the constructor, require a Todo
  PhotosFriend({Key key, @required this.id, this.albumid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Photos"),
        centerTitle: true,
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
              future: fetchTodos(this.albumid),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError) {
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
    List<Photos> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(5),
            child: new Card(
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${(values[index].id).toString()}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      '${(values[index].title).toString()}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Container(
                        child: Image.network(
                          '${values[index].url}',
                        ))
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
