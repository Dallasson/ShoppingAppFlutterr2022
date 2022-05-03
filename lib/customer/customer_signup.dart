import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping/customer/customer_login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping/customer/customer_main.dart';
import 'package:shopping/extras/firebase_helper.dart';
class CustomerSignUp extends StatefulWidget {
  const CustomerSignUp({Key? key}) : super(key: key);

  @override
  State<CustomerSignUp> createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  bool isVisible =  false;
  bool isObsecure = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController shippingAddressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var emailKey = GlobalKey<FormState>();
  var passwordKey = GlobalKey<FormState>();
  var fullNameKey = GlobalKey<FormState>();
  var shippingAddressKey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();
  File? file;

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
                        child: Text("Join The Globe",style: TextStyle(fontSize: 20,fontFamily: 'montregular')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Create Account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,
                            fontFamily: 'montbold.ttf')),
                      ),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: (){
                          pickImage();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: file == null ? Image.asset("assets/images/deal.png",height: 80,width: 80,fit: BoxFit.cover,) :
                          Image.file(file!,height: 80,width: 80,fit: BoxFit.cover,),
                        ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 30),
                child: Form(
                  key: fullNameKey,
                  child: TextFormField(
                    controller: fullNameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Full Name cannot be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Full Name',
                        hintStyle: TextStyle(fontFamily: 'montregular'),
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
                        return "Email Field cannot be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Email',
                        hintStyle: TextStyle(fontFamily: 'montregular'),
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
                        return "Password Field cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontFamily: 'montregular'),
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
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 30),
                child: Form(
                  key: shippingAddressKey,
                  child: TextFormField(
                    controller: shippingAddressController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Shipping Address field cannot be empty";
                      }
                      return null;
                    },
                    decoration:  const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Shipping Address',
                        hintStyle: TextStyle(fontFamily: 'montregular'),
                        prefixIcon: Icon(Icons.security_outlined),

                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    Get.off(() => const CustomerLogin());
                  },
                  child: const Text("Have An Account !",
                    style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'montbold'),),
                ),
              ),
              const SizedBox(height: 30,),
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
                        setState(() {
                          isVisible = true;
                        });
                        String fullName = fullNameController.text.toString();
                        String email = emailController.text.toString();
                        String password = passwordController.text.toString();
                        String shippingAddress = shippingAddressController.text.toString();
                        if(fullNameKey.currentState!.validate() && emailKey.currentState!.validate() && shippingAddressKey.currentState!.validate()
                            &&  passwordKey.currentState!.validate()){
                          if(file != null){
                            var value =  await FirebaseHelper().createCustomerAccount(email,password);
                            if(value.user != null){
                              String imageUrl = await FirebaseHelper().uploadProfileImage(file!);
                              if(imageUrl.isNotEmpty){
                                bool isDone = await FirebaseHelper().signUpCustomer(fullName, email, shippingAddress, imageUrl);
                                if(isDone){
                                  Fluttertoast.showToast(msg: "Account Successfully Registered..");
                                  setState(() {
                                    isVisible = false;
                                  });
                                  Get.off(() => const CustomerMainScreen());
                                }else {
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
                            // show toast
                            setState(() {
                              isVisible = false;
                            });
                          }
                        }
                        else {

                        }

                      }, style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )
                          )
                      ),
                          child: const Text("Sign Up",style: TextStyle(color: Colors.white,fontFamily: 'montbold'),)),
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
