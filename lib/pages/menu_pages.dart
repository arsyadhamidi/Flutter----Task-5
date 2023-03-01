import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task5flutter/pages/add_pages.dart';
import 'package:task5flutter/pages/edit_pages.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> deleteDataNotes(String id) async{
    DocumentReference docRef = firestore.collection("notes").doc(id);

    try{
      docRef.delete();
    }catch(exp){}

  }

  // Satu Pemanggilan
  // Future<QuerySnapshot<Object?>> getDataNotes() async{
  //   CollectionReference datanotes = firestore.collection("notes");
  //
  //   return datanotes.get();
  //
  // }

  // Penggunaan secara realtime

  Stream<QuerySnapshot<Object?>> streamData(){
    CollectionReference datanotes = firestore.collection("notes");

    return datanotes.snapshots();
  }

  @override
  void initState() {
    streamData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Notes", style: TextStyle(fontWeight: FontWeight.bold),),
      ),

      // Pemanggilan secara realtime
      body: StreamBuilder<QuerySnapshot<Object?>>(
        stream: streamData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            var lisAllDocument = snapshot.data!.docs;
            return ListView.builder(
                itemCount: lisAllDocument.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  EditPage(
                                      data: lisAllDocument[index],
                                      id: snapshot.data!.docs[index].id)));
                        },
                        title: Text(lisAllDocument[index]["title"],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        subtitle: Text(lisAllDocument[index]["conten"]),
                        trailing: IconButton(
                            onPressed: (){
                              deleteDataNotes(snapshot.data!.docs[index].id);
                            },
                            icon: Icon(Icons.delete)
                        ),
                      ),
                    ),
                  );
                },
            );
          }

          return Center(child: CircularProgressIndicator(),);
        },
      ),

      // Satu kali pemanggilan
      // body: FutureBuilder<QuerySnapshot<Object?>>(
      //   future: getDataNotes(),
      //   builder: (context, snapshot) {
      //
      //     if(snapshot.connectionState == ConnectionState.done){
      //
      //       var listDocument = snapshot.data!.docs;
      //
      //       return ListView.builder(
      //         itemCount: listDocument.length,
      //         itemBuilder: (context, index) {
      //           return Card(
      //             child: Padding(
      //               padding: const EdgeInsets.all(10),
      //               child: ListTile(
      //                 title:
      //                   Text(listDocument[index]['title'],
      //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //                 ),
      //                 subtitle: Text(listDocument[index]['conten']),
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //
      //     return Center(child: CircularProgressIndicator());
      //
      //
      //   },
      //
      // ),



      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPage()));
        },
        child: Icon(CupertinoIcons.add),
      ),
    );
  }
}
