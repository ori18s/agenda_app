import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;


List<POST> parsePosts(String responseBody) { 
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>(); 
  developer.log(responseBody, name: 'my.app');
  return parsed.map<POST>((json) => POST.fromJson(json)).toList(); 
}

Future<List<POST>> getData() async {
  final response = await http.get('http://jsonplaceholder.typicode.com/posts');
  if (response.statusCode == 200) {
    return parsePosts(response.body); 
  } else {
    throw Exception('Failed to load album');
  }
}

class POST {
  final int userId;
  final int id;
  final String title;
  final String body;

  POST({this.userId, this.id, this.title, this.body});

  factory POST.fromJson(Map<String, dynamic> json) {
    return POST(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLinePage> {
  Future<List<POST>> futurePOST;

  @override
  void initState() {
    super.initState();
    futurePOST = getData();
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<POST> items = snapshot.data;

    return new ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(items[index].title),
              ),
              new Divider(height: 2.0,),
            ],
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: FutureBuilder<List<POST>>(
          future: futurePOST,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return createListView(context, snapshot);
            }
          },
        ),
      ),
    );
  }
}

// class TimeLinePage extends StatelessWidget {
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Index 3: School',
//       style: optionStyle,
//     );
//   }
// }