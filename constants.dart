import 'package:flutter/material.dart';

final kLogo = Padding(
  padding: EdgeInsets.only(left: 20.0),
  child: Row(
    children: <Widget>[
      Text(
        'REVIEW',
        style: TextStyle(
          letterSpacing: 1.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      Center(
        child: Container(
          margin: EdgeInsets.only(left: 4),
          //padding: EdgeInsets.(2.0),
          padding:
              EdgeInsets.only(bottom: 4.0, top: 1.0, left: 2.0, right: 2.0),
          child: Text(
            'DEKHO',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xFFa9682f),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
      ),
    ],
  ),
);
