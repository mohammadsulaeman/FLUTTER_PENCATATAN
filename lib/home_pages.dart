import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pencatatan/notes/insert_notes.dart';
import 'package:pencatatan/notes/update_notes.dart';
import 'package:pencatatan/profile/users_pages.dart';

class MyHomePages extends StatefulWidget {
  MyHomePages({super.key, required this.personKeys});
  String personKeys;

  @override
  State<MyHomePages> createState() => _MyHomePagesState();
}

class _MyHomePagesState extends State<MyHomePages> {
  final registerRef = FirebaseDatabase.instance.ref().child('Register');
  final TextEditingController nama = TextEditingController();
  final Query notesRef =
      FirebaseDatabase.instance.ref().child('Notes').orderByChild('title');
  final noteRef = FirebaseDatabase.instance.ref().child('Notes');
  Widget listNotes({required Map notes}) {
    return Card(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: ClipOval(
                child: Image.network(
              notes['image_notes'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(notes['title']),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(notes['deskripsi']),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(notes['tanggal']),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(notes['waktu']),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(notes['createdby']),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => MyUpdateNotes(
                              personKey: notes['key'],
                              nama: nama.text,
                              images: notes['image_notes'],
                              title: notes['title'],
                              deskripsi: notes['deskripsi'],
                            )),
                      ),
                    );
                  },
                  child: const Text('Update'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    await noteRef.child(notes['key']).remove().then((value) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MyHomePages(personKeys: widget.personKeys)));
                    }).catchError((onError) {
                      print(onError);
                    });
                  },
                  child: const Text('Delete'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget profile = IconButton(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => const MyProfilePage())));
      },
      icon: const FaIcon(
        FontAwesomeIcons.circleInfo,
        size: 25,
      ),
    );
    Widget add = IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => MyInsertNote(nama: nama.text))));
      },
      icon: const FaIcon(
        FontAwesomeIcons.plus,
        size: 25,
      ),
      tooltip: 'Add',
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Pilihan'),
      content: Text('Silakan Pilih Aksi'),
      actions: [profile, add],
    );
    showDialog(
      context: context,
      builder: ((context) {
        return alertDialog;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    getDataUsersByID();
  }

  Future getDataUsersByID() async {
    DataSnapshot snapshot = await registerRef.child(widget.personKeys).get();
    print(snapshot);
    Map person = snapshot.value as Map;
    print("person = $person");
    nama.text = person['nama'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home Pages'),
        ),
      ),
      body: FirebaseAnimatedList(
        query: notesRef,
        itemBuilder: ((context, snapshot, animation, index) {
          Map note = snapshot.value as Map;
          note['key'] = snapshot.key;
          print(snapshot.key);
          return listNotes(notes: note);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlertDialog(context);
        },
        tooltip: "Modal",
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
