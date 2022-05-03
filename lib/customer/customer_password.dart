import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopping/extras/firebase_helper.dart';

class CustomerPasswordScreen extends StatefulWidget {
  const CustomerPasswordScreen({Key? key}) : super(key: key);

  @override
  State<CustomerPasswordScreen> createState() => _CustomerPasswordScreenState();
}

class _CustomerPasswordScreenState extends State<CustomerPasswordScreen> {
  TextEditingController editingController = TextEditingController();
  var editKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 50,),
            Image.asset("assets/images/deal.png",height: 120,width: 120,),
            const SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: editKey,
                child: TextFormField(
                  controller: editingController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Email field cannot be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Email",
                      hintStyle: TextStyle(fontFamily: 'montregular'),
                      prefixIcon: Icon(Icons.email)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: 250,
              child: ElevatedButton(onPressed: () async {
                  String email = editingController.text.toString();
                  if(editKey.currentState!.validate()){
                     var isSent = await FirebaseHelper().recoverUserPassword(email);
                     if(isSent){
                       Fluttertoast.showToast(msg: "Recovery email was sent , please check your email ..");
                     } else {
                       Fluttertoast.showToast(msg: "Error occured..");
                     }
                  }
              },style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )
                  )
              ),child: const Text("Recover",style: TextStyle(fontFamily: 'montregular'),),),
            )
          ],
        ),
      ),
    );
  }
}
