import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pencatatan/forget_pages.dart';
import 'package:pencatatan/home_pages.dart';
import 'package:pencatatan/register_pages.dart';
import 'package:pencatatan/style.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.personKeys});
  final String personKeys;
  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final Future<FirebaseApp> future = Firebase.initializeApp();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordeye = true;

  Future signEmailandPassword() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        print(value);
        if (value != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => MyHomePages(
                    personKeys: widget.personKeys,
                  )),
            ),
          );
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Login Page',
            style: fontJudul,
          ),
        ),
      ),
      body: FutureBuilder(
        future: future,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'error',
                style: fontController,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: const CircularProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.blue,
                      strokeWidth: 100,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Loading..........',
                      style: fontController,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 25, left: 15, right: 15),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email Wajib Di isi dan memiliki karakter @ ';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: fontController,
                            labelText: 'Email',
                            labelStyle: fontController,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: const FaIcon(
                                FontAwesomeIcons.envelope,
                                size: 34,
                              ),
                            )),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        controller: passwordController,
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
                          hintStyle: fontController,
                          labelText: 'Password',
                          labelStyle: fontController,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: IconButton(
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 45,
                      width: 310,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signEmailandPassword();
                          }
                        },
                        child: Text(
                          'Login',
                          style: fontController,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5, left: 200),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => const MyForgetPassword()),
                            ),
                          );
                        },
                        child: const Text(
                          'Forget Password',
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 21,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, left: 60),
                          child: const Text(
                            'Belum Punya Akun ?',
                            style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, left: 5),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        const MyRegisterPages()),
                                  ),
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontSize: 23,
                                ),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
