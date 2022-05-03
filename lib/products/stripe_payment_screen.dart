import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/db/Helper.dart';
import 'package:shopping/products/order_finish_screen.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripePaymentScreen extends StatefulWidget {
  final List<HelperData> list;
  final String totalPrice;
  const StripePaymentScreen({Key? key,required this.list,required this.totalPrice}) : super(key: key);

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  static String secret = 'sk_test_51IVasBFP6YK87V1sTrKbMuwQYmPC6ykldO9fbabCoZQ2O7BjpHuleUECnJ5KWr5BpTBRR3Ji77801GUxIUc3Bjbx00RHTmROSZ';

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expYearController = TextEditingController();
  TextEditingController expMonthController = TextEditingController();

  @override
  initState() {
    super.initState();

    StripePayment.setOptions(
        StripeOptions(
            publishableKey: "pk_test_51IVasBFP6YK87V1sCbMrswWJDG0nl4qdHUBsvzWqbDAKS4UwPTL5MKR1hulV26gQTYgRFPsZqk9zlg0Cw7RCA0Vc00Lzgmtm5n",
            merchantId: "Test",
            androidPayMode: 'test')
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/card.png",height: 100,width: 100,color: Colors.indigo,),
            const SizedBox(height: 30,),
            const Center(child: Text("Add Payment Card Info",style:  TextStyle(fontFamily: 'montbold',fontSize: 20),),),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Card Number',labelStyle: TextStyle(fontFamily: 'montregular')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: expMonthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expired Month',labelStyle: TextStyle(fontFamily: 'montregular')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: expYearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expired Year',labelStyle: TextStyle(fontFamily: 'montregular')),
              ),
            ),
            const SizedBox(height: 50,),
            RaisedButton(
              child: const Text('card'),
              onPressed: () {
                final CreditCard testCard =  CreditCard(
                    number: cardNumberController.text,
                    expMonth: int.parse(expMonthController.text),
                    expYear: int.parse(expYearController.text)
                );

                StripePayment.createTokenWithCard(testCard).then((token) {
                  print(token.tokenId);
                  createCharge(token.tokenId!,widget.totalPrice,widget.list).then((value) => {
                      Get.to(() =>  OrderFinishScreen(map: value!['id']!))
                  });
                });
              },)
          ],
        ),
      ),
    );
  }

  static Future<Map<String,dynamic>?> createCharge(String tokenId,String totalPrice,List<HelperData> list) async {
    try {
      Map<String, dynamic> body = {
        'amount': totalPrice,
        'currency': 'usd',
        'source': tokenId,
        'description': 'Successful Purchase'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/charges'),
          body: body,
          headers: { 'Authorization': 'Bearer ${secret}','Content-Type': 'application/x-www-form-urlencoded'}
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}