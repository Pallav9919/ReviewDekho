import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:reviewdekho/Restaurant.dart';
import 'constants.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String userId = "";
  String coins = "";

  void refresh() {
    getCoins();
  }

  Future getCoins() async {
    var url = "https://reviewdekho.000webhostapp.com/Coin";
    var response = await http.post(url, body: {"userid": userId});
    String coins = (jsonDecode(response.body)[0]["coins"]);
    this.coins = coins;
    ScreenArguments.coins = int.parse(coins);
    setState(() {
      f=false;
    });
  }

  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    this.userId = userId;

    if (userId != null) {
      ScreenArguments.name = userId;
      refresh();
      return;
    }
    Navigator.of(context).pushNamed('/');
  }

  static const IconData account_box_outlined =
      IconData(0xe00f, fontFamily: 'MaterialIcons');
  Widget sliverGrid() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 100, right: 100, bottom: 120),
              child: Text(
                "Review Dekho is review checking website where you can visit and see reviews of your favorite restaurants. If you have visited a restaurant you can let other people know how was your experience.If its your first time then don't forget to check reviews before visiting any restaurant. You can also get basic details related to restaurant.",
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/MainPage/UserPage');
                },
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF1D1E33),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black38,
                            border: Border.all(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 24, bottom: 60),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "REVIEW",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w300),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xFFa9682f),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "DEKHO",
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "CHECK REVIEWS",
                        style: TextStyle(
                          color: Color(0xFF8D8E98),
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 100),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/MainPage/DevelopersPage');
                },
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF1D1E33),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        account_box_outlined,
                        size: 250,
                      ),
                      SizedBox(height: 40),
                      Text(
                        "KNOW YOUR DEVELOPERS",
                        style: TextStyle(
                          color: Color(0xFF8D8E98),
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool f = true;

  @override
  Widget build(BuildContext context) {
    var screenWidth = (MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: max(screenWidth, 1000),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.black,
                  elevation: 10.0,
                  expandedHeight: 500.0,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Container(
                      margin: EdgeInsets.only(
                        right: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: kLogo,
                          ),
                          Row(
                            children: [
                              f?Text(ScreenArguments.name):Text(ScreenArguments.name),
                              SizedBox(width: 15),
                              Icon(
                                Icons.panorama_fish_eye_outlined,
                                color: Colors.yellowAccent[700],
                              ),
                              f?Text(ScreenArguments.coins.toString()):Text(ScreenArguments.coins.toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                    background: Image.network(
                      "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 150.0),
                ),
                sliverGrid(),
                SliverToBoxAdapter(
                  child: SizedBox(height: 70.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
