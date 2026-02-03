import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';
import 'SignUp.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  Future<void> _setSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_welcome', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Image.asset(
              'assets/image/img_welcome.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              /// Login
              ElevatedButton(
                onPressed: () async {
                  await _setSeen();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(250, 60),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              /// Sign Up
              ElevatedButton(
                onPressed: () async {
                  await _setSeen();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Signup()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(250, 60),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
