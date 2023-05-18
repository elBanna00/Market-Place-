import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/stores/checkout_store.dart';
import 'package:frontend/stores/user_store.dart';

class PaymentScreen extends StatefulWidget{
  const PaymentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PaymentScreenState();
  }
}

class _PaymentScreenState extends State<PaymentScreen>{
  final TextEditingController __addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Screen"),
      ),
      body: FutureBuilder(
        future: RequestHandler().getAccountDetails(UserStore().userId!, UserStore().token!),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              textField(
                  controller: __addressController,
                  isHide: false,
                  labelText: "Address"
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Current Balance: ${UserStore().balance}",
                  ),
                  Text(
                    "Total Price: ${CheckOutStore().totalPrice}"
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: (){
                          onClickPay();
                        },
                        child: const Text("Pay")
                    ),
                  ),
                ],
              )
            ],
          );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

  Row textField({required TextEditingController controller, required bool isHide, required String labelText}){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 500,
          child: Center(
            child: Material(
              color: Colors.white,
              child: TextField(
                obscureText: isHide,
                controller: controller,
                decoration: InputDecoration(
                    labelText: labelText,
                    border: const OutlineInputBorder()
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> onClickPay() async {
    if(__addressController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Specify the address")));
      return;
    }

    List<int> advertisementsIds = [];

    for (Advertisement advertisement in CheckOutStore().selectedAdvertisements.value){
      advertisementsIds.add(advertisement.advertiseId);
    }

    String responseBody = await RequestHandler().handleCreateOrder(UserStore().userId!, UserStore().token!, __addressController.text, advertisementsIds);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody)));
    if(responseBody == "\"Saved Successfully\""){
      CheckOutStore().clearAdvertisements();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}