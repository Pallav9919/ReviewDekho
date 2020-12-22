import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Restaurant.dart';
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  AutoCompleteTextField _searchTextField;
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  List<Restaurant> restaurantData = [];
  List<City> cities = [];
  List<Widget> restaurantWidget = [];
  List<String> sugg = [];
  bool loading = true, loading2 = true, first = true;
  int data1 = 0, data2 = 5;

  Widget create(Restaurant instance, int index, int loc) {
    List<String> images = [];
    bool wait = false;
    int size;
    String st = "https://reviewdekho.000webhostapp.com/" + instance.id + "/";
    for (int i = 0; i < instance.imgs.length; ++i) {
      var ch = instance.imgs[i];
      if (ch != ',')
        st += ch;
      else {
        images.add(st);
        st = "https://reviewdekho.000webhostapp.com/" + instance.id + "/";
      }
    }
    images.add(st);
    size = images.length;
    return GestureDetector(
      onTap: () async {
        ScreenArguments.res = instance;
        ScreenArguments.tag = index.toString();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('restaurant_al1', ScreenArguments.res.addressLine1);
        prefs.setString('restaurant_al2', ScreenArguments.res.addressLine2);
        prefs.setString('restaurant_city', ScreenArguments.res.city);
        prefs.setString('restaurant_id', ScreenArguments.res.id);
        prefs.setString('restaurant_imgs', ScreenArguments.res.imgs);
        prefs.setString('restaurant_mailid', ScreenArguments.res.mailid);
        prefs.setString('restaurant_name', ScreenArguments.res.name);
        prefs.setString('restaurant_phoneNo', ScreenArguments.res.phoneNo);
        prefs.setString('restaurant_review', ScreenArguments.res.review);
        prefs.setString(
            'restaurant_reviewCount', ScreenArguments.res.reviewCount);
        prefs.setString('tag', index.toString());
        Navigator.of(context)
            .pushNamed('/MainPage/UserPage/ReviewForm')
            .then((value) => initState());
      },
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      loc--;
                      if (loc < 0) loc = size - 1;
                      restaurantWidget[index] =
                          create(restaurantData[index], index, loc);
                    });
                  },
                ),
                Container(
                  height: 360,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Color(0xFF1D1E33),
                  ),
                  child: Hero(
                    tag: index.toString(),
                    child: Image.network(
                      images[loc],
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      loc++;
                      if (loc == size) loc = 0;
                      restaurantWidget[index] =
                          create(restaurantData[index], index, loc);
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              instance.name.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF8D8E98),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 50,
                  ),
                  Text(
                    instance.review.toString() + '/5.00',
                    style: TextStyle(
                      color: Color(0xFF8D8E98),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
        width: 400,
      ),
    );
  }

  List<Restaurant> loadRestaurant(String jsonString) {
    var parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
  }

  Future searchRestaurant(String city, String name, String all) async {
    var url = "https://reviewdekho.000webhostapp.com/Restaurants";
    var response = await http.post(url, body: {
      "city": city,
      "name": name,
      "all": all,
      "data1": data1.toString(),
      "data2": data2.toString()
    });
    restaurantData = loadRestaurant(response.body);
    setState(() {
      loading = false;
      loading2 = false;
    });
    restaurantWidget = [];
    for (int i = 0; i < restaurantData.length; ++i) {
      restaurantWidget.add(create(restaurantData[i], i, 0));
      if (first) sugg.add(restaurantData[i].name);
    }
    first = false;
  }

  List<City> loadCity(String jsonString) {
    var parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<City>((json) => City.fromJson(json)).toList();
  }

  Future searchCities() async {
    var url = "https://reviewdekho.000webhostapp.com/Cities";
    var response = await http.get(url);
    setState(() {
      loading = false;
      loading2 = false;
    });
    cities = loadCity(response.body);
    for (int i = 0; i < cities.length; ++i) {
      sugg.add(cities[i].name);
    }
  }

  Future getCoins() async {
    var url = "https://reviewdekho.000webhostapp.com/Coin";
    var response = await http.post(url, body: {"userid": ScreenArguments.name});
    String coins = (jsonDecode(response.body)[0]["coins"]);
    ScreenArguments.coins = int.parse(coins);
  }

  void refresh() {
    searchCities();
    searchRestaurant("", "", "yes");
    getCoins();
  }

  Widget sliverGrid() {
    return SliverToBoxAdapter(
      child: Center(
        child: Wrap(
          children: restaurantWidget,
        ),
      ),
    );
  }

  Widget _loading() {
    return SliverToBoxAdapter(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget row(String s) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          s,
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');

    if (userId != null) {
      ScreenArguments.name = userId;
      refresh();
      return;
    }
    Navigator.of(context).pushNamed('/');
  }

  void initState() {
    super.initState();
    autoLogIn();
  }

  @override
  Widget build(BuildContext context) {
    //searchRestaurant();
    var screenWidth = (MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: SingleChildScrollView(
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
              SliverAppBar(
                backgroundColor: Color(0xFF040505),
                elevation: 10.0,
                toolbarHeight: 100,
                automaticallyImplyLeading: false,
                pinned: true,
                title: Column(
                  children: [
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: _searchTextField =
                                      AutoCompleteTextField<String>(
                                    key: _key,
                                    suggestions: sugg,
                                    clearOnSubmit: false,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText:
                                          '   Enter City or Restaurant Name',
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    itemBuilder: (context, item) {
                                      return row(item);
                                    },
                                    itemFilter: (item, query) {
                                      return item
                                          .toLowerCase()
                                          .contains(query.toLowerCase());
                                    },
                                    itemSorter: (a, b) {
                                      return a.compareTo(b);
                                    },
                                    itemSubmitted: (item) {
                                      setState(() {
                                        _searchTextField
                                            .textField.controller.text = item;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: 50,
                                padding: EdgeInsets.only(
                                  left: 19.5,
                                  right: 19.5,
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  onChanged: (s) {
                                    if (s == '0' ||
                                        s == '1' ||
                                        s == '2' ||
                                        s == '3' ||
                                        s == '4' ||
                                        s == '5')
                                      data1 = int.parse(s);
                                    else
                                      data1 = 0;
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Text('-'),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: 50,
                                padding: EdgeInsets.only(
                                  left: 19.5,
                                  right: 19.5,
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  onChanged: (s) {
                                    if (s == '0' ||
                                        s == '1' ||
                                        s == '2' ||
                                        s == '3' ||
                                        s == '4' ||
                                        s == '5')
                                      data2 = int.parse(s);
                                    else
                                      data2 = 5;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  setState(() {
                                    loading2 = true;
                                    if (_searchTextField
                                            .textField.controller.text ==
                                        "")
                                      searchRestaurant(
                                          _searchTextField
                                              .textField.controller.text,
                                          _searchTextField
                                              .textField.controller.text,
                                          "yes");
                                    else
                                      searchRestaurant(
                                          _searchTextField
                                              .textField.controller.text,
                                          _searchTextField
                                              .textField.controller.text,
                                          "no");
                                    loading2 = false;
                                  });
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  width: 200,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.all(10),
                  // color: Colors.pink,
                  child: RaisedButton(
                    color: Colors.pink,
                    child: Container(
                      child: Text(
                        'Show All',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        loading2 = true;
                        searchRestaurant("", "", "yes");
                        loading2 = false;
                      });
                    },
                  ),
                ),
              ),
              loading2 ? _loading() : sliverGrid(),
              // SizedBox(height: 40),
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
