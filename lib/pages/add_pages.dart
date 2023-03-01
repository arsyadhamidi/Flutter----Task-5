import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task5flutter/pages/menu_pages.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addDataNotes() async{
    try{
      CollectionReference addnotes = firestore.collection("notes");

      await addnotes.add({
        "title": _title.text,
        "conten": _content.text,
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));

    }catch(exp){
      print(exp);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextFormField(
              controller: _title,
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _content,
              autofocus: true,
              maxLines: 30,
              decoration: InputDecoration(
                hintText: "Write notes...",
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MaterialButton(
          onPressed: (){
            addDataNotes();
          },
          color: Colors.blue,
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
