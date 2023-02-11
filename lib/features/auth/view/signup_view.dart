import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../widgets/auth_field.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
                    text: "Already have an account?",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '\tLogin',
                        style: const TextStyle(
                          color: Pallete.blueColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              LoginView.route(),
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
