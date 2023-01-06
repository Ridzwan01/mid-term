import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/view/addProduct.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class productScreen extends StatefulWidget {
    final User user;
    const productScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<productScreen> createState() => _productScreenState();
}

class _productScreenState extends State<productScreen> {

  String titlecenter = " ";
  var _lat, _lng;
  late Position _position;
  var placemarks;
  TextEditingController searchctrl = TextEditingController();
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => AddProductScreen()));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
    );
  }
}