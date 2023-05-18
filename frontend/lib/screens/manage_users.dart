import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/request_handler.dart';

class ManageUsers extends StatefulWidget{
  const ManageUsers({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ManageUsersState();
  }
}

class _ManageUsersState extends State<ManageUsers>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
      ),
      body: FutureBuilder<List<User>>(
        future: RequestHandler().getAllUsersIds(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(snapshot.data![index].username),
                leading: const Icon(
                  Icons.account_circle_rounded
                ),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width/3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: (){
                        onTapDepromot(snapshot.data![index]);
                      }, icon: Icon(Icons.arrow_left)),
                      Text(snapshot.data![index].role),
                      IconButton(onPressed: (){
                        onTapPromot(snapshot.data![index]);
                      }, icon: Icon(Icons.arrow_right))
                    ],
                  ),
                ),
              );
            },
          );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

  Future<void> onTapDepromot(User user) async {
    if(user.role =="normal"){
      return;
    }
    if(user.role == "vendor"){
      String responseBody =await RequestHandler().demotedFromVendor(user.userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody)));
      setState(() {
      });
    }
    if(user.role == "admin"){
      String responseBody =await RequestHandler().demotedFromAdmin(user.userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody)));
      setState(() {

      });
    }

  }

  Future<void> onTapPromot(User user) async {
    if(user.role == "admin"){
      return;
    }
    if(user.role == "vendor"){
      String responseBody =await RequestHandler().promoteToAdmin(user.userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody)));
      setState(() {
      });
    }
    if(user.role == "normal"){
      String responseBody =await RequestHandler().promoteToVendor(user.userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody)));
      setState(() {
      });
    }

  }
}