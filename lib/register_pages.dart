import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencatatan/login_pages.dart';
import 'package:pencatatan/style.dart';
import 'package:toast/toast.dart';

class MyRegisterPages extends StatefulWidget {
  const MyRegisterPages({super.key});

  @override
  State<MyRegisterPages> createState() => _MyRegisterPagesState();
}

class _MyRegisterPagesState extends State<MyRegisterPages> {
  final fromkey = GlobalKey<FormState>();
  File? imagesProfile;
  ImagePicker picker = ImagePicker();
  TextEditingController namaControllerRegis = TextEditingController();
  TextEditingController alamatControllerRegis = TextEditingController();
  TextEditingController emailControllerRegis = TextEditingController();
  TextEditingController passwordControllerRegis = TextEditingController();
  TextEditingController phoneControllerRegis = TextEditingController();
  bool passwordeye = true;
  final storageRef = FirebaseStorage.instance.ref();
  final registerRef = FirebaseDatabase.instance.ref().child('Register');

  Future getImageCamera() async {
    final pickedfile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      if (pickedfile != null) {
        imagesProfile = File(pickedfile.path);
      }
    });
  }

  Future createSignEmailandPassword() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailControllerRegis.text,
              password: passwordControllerRegis.text)
          .then((value) {
        print(value);
        if (value != null) {
          saveImagesFilesName(imagesProfile!);
        }
      });
      print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future saveImagesFilesName(File imagesprofiles) async {
    String fileName = imagesprofiles.path.split('/').last;
    try {
      TaskSnapshot snapshot = await storageRef
          .child('image/users/$fileName')
          .putFile(imagesprofiles);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl);
        Map register = {
          'nama': namaControllerRegis.text,
          'phone': phoneControllerRegis.text,
          'alamat': alamatControllerRegis.text,
          'email': emailControllerRegis.text,
          'password': passwordControllerRegis.text,
          'images': downloadUrl,
        };

        await registerRef
            .child(FirebaseAuth.instance.currentUser!.uid)
            .set(register)
            .then((value) {
          String personKey = register['key'].toString();
          String currencyuser =
              FirebaseAuth.instance.currentUser!.uid.toString();
          print("Person Key Regis = $personKey");
          print("CurrencyUser : $currencyuser");
          Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => const MyLoginPage())));
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
    namaControllerRegis.dispose();
    alamatControllerRegis.dispose();
    emailControllerRegis.dispose();
    passwordControllerRegis.dispose();
    phoneControllerRegis.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Registrasi Pages',
            style: fontJudul,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: fromkey,
          child: Column(
            children: [
              imagesProfile != null
                  ? ClipOval(
                      child: Image.file(
                        imagesProfile!,
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
                margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                child: TextFormField(
                  controller: namaControllerRegis,
                  keyboardType: TextInputType.name,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'Nama Wajib Di isi';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      hintText: 'Nama Lengkap',
                      labelText: 'Nama Lengkap',
                      hintStyle: fontController,
                      labelStyle: fontController,
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const FaIcon(
                          FontAwesomeIcons.idCard,
                          size: 35,
                        ),
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ))),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: TextFormField(
                  controller: alamatControllerRegis,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Alamat Wajib Di isi';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Alamat Lengkap',
                      labelText: 'Alamat Lengkap',
                      hintStyle: fontController,
                      labelStyle: fontController,
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const FaIcon(
                          FontAwesomeIcons.locationPinLock,
                          size: 35,
                        ),
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: TextFormField(
                  controller: phoneControllerRegis,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nomor Telepon Wajib Di isi';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nomer Telepon',
                    labelText: 'Nomer Telepon',
                    hintStyle: fontController,
                    labelStyle: fontController,
                    suffixIcon: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const FaIcon(
                        FontAwesomeIcons.phone,
                        size: 35,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: TextFormField(
                  controller: emailControllerRegis,
                  keyboardType: TextInputType.emailAddress,
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'Email Wajib Di isi dan memiliki karakter @';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    labelText: 'Email',
                    hintStyle: fontController,
                    labelStyle: fontController,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const FaIcon(
                        FontAwesomeIcons.envelope,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: TextFormField(
                  controller: passwordControllerRegis,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: passwordeye,
                  validator: ((value) {
                    if (value!.length < 6) {
                      return 'Password minimal terdiri dari 6 karakter';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordeye = !passwordeye;
                        });
                      },
                      icon: Icon(passwordeye
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (imagesProfile == null) {
                      Toast.show("Image Tidak Boleh Kosong",
                          duration: Toast.lengthShort, gravity: Toast.bottom);
                    } else {
                      if (fromkey.currentState!.validate()) {
                        createSignEmailandPassword();
                      }
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 21,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
