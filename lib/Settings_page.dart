import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/Login.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'locale_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات'), centerTitle: true),

      // 🌍 الصفحة عربية RTL
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ===== USER INFO =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Text(
                    user?.displayName != null && user!.displayName!.isNotEmpty
                        ? user.displayName![0].toUpperCase()
                        : "U",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  user?.displayName ?? 'مستخدم',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(user?.email ?? ''),
              ),
            ),

            const SizedBox(height: 30),

            // ===== SETTINGS =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('الملف الشخصي'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // لاحقًا: صفحة تعديل البروفايل
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('اللغة'),
                    subtitle: Text(
                      context.watch<LocaleProvider>().locale.languageCode ==
                              'ar'
                          ? 'العربية'
                          : 'English',
                    ),
                    trailing: const Icon(Icons.swap_horiz),
                    onTap: () {
                      context.read<LocaleProvider>().toggleLanguage();
                    },
                  ),

                  const Divider(height: 1),

                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode),
                    title: const Text('الوضع الليلي'),
                    value: themeProvider.isDark,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ===== LOGOUT =====
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
