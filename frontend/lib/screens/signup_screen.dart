import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/request_handler.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

class _SignupScreenState extends State<SignupScreen>{
  final TextEditingController __usernameController = TextEditingController();
  final TextEditingController __passwordController = TextEditingController();
  final TextEditingController __confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup page"),
      ),
      body: ListView(
        children: [
          SizedBox(
              width: 200,
              height: 200,
              child: Image.asset("${IMAGES_LOCATION}logo.png")
          ),
          const SizedBox(
            height: 5,
          ),
          textField(controller: __usernameController, isHide: false, labelText: "Username"),
          const SizedBox(
            height: 10,
          ),
          textField(controller: __passwordController, isHide: true, labelText: "Password"),
          const SizedBox(
            height: 10,
          ),
          textField(controller: __confirmPasswordController, isHide: true, labelText: "Confirm Password"),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 400, right: 400),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: (){
                    onClickSignup();
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding textField({required TextEditingController controller, required bool isHide, required String labelText}){
    return Padding(
      padding: const EdgeInsets.only(
          left: 300,
          right: 300
      ),
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
    );
  }


  Future<void> onClickSignup() async {
    if(__passwordController.text != __confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password and Confirm Password are different"))
      );
      return;
    }

    await RequestHandler().handleCreateAccount(__usernameController.text, __passwordController.text, context);
    Navigator.pop(context);
  }
}