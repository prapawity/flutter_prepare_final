import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Comment>> fetchTodos(int postid) async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts/${postid}/comments');

  List<Comment> todoApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var todo = Comment.fromJson(body[i]);
      print(todo.name);
      if(todo.postid == postid){
        todoApi.add(todo);
      }
    }
    return todoApi;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}


class Comment {
  final int postid;
  final int id;
  final String name;
  final String body;
  final String email;
  Comment({this.postid, this.id, this.name, this.body, this.email});

  factory Comment.fromJson(Map<String, dynamic> json) {
      return Comment(
      postid: json['postId'],
      id: json['id'],
      name: json['name'],
      body: json['body'],
      email: json['email']
    );
  }
}

class CommentFriend extends StatelessWidget {
  // Declare a field that holds the Todo
  final int postid;
  // In the constructor, require a Todo
  CommentFriend({Key key, @required this.postid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment"),centerTitle: true,automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("BACK"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FutureBuilder(
              future: fetchTodos(this.postid),
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
    List<Comment> values = snapshot.data;
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
                    '${(values[index].id).toString()} : ${values[index].id}',
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
                  Padding(padding: EdgeInsets.all(5),),
                  Text(
                    values[index].name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                  ),
                  Padding(padding: EdgeInsets.all(5),),
                  Text(
                    values[index].email,
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