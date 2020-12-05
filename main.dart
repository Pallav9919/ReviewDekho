import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reviewdekho/ReviewForm.dart';
import 'Login.dart';
import 'Register.dart';
import 'UserPage.dart';
import 'package:animated_background/animated_background.dart';

bool isLoginPage = true;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/UserPage': (context) => UserPage(),
        '/UserPage/ReviewForm': (context) => ReviewForm(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void change() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: title(),
      ),
      body: Container(
        height: 1000,
        color: Colors.amber[200],
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              isLoginPage ? Login(change) : Register(change),
              Container(
                height: 500,
                width: 500,
                child: Image.network(
                  "https://reviewdekho.000webhostapp.com/restaurant.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget title() {
  return Row(
    children: <Widget>[
      Text(
        'Review',
        style: TextStyle(
          letterSpacing: 1.0,
        ),
      ),
      roundCornerYellowBox('Dekho'),
    ],
  );
}

Widget roundCornerYellowBox(String s) {
  return Container(
    margin: EdgeInsets.only(
      left: 4,
    ),
    child: Text(
      s,
      style: TextStyle(
        color: Colors.black,
        letterSpacing: 1.0,
      ),
    ),
    decoration: BoxDecoration(
      color: Color(0xffffff00),
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
  );
}
