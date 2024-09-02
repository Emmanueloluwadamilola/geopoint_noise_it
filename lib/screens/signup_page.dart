import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/screens/index_screen.dart';
import 'package:futa_noise_app/screens/sign_in.dart';
import 'package:futa_noise_app/Logic/toast.dart';
import 'package:futa_noise_app/Logic/Firebase/user_auth.dart';
import 'package:gap/gap.dart';

class SignUp extends StatefulWidget {
  static const String id = 'signup_screen';
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(120),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.multitrack_audio_sharp,
                        size: 70,
                        color: Color(0XFF1E319D),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Register a new account",
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  hintText: "email",
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  suffixIcon: const Icon(Icons.mail)),
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  hintText: "password",
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  suffixIcon: const Icon(Icons.visibility_off)),
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "confirm password",
                                hintStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                                suffixIcon: const Icon(Icons.visibility_off),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: InkWell(
                          onTap: _signUp,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0XFF1E319D),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: double.infinity,
                            //height: 30,
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: isSigningUp
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Register",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                            )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, SignIn.id);
                        },
                        child: const Text(
                          "Already has account?",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      if (confirmPassword == password) {
        showToast(
          message: "User is successfully created",
        );
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, IndexScreen.id);
      } else {
        showToast(message: "Password does not match");
      }
    } else {
      showToast(message: "Some error happend");
    }
  }
}
