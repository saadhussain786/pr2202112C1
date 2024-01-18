import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr212c1/Reusable_Widgets/CustomTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email=TextEditingController();
  final password=TextEditingController();
  void userSignIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.toString(), password: password.text.toString());
    final SharedPreferences sp=await SharedPreferences.getInstance();
    sp.setString('userId', email.text.toString());
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login',style: TextStyle(
                color: Colors.purple,
                fontSize: 40
              ),),
              SizedBox(height: 20,),
              ReusableTextField(lable: "Email", hintText: "Enter your Email", controller: email),
              SizedBox(height: 20,),
              ReusableTextField(lable: "Password", hintText: "Enter your password", controller: password),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                userSignIn();
              }, child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
