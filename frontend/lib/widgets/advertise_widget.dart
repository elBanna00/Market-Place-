import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart';
import 'package:frontend/screens/advertise_screen.dart';


class AdvertiseWidget extends StatefulWidget{
  Advertisement advertisement;
  AdvertiseWidget({super.key, required this.advertisement});

  @override
  State<StatefulWidget> createState() {
    return _AdvertiseWidgetState();
  }
}


class _AdvertiseWidgetState extends State<AdvertiseWidget>{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: (){
            onTapAdvertise();
          },
          child: Container(
            height: 250,
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: Colors.green,
                    width: 3
                )
            ),
            child: Row(
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width-60) /3,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: widget.advertisement.photosURLS.isNotEmpty ?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(widget.advertisement.photosURLS[0]),
                  ) :
                  const Center(
                      child: Icon(
                        Icons.no_photography,
                        size: 40,
                      )
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width-60)*2 /3,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 194,
                        child: Text(
                          widget.advertisement.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 35
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 25,
                            child: Text(
                              "Price: ${widget.advertisement.price}\$",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 25,
                            child: Text(
                              "${widget.advertisement.quantity} items are left",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.red
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapAdvertise(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AdvertiseScreen(
      advertisement: widget.advertisement,
    )));
  }
}