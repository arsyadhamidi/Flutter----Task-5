import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task5flutter/pages/menu_pages.dart';

class EditPage extends StatefulWidget {

  final dynamic data;
  final String id;
  EditPage({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Object?>> getData(String docId) async{
   DocumentReference docRef = firestore.collection("notes").doc(docId);
   return docRef.get();
  }

  Future<void> editDataNotes() async{
    try{
      DocumentReference<Map<String, dynamic>> addnotes = firestore.collection("notes").doc(widget.id);

      await addnotes.update({
        "title": _title.text,
        "conten": _content.text,
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));

    }catch(exp){
      print(exp);
    }
  }

  @override
  void initState() {
    _title.text = widget.data["title"];
    _content.text = widget.data["conten"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Notes", style: TextStyle(fontWeight: FontWeight.bold),),
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
            editDataNotes();
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
