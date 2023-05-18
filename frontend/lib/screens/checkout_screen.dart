import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart' as AdvertisementsModels;
import 'package:frontend/screens/payment_screen.dart';
import 'package:frontend/stores/checkout_store.dart';
import 'package:frontend/widgets/advertise_widget.dart';

class CheckOutScreen extends StatefulWidget{
  const CheckOutScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CheckOutScreenState();
  }
}

class _CheckOutScreenState extends State<CheckOutScreen>{

  void updateScreenOnChange(){
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    CheckOutStore().selectedAdvertisements.addListener(updateScreenOnChange);
  }

  @override
  void dispose() {
    super.dispose();
    CheckOutStore().selectedAdvertisements.removeListener(updateScreenOnChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Homepage"
        ),
        actions: [
          Center(
            child: Text(
              "Total Price: ${CheckOutStore().totalPrice}"
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: CheckOutStore().selectedAdvertisements.value.length,
            itemBuilder: (context,index){
              return Stack(
                children: [
                  AdvertiseWidget(advertisement: CheckOutStore().selectedAdvertisements.value[index]),
                  Positioned(
                      bottom: 25,
                      right: 25,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 25,
                        ),
                        onPressed: (){
                          CheckOutStore().removeAdvertisement(CheckOutStore().selectedAdvertisements.value[index]);
                        },
                      )
                  ),
                ],
              );
            },
          ),
          if(CheckOutStore().selectedAdvertisements.value.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
                    },
                    child:const Center(
                      child: Text(
                        "Checkout"
                      ),
                    )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}