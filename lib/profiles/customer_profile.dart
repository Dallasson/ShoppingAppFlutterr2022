import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/extras/firebase_helper.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController shippingController = TextEditingController();

  var nameKey = GlobalKey<FormState>();
  var emailKey = GlobalKey<FormState>();
  var shippingKey = GlobalKey<FormState>();
  var isVisible = false;
  var isNameEnabled = false;
  var isEmailEnabled = false;
  var isShippingEnabled = false;
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
          future: FirebaseHelper().getCustomerProfile(),
          builder: (context,data){
             if (data.connectionState == ConnectionState.done){
              if(data.data!.snapshot.exists){
                var map = data.data!.snapshot.value as Map<dynamic,dynamic>;
                previousImg = map['image'];
                fullNameController.text = map["fullName"];
                emailController.text = map["email"];
                shippingController.text = map["shippingAddress"];
                return Column(
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
                            isShippingEnabled = true;
                          });
                        }, icon: const Icon(Icons.edit)),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: nameKey,
                        child : TextFormField(
                          controller: fullNameController,
                          enabled: isNameEnabled,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Full Name Field cannot be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),

                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),

                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: shippingKey,
                        child : TextFormField(
                          controller: shippingController,
                          enabled: isShippingEnabled,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Shipping Field cannot be empty';
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
                       String fullName = fullNameController.text.toString();
                       String email = emailController.text.toString();
                       String shippingAddress = shippingController.text.toString();
                       if(nameKey.currentState!.validate() && emailKey.currentState!.validate() && shippingKey.currentState!.validate()){
                         setState(() {
                           isVisible = true;
                         });
                         if(file != null){
                           var imageUrl = await FirebaseHelper().uploadProfileImage(file!);
                           if(imageUrl.isNotEmpty){
                               var isSaved = await FirebaseHelper().updateCustomerProfile(fullName, email, shippingAddress, imageUrl);
                               if(isSaved){
                                  setState(() {
                                    isVisible = false;
                                    isNameEnabled = false;
                                    isEmailEnabled = false;
                                    isShippingEnabled = false;
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
                         } else {
                           var isSaved = await FirebaseHelper().updateCustomerProfile(fullName, email, shippingAddress, previousImg);
                           if(isSaved){
                             setState(() {
                               isVisible = false;
                               isNameEnabled = false;
                               isEmailEnabled = false;
                               isShippingEnabled = false;
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
                );
              }
            }
            return const Center(child: Text(''),);
          },
        ),
      ),
    );
  }
}
