import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/cubits/login_cubit/login_cubit.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/screens/homescreen.dart';
import 'package:frontend/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController __usernameController = TextEditingController();
  final TextEditingController __passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Login Screen"
        ),
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
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 400,

                child: ElevatedButton(
                    onPressed: (){
                      onClickLogin();
                    },
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 400,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: (){
                    onClickSignup();
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.bodyMedium?.apply(
                      color: Colors.black
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

  Future<void> onClickLogin() async {

    int statusCode = await RequestHandler().handleUserLogin(__usernameController.text, __passwordController.text, context);
    if(statusCode == 200){
      context.read<LoginCubit>().setLoggedState(context);
    }
  }

  void onClickSignup(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const SignupScreen();
    }));
  }
}