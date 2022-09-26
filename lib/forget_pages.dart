import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pencatatan/login_pages.dart';
import 'package:pencatatan/style.dart';
import 'package:toast/toast.dart';

class MyForgetPassword extends StatefulWidget {
  const MyForgetPassword({super.key});

  @override
  State<MyForgetPassword> createState() => _MyForgetPasswordState();
}

class _MyForgetPasswordState extends State<MyForgetPassword> {
  final TextEditingController emailControllerReset = TextEditingController();
  Future resetSandi(BuildContext context) async {
    ToastContext().init(context);
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailControllerReset.text)
        .then((value) {
      Toast.show(
          "Silakan Periksa Email Anda, Untuk Proses reset sandi selanjutnya",
          duration: Toast.lengthShort,
          gravity: Toast.bottom);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => const MyLoginPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forget Password',
          style: fontJudul,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 200),
              child: TextFormField(
                controller: emailControllerReset,
                style: fontController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  hintStyle: fontController,
                  labelStyle: fontController,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  onPressed: () {
                    resetSandi(context);
                  },
                  child: const Text('Reset Sandi')),
            )
          ],
        ),
      ),
    );
  }
}
