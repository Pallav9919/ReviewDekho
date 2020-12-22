import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Restaurant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Function st;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
  Register(Function change) {
    st = change;
  }
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Register(context);
  }

  Widget Register(BuildContext context) {
    return form();
  }

  bool _autovalidate = false, _isObscure = true;
  String _errorMessage = "";
  TextEditingController _userid = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _fname = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _emailid = TextEditingController();

  GlobalKey<FormState> _key = new GlobalKey();
  Widget expand(Widget ex) {
    return Expanded(
      child: ex,
    );
  }

  Future register() async {
    var url = "https://reviewdekho.000webhostapp.com/Register"; //api call for register user
    String city = _city.text[0].toUpperCase()+_city.text.substring(1).toLowerCase();
    var response = await http.post(url, body: {
      "userid": _userid.text,
      "password": _password.text,
      "fname": _fname.text,
      "lname": _lname.text,
      "email": _emailid.text,
      "city": city
    });
    print(response.body);
    var data = jsonDecode(response.body);
    
    if (data == "Already Registered") {
      setState(() {
        _errorMessage =
            "*Userid already registered. Please login or try different Userid.";
      });
    } else {
      ScreenArguments.name = _userid.text;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', _userid.text);
      ScreenArguments.name = _userid.text;
      Navigator.of(context)
          .pushNamed('/MainPage'); //forward to next page(practicepage)
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
      return "This field is required!";
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

  String _validateEmail(String val) {
    if (EmailValidator.validate(val))
      return null;
    else
      return "Wrong Email id";
  }

  Widget formUI() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  st();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
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
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                  color: Color(0xFFf29544),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                height: 50,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
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
                  prefixIcon: Icon(Icons.account_box, color: Colors.white),
                  hintText: 'Userid',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLength: 32,
                validator: _validateUserid,
              ),
              TextFormField(
                controller: _fname,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon:
                      Icon(Icons.account_circle_outlined, color: Colors.white),
                  hintText: 'First Name',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLength: 32,
                validator: _validateUserid,
              ),
              TextFormField(
                controller: _lname,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon:
                      Icon(Icons.account_circle_outlined, color: Colors.white),
                  hintText: 'Last Name',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLength: 32,
                validator: _validateUserid,
              ),
              TextFormField(
                controller: _emailid,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  hintText: 'Email id',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLength: 32,
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _city,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_city, color: Colors.white),
                  hintText: 'City',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                maxLength: 32,
                validator: _validateUserid,
              ),
              TextFormField(
                controller: _password,
                style: TextStyle(color: Colors.white),
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
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
                    'Register',
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
                onPressed: _register,
              ),
              // RaisedButton(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(18.0),
              //   ),
              //   color: Colors.blue,
              //   child: Text(
              //     'Register',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onPressed: _register,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Column(
      children: [
        Container(
          height: 50,
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
