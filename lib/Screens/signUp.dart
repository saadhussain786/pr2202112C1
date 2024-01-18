import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pr212c1/Screens/signIn.dart';
import 'package:uuid/uuid.dart';

import '../Reusable_Widgets/CustomTextField.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final name=TextEditingController();
  final phone=TextEditingController();
  final email=TextEditingController();
  final address=TextEditingController();
  final age=TextEditingController();
  final password=TextEditingController();
  String selectedGender='Male';
  File? UserProfile;
  void UserSignUp() async{
    try
        {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.toString(), password: password.text.toString());
          userImage();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Account Create Successfully')));
          Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
        }
    on FirebaseAuthException catch(e)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${e.code.toString()}')));
    }

  }
  void userImage() async
  {
    UploadTask uploadTask=FirebaseStorage.instance.ref().child('UserImage').putFile(UserProfile!);
    TaskSnapshot taskSnapshot=await uploadTask;
    String userImage=await taskSnapshot.ref.getDownloadURL();
    userInfo(image: userImage);
  }
  void userInfo({String? image}) async{
   String userId=Uuid().v1();
   Map<String,dynamic> user_data={
     "name":name.text.toString(),
     "phone":phone.text.toString(),
     "email":email.text.toString(),
     "address":address.text.toString(),
     "gender":selectedGender,
     "id":userId,
     "user_image":image
   };
   await FirebaseFirestore.instance.collection('users').add(user_data);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign Up',style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40
                  ),),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () async
                    {
                      XFile? selectedImage=await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(selectedImage!=null)
                        {
                          File convertedFile=File(selectedImage.path);
                          setState(() {
                            UserProfile=convertedFile;
                          });
                        }
          
          
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.red,
                      backgroundImage:UserProfile!=null?FileImage(UserProfile!):null
                    ),
                  ),
                  SizedBox(height: 20,),
                  ReusableTextField(
                    controller: name,
                    lable: "Name",
                    hintText: "Enter your name",
                  ),

                  SizedBox(height: 20,),
                  ReusableTextField(
                    controller: age,
                    lable: "Age",
                    hintText: "Enter your age",
                  ),
                  SizedBox(height: 20,),
                  DropdownButtonFormField(
                    onChanged: (newValue)
                    {
                      setState(() {
                        selectedGender=newValue!;
                      });
                    },
                    items: ['Male','Female','Other'].map((String value){
                      return DropdownMenuItem(child: Text('$value'),value: value,);
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Gender')
                    ),
                  ),
                  SizedBox(height: 20,),
                  ReusableTextField(
                    controller: phone,
                    lable: "Phone",
                    hintText: "Enter your phone",
                  ),
                  SizedBox(height: 20,),
                  ReusableTextField(
                    controller: email,
                    lable: "Email",
                    hintText: "Enter your email",
                  ),
                  SizedBox(height: 20,),
                  ReusableTextField(
                    controller: password,
                    lable: "Password",
                    hintText: "Enter your password",
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(onPressed: (){
                    UserSignUp();
                  }, child: Text('Sign Up1'))
          
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
