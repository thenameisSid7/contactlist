// ignore_for_file: avoid_print
import 'package:contactlist/login.dart';
import 'package:contactlist/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? pass;

  Future save() async {
    if (pass != null && email != null) {
      var response = await Dio().post(
          "http://172.20.10.5:8000/api/v1/user/auth/register",
          data: {"password": "$pass", "email": "$email"});
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data.toString())));
      }
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: SvgPicture.asset(
                'images/top.svg',
                width: 400,
                height: 200,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    Text(
                      'SignUp',
                      style: GoogleFonts.pacifico(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: TextEditingController(text: email),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter Email',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.red))),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: TextEditingController(text: pass),
                        onChanged: (value) {
                          pass = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter Password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Colors.red))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      // ignore: sized_box_for_whitespace
                      child: Container(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              save();
                            } else {
                              print("not ok");
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.resolveWith<
                                OutlinedBorder?>(
                              (Set<MaterialState> states) {
                                return RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                );
                              },
                            ),
                          ),
                          child: const Text(
                            "Signup",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(65, 20, 0, 0),
                      child: Row(
                        children: [
                          const Text(
                            'Already have an account ? ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const LoginPage())));
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
