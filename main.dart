import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        '/': (context) => MyHomePage(title: 'CodeChef'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//for passing userid to next page
class ScreenArguments {
  static String userid = null;
}

class _MyHomePageState extends State<MyHomePage> {
  bool _autovalidate = false, _isObscure = true;
  String _errorMessage = "";
  TextEditingController _userid = TextEditingController();
  TextEditingController _password = TextEditingController();

  GlobalKey<FormState> _key = new GlobalKey();

  Future Hello() async {
    var response = await http.get("https://reviewdekho.000webhostapp.com/");
    var result = response.body;
    print(result);
  }

  Future register() async {
    var url =
        "https://reviewdekho.000webhostapp.com/Register"; //api call for register user
    var response = await http
        .post(url, body: {"userid": _userid.text, "password": _password.text});
    var data = response.body;
    if (data == "Already Registered") {
      setState(() {
        _errorMessage =
            "*Userid already registered. Please login or try different Userid.";
      });
    } else {
      ScreenArguments.userid = _userid.text;
      Navigator.of(context)
          .pushNamed('/practicepage'); //forward to next page(practicepage)
    }
  }

  Future login() async {
    var url =
        "https://reviewdekho.000webhostapp.com/Login"; //api call for login user
    var response = await http
        .post(url, body: {"userid": _userid.text, "password": _password.text});
    var data = response.body;
    if (data == "Login Successfull") {
      ScreenArguments.userid = _userid.text;
      Navigator.of(context)
          .pushNamed('/practicepage'); //forward to next page(practicepage)
    } else {
      setState(() {
        _errorMessage = "*Wrong userid or password.";
      });
    }
  }

  void _login() {
    if (_key.currentState.validate()) {
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  void _register() {
    if (_key.currentState.validate()) {
      register();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  String _validateUserid(String val) {
    if (val.length == 0) {
      return "Userid is required";
    }
    return null;
  }

  String _validatePassword(String val) {
    if (val.length == 0) {
      return "Password is required";
    } else if (val.length < 6) {
      return "Password must be at least 6 characters";
    } else
      return null;
  }

  Widget formUI() {
    return Column(
      children: [
        Text(
          'Login/Register',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 50,
          ),
        ),
        TextFormField(
          controller: _userid,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.account_box),
            labelText: 'Userid',
          ),
          maxLength: 32,
          validator: _validateUserid,
        ),
        TextFormField(
          controller: _password,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: _isObscure
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  if (_isObscure)
                    _isObscure = false;
                  else
                    _isObscure = true;
                });
              },
            ),
          ),
          maxLength: 32,
          validator: _validatePassword,
        ),
        Container(
          child: Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 45,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.blue,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                //onPressed: Hello,
                onPressed: _login,
              ),
            ),
            Spacer(
              flex: 10,
            ),
            Expanded(
              flex: 45,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.blue,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _register,
              ),
            ),
          ],
        ),
        Container(
          height: 10,
        ),
        FlatButton(
          child: Text('Continue without login'),
          onPressed: () {
            Navigator.of(context).pushNamed(
                '/practicepage'); //forward to next page(practicepage)
          },
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Container(
          margin: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width) * (0.05),
          ),
          child: Container(
            //'logo.jpg',
            height: 500,
            width: 200,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
            ),
            Center(
              child: Card(
                child: Container(
                  width: 500,
                  margin: EdgeInsets.all(15.0),
                  child: Form(
                    key: _key,
                    autovalidate: _autovalidate,
                    child: formUI(),
                  ),
                ),
                color: Colors.blue[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
