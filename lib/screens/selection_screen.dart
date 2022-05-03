import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/customer/customer_login.dart';
import 'package:shopping/customer/customer_main.dart';
import 'package:shopping/seller/seller_login.dart';
import 'package:shopping/seller/seller_main.dart';

import '../extras/utils.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  late FirebaseAuth firebaseAuth;
  late FirebaseDatabase firebaseDatabase;
  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseDatabase = FirebaseDatabase.instanceFor(app: Firebase.app(),databaseURL: Utils().DATABASE_URL);

  }

  void getCustomerInfo(){
    if(firebaseAuth.currentUser != null) {
      firebaseDatabase
          .ref()
          .child("Customers")
          .child(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) {
           if(value.exists){
             var values = value.value as Map<dynamic, dynamic>;
             var uid = values['uid'];
             if (uid == firebaseAuth.currentUser!.uid) {
               Get.to(() => const CustomerMainScreen());
             } else {
               Get.to(() => const CustomerLogin());
             }
           } else {
             Get.to(() => const CustomerLogin());
           }
      });
    } else {
      Get.to(() => const CustomerLogin());
    }
  }
  void getSellerInfo(){
    if(firebaseAuth.currentUser != null) {
      firebaseDatabase
          .ref()
          .child("Sellers")
          .child(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) {
           if(value.exists){
             var values = value.value as Map<dynamic, dynamic>;
             var uid = values['uid'];
             if (uid == firebaseAuth.currentUser!.uid) {
               Get.to(() => const SellerMainScreen());
             } else {
               Get.to(() => const SellerLogin());
             }
           } else {
             Get.to(() => const SellerLogin());
           }
      });
    } else {
      Get.to(() => const SellerLogin());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children:  [
            const SizedBox(height: 20,),
            const Center(child: Text("Select Your Type",style: TextStyle(fontFamily: 'lato',fontSize: 19),),),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: Colors.indigo)
                    ),
                    child: FlatButton(onPressed: (){
                      getCustomerInfo();
                    }, child:  const Text("Customer",style: TextStyle(fontFamily: 'lato',fontSize: 19)),),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(color: Colors.indigo)
                    ),
                    child: FlatButton(onPressed: (){
                      getSellerInfo();
                    }, child: const Text("Seller",style: TextStyle(fontFamily: 'lato',fontSize: 19,)),),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
/*

 */