import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/view/mainScreen.dart';
import 'package:homestay_raya/view/registerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Config.dart';
import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

TextEditingController _emailEditingController     = TextEditingController();
TextEditingController _passwordEditingController   = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool _passwordVisible = true;
bool _isChecked = false;
var screenHeight, screenWidth, cardWidth;

@override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth<=600){
      cardWidth = screenWidth;
    }else{
      cardWidth = 400.00;
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: cardWidth,
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const Text(
                      "Login User",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val!.isEmpty ||
                        !val.contains("@") ||
                        !val.contains(".")
                        ? "enter a valid email"
                        : null,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.email),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        )
                      ),
                    ),
                    TextFormField(
                      controller: _passwordEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _passwordVisible,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.password),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        )
                      )
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: _isChecked, 
                          onChanged: (bool? value){
                          setState(() {
                            _isChecked = value!;
                            saveremovepref(value);
                          });
                        }),
                        Flexible(
                          child: GestureDetector(
                            onTap: null,
                            child: const Text('Remember Me',
                            style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            )),
                          ),
                        ),
                         MaterialButton(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                              minWidth: 115,
                              height: 50,
                              elevation: 10,
                              onPressed: _login,
                              color: Theme.of(context).colorScheme.primary,
                              child: const Text('Login'),
                            ),
                      ],
                    ),
                    const SizedBox(
                          height: 8,
                    ),
                    GestureDetector(
                      onTap: _goLogin,
                      child: const Text(
                        "No account? Create One",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: _goHome,
                      child: const Text("Go back Home", style: TextStyle(fontSize: 18)),
                    )
                  ])
                ),
              ),
            ),
            
          ),
        ),
      ),
    );
  }

  void _login() {

    if(!_formKey.currentState!.validate()){
      Fluttertoast.showToast(
        msg: "Please fill in the login credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0
      );
      return;
    }

    String _email     = _emailEditingController.text;
    String _password  = _passwordEditingController.text;

    http.post(Uri.parse("${Config.server}/homestay_raya/mobile/php/user_login.php"),
      body: {"email": _email, "password": _password}).then((response){
        print(response.body);
        if(response.statusCode == 200){
          var jsonResponse = json.decode(response.body);
          print(jsonResponse);
          User user = User.fromJson(jsonResponse['data']);
          print(user);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(user: user)));
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
          return;
        } else {
          Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
          return;
        }
      }
    );
  }

  void _goLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegisterScreen()));
  }

  void _goHome() {
    User user = User(
        id: "0",
        email: "unregistered",
        name: "unregistered",
        address: "na",
        phone: "0123456789",);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => MainScreen(user: user)));
  }

  void saveremovepref(bool value) async {

    String email = _emailEditingController.text;
    String password = _passwordEditingController.text;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Fluttertoast.showToast(
        msg: "Preference Stored",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passwordEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }
  
  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.isNotEmpty) {
      setState(() {
        _emailEditingController.text = email;
        _passwordEditingController.text = password;
        _isChecked = true;
      });
    }
  }
}