import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/firebase/firebase_auth_codes.dart';
import 'package:to_do_app/style/dialog_utils.dart';
import 'package:to_do_app/ui/home/home_screen.dart';
import '../../style/reusable_components/custom_button.dart';
import '../../style/reusable_components/custom_text_field.dart';
import '../../style/validation.dart';
import '../sign_up/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text('Login'),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(height * 0.03),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Email Address',
                      keyword: TextInputType.emailAddress,
                      controller: emailController,
                      validator: Validation.emailValidator,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomTextField(
                      label: 'Password',
                      keyword: TextInputType.visiblePassword,
                      controller: passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'should enter your password';
                        }
                        if (value.length < 8) {
                          return "Password shouldn't be less than 8 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    CustomButton(
                      onPress: () {
                        login();
                      },
                      title: 'Login',
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RegisterScreen.routeName,
                        );
                      },
                      child: const Text(
                        "Don't have an Account ?",
                        style: TextStyle(color: Color(0xff5D9CEC),
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      try {
        DialogUtils.showLoading(context);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // FirebaseAuth.instance.currentUser
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
        print('sign in success:${userCredential.user?.uid}');
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == FirebaseAuthCodes.userNotFound) {
          DialogUtils.showMessageDialog(context,
              message: 'No User Found For That Email.',
              positiveActionTitle: 'Ok', positiveActionClick: (context) {
            Navigator.pop(context);
          });
        } else if (e.code == FirebaseAuthCodes.wrongPass) {
          DialogUtils.showMessageDialog(context,
              message: 'Wrong password provided for that user.',
              positiveActionTitle: 'Ok', positiveActionClick: (context) {
            Navigator.pop(context);
          });
        }
      }
    }
  }
}
