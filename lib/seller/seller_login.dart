import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/extras/firebase_helper.dart';
import 'package:shopping/seller/seller_main.dart';
import 'package:shopping/seller/seller_password.dart';
import 'package:shopping/seller/seller_signup.dart';
class SellerLogin extends StatefulWidget {
  const SellerLogin({Key? key}) : super(key: key);

  @override
  State<SellerLogin> createState() => _SellerLoginState();
}

class _SellerLoginState extends State<SellerLogin> {
  bool isVisible = false;
  bool isObsecure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var emailKey = GlobalKey<FormState>();
  var passwordKey = GlobalKey<FormState>();
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
              const SizedBox(height: 70,),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Welcome Back",style: TextStyle(fontSize: 20,fontFamily : 'montregular')),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Account Log-In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26,fontFamily : 'montbold')),
              ),
              const SizedBox(height: 30,),
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
                    Get.to(() => const SellerPasswordScreen());
                  },
                  child: const Text("Forgot Password",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,
                      fontFamily : 'montbold'),),
                ),
              ),
              const SizedBox(height: 30,),
              Center(
                child: GestureDetector(
                  onTap: (){
                    Get.to(() => const SellerSignup());
                  },
                  child: const Text("Create New Account",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,
                      fontFamily : 'montbold'),),
                ),
              ),
              const SizedBox(height: 90,),
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
                        String email = emailController.text.toString();
                        String password = passwordController.text.toString();
                        setState(() {
                          isVisible = true;
                        });

                        if(emailKey.currentState!.validate() &&  passwordKey.currentState!.validate()){
                          var user = await FirebaseHelper().signInSeller(email, password);
                          if(user.user != null){
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

                      }, style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )
                          )
                      ),
                          child: const Text("Log In",style: TextStyle(color: Colors.white,fontFamily : 'montbold'),)),
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
