import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pr212c1/Screens/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userid='';
  _getUserId() async
  {
    
    final SharedPreferences sp=await SharedPreferences.getInstance();
    String? id=sp.getString('userId');
    return  id;
  }
  @override
  void initState() {
    // TODO: implement initState
    _getUserId().then((id){
      setState(() {
        userid=id;

      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              child: StreamBuilder(stream: FirebaseFirestore.instance.collection('users').where('email',isEqualTo: "$userid").snapshots(),
                  builder: (context, snapshot) {

                if(snapshot.hasData||snapshot.data != null)
                  {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage('${snapshot.data!.docs[index]['user_image']}'),
                          ),
                          Text('$userid'),
                          Text('${snapshot.data!.docs[index]["name"]}',style: const TextStyle(fontSize: 40),),
                          Text('${snapshot.data!.docs[index]["email"]}'),
                          Text('${snapshot.data!.docs[index]["phone"]}'),
                        ],
                      );
                    },);

                  }
                if(ConnectionState.waiting==snapshot.connectionState)
                {
                  return const CircularProgressIndicator();
                }
                if(snapshot.hasError)
                {
                  return const Text("Error");
                }
                    return Container(
                    );
                  },),
            ),
            ElevatedButton(onPressed: () async{
              await FirebaseAuth.instance.signOut();
              SharedPreferences sp=await SharedPreferences.getInstance();
              sp.remove('userId');

            },
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
                ),
                child: Text('Logout',style: TextStyle(
                  color: Colors.white
                ),))
          ],
        )
      ),
    );
  }
}
