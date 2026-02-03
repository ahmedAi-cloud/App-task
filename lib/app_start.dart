import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Welcom_page.dart';
import 'auth_gate.dart';

class AppStart extends StatefulWidget {
  const AppStart({super.key});

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  bool? isFirstOpen;

  @override
  void initState() {
    super.initState();
    _checkFirstOpen();
  }

  Future<void> _checkFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenWelcome = prefs.getBool('seen_welcome') ?? false;

    setState(() {
      isFirstOpen = !seenWelcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstOpen == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isFirstOpen!) {
      return const Welcomepage();
    }

    return const AuthGate();
  }
}
