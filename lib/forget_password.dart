import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {

  static const String id = 'forgetpassword_screen'; 
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: TextField(
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
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0XFF1E319D),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    //height: 30,
                    child: const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        "Send Mail",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
