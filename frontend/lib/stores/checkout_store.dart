import 'package:flutter/cupertino.dart';
import 'package:frontend/models/advertisement.dart';

class CheckOutStore{
  static final CheckOutStore __instance = CheckOutStore._internal();

  double totalPrice = 0;
  ValueNotifier<List<Advertisement>> selectedAdvertisements = ValueNotifier([]);
  Map<int, int> selectedQuantity = {};

  factory CheckOutStore(){
    return __instance;
  }
  CheckOutStore._internal();


  List<Advertisement> getAdvertisements(){
    return selectedAdvertisements.value;
  }

  int addAdvertisement(Advertisement advertisement, int quantity){
    if(selectedQuantity[advertisement.advertiseId] == null){
      selectedQuantity[advertisement.advertiseId] = 0;
    }
    if(selectedQuantity[advertisement.advertiseId]! + quantity <= advertisement.quantity){
      for(int _ = 0; _ < quantity; _++) {
        selectedAdvertisements.value.add(advertisement);
      }
      totalPrice += advertisement.price * quantity;
      selectedQuantity[advertisement.advertiseId] = selectedQuantity[advertisement.advertiseId]! + quantity;
      selectedAdvertisements.notifyListeners();
      return 200;
    }

    return 400;
  }

  void removeAdvertisement(Advertisement advertisement){
    selectedQuantity[advertisement.advertiseId] = selectedQuantity[advertisement.advertiseId]! - 1;
    selectedAdvertisements.value.remove(advertisement);
    totalPrice -= advertisement.price;
    selectedAdvertisements.notifyListeners();
  }
  void clearAdvertisements(){
    for(Advertisement advertisement in selectedAdvertisements.value){
      advertisement.quantity--;
    }

    selectedAdvertisements.value.clear();
    selectedQuantity = {};
    selectedAdvertisements.notifyListeners();
  }
}