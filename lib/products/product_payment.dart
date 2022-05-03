import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping/db/Helper.dart';
import 'package:shopping/db/locator.dart';
import 'package:shopping/extras/firebase_helper.dart';
import 'package:shopping/products/stripe_payment_screen.dart';



class ProductPaymentScreen extends StatefulWidget {
  const ProductPaymentScreen({Key? key}) : super(key: key);

  @override
  State<ProductPaymentScreen> createState() => _ProductPaymentScreenState();
}

class _ProductPaymentScreenState extends State<ProductPaymentScreen> {
  late AppDatabase appDatabase;
  var totalPrice = 0.0;
  late List<HelperData> list;
  @override
  void initState() {
    super.initState();
    appDatabase = locator<AppDatabase>();
    getTotalPrice();
  }

  void getTotalPrice(){
    appDatabase.getAllUsers().then((value){
      for (var element in value) {
        setState(() {
          totalPrice += double.parse(element.totalPrice);
        });
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 const Padding(
                  padding: EdgeInsets.all(8.0),
                  child:  Text("Payment",style: TextStyle(fontSize: 20,fontFamily: 'montbold'),),
                ),
                 IconButton(onPressed: (){
                   // delete all items
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Removing Items'),
                            content: const Text('Are you sure you want to remove all items!'),
                            actions: [
                              ElevatedButton(onPressed: () async {
                                // delete all items
                                if(list.isNotEmpty){
                                  await appDatabase.deleteAllProducts();
                                  setState(() {
                                    list.clear();
                                  });
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(msg: 'No items to delete ..');
                                  Navigator.pop(context);
                                }

                              }, child: const Text("Yes")),
                              ElevatedButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: const Text("No"))
                            ],
                          );
                        });
                 }, icon: const Icon(Icons.delete_forever)),
              ],
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder<List<HelperData>>(
                future: appDatabase.getAllUsers(),
                builder: (context,data){
                  if(data.hasError){
                    return const Center(child: Text("No Items In The Basket",style: TextStyle(fontFamily: 'montregular'),),);
                  } else if (data.connectionState == ConnectionState.done){
                    list = data.data!;
                    if(list.isNotEmpty){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context,index){
                            return Dismissible(
                                key: Key(list[index].productId),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (direction){
                                  setState(() {
                                    list.removeAt(index);
                                    totalPrice -= double.parse(list[index].totalPrice);
                                  });
                                  Fluttertoast.showToast(msg: 'Item Successfully Dismissed');
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(list[index].productImage,height: 80,width: 80,),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 280,
                                            child: Text(list[index].productTitle,style: const
                                            TextStyle(fontSize: 16,fontFamily: 'montbold',overflow: TextOverflow.ellipsis),maxLines: 1,),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('Quantity : ' + list[index].totalQuantity,style: const TextStyle(fontSize: 14,fontFamily: 'montregular'),),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text('Total : ' + list[index].totalPrice + '\$',style: const TextStyle(fontSize: 14,fontFamily: 'montregular',color: Colors.red),),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                          },
                        ),
                      );
                    }  else {
                      return const Center(child: Text("No Items In The Basket",style: TextStyle(fontFamily: 'montregular'),),);
                    }
                  }
                  return const Center(child: Text("No Items In The Basket"),);
                },
              ),
            ),
            Container(
              height: 100,
              width: 400,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
              ),
              child: Card(
                elevation: 8,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top : 8),
                      child: Text("Total Price : " + totalPrice.toString().substring(0,totalPrice.toString().indexOf('.')) + '\$',style: const TextStyle(fontFamily: 'montbold',fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top : 8),
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(onPressed: () async {
                          var list = await appDatabase.getAllUsers();
                          if(list.isNotEmpty){
                            Get.to(() =>  StripePaymentScreen(
                              list: list,
                              totalPrice: totalPrice.toString().substring(0,totalPrice.toString().indexOf('.')),));
                          } else {
                            Fluttertoast.showToast(msg: 'No Items in the basket');
                          }
                        },child: const Text('Pay Now'),),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
