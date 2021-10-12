import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/weight_room.dart';

class UpdateScreen extends StatelessWidget {

  final String uid;

  UpdateScreen({this.uid});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _message = TextEditingController();


  Future setUpdate(BuildContext context) async {
    if(_message.text.isNotEmpty)
      {
        await _firestore.collection('weightroom').doc(uid).update({
          "weight": _message.text.toString(),
        });
        Navigator.push(context, MaterialPageRoute(builder: (_) => WeightRoom()));
      }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Update data"),
      ),

      body: Container(
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
                  icon: Icon(Icons.send), onPressed: ()=> setUpdate(context)),
            ],
          ),
        ),
      ),
    );
  }
}
