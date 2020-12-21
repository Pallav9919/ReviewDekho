import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Restaurant.dart';

Function st;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
  Login(Function change) {
    st = change;
  }
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Login(context);
  }

  Widget Login(BuildContext context) {
    return form();
  }

  bool _autovalidate = false, _isObscure = true;
  String _errorMessage = "";
  TextEditingController _userid = TextEditingController();
  TextEditingController _password = TextEditingController();

  GlobalKey<FormState> _key = new GlobalKey();

  Widget expand(Widget ex) {
    return Expanded(
      child: ex,
    );
  }

  Future login() async {
    var url =
        "https://reviewdekho.000webhostapp.com/Login"; //api call for login user
    var response = await http
        .post(url, body: {"userid": _userid.text, "password": _password.text});
    var data = jsonDecode(response.body);
    if (data == "Login Successfull") {
      ScreenArguments.name = _userid.text;
      Navigator.of(context)
          .pushNamed('/MainPage'); //forward to next page(practicepage)
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
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                  color: Color(0xFFf29544),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                height: 50,
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  st();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Color(0xFFf29544),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  height: 50,
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
            color: Color(0xFFf29544),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                controller: _userid,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.account_box,
                    color: Colors.white,
                  ),
                  hintText: 'Userid',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                maxLength: 32,
                validator: _validateUserid,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _password,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    color: Colors.white,
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
              RawMaterialButton(
                elevation: 6.0,
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                constraints: BoxConstraints.tightFor(
                  width: 126.0,
                  height: 40.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                fillColor: Color(0xFF4C4F5E),
                onPressed: _login,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Column(
      children: [
        Center(
          child: Card(
            child: Container(
              color: Colors.white,
              width: 400,
              margin: EdgeInsets.all(15.0),
              child: Form(
                key: _key,
                autovalidate: _autovalidate,
                child: formUI(),
              ),
              padding: EdgeInsets.all(3),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
