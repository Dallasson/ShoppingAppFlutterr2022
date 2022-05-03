
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopping/db/Helper.dart';
import 'package:shopping/db/locator.dart';
import 'package:shopping/models/product_model.dart';
import 'package:shopping/products/product_payment.dart';

class AddProductBasket extends StatefulWidget {
  final ProductModel productModel;
  const AddProductBasket({Key? key, required this.productModel}) : super(key: key);

  @override
  State<AddProductBasket> createState() => _AddProductBasketState();
}

class _AddProductBasketState extends State<AddProductBasket> {
  late AppDatabase appDatabase;
  var totalPrice = 0.0;
  var counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appDatabase  = locator<AppDatabase>();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.productModel.productImage!,height: 250,width: double.infinity,fit: BoxFit.cover,),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.productModel.productName!,style: const TextStyle(fontFamily: 'montregular',fontSize: 16),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.productModel.productPrice! + "\$",
                    style: const TextStyle(fontFamily: 'montbold',fontSize: 17,color: Colors.red),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.productModel.productDescription!,
                    style: const TextStyle(fontFamily: 'montregular',fontSize: 14),),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 130,
                width: 400,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
                ),
                child: Card(
                  elevation: 8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top : 4),
                        child: Container(
                          height: 55,
                          width: 200,
                          decoration: const BoxDecoration(
                              color: Colors.red
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: (){
                                setState(() {
                                  counter++;
                                  totalPrice += double.parse(widget.productModel.productPrice!);
                                });
                              }, icon: const Icon(Icons.add)),
                              Text(counter.toString()),
                              IconButton(onPressed: (){
                                if(counter > 0){
                                  setState(() {
                                    counter--;
                                    totalPrice -= double.parse(widget.productModel.productPrice!);
                                  });
                                }
                              }, icon: const Icon(Icons.add))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top : 4),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(onPressed: () async {
                            if(counter < 1){
                              Fluttertoast.showToast(msg: "Please add an item..");
                            } else {
                              await appDatabase.insertUser(HelperData(
                                  id: DateTime.now().millisecondsSinceEpoch.toInt(),
                                  productImage : widget.productModel.productImage!,
                                  productTitle: widget.productModel.productName!,
                                  productPrice: widget.productModel.productPrice!,
                                  productDescription: widget.productModel.productDescription!,
                                  totalPrice: totalPrice.toString(),
                                  totalQuantity: counter.toString(),
                                  productId: widget.productModel.productId!,
                                  productCategory: widget.productModel.category!));

                              Fluttertoast.showToast(msg: "Item Successfully Added To Car");
                              Get.to(() => const ProductPaymentScreen());
                            }
                          },child: const Text('Add To Basket'),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
