import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/models/product_model.dart';
import 'package:shopping/products/add_product_basket.dart';

class ViewAllProducts extends StatefulWidget {
  final List<ProductModel> list;

  const ViewAllProducts({Key? key, required this.list}) : super(key: key);

  @override
  State<ViewAllProducts> createState() => _ViewAllProductsState();
}

class _ViewAllProductsState extends State<ViewAllProducts> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Any Value  " + widget.list[0].category!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('All Items',style: TextStyle(fontSize: 22,fontFamily: 'montbold'),),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 200,
              child: GridView.builder(
                itemCount: widget.list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Get.to(() => AddProductBasket(productModel: widget.list[index],));
                    },
                    child: Card(
                      elevation: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            widget.list[index].productImage!, width: 200,
                            height: 130,
                            fit: BoxFit.cover,),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              widget.list[index].productName!, maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'montbold'),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              widget.list[index].productPrice! + '\$',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14,fontFamily: 'montregular'),),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
