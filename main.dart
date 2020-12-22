import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reviewdekho/ReviewForm.dart';
import 'Login.dart';
import 'Register.dart';
import 'UserPage.dart';
import 'constants.dart';
import 'package:reviewdekho/MainPage.dart';
import 'package:reviewdekho/developers.dart';
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
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/MainPage': (context) => MainPage(),
        '/MainPage/UserPage': (context) => UserPage(),
        '/MainPage/DevelopersPage': (context) => DevelopersPage(),
        '/MainPage/UserPage/ReviewForm': (context) => ReviewForm(),
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
        title: kLogo,
      ),
      body: Container(
        height: 1000,
        color: Color(0xFF0A0E21),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                isLoginPage
                    ? Expanded(child: Login(change))
                    : Expanded(child: Register(change)),
                Expanded(
                  child: Container(
                    height: 500,
                    width: 500,
                    child: Image.network(
                      "https://reviewdekho.000webhostapp.com/restaurant.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
