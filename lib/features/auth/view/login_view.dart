import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:socially/features/auth/view/signup_view.dart';
import 'package:socially/theme/pallete.dart';

import '../../../common/rounded_small_button.dart';
import '../../../constants/ui_constants.dart';
import '../widgets/auth_field.dart';

class LoginView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                // textfield1
                AuthField(
                  textEditingController: emailController,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 25,
                ),
                // textfield2
                AuthField(
                  textEditingController: passwordController,
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 40,
                ),
                // button
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    label: "Done",
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // textspan
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '\tSign Up',
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              SignUpView.route(),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}