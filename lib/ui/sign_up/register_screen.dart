import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/firebase/firestore_handler.dart';
import 'package:to_do_app/firebase/model/user.dart' as my_user;
import 'package:to_do_app/style/dialog_utils.dart';
import 'package:to_do_app/ui/home/home_screen.dart';

import '../../firebase/firebase_auth_codes.dart';
import '../../style/reusable_components/custom_button.dart';
import '../../style/reusable_components/custom_text_field.dart';
import '../../style/validation.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    ageController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Create Account'),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(height * 0.03),
          child: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Full Name',
                      controller: nameController,
                      keyword: TextInputType.name,
                      validator: (value) {
                        return Validation.fullNameValidator(
                          value,
                          'should enter your name',
                        );
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
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
                        label: 'Age',
                        keyword: TextInputType.number,
                        controller: ageController,
                        validator: (value) {
                          Validation.fullNameValidator(
                              value, 'Please Enter Your Age');
                        }),
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
                      height: height * 0.02,
                    ),
                    CustomTextField(
                      label: 'Password Confirmation',
                      keyword: TextInputType.visiblePassword,
                      controller: passwordConfirmController,
                      isPassword: true,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'mismatch with password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    CustomButton(
                      onPress: () {
                        createAccount();
                      },
                      title: 'Create Account',
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

  createAccount() async {
    if (formKey.currentState!.validate()) {}
    try {
      DialogUtils.showLoading(context);
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
     await FireStoreHandler.createUser(
        my_user.User(
          id: userCredential.user!.uid,
          age: int.parse(ageController.text),
          email: emailController.text,
          fullName: nameController.text,
        ),
      );
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == FirebaseAuthCodes.weakPass) {
        DialogUtils.showMessageDialog(context,
            message: 'The password provided is too weak.',
            positiveActionTitle: 'Ok', positiveActionClick: (context) {
          Navigator.pop(context);
        });
      } else if (e.code == FirebaseAuthCodes.emailAlreadyInUse) {
        DialogUtils.showMessageDialog(context,
            message: 'The account already exists for that email.',
            positiveActionTitle: 'Ok', positiveActionClick: (context) {
          Navigator.pop(context);
        });
      }
    } catch (error) {}
  }
}
