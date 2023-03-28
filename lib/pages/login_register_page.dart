import 'package:firebase_auth_project/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController telcontroller = TextEditingController();
  final TextEditingController _controllerPermissionlevel =
      TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return Row(
      children: [
        Icon(Icons.build_sharp, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Icon(
          Icons.report_gmailerrorred_sharp,
          color: Color.fromARGB(255, 77, 80, 82),
        ),
        const Text(
          'Report App',
          style: TextStyle(
            color: Color.fromARGB(255, 77, 80, 82),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _entryInfo(
    TextEditingController nameController,
    TextEditingController telController,
  ) {
    String? prefixValue = 'Mr.'; // default prefix value

    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: 'Mr.',
              groupValue: prefixValue,
              onChanged: (value) {
                prefixValue = value;
                setState(
                    () {}); // Assuming this function is inside a stateful widget.
              },
            ),
            Text('Mr.'),
            Radio(
              value: 'Mrs.',
              groupValue: prefixValue,
              onChanged: (value) {
                prefixValue = value;
                setState(() {});
              },
            ),
            Text('Mrs.'),
            Radio(
              value: 'Ms.',
              groupValue: prefixValue,
              onChanged: (value) {
                prefixValue = value;
                setState(() {});
              },
            ),
            Text('Ms.'),
          ],
        ),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: telController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Telephone Number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _entryField(
      String title, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: title == 'Password',
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        errorMessage == '' ? '' : 'Oops! $errorMessage',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.login, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            isLogin ? 'Login' : 'Register',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'Register instead' : 'Login instead',
        style: const TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: _title(),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/logo.png"),
                // _entryInfo(namecontroller, telcontroller),
                const SizedBox(height: 15),
                _entryField("Email", _controllerEmail, Icons.email),
                const SizedBox(height: 15),
                _entryField("Password", _controllerPassword, Icons.lock),
                const SizedBox(height: 15),
                _errorMessage(),
                const SizedBox(height: 15),
                _submitButton(),
                const SizedBox(height: 15),
                _loginOrRegisterButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
