import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart' as AdvertisementModel;
import 'package:frontend/models/advertisement.dart';
import 'package:frontend/stores/checkout_store.dart';


class AdvertiseScreen extends StatefulWidget{
  final Advertisement advertisement;
  const AdvertiseScreen({super.key, required this.advertisement});

  @override
  State<StatefulWidget> createState() {
    return _AdvertiseScreenState();
  }
}

class _AdvertiseScreenState extends State<AdvertiseScreen>{

  late Advertisement advertisement;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    advertisement = widget.advertisement;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Advertise Screen"
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: PageView.builder(

              scrollDirection: Axis.horizontal,
              itemCount: advertisement.photosURLS.length,
              itemBuilder: (context, index){
                return Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(advertisement.photosURLS[index])
                    )
                  ),
                );
              },
            ),
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          Text(
            advertisement.name,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 35,
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            "${advertisement.price}\$",
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
            ),
          ),
          const Divider(
            thickness: 1,
            height: 20,
          ),
          const Text(
              "Description",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 25,
              ),
          ),
          Text(
              advertisement.description,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
              ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: (){
                    if(quantity == 0){
                      return;
                    }
                    setState(() {
                      quantity--;
                    });
                  },
                  icon: const Icon(Icons.arrow_left)
              ),
              Text(
                quantity.toString()
              ),
              IconButton(
                  onPressed: (){
                    if(CheckOutStore().selectedQuantity[advertisement.advertiseId] == null){
                      CheckOutStore().selectedQuantity[advertisement.advertiseId] = 0;
                    }

                    if(quantity >= advertisement.quantity - CheckOutStore().selectedQuantity[advertisement.advertiseId]!){
                      return;
                    }

                    setState(() {
                      quantity += 1;
                    });
                  },
                  icon: const Icon(Icons.arrow_right)
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 400, right: 400),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  onPressed: (){
                    onAddToCart();
                  },
                  child: const Center(
                    child: Text(
                      "Add To Cart"
                    ),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

  void onAddToCart(){
    if(quantity == 0){
      return;
    }

    if(CheckOutStore().addAdvertisement(advertisement, quantity) == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added Successfully"))
      );
    }
    setState(() {
      quantity = 0;
    });
  }

}