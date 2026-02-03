import 'package:flutter/material.dart';
import 'package:login/SignUp.dart';
import 'package:login/Home_page.dart';
import 'package:login/Widgets/Forget_Pass.dart';
import 'Firebase/auth_firebase.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthFirebase auth = AuthFirebase();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // تأكيد وجود user document
  Future<void> createUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      await userRef.set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page'), centerTitle: true),

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
                  'Welcome Back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

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
                SizedBox(height: 10
                ,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end  ,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ForgetPass())
                         );
                       },
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle( fontSize: 17),
                      ),
                    )
                  ],
                ),
                

                 SizedBox(height: 10),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus(); // يقفل الكيبورد

                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "من فضلك أدخل البريد الإلكتروني وكلمة المرور",
                            ),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16),
                          ),
                        );
                        return;
                      }

                      try {
                        await auth.loginUsingEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (!mounted) return;

                        await createUserDoc();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (route) => false,
                        );
                      } on FirebaseAuthException catch (e) {
                        String message = "فشل تسجيل الدخول";

                        switch (e.code) {
                          case 'user-not-found':
                            message = "الحساب غير موجود";
                            break;
                          case 'wrong-password':
                            message = "كلمة المرور غير صحيحة";
                            break;
                          case 'invalid-email':
                            message = "البريد الإلكتروني غير صالح";
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
                      ' Login',
                      style: TextStyle(fontSize: 23, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ",
                      style: TextStyle(fontSize: 18,),),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Signup()),
                        );
                      },
                      child: const Text('Sign Up',style: TextStyle(fontSize: 18,)),
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
