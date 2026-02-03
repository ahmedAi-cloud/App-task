import 'package:flutter/material.dart';
import 'package:login/Login.dart';
import 'Firebase/auth_firebase.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthFirebase auth = AuthFirebase();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // إنشاء user document في Firestore
  Future<void> createUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      await userRef.set({
        'username': usernameController.text.trim(),
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),

      // 🔥 الصفحة كلها LTR
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                // Username
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    suffixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    suffixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus(); // يقفل الكيبورد

                      if (usernameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("من فضلك املأ جميع الحقول"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16),
                          ),
                        );
                        return;
                      }

                      try {
                        await auth.signupUsingUsernameEmailAndPassword(
                          username: usernameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (!mounted) return;

                        await createUserDoc();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) =>  Login()),
                          (route) => false,
                        );
                      } on FirebaseAuthException catch (e) {
                        String message = "فشل إنشاء الحساب";

                        switch (e.code) {
                          case 'email-already-in-use':
                            message = "البريد الإلكتروني مستخدم بالفعل";
                            break;
                          case 'invalid-email':
                            message = "البريد الإلكتروني غير صالح";
                            break;
                          case 'weak-password':
                            message = "كلمة المرور ضعيفة";
                            break;
                          case 'network-request-failed':
                            message = "تأكد من اتصال الإنترنت";
                            break;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("حدث خطأ غير متوقع، حاول مرة أخرى"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16),
                          ),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      ' Sign UP',
                      style: TextStyle(fontSize: 23, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

              
                  
                   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I have an account ! ",
                      style: TextStyle(fontSize: 18,color: Colors.black),),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Login()),
                        );
                      },
                      child: TextButton(onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Login()),
                    );
                  },  child: Text('Login',style: TextStyle(fontSize: 18),))
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
