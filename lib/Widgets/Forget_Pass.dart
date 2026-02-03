import 'package:flutter/material.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController emailControler = TextEditingController();
  //  final TextEditingController PasswordControler=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        )),
        body: Padding(
          padding: EdgeInsets.only(top: 150),
          child: Column(
            children: [
              Text(
                "Forget Password",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextFiled(
                  hint: "enter your email",
                  controller: emailControler,
                  icon: Icons.email),
              SizedBox(
                height: 20,
              ),
              CustomButton(onPressed: () {}, text: "SEND")
            ],
          ),
        ),
      ),
    );
  }
}




//--------------------------------------------//
//----------------------TEXT FILED----------------//
//--------------------------------------------//

class CustomTextFiled extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final IconData icon;
  const CustomTextFiled({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: Icon(icon),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

//--------------------------------------------//
//----------------------BUTTON----------------//
//--------------------------------------------//
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17))),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 23, color: Colors.white),
          )),
    );
  }
}

