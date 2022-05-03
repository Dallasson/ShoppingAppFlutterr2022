import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../extras/firebase_helper.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({Key? key}) : super(key: key);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {

  TextEditingController shopNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late Map<dynamic,dynamic> map;
  var shopNameKey = GlobalKey<FormState>();
  var emailKey = GlobalKey<FormState>();
  var isVisible = false;
  var isNameEnabled = false;
  var isEmailEnabled = false;
  String previousImg = "";
  File? file;
  ImagePicker imagePicker =  ImagePicker();

  void pickNewImage() async {
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
        body: FutureBuilder<DatabaseEvent>(
          future: FirebaseHelper().getSellerProfile(),
          builder: (context,data){
             if (data.connectionState == ConnectionState.done){
              if(data.data!.snapshot.exists){
                map = data.data!.snapshot.value as Map<dynamic,dynamic>;
                previousImg = map['image'];
                shopNameController.text = map["fullName"];
                emailController.text = map["email"];
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: file == null ? Image.network(map['image'],height: 150,width: 150,fit: BoxFit.cover,) :
                        Image.file(file!,height: 150 , width: 150,fit: BoxFit.cover,)
                    ),
                    const SizedBox(height: 30,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60)
                      ),
                      child:  Card(
                        elevation: 6,
                        child: IconButton(onPressed: (){
                          setState(() {
                            isNameEnabled = true;
                            isEmailEnabled = true;
                          });
                        }, icon: const Icon(Icons.edit)),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: shopNameKey,
                        child : TextFormField(
                          controller: shopNameController,
                          enabled: isNameEnabled,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Full Name Field cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: map["fullName"]
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: emailKey,
                        child : TextFormField(
                          controller: emailController,
                          enabled: isEmailEnabled,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Email Field cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),

                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(onPressed: () async {
                      String shopName = shopNameController.text.toString();
                      String email = emailController.text.toString();
                      if(shopNameKey.currentState!.validate() && emailKey.currentState!.validate()){
                        setState(() {
                          isVisible = true;
                        });
                        if(file != null){
                          var imageUrl = await FirebaseHelper().uploadProfileImage(file!);
                          if(imageUrl.isNotEmpty){
                            var isSaved = await FirebaseHelper().updateSellerProfile(shopName, email,imageUrl);
                            if(isSaved){
                              setState(() {
                                isVisible = false;
                                isNameEnabled = false;
                                isEmailEnabled = false;
                              });
                              Fluttertoast.showToast(msg: "Profile Successfully Updated");
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
                        }
                        else {
                          var isSaved = await FirebaseHelper().updateSellerProfile(shopName, email,previousImg);
                          if(isSaved){
                            setState(() {
                              isVisible = false;
                              isNameEnabled = false;
                              isEmailEnabled = false;
                            });
                            Fluttertoast.showToast(msg: "Profile Successfully Updated");
                          } else {
                            setState(() {
                              isVisible = false;
                            });
                          }
                        }
                      }
                    }, child: const Text("Update")),
                    const SizedBox(height: 30,),
                    Visibility(
                      visible: isVisible,
                      child: const CircularProgressIndicator(),
                    )
                  ],
                ),
              );
            }
            return const Center(child: Text(''),);
          },
        ),
      ),
    );
  }
}
