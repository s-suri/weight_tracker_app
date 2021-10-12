import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/LoginScreen.dart';
import 'package:surichatapp/updateScreen.dart';

class WeightRoom extends StatefulWidget {
  @override
  _WeightRoomState createState() => _WeightRoomState();
}


class _WeightRoomState extends State<WeightRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic> userMap;


  Future logOut(BuildContext context) async
  {
    FirebaseAuth auth = FirebaseAuth.instance;

    try{
      await auth.signOut().then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      });
    }
    catch(e)
    {
      print('error');
    }
  }

  String getRandomString(){
    var random = Random.secure();
    var value = List<int>.generate(12, (i) => random.nextInt(255));

    return base64Encode(value);
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      await _firestore
          .collection('users')
          .where("uid", isEqualTo: _auth.currentUser.uid)
          .get()
          .then((value) {
          userMap = value.docs[0].data();
        print(userMap);
      });



      String uid = getRandomString();

      Map<String, dynamic> messages = {
        "name": userMap['name'],
        "weight": _message.text,
        "uid": uid,
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('weightroom')
          .doc(uid)
          .set(messages);
    } else {
      print("Enter Some Text");
    }
  }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person,color: Colors.white,),
        title: StreamBuilder<DocumentSnapshot>(
          stream:
          _firestore.collection("users").doc(_auth.currentUser.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(snapshot.data.get("name")),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),

        actions: [
          IconButton(onPressed: ()=> logOut(context), icon: Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),

            Container(
          //    height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 13,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "Please Enter Weight",
                            border: OutlineInputBorder(),
                          labelText: 'Please Enter Weight'
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20,),

            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('weightroom')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data.docs[index]
                            .data() as Map<String, dynamic>;


                        return ListTile(
                                onTap: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateScreen(uid: map['uid'])));
                               },
                               leading: Icon(Icons.account_box, color: Colors.black),
                               title: Text(map['name'],
                                     style: TextStyle(
                                     color: Colors.black,
                                     fontSize: 17,
                                     fontWeight: FontWeight.w500,
                                ),
                               ),
                                subtitle: Text("Weight: ${map['weight']}"),
                               trailing: IconButton(icon: Icon(Icons.delete),onPressed: ()
                                 {
                                    _firestore.collection('weightroom').doc(map['uid']).delete();
                                 },
                               ),
                               );
                              },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
