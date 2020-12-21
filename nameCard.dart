import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class NameCard extends StatelessWidget {
  final String name;
  final String userID;
  final String photo;

  NameCard({this.name, this.userID, this.photo});

  // _launchURL() async {
  //   const url = 'https://flutter.dev';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: _launchURL,
      onTap: () {
        html.window.open('https://instagram.com/' + userID + '/', 'new tab');
      },
      child: Container(
        height: 400,
        margin: EdgeInsets.only(left: 30, right: 30),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF1D1E33),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('images/' + photo + '.jpeg'),
              width: 200,
              height: 200,
            ),
            SizedBox(height: 40),
            Text(
              'Name: $name',
              style: TextStyle(color: Color(0xFF8D8E98), fontSize: 22),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'How to reach us?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.instagram),
                      iconSize: 40,
                      onPressed: () {
                        html.window.open(
                            'https://instagram.com/' + userID + '/', 'new tab');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
