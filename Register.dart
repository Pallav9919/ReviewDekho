import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Restaurant.dart';
import 'package:email_validator/email_validator.dart';

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
      Navigator.of(context)
          .pushNamed('/UserPage'); //forward to next page(practicepage)
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
      return "this field is required";
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

  String _validateEmail(String val){
    if(EmailValidator.validate(val))
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
                      color: Colors.blue,
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
                color: Colors.blue[200],
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.blue[700],
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
          color: Colors.blue[200],
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
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
                controller: _fname,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  labelText: 'first name',
                ),
                maxLength: 32,
                validator: _validateUserid,
              ),
              TextFormField(
                controller: _lname,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  labelText: 'last name',
                ),
                maxLength: 32,
                validator: _validateUserid,
              ),
              TextFormField(
                controller: _emailid,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email id',
                ),
                maxLength: 32,
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _city,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_city),
                  labelText: 'city',
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
              RaisedButton(
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
            ),
            color: Colors.blue[50],
          ),
        ),
      ],
    );
  }
}
