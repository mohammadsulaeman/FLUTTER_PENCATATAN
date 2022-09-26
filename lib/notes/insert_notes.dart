import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencatatan/datetime.dart';
import 'package:pencatatan/home_pages.dart';
import 'package:pencatatan/style.dart';
import 'package:toast/toast.dart';

class MyInsertNote extends StatefulWidget {
  MyInsertNote({super.key, required this.nama});
  String nama;
  @override
  State<MyInsertNote> createState() => _MyInsertNoteState();
}

class _MyInsertNoteState extends State<MyInsertNote> {
  final DatabaseReference notesRef =
      FirebaseDatabase.instance.ref().child('Notes');
  final TextEditingController titleControllerAdd = TextEditingController();
  final TextEditingController deskripsiControllerAdd = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? imagesNote;
  ImagePicker picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();

  Future getImageCamera() async {
    final pickedfile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      if (pickedfile != null) {
        imagesNote = File(pickedfile.path);
      }
    });
  }

  Future insertNotes(File imagesNotes) async {
    String fileName = imagesNotes.path.split('/').last;

    try {
      TaskSnapshot snapshot =
          await storageRef.child('image/notes/$fileName').putFile(imagesNotes);
      if (snapshot.state == TaskState.success) {
        String downloadUrl = await snapshot.ref.getDownloadURL();
        Map notes = {
          'title': titleControllerAdd.text,
          'deskripsi': deskripsiControllerAdd.text,
          'tanggal': tanggalIndo,
          'waktu': jamIndo,
          'image_notes': downloadUrl,
          'createdby': widget.nama,
        };

        await notesRef.push().set(notes).then((value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const MyHomePages()),
            ),
          );
        }).catchError((onError) {
          print(onError);
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleControllerAdd.dispose();
    deskripsiControllerAdd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Insert Note'),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              imagesNote != null
                  ? ClipOval(
                      child: Image.file(
                        imagesNote!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox(
                      width: 100, height: 100, child: Icon(Icons.person)),
              const Text(
                'Choose Image',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Positioned(
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Ambil Photo Profile',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: getImageCamera,
                                          child: const Text('Camera'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                ),
                child: TextFormField(
                  controller: titleControllerAdd,
                  keyboardType: TextInputType.name,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'Title Tidak Boleh Kosong';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    labelText: 'Title',
                    hintStyle: fontController,
                    labelStyle: fontController,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    suffixIcon: const FaIcon(
                      FontAwesomeIcons.pencil,
                      size: 15,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                ),
                child: TextFormField(
                  controller: deskripsiControllerAdd,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Deskripsi Wajib Di isi';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Deskripsi',
                    labelText: 'Deskripsi',
                    hintStyle: fontController,
                    labelStyle: fontController,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    suffixIcon: const FaIcon(
                      FontAwesomeIcons.list,
                      size: 15,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 30, right: 10),
                width: 370,
                height: 45,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 4,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  tanggalIndo,
                  style: fontController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                ),
                width: 370,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  jamIndo,
                  style: fontController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                ),
                width: 370,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  widget.nama,
                  style: fontController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (imagesNote == null) {
                      Toast.show("Image Tidak Boleh Kosong",
                          duration: Toast.lengthShort, gravity: Toast.bottom);
                    } else {
                      if (formKey.currentState!.validate()) {
                        insertNotes(imagesNote!);
                      }
                    }
                  },
                  child: Text('Insert', style: fontController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
