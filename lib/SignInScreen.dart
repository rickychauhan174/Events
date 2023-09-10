import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/SignUpScreen.dart';

import 'main.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email = "";
  String _password = "";

  void _signIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        // User successfully signed in
        print("User signed in: ${userCredential.user!.email}");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EventsPage()));
        // You can navigate to another screen or perform other actions here.
      } catch (e) {
        // Handle sign-in errors
        print("Error signing in: $e");
        if(e.toString().contains('configuration-not-found')){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User not found'),
          ));
        }else if(e.toString().contains('invalid-email')){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid email'),
          ));
        }
        // You can display an error message to the user here.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff80cbc4),
        centerTitle: false,
        title: Text("AVENTI",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xff000000),
            shadows: [
              Shadow(
                color: Color(0xffffffff),
                offset: Offset(3.0, 3.0),
                blurRadius: 3.0,
              ),
            ],
          ),),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn,
                  child: Text('Sign In'),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  },
                    child: Text("Don't have account? Sign Up")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}