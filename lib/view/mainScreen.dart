import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/view/addProduct.dart';
import 'package:http/http.dart' as http;

import '../Config.dart';
import '../model/user.dart';


class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _lat, lgn;
  late Position _position;
  List productlist = [];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Homestay')
        ),

        body: productlist.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Your Current Products",
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),),
                  Expanded(
child: GestureDetector(
          child: GridView.count(
             crossAxisCount: 2,
             children: List.generate(productlist.length, (index) {
             return Card(
               child: Column(
                     children: [
                           Flexible(
                 flex: 6,
                           child: CachedNetworkImage(
                                 width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl: Config.server +
                                      "/mypasar/images/products/" +
productlist[index]['id'] +
                                      ".png",
                                    placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            productlist[index]
                                                    ['prname']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: resWidth * 0.045,
                                                fontWeight: FontWeight.bold)),
                                        Text("RM " +
                                            double.parse(productlist[index]
                                                    ['price'])
                                                .toStringAsFixed(2) +
                                            "  ‐  " +
                                            productlist[index]['guest'] +
                                            " in stock"),
                                      ],
                                    ),
                                  )),
                            ],
                          ));
                        }),
                      ),
                    ),
                  ),
                ],
              ),

          floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => const AddProductScreen()));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      );
  }
  
  void _loadProduct() {
    if (widget.user.email == "na") {
      setState(() {
        titlecenter = "Unregistered User";
      });
      return;
    }
    http.post(Uri.parse(Config.server + "/mypasar/php/display_homestay.php"),
        body: {"userid": widget.user.id}).then((response) {
          var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        setState(() {
          productlist = extractdata["products"];
          print(productlist);
        });
      } else {
        setState(() {
          titlecenter = "No Data";
        });
      }
    });
  }
  }


