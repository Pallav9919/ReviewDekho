import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reviewdekho/Restaurant.dart';
import 'UserPage.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ReviewForm extends StatefulWidget {
  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  List<String> images = [
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80"
  ];
  List<String> contacts = [];

  int sizeImages = 0, index = 0;
  int sizeContacts = 0;
  bool load = true;
  List<List<bool>> selected = [
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false]
  ];
  String review = "";

  void getPhoneNo() {
    contacts = [];
    String st =
        "https://reviewdekho.000webhostapp.com/" + ScreenArguments.res.id + "/";
    for (int i = 0; i < ScreenArguments.res.phoneNo.length; ++i) {
      var ch = ScreenArguments.res.phoneNo[i];
      if (ch != ',')
        st += ch;
      else {
        contacts.add(st);
        st = "https://reviewdekho.000webhostapp.com/" +
            ScreenArguments.res.id +
            "/";
      }
    }
    contacts.add(st);
    sizeContacts = contacts.length;
  }

  void getImages() {
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
    sizeImages = images.length;
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
          size: 30.0,
          color: selected[q][ind] ? Colors.yellow : Colors.white,
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

  Widget rating(int q) {
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
  Future uploadReview() async {
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

  void updateReview() {
    for (int i = 0; i < 5; ++i) {
      if (selected[0][i]) rat1 = double.parse((i + 1).toString());
      if (selected[1][i]) rat2 = double.parse((i + 1).toString());
      if (selected[2][i]) rat3 = double.parse((i + 1).toString());
    }
    rat = (rat1 + rat2 + rat3) / 3;
    double oldrat = double.parse(ScreenArguments.res.review);
    double count = double.parse(ScreenArguments.res.reviewCount);
    rat = (oldrat * count + rat) / (count + 1);
    uploadReview();
  }

  @override
  Widget build(BuildContext context) {
    getImages();
    var screenWidth = (MediaQuery.of(context).size.width);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: max(screenWidth, 750),
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
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: kLogo,
                        ),
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
                        fit: BoxFit.fitHeight,
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
                                color: Colors.white,
                                size: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  index =
                                      ((index - 1) % sizeImages + sizeImages) %
                                          sizeImages;
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
                                color: Colors.white,
                                size: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  index = (index + 1) % sizeImages;
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: Text(
                      'Would you like to tell about your experience?',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.all(50),
                        padding: EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: Color(0xFFf29544),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Food & Beverage',
                                  style: TextStyle(
                                    fontSize: 35,
                                  ),
                                ),
                                rating(0),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Service',
                                  style: TextStyle(
                                    fontSize: 35,
                                  ),
                                ),
                                rating(1),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ambiance',
                                  style: TextStyle(
                                    fontSize: 35,
                                  ),
                                ),
                                rating(2),
                              ],
                            ),
                            SizedBox(height: 100.0),
                            Text(
                              'You can also leave a review below(optional)',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              padding: EdgeInsets.only(top: 10.0, right: 4.0),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: 'Write your review',
                                  hintStyle: TextStyle(color: Colors.black),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25.0),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                maxLines: 5,
                                onChanged: (s) {
                                  review = s;
                                },
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Color(0xFF4C4F5E),
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                updateReview();
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(right: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xFF1D1E33),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50, bottom: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    'Restaurant Details',
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Color(0xFF91907c),
                                  height: 2,
                                  thickness: 2,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                SizedBox(height: 50.0),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, right: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Contact No.: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            ' +91${ScreenArguments.res.phoneNo}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Address: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 50.0, left: 50),
                                          child: Text(
                                            '${ScreenArguments.res.addressLine1}, ${ScreenArguments.res.addressLine2}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 80),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    color: Colors.black26,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 150),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/MainPage/DevelopersPage');
                                  },
                                  child: Text(
                                    "Know your developers",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 150),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/MainPage');
                                  },
                                  child: Text(
                                    "Return to the Main Page",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.white54),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
