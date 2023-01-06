import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/view/loginScreen.dart';
import 'package:http/http.dart' as http;

import '../Config.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final TextEditingController _emailEditingControlller    = TextEditingController();
final TextEditingController _nameEditingControlller     = TextEditingController();
final TextEditingController _phoneEditingControlller    = TextEditingController();
final TextEditingController _passwordEditingControlller = TextEditingController();
final TextEditingController _addressEditingControlller  = TextEditingController();


bool _isChecked = false;
final _formKey = GlobalKey<FormState>();
bool _passwordVisible = true;

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Container(
              child: Form(
                child: Column(
                  children: [
                    const Text(
                      "Registration Form",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      controller: _emailEditingControlller,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val!.isEmpty ||
                      !val.contains("@") ||
                      !val.contains(".")
                      ? "Enter a valid email"
                      : null,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                        labelStyle: TextStyle(),
                        focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _nameEditingControlller,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _phoneEditingControlller,
                      validator: (val) => val!.isEmpty || (val.length < 11)
                          ? "Please enter valid phone number"
                          : null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                        labelText: 'Phone Number',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordEditingControlller,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (val) => validatePassword(val.toString()),
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(),
                        icon: const Icon(Icons.password),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      )),
                    TextFormField(
                      controller: _addressEditingControlller,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.house),
                        labelText: 'Address',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                    ElevatedButton(onPressed: _register, child: const Text("Register"))
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _register() {

    String _email     = _emailEditingControlller.text;
    String _name      = _nameEditingControlller.text;
    String _phone     = _phoneEditingControlller.text;
    String _password  = _passwordEditingControlller.text;
    String _address   = _addressEditingControlller.text;

    if (_email.isNotEmpty && _name.isNotEmpty && _phone.isNotEmpty && _password.isNotEmpty && _address.isNotEmpty) {
      http.post(Uri.parse("${Config.server}/homestay_raya/mobile/php/user_register.php"),
      body: {"email": _email,"name":_name, "phone":_phone, "password": _password, "address":_address})
      .then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (content) => const LoginScreen()));
          Fluttertoast.showToast(
            msg: "Success registered",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
          return;
        } 
      });
    }else {
      Fluttertoast.showToast(
      msg: "Please complete the form!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14.0);
    return;
  }

    
  }

  
}