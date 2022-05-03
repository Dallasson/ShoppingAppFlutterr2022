

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping/extras/firebase_helper.dart';
import 'package:shopping/models/product_model.dart';

import '../products/edit_seller_product.dart';
import '../products/seller_add_products.dart';
import '../profiles/seller_profile.dart';
import '../screens/selection_screen.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({Key? key}) : super(key: key);

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int currentIndex = 0;
  late FirebaseAuth firebaseAuth;
  List<ProductModel>? list = [];
  List<String> popUpList = [
    "Delete","Edit"
  ];

  @override
  void initState() {
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(() => const AddNewProduct());
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("My Products",style: TextStyle(fontFamily: 'montbold'),),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
             Get.to(() => const SellerProfile());
          }, icon: const Icon(Icons.person)),
          IconButton(onPressed: () async {
             showDialog(
                 context: context,
                 builder: (_){
                   return AlertDialog(
                     title: const Text("Exit!",style: TextStyle(fontFamily: 'montbold'),),
                     content: const Text("Are you sure you want to exit !",style: TextStyle(fontFamily: 'montregular'),),
                     actions: [
                       ElevatedButton(onPressed: () async {
                         var isDeleted = await FirebaseHelper().deleteAllProducts();
                          if(isDeleted){
                            setState(() {
                              list!.clear();
                            });
                            Fluttertoast.showToast(msg: "All Products Deleted Successfully");
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(msg: "Error Occurred");
                            Navigator.pop(context);
                          }
                       }, child: const Text("Yes",style: TextStyle(fontFamily: 'montregular'))),
                       ElevatedButton(onPressed: (){
                         Navigator.pop(context);
                       }, child: const Text("No",style: TextStyle(fontFamily: 'montregular')))
                     ],
                   );
                 });

          }, icon: const Icon(Icons.delete_forever)),
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
          }, icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseHelper().getSellerProducts(),
        builder: (context,data){
          if(data.connectionState == ConnectionState.waiting){
            const Center(child: Text("No Products To Show",style: TextStyle(fontFamily: 'montregular'),),);
          }
          else if (data.connectionState == ConnectionState.active){
            list!.clear();
            if(data.data!.snapshot.exists){
              for(var item in data.data!.snapshot.children){
                var values = item.value as Map<dynamic,dynamic>;
                String productName = values["productName"];
                String productPrice = values["productPrice"];
                String productDiscount = values["productDiscount"];
                String productDescription = values["productDescription"];
                String productImage = values["productImage"];
                String sellerUid = values["sellerUid"];
                String productID = values["productID"];
                String category = values["category"];
                var productModel = ProductModel(productName: productName,productPrice: productPrice,productDiscount: productDiscount,
                    productDescription: productDescription,productImage: productImage,sellerUid: sellerUid,category: category,productId: productID);
                list!.add(productModel);
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: list!.length,
                  itemBuilder: (context,index){
                    currentIndex = index;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child:  Card(
                        elevation: 6,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.network(list![index].productImage!,height: 120,width: 200,fit: BoxFit.cover,),
                                Positioned(
                                    right: -10,
                                    top: -10,
                                    child: IconButton(onPressed: (){
                                      PopupMenuButton(
                                        icon: const Icon(Icons.more_vert_sharp,color: Colors.white,),
                                        itemBuilder: (_){
                                          return List.generate(popUpList.length, (index) {
                                            return PopupMenuItem(
                                              onTap: () async {
                                                if(index == 0){
                                                  //Delete
                                                  var isDeleted = await FirebaseHelper().deleteProductByIndex(list![currentIndex].productId!);
                                                  if(isDeleted){
                                                    Fluttertoast.showToast(msg: "Product Successfully Deleted");
                                                  } else {
                                                    Fluttertoast.showToast(msg: "Error occurred");
                                                  }
                                                }
                                                if(index == 1) {
                                                  Get.to(() =>   SellerEditProduct(productModel: list![currentIndex],));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text(popUpList[index].toString()),
                                            );
                                          });
                                        },
                                      );
                                    },icon: const Icon(Icons.more_vert,))
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: list![index].productDiscount != '0' ? Container(
                                    height: 30,
                                    decoration:  const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(6))
                                    ),
                                    child: Center(child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('- ' + list![index].productDiscount! + '\$'
                                        ,style: const TextStyle(color: Colors.white,fontFamily: 'montregular'),),
                                    )),
                                  ) : Text(''),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(list![index].productName!,maxLines: 1,overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16,fontFamily: 'montbold'),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Price ' + list![index].productPrice! + '\$',
                                style: const TextStyle(color: Colors.red,fontSize: 14,fontFamily: 'montregular'),),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text("No Products To Show",style: TextStyle(fontFamily: 'montregular'),));
            }

          }
          return const Center(child: Text("No Products To Show",style: TextStyle(fontFamily: 'montregular'),));
        },
      ),
    );
  }
}

