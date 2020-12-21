import 'package:flutter/material.dart';
import 'package:reviewdekho/Restaurant.dart';
import 'constants.dart';
import 'nameCard.dart';
import 'dart:math';

class DevelopersPage extends StatefulWidget {
  @override
  _DevelopersPageState createState() => _DevelopersPageState();
}

class _DevelopersPageState extends State<DevelopersPage> {
  Widget sliverGrid() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: NameCard(
                name: 'Pallav Chauhan', userID: 'pal_love_451', photo: 'pallu'),
          ),
          Expanded(
            child: NameCard(
                name: 'Hetvi Patel', userID: '_hetu_9919', photo: 'hetvi'),
          ),
          Expanded(
            child: NameCard(
                name: 'Purv Patel', userID: 'purv.patel_21', photo: 'puru'),
          ),
          Expanded(
            child: NameCard(
                name: 'Paritosh Joshi',
                userID: 'he_who_must_not_be_named_vd',
                photo: 'pari'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = (MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: max(screenWidth, 750),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color(0xFF0A0F21),
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
                              Text(ScreenArguments.name),
                              SizedBox(width: 15),
                              Icon(
                                Icons.panorama_fish_eye_outlined,
                                color: Colors.yellowAccent[700],
                              ),
                              Text(ScreenArguments.coins.toString()),
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
