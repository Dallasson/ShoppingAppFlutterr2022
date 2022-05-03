import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/extras/firebase_helper.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  String dropdownValue = "Babies";
  List<String> categories = [
    "Babies",
    "Men Clothes",
    "Women Clothes",
    "Electronics"
  ];
  bool isVisible = false;
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDiscount = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  var nameKey = GlobalKey<FormState>();
  var priceKey = GlobalKey<FormState>();
  var discountKey = GlobalKey<FormState>();
  var descriptionKey = GlobalKey<FormState>();
  File? file;
  ImagePicker imagePicker =  ImagePicker();

  void pickProductImage() async {
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  pickProductImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: file == null ? Image.asset("assets/images/deal.png",height: 120,width: 120,fit: BoxFit.cover,) :
                  Image.file(file!,height: 120,width: 120,fit: BoxFit.cover,),
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: nameKey,
                  child: TextFormField(
                    controller: productName,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Product Name cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      hintText: 'Product Name',
                      hintStyle: TextStyle(fontFamily: 'montregular')
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: priceKey,
                  child: TextFormField(
                    controller: productPrice,
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Product Price cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Product Price',
                        hintStyle: TextStyle(fontFamily: 'montregular')
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: discountKey,
                  child: TextFormField(
                    controller: productDiscount,
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Product Discount cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      hintText: 'Product Discount',
                        hintStyle: TextStyle(fontFamily: 'montregular')
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black38, fontSize: 18),
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    onChanged: (data) {
                      setState(() {
                        dropdownValue = data.toString();
                      });
                    },  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: const TextStyle(fontFamily: 'montregular'),),
                    );
                  }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: descriptionKey,
                  child: TextFormField(
                    controller: productDescription,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Product Description cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Product Description',
                        hintStyle: TextStyle(fontFamily: 'montregular')
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50,),
              ElevatedButton(onPressed: () async {
                String name = productName.text.toString();
                String price = productPrice.text.toString();
                String discount = productDiscount.text.toString();
                String description = productDescription.text.toString();
                String productID = DateTime.now().millisecondsSinceEpoch.toString();
                setState(() {
                  isVisible = true;
                });
                if(nameKey.currentState!.validate() &&  priceKey.currentState!.validate() && discountKey.currentState!.validate()
                && descriptionKey.currentState!.validate()){
                  if(dropdownValue.isNotEmpty){
                    if(file != null){
                      String imageUrl = await FirebaseHelper().uploadProductImage(file!);
                      if(imageUrl.isNotEmpty){
                        var isDone = await FirebaseHelper().addNewProduct(name, price, description, discount, productID,imageUrl,dropdownValue);
                        if(isDone){
                          setState(() {
                            isVisible = false;
                          });
                          Fluttertoast.showToast(msg: "Product Successfully Added..");
                          productName.clear();
                          productPrice.clear();
                          productDiscount.clear();
                          productDescription.clear();
                          file = null;
                        } else {
                          setState(() {
                            isVisible = false;
                          });
                        }
                      } else {
                        setState(() {
                          isVisible = false;
                        });
                      }
                    } else {
                      setState(() {
                        isVisible = false;
                      });
                    }
                  } else {
                    setState(() {
                      isVisible = false;
                    });
                  }

                } else{
                  setState(() {
                    isVisible = false;
                  });
                }
              }, child: const Text('Add Product',style: TextStyle(fontFamily: 'montbold'),)),
              const SizedBox(height: 30,),
              Visibility(
                visible: isVisible,
                child: const CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
