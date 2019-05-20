import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Post>> fetchTodos(int userid) async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users/${userid}/posts');

  List<Post> todoApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var todo = Post.fromJson(body[i]);
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


class Post {
  final int userid;
  final int id;
  final String title;
  final String body;

  Post({this.userid, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
      return Post(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class PostFriend extends StatelessWidget {
  // Declare a field that holds the Todo
  final int id;
  // In the constructor, require a Todo
  PostFriend({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),centerTitle: true,
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
    List<Post> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(5),
            child: new Card(
              child: InkWell(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${(values[index].id).toString()} : ${values[index].title}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5),),
                  Text(
                    values[index].body,
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