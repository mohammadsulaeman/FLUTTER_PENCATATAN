import 'package:flutter/material.dart';

class MyForgetPassword extends StatefulWidget {
  const MyForgetPassword({super.key});

  @override
  State<MyForgetPassword> createState() => _MyForgetPasswordState();
}

class _MyForgetPasswordState extends State<MyForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password'),
      ),
    );
  }
}
