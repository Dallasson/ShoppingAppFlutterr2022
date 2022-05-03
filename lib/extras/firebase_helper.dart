import 'dart:collection';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shopping/extras/utils.dart';

import '../db/Helper.dart';


class FirebaseHelper {

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    late FirebaseDatabase firebaseDatabase = FirebaseDatabase.instanceFor(app: Firebase.app(),databaseURL: Utils().DATABASE_URL);
    late Reference firebaseStorage;

    Future<bool> signUpCustomer(String fullName , String email , String shippingAddress,String image) async{
        try{

            var hashMap = HashMap<String,Object>();
            hashMap["fullName"] = fullName;
            hashMap["email"] = email;
            hashMap["shippingAddress"] = shippingAddress;
            hashMap["image"] = image;
            hashMap["uid"] = firebaseAuth.currentUser!.uid;

            await firebaseDatabase
                 .ref()
                 .child("Customers")
                 .child(firebaseAuth.currentUser!.uid)
                 .set(hashMap);

            return true;
        }on FirebaseException catch(e){
            return false;
        }
    }
    Future<bool> signUpSeller(String fullName , String email , String image) async{
        try{
            var hashMap = HashMap<String,Object>();
            hashMap["fullName"] = fullName;
            hashMap["email"] = email;
            hashMap["image"] = image;
            hashMap["uid"] = firebaseAuth.currentUser!.uid;

            await firebaseDatabase
                .ref()
                .child("Sellers")
                .child(firebaseAuth.currentUser!.uid)
                .set(hashMap);

            return true;
        }on FirebaseException catch(e){
            return false;
        }
    }

    Future<UserCredential> createCustomerAccount(String email , String password) async {
        return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }
    Future<UserCredential> createSellerAccount(String email , String password) async {
        return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }

    Future<UserCredential> signInCustomer(String email , String password) async {
        return  await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }
    Future<UserCredential> signInSeller(String email , String password) async {
        return  await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }

    Future<String> uploadProfileImage(File file) async {
        try {
            firebaseStorage = FirebaseStorage.instance.ref().child("images");
            TaskSnapshot taskSnapshot =  await firebaseStorage.child(firebaseAuth.currentUser!.uid)
                .child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(file);
            return await taskSnapshot.ref.getDownloadURL();
        } on FirebaseException catch(e){
            return "";
        }
    }

    Future<bool> recoverUserPassword(String email) async {
        try{
            firebaseAuth.sendPasswordResetEmail(email: email);
            return true;
        } on FirebaseException catch(e){
            return false;
        }
    }

    /// PRODUCTS SECTION
    Future<String> uploadProductImage(File file) async {
        try {
            firebaseStorage = FirebaseStorage.instance.ref().child("products");
            TaskSnapshot taskSnapshot =  await firebaseStorage.child(firebaseAuth.currentUser!.uid)
                .child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(file);
            return await taskSnapshot.ref.getDownloadURL();

        } on FirebaseException catch(e){
            return "";
        }
    }
    Future<bool> addNewProduct(String productName,String productPrice,String productDescription
        ,String productDiscount,String productID,String productImage,String category) async{
        try{
            var productMap = HashMap<String,Object>();
            productMap["productName"] = productName;
            productMap["productPrice"] = productPrice;
            productMap["productDescription"] = productDescription;
            productMap["productDiscount"] = productDiscount;
            productMap["productID"] = productID;
            productMap["sellerUid"] = firebaseAuth.currentUser!.uid;
            productMap["productImage"] = productImage;
            productMap["category"] = category;

            firebaseDatabase
            .ref()
            .child("products")
            .child(productID)
            .set(productMap);
            return true;
        }on FirebaseException catch(e){
            return false;
        }
    }
    Future<bool> updateProduct(String productName,String productPrice,String productDescription
        ,String productDiscount,String productID,String productImage,String category) async{
        try{
            var productMap = HashMap<String,Object>();
            productMap["productName"] = productName;
            productMap["productPrice"] = productPrice;
            productMap["productDescription"] = productDescription;
            productMap["productDiscount"] = productDiscount;
            productMap["productID"] = productID;
            productMap["sellerUid"] = firebaseAuth.currentUser!.uid;
            productMap["productImage"] = productImage;
            productMap["category"] = category;

            firebaseDatabase
                .ref()
                .child("products")
                .child(firebaseAuth.currentUser!.uid)
                .child(productID)
                .update(productMap);
            return true;
        }on FirebaseException catch(e){
            return false;
        }
    }


    Stream<DatabaseEvent> getProductsByCategory(String category) {
       return firebaseDatabase.ref().child("products").orderByChild('category').equalTo(category).onValue;
    }
    Stream<DatabaseEvent> getSellerProducts()  {
        return firebaseDatabase.ref().child('products').orderByChild('sellerUid').equalTo(firebaseAuth.currentUser!.uid).onValue;
    }
    
    /*
    Stream<DatabaseEvent> getSellerProducts()  {
        return firebaseDatabase.ref().child("products").orderByChild('sellerUid').equalTo(firebaseAuth.currentUser!.uid).onValue;
    }
     */
    Future<bool> deleteAllProducts() async {
        try{
            firebaseDatabase
                .ref()
                .child("products")
                .child(firebaseAuth.currentUser!.uid)
                .remove();
            return true;
        } on FirebaseException catch(e){
            return false;
        }
    }
    Future<bool> deleteProductByIndex(String productId) async {
        try{
            firebaseDatabase
                .ref()
                .child("products")
                .child(firebaseAuth.currentUser!.uid)
                .child(productId)
                .remove();
            return true;
        } on FirebaseException catch(e){
            return false;
        }
    }
    
    
    /// PROFILE SECTION
    Future<DatabaseEvent> getCustomerProfile() async {
        return firebaseDatabase.ref().child("Customers").child(firebaseAuth.currentUser!.uid).once();
    }
    Future<DatabaseEvent> getSellerProfile() async {
        return firebaseDatabase.ref().child("Sellers").child(firebaseAuth.currentUser!.uid).once();
    }

    Future<bool> updateCustomerProfile(String fullName,String email,String shippingAddress , String imageUrl) async {

        try{
            var hashMap = HashMap<String,Object>();
            hashMap["fullName"] = fullName;
            hashMap["email"] = email;
            hashMap["shippingAddress"] = shippingAddress;
            hashMap["image"] = imageUrl;
            hashMap["uid"] = firebaseAuth.currentUser!.uid;

            await firebaseDatabase
                .ref()
                .child("Customers")
                .child(firebaseAuth.currentUser!.uid)
                .set(hashMap);

            return true;
        } on FirebaseException catch(e){
            return false;
        }
    }
    Future<bool> updateSellerProfile(String shopName,String email, String imageUrl) async {

        try{
            var hashMap = HashMap<String,Object>();
            hashMap["fullName"] = shopName;
            hashMap["email"] = email;
            hashMap["image"] = imageUrl;
            hashMap["uid"] = firebaseAuth.currentUser!.uid;

            await firebaseDatabase
                .ref()
                .child("Sellers")
                .child(firebaseAuth.currentUser!.uid)
                .update(hashMap);
            return true;
        } on FirebaseException catch(e){
            return false;
        }
    }

    Future<bool> persistOrder(List<HelperData> list,String totalPrice) async {
        try{
            var map = HashMap<String,Object>();
            map["lis"] = list;
            map["total"] = totalPrice;

            firebaseDatabase
            .ref()
            .child("orders")
            .child(firebaseAuth.currentUser!.uid)
            .child("amel")
            .set(map);

            firebaseDatabase
                .ref()
                .child("orders")
                .child("taki")
                .child(firebaseAuth.currentUser!.uid)
                .set(map);
            return true;
        }on FirebaseException catch(e){
            return false;
        }
    }
    
}
