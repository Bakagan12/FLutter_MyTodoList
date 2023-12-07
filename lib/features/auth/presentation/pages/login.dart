// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:mytodolist/features/auth/presentation/pages/register.dart';
import 'package:mytodolist/features/auth/repository/authrepository.dart';
import 'package:mytodolist/features/todo/presentation/pages/todoList.dart';
import 'package:mytodolist/guard.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => MyGlobalKey();
}

class MyGlobalKey extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isloading = false;
  late AuthRepository authRepository;
  late ScaffoldMessengerState _snackbar;

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    autologin();
  }

  void autologin() {
    setState(() => isloading = true);
    authRepository.autologin().then((authModel) {
      ///Gi pawng ang loading
      if (authModel == null) {
      } else {
        setState(() => isloading = false);

        ///lahos na sa home page
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoListPage(authModel: authModel),
            ));
      }
    }).catchError((e) {
      ///pagngon gihapon ang loading
      setState(() => isloading = false);
    });
  }

  Future<void> login() async {
    if (formkey.currentState!.validate()) {
      setState(() => isloading = true);
      authRepository
          .login(_emailController.text, _passwordController.text)
          .then((authModel) {
        setState(() => isloading = false);

        /// Lahus na sa home page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TodoListPage(authModel: authModel)),
        );
      }).catchError((e) {
        /// Gi pawng ang loading if naay error
        setState(() => isloading = false);

        /// Gi pagawas ang gibati
        _snackbar.showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _snackbar = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 500,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.teal, // Change this to the desired color
                      ),
                      hintText: 'Enter your email',
                      filled: true, // This will enable the background color
                      fillColor: Colors.grey, // Set the background color here
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      return Guard.invalidEmail(value, 'Email');
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 500,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.teal, // Change this to the desired color
                      ),

                      hintText: 'Enter your password',
                      filled: true, // This will enable the background color
                      fillColor: Colors.grey, // Set the background color here
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      return Guard.invalidPassword(value, 'Password');
                    },
                    obscureText: true, // Obfuscate the text
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 500,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          setState(() => isloading = true);
                          authRepository
                              .login(
                            _emailController.text,
                            _passwordController.text,
                          )
                              .then(
                            (value) {
                              setState(() => isloading = false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TodoListPage(authModel: value)),
                              );
                            },
                          ).catchError((e) {
                            setState(() => isloading = false);

                            ///gipagawas ang gibati
                            _snackbar.showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          });
                        } //check if form data are valid
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[500], // Background color
                        onPrimary: Colors.white,
                      ),
                      child: const Text('Login')),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 500,
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );

                        //check if form data are valid
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[500], // Background color
                        onPrimary: Colors.white,
                      ),
                      child: const Text('Register')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
