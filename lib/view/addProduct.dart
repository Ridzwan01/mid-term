import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/Config.dart';
import 'package:homestay_raya/view/mainScreen.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final TextEditingController _homestaynameEditingController      = TextEditingController();
  final TextEditingController _homestaydescEditingController      = TextEditingController();
  final TextEditingController _homestaypriceEditingController     = TextEditingController();
  final TextEditingController _homestayguestEditingController     = TextEditingController();
  final TextEditingController _homestayaddressEditingController   = TextEditingController();
  final TextEditingController _homestaystateEditingController     = TextEditingController();
  final TextEditingController _homestaylocalEditingController     = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _lat, _lng;

  File? _image;
  var pathAsset = "assets/images/plus2.png"; 
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add New Homestay",
                style: TextStyle(
                fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

              GestureDetector(
              onTap: _selectImageDialog,
              child: Card(
                elevation: 8,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image!) as ImageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
                  
              Divider(),
              
              Container(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _homestaynameEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Homestay Name must be longer than 3"
                          : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Homestay Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.house),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),
                      
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _homestaydescEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Homestay description must be longer than 10"
                          : null,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Homestay Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.description),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),

                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _homestayaddressEditingController,
                        validator: (val) => val!.isEmpty || (val.length < 10)
                          ? "Homestay Address must be longer than 10"
                          : null,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Homestay Address',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.description),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          )
                        ),
                      ),

                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _homestaypriceEditingController,
                              validator: (val) => val!.isEmpty
                                ? "Product price must contain value"
                                : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.money),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _homestayguestEditingController,
                              validator: (val) => val!.isEmpty
                                ? "Guest quantity should be more than 0"
                                : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Guest',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.person),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _homestaystateEditingController,
                              validator: (val) => val!.isEmpty
                                ? "Current state"
                                : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'State',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _homestaylocalEditingController,
                              validator: (val) => val!.isEmpty
                                ? "Current Locality"
                                : null,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Locality',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(),

            MaterialButton(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
              minWidth: 100,
              height: 40,
              elevation: 10,
              onPressed: _addHomestay,
              color: Theme.of(context).colorScheme.primary,
              child: const Text('Add'),
            ),
          ]
        ),
      )
    );
  }

  void _addHomestay() {
    
    String _name        = _homestaynameEditingController.text;
    String _desc        = _homestaydescEditingController.text;
    String _price       = _homestaypriceEditingController.text;
    String _guest       = _homestayguestEditingController.text;
    String _address     = _homestayaddressEditingController.text;
    String _state       = _homestaystateEditingController.text;
    String _local       = _homestaylocalEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
  
      http.post(
        Uri.parse("${Config.server}/homestay_raya/mobile/php/add_homestay.php"),
      body: {
        "name": _name,"desc":_desc, "price":_price, "guest": _guest, "address":_address, "state":_state, "local":_local, "image": base64Image
        })
      .then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
            msg: "Success registered",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
            Navigator.of(context).pop();
          return;
        } 
      });

  }

  Future<void> _onGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }   

  void _selectImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select picture from:",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 64,
                    onPressed: _onCamera,
                    icon: const Icon(Icons.camera)),
                IconButton(
                    iconSize: 64,
                    onPressed: _onGallery,
                    icon: const Icon(Icons.browse_gallery)),
              ],
            ));
      },
    );
  }

  Future<void> _onCamera() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

}