import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/ui_constants.dart';
import '../widgets/auth_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appBar = UiConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              // textfield1
              AuthField(
                textEditingController: emailController,
              ),
              // textfield2
              AuthField(
                textEditingController: passwordController,
              ),
              // button
              // textspan
            ],
          ),
        ),
      ),
    );
  }
}
