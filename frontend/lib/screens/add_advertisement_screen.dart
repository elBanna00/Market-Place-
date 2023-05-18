import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/advertisement.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/stores/user_store.dart';

class AddAdvertiseScreen extends StatefulWidget{
  final Advertisement? advertisement;
  const AddAdvertiseScreen({super.key, this.advertisement});

  @override
  State<StatefulWidget> createState() {
    return _AddAdvertiseScreenState();
  }
}

class _AddAdvertiseScreenState extends State<AddAdvertiseScreen>{

  List<TextEditingController> photoURLs = [];
  final TextEditingController __nameController = TextEditingController();
  final TextEditingController __descriptionController = TextEditingController();
  final TextEditingController __priceController = TextEditingController();
  final TextEditingController __quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.advertisement != null){
      __nameController.text = widget.advertisement!.name;
      __descriptionController.text = widget.advertisement!.description;
      __priceController.text = widget.advertisement!.price.toString();
      __quantityController.text = widget.advertisement!.quantity.toString();

      for(int i = 0; i < widget.advertisement!.photosURLS.length; i++){
        TextEditingController photoController = TextEditingController();
        photoController.text = widget.advertisement!.photosURLS[i];
        photoURLs.add(photoController);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Add Advertisement"
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: List.generate(photoURLs.length, (index){
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField(controller: photoURLs[index], labelText: "photoUrl"),
                  IconButton(onPressed: (){
                    setState(() {
                      photoURLs.removeAt(index);
                    });
                  }, icon: const Icon(Icons.delete))
                ],
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(onPressed: (){
                setState(() {
                  photoURLs.add(TextEditingController());
                });
              }, icon: const Icon(Icons.add))
            ],
          ),
          textField(controller: __nameController, labelText: "Name"),
          textField(controller: __descriptionController, labelText: "Description"),
          textField(controller: __priceController, labelText: "Price", isDigit:  true),
          textField(controller: __quantityController, labelText: "Quantity", isDigit:  true),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(onPressed: (){
                onClickSave();
              }, child: Text("Save"))),
            ],
          )
        ],
      )
    );
  }
  Row textField({required TextEditingController controller, bool isHide = false, required String labelText, isDigit = false}){
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
                inputFormatters: [
                  if(isDigit)
                  FilteringTextInputFormatter.digitsOnly
                ],
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

  Future<void> onClickSave() async {
    if(widget.advertisement == null){
      List<String> photos = [];
      for(int i = 0; i < photoURLs.length; i++){
        photos.add(photoURLs[i].text);
      }
      String name = __nameController.text;
      String description = __descriptionController.text;
      int quantity = int.parse(__quantityController.text);
      double price = double.parse(__priceController.text);

      String responseBody = await RequestHandler().createAdvertisement(UserStore().userId!, UserStore().token!, name, description, quantity, price, photos);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody)));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    else{
      List<String> photos = [];
      for(int i = 0; i < photoURLs.length; i++){
        photos.add(photoURLs[i].text);
      }
      String name = __nameController.text;
      String description = __descriptionController.text;
      int quantity = int.parse(__quantityController.text);
      double price = double.parse(__priceController.text);

      String responseBody = await RequestHandler().updateAdvertisement(UserStore().userId!, UserStore().token!, name, description, quantity, price, photos, widget.advertisement!.advertiseId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody)));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

}