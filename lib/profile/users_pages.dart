import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:pencatatan/home_pages.dart';
import 'package:pencatatan/style.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final DatabaseReference registerRef =
      FirebaseDatabase.instance.ref().child('Register');

  final Query personRef = FirebaseDatabase.instance
      .ref()
      .child('Register')
      .orderByChild(FirebaseAuth.instance.currentUser!.uid);

  Widget listUsers({required Map person}) {
    return Card(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: ClipOval(
              child: Image.network(
                person['images'],
                width: 210,
                height: 210,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              person['nama'],
              style: fontController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              person['phone'],
              style: fontController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              person['alamat'],
              style: fontController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              person['email'],
              style: fontController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyHomePages()));
                },
                child: Text(
                  'Home',
                  style: fontController,
                )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Pages',
          style: fontJudul,
        ),
      ),
      body: FirebaseAnimatedList(
          query: personRef,
          itemBuilder: ((context, snapshot, animation, index) {
            Map person = snapshot.value as Map;
            print(person);
            return listUsers(person: person);
          })),
    );
  }
}
