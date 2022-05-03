import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/customer/customer_main.dart';
import 'package:shopping/db/Helper.dart';

import '../db/locator.dart';

class OrderFinishScreen extends StatefulWidget {
  final String map;
  const OrderFinishScreen({Key? key,required this.map}) : super(key: key);

  @override
  State<OrderFinishScreen> createState() => _OrderFinishScreenState();
}

class _OrderFinishScreenState extends State<OrderFinishScreen> {
  late final AppDatabase appDatabase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appDatabase = locator<AppDatabase>();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text("Payment Success",textAlign: TextAlign.center,style: TextStyle(fontFamily: "montregular",fontSize: 25),),
          ),
          const SizedBox(height: 50,),
          Container(
            width: 200,
            decoration:  BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(8)
            ),
            child: FlatButton(onPressed: (){
              //appDatabase.delete(table)
              Get.off(() => const CustomerMainScreen());
            }, child: const Text('Finish',style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
}
