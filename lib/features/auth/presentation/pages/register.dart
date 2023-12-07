// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mytodolist/features/auth/repository/authrepository.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late GlobalKey<FormState> formkey;

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AuthRepository _authRepository;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formkey = GlobalKey();

    /// Initialize authrepository
    _authRepository = AuthRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Builder(builder: (context) {
          if (isloading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: SizedBox(
              width: 400,
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color:
                              Colors.teal, // Change this to the desired color
                        ),
                        hintText: 'Enter User',
                        filled: true, // This will enable the background color
                        fillColor: Colors.grey, // Set the background color here
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    buildPasswordTextField(
                        "Password", passwordController, _obscurePassword),
                    const SizedBox(height: 20),
                    buildPasswordTextField("Confirm Password",
                        confirmPasswordController, _obscureConfirmPassword),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 500.0, // Adjust the width as needed
                      height: 50.0, // Adjust the height as needed
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {
                          setState(() {
                            isloading = true;
                          });

                          if (formkey.currentState!.validate()) {
                            _authRepository
                                .register(emailController.text,
                                    passwordController.text)
                                .then((value) {
                              setState(() => isloading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Welcome ${emailController.text}'),
                                ),
                              );

                              // You can add any additional logic here
                            }).catchError((error) {
                              setState(() => isloading = false);
                            });
                          }
                        },
                        child: const Text('Register'),
                        color: Colors.teal,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Widget buildPasswordTextField(
      String label, TextEditingController controller, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        filled: true, // This will enable the background color
        fillColor: Colors.grey, // Set the background color here
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.teal, // Change this to the desired color
        ),

        hintText: 'Enter $label',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              if (label == "Password") {
                _obscurePassword = !_obscurePassword;
              } else if (label == "Confirm Password") {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              }
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your $label';
        }
        if (value != passwordController.text && label == "Confirm Password") {
          return 'Passwords do not match';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
