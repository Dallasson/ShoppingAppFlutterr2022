import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/extras/firebase_helper.dart';
import 'package:shopping/seller/seller_login.dart';
import 'package:shopping/seller/seller_main.dart';

class SellerSignup extends StatefulWidget {
  const SellerSignup({Key? key}) : super(key: key);

  @override
  State<SellerSignup> createState() => _SellerSignupState();
}

class _SellerSignupState extends State<SellerSignup> {
  bool isVisible = false;
  bool isObsecure = true;
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var emailKey = GlobalKey<FormState>();
  var passwordKey = GlobalKey<FormState>();
  var shopNameKey = GlobalKey<FormState>();
  File? file;
  ImagePicker imagePicker = ImagePicker();


  void pickImage() async {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset("assets/images/deal.png"),
              ),),
              const SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Join The Globe",style: TextStyle(fontSize: 20,fontFamily : 'montregular')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Create Account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,
                            fontFamily : 'montbold')),
                      ),
                    ],
                  )),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: (){
                          pickImage();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: file == null ? Image.asset("assets/images/deal.png",height: 80,width: 80,fit: BoxFit.cover,) :
                          Image.file(file!,height: 80,width: 80,fit: BoxFit.cover,),
                        ),
                      )
                  )
                ],
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 30),
                child: Form(
                  key: shopNameKey,
                  child: TextFormField(
                    controller: shopNameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Shop Name field cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Shop Name',
                        hintStyle: TextStyle(fontFamily : 'montregular'),
                        prefixIcon: Icon(Icons.security_outlined)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 30),
                child: Form(
                  key: emailKey,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Email field cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        hintStyle: TextStyle(fontFamily : 'montregular'),
                        prefixIcon: Icon(Icons.email)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 30),
                child: Form(
                  key: passwordKey,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: isObsecure,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Password field cannot be empty';
                      }
                      return null;
                    },
                    decoration:  InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontFamily : 'montregular'),
                        prefixIcon: const Icon(Icons.security_outlined),
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            isObsecure = !isObsecure;
                          });
                        }, icon: const Icon(Icons.remove_red_eye))
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    Get.off(() => const SellerLogin());
                  },
                  child: const Text("Have An Account !",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,
                      fontFamily : 'montbold'),),
                ),
              ),
              const SizedBox(height: 95,),
              Row(
                children: [
                  Container(
                    width : 350,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child :  Padding(
                      padding: const EdgeInsets.only(top: 8,bottom: 8,left: 8,right: 100),
                      child: ElevatedButton(onPressed: () async {
                        String shopName = shopNameController.text.toString();
                        String email = emailController.text.toString();
                        String password = passwordController.text.toString();
                        setState(() {
                          isVisible = true;
                        });
                        if(shopNameKey.currentState!.validate() && emailKey.currentState!.validate() &&
                            passwordKey.currentState!.validate()){
                          if(file != null){
                            var user = await FirebaseHelper().createSellerAccount(email, password);
                            if(user.user != null){
                              String imageUrl = await FirebaseHelper().uploadProfileImage(file!);
                              if(imageUrl.isNotEmpty){
                                var isDone = await FirebaseHelper().signUpSeller(shopName, email, imageUrl);
                                if(isDone){
                                  Fluttertoast.showToast(msg: "Account Successfully Created..");
                                  setState(() {
                                    isVisible = false;
                                  });
                                  Get.off(() => const SellerMainScreen());
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
                            Fluttertoast.showToast(msg: "Please pick an image");
                          }

                        }

                      }, style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )
                          )
                      ),
                          child: const Text("Sign Up",style: TextStyle(color: Colors.white,fontFamily : 'montbold'),)),
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: const CircularProgressIndicator(
                      color: Colors.indigo,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
