import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping/customer/customer_login.dart';
import 'package:shopping/products/product_payment.dart';
import 'package:shopping/products/view_all_products.dart';
import 'package:shopping/profiles/customer_profile.dart';
import 'package:shopping/screens/selection_screen.dart';

import '../extras/firebase_helper.dart';
import '../models/product_model.dart';
import '../products/add_product_basket.dart';


class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({Key? key}) : super(key: key);

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  late FirebaseAuth firebaseAuth;
  List<ProductModel>? menList = [];
  List<ProductModel>? womenList = [];
  List<ProductModel>? babiesList = [];
  List<ProductModel>? electronicsList = [];
  @override
  void initState() {
    super.initState();
    firebaseAuth  = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products",style: TextStyle(fontFamily: 'montbold'),),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            Get.to(() => const ProductPaymentScreen());
          }, icon: const Icon(Icons.add_shopping_cart)),
          IconButton(onPressed: (){
            Get.to(() => const CustomerProfile());
          },icon: const Icon(Icons.person),),
          IconButton(onPressed: (){
            showDialog(
                context: context,
                builder: (_){
                  return AlertDialog(
                    title: const Text("Exit!",style: TextStyle(fontFamily: 'montbold'),),
                    content: const Text("Are you sure you want to exit !",style: TextStyle(fontFamily: 'montregular'),),
                    actions: [
                      ElevatedButton(onPressed: (){
                         firebaseAuth.signOut();
                         Get.off(() => const SelectionScreen());
                      }, child: const Text("Yes")),
                      ElevatedButton(onPressed: (){
                         Navigator.pop(context);
                      }, child: const Text("No"))
                    ],
                  );
                });
          }, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text("Men Clothes",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'montbold'),),
              GestureDetector(
                onTap: (){
                  if(menList!.isNotEmpty){
                    Get.to(() =>  ViewAllProducts(list: menList!,));
                  } else {
                    Fluttertoast.showToast(msg: "List is empty or null");
                  }
                },
                child: const Text("View All",style: TextStyle(fontFamily: 'montregular'),),
              )
            ],
          ),
        ),
        Container(
          height: 190,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8)
          ),
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseHelper().getProductsByCategory("Men Clothes"),
            builder: (context,data){
              if(data.hasError){
                return Center(child: Text("Error " + data.error.toString()),);
              } else if (data.connectionState == ConnectionState.active){
                menList!.clear();
                if(data.data!.snapshot.exists){
                  for(var item in data.data!.snapshot.children){
                    var values = item.value as Map<dynamic,dynamic>;
                    String productName = values["productName"];
                    String productPrice = values["productPrice"];
                    String productDiscount = values["productDiscount"];
                    String productDescription = values["productDescription"];
                    String productImage = values["productImage"];
                    String sellerUid = values["sellerUid"];
                    String category = values["category"];
                    String productID = values["productID"];
                    var productModel = ProductModel(productName: productName,productPrice: productPrice,productDiscount: productDiscount,
                        productDescription: productDescription,productImage: productImage,sellerUid: sellerUid,category: category,productId: productID);
                    menList!.add(productModel);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: menList!.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            Get.to(() => AddProductBasket(productModel: menList![index],));
                          },
                          child: Card(
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(menList![index].productImage!,width: 220,height: 100,fit: BoxFit.cover,),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text(menList![index].productName!,overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16,fontFamily: 'montbold'),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(menList![index].productPrice! + '\$',
                                    style: const TextStyle(color: Colors.red,fontSize: 14,fontFamily: 'montregular'),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              return  const Center(child: Text("No Products To Show",style: TextStyle(fontFamily: 'montregular')));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text("Women Clothes",style: TextStyle(fontSize: 16,fontFamily: 'montbold'),),
              GestureDetector(
                onTap: (){
                  if(womenList!.isNotEmpty){
                    Get.to(() =>  ViewAllProducts(list: womenList!,));
                  }
                },
                child: const Text("View All",style: TextStyle(fontFamily: 'montregular'),),
              )
            ],
          ),
        ),
        Container(
          height: 190,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8)
          ),
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseHelper().getProductsByCategory("Women Clothes"),
            builder: (context,data){
              if (data.connectionState == ConnectionState.active){
                womenList!.clear();
                if(data.data!.snapshot.exists){
                  for(var item in data.data!.snapshot.children){
                    var values = item.value as Map<dynamic,dynamic>;
                    String productName = values["productName"];
                    String productPrice = values["productPrice"];
                    String productDiscount = values["productDiscount"];
                    String productDescription = values["productDescription"];
                    String productImage = values["productImage"];
                    String sellerUid = values["sellerUid"];
                    String category = values["category"];
                    String productID = values["productID"];
                    ProductModel productModel = ProductModel(productName: productName,productPrice: productPrice,productDiscount: productDiscount,
                        productDescription: productDescription,productImage: productImage,sellerUid: sellerUid,category: category,productId: productID);
                    womenList!.add(productModel);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: womenList!.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            Get.to(() => AddProductBasket(productModel: womenList![index],));
                          },
                          child: Card(
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(womenList![index].productImage!,width: 220,height: 100,fit: BoxFit.cover,),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text(womenList![index].productName!,overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16,fontFamily: 'montbold'),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(womenList![index].productPrice!+ '\$',
                                    style: const TextStyle(color: Colors.red,fontSize: 14,fontFamily: 'montregular'),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

              }
              return const Center(child: Text("No Products To Show",style: TextStyle(fontFamily: 'montregular'),),);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text("Babies",style: TextStyle(fontSize: 16,fontFamily: 'montbold'),),
              GestureDetector(
                onTap: (){
                  if(babiesList!.isNotEmpty){
                    Get.to(() =>  ViewAllProducts(list: babiesList!,));
                  }
                },
                child: const Text("View All",style: TextStyle(fontFamily: 'montregular'),),
              )
            ],
          ),
        ),
        Container(
          height: 190,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8)
          ),
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseHelper().getProductsByCategory("Babies"),
            builder: (context,data){
              if (data.connectionState == ConnectionState.active){
                babiesList!.clear();
                if(data.data!.snapshot.exists){
                  for(var item in data.data!.snapshot.children){
                    var values = item.value as Map<dynamic,dynamic>;
                    String productName = values["productName"];
                    String productPrice = values["productPrice"];
                    String productDiscount = values["productDiscount"];
                    String productDescription = values["productDescription"];
                    String productImage = values["productImage"];
                    String sellerUid = values["sellerUid"];
                    String category = values["category"];
                    String productID = values["productID"];
                    ProductModel productModel = ProductModel(productName: productName,productPrice: productPrice,productDiscount: productDiscount,
                        productDescription: productDescription,productImage: productImage,sellerUid: sellerUid,category: category,productId: productID);
                    babiesList!.add(productModel);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: babiesList!.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            Get.to(() => AddProductBasket(productModel: babiesList![index],));
                          },
                          child: Card(
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(babiesList![index].productImage!,width: 220,height: 100,fit: BoxFit.cover,),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text(babiesList![index].productName!,overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16,fontFamily: 'montbold'),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(babiesList![index].productPrice!+ '\$',
                                    style: const TextStyle(color: Colors.red,fontSize: 14,fontFamily: 'montregular'),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              return const Center(child: Text("No Products To Show",style: TextStyle(fontFamily: 'montregular')),);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text("Electronics",style: TextStyle(fontSize: 16,fontFamily: 'montbold'),),
              GestureDetector(
                onTap: (){
                  if(electronicsList!.isNotEmpty){
                    Get.to(() =>  ViewAllProducts(list: electronicsList!,));
                  }
                },
                child: const Text("View All",style: TextStyle(fontFamily: 'montregular'),),
              )
            ],
          ),
        ),
        Container(
          height: 190,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8)
          ),
          child: StreamBuilder<DatabaseEvent>(
            stream: FirebaseHelper().getProductsByCategory("Electronics"),
            builder: (context,data){
              if (data.connectionState == ConnectionState.active){
                electronicsList!.clear();
                if(data.data!.snapshot.exists){
                  for(var item in data.data!.snapshot.children){
                    var values = item.value as Map<dynamic,dynamic>;
                    String productName = values["productName"];
                    String productPrice = values["productPrice"];
                    String productDiscount = values["productDiscount"];
                    String productDescription = values["productDescription"];
                    String productImage = values["productImage"];
                    String sellerUid = values["sellerUid"];
                    String category = values["category"];
                    String productID = values["productID"];
                    ProductModel productModel = ProductModel(productName: productName,productPrice: productPrice,productDiscount: productDiscount,
                        productDescription: productDescription,productImage: productImage,sellerUid: sellerUid,category: category,productId: productID);
                    electronicsList!.add(productModel);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: electronicsList!.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            Get.to(() => AddProductBasket(productModel: electronicsList![index],));
                          },
                          child: Card(
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(electronicsList![index].productImage!,width: 220,height: 100,fit: BoxFit.cover,),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text(electronicsList![index].productName!,overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16,fontFamily: 'montbold'),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(electronicsList![index].productPrice!+ '\$',
                                    style: const TextStyle(color: Colors.red,fontSize: 14,fontFamily: 'montregular'),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

              }
              return const Center(child: Text("No Products To Show",style: TextStyle(fontFamily: 'montregular')),);
            },
          ),
        ),
      ],
     ),
    ),
    );
  }
}
