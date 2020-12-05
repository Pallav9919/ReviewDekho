import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reviewdekho/Restaurant.dart';
import 'UserPage.dart';
import 'package:http/http.dart' as http;

class ReviewForm extends StatefulWidget {
  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  List<String> images = [
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80"
  ];
  int size = 0, index = 0;
  bool load = true;
  List<List<bool>> selected = [
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false]
  ];
  String review = "";
  void getimgs() {
    images = [];
    String st =
        "https://reviewdekho.000webhostapp.com/" + ScreenArguments.res.id + "/";
    for (int i = 0; i < ScreenArguments.res.imgs.length; ++i) {
      var ch = ScreenArguments.res.imgs[i];
      if (ch != ',')
        st += ch;
      else {
        images.add(st);
        st = "https://reviewdekho.000webhostapp.com/" +
            ScreenArguments.res.id +
            "/";
      }
    }
    images.add(st);
    size = images.length;
  }

  NetworkImage img() {
    return NetworkImage(
      images[index],
    );
  }

  Widget star(int ind, int q) {
    return SizedBox(
      height: 50,
      width: 50,
      child: IconButton(
        padding: EdgeInsets.all(0.0),
        icon: Icon(
          Icons.star,
          size: 50.0,
          color: selected[q][ind] ? Colors.yellow : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            for (int i = 0; i <= ind; ++i) selected[q][i] = true;
            for (int i = ind + 1; i < 5; ++i) selected[q][i] = false;
          });
        },
      ),
    );
  }

  Widget ratting(int q) {
    return Row(
      children: [
        star(0, q),
        star(1, q),
        star(2, q),
        star(3, q),
        star(4, q),
      ],
    );
  }

  double rat = 0, rat1 = 0, rat2 = 0, rat3 = 0;
  Future uploadreview() async {
    var url = "https://reviewdekho.000webhostapp.com/UploadReview";
    var result = await http.post(url, body: {
      "userid": ScreenArguments.name,
      "restaurantid": ScreenArguments.res.id,
      "rat1": rat1.toString(),
      "rat2": rat2.toString(),
      "rat3": rat3.toString(),
      "rat": rat.toString(),
      "review": review,
      "count": (int.parse(ScreenArguments.res.reviewCount) + 1).toString(),
      "coins": (ScreenArguments.coins + 5).toString()
    });
  }

  void updatereview() {
    for (int i = 0; i < 5; ++i) {
      if (selected[0][i]) rat1 = double.parse((i + 1).toString());
      if (selected[1][i]) rat2 = double.parse((i + 1).toString());
      if (selected[2][i]) rat3 = double.parse((i + 1).toString());
    }
    rat = (rat1 + rat2 + rat3) / 3;
    double oldrat = double.parse(ScreenArguments.res.review);
    double count = double.parse(ScreenArguments.res.reviewCount);
    rat = (oldrat * count + rat) / (count + 1);
    uploadreview();
  }

  @override
  Widget build(BuildContext context) {
    getimgs();
    var ScreenWidth = (MediaQuery.of(context).size.width);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: max(ScreenWidth, 750),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black,
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
                        title(),
                        Text(
                          'Overall Rating : ' +
                              ScreenArguments.res.review.toString() +
                              '/5.00',
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: img(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.arrow_left,
                                color: Colors.yellow,
                                size: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  index = ((index - 1) % size + size) % size;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.arrow_right,
                                color: Colors.yellow,
                                size: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  index = (index + 1) % size;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Would you like to tell about your experence?',
                    style: TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Food & Beverage',
                            style: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                          ratting(0),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service',
                            style: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                          ratting(1),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ambience',
                            style: TextStyle(
                              fontSize: 50,
                            ),
                          ),
                          ratting(2),
                        ],
                      ),
                      Text(
                        'You can also leave a review below.(optional)',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          onChanged: (s) {
                            review = s;
                          },
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 30,),
                        ),
                        onPressed: () {
                          updatereview();
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1000,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
