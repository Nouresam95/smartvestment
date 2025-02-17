import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartvestment/screens/intro_screen.dart';
import 'package:smartvestment/screens/main_page.dart';
import 'package:smartvestment/localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; // ✅ استيراد Provider
import 'package:smartvestment/providers/language_provider.dart'; // ✅ استيراد LanguageProvider
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    await dotenv.load(fileName: ".env"); // تحميل المتغيرات
   runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

/// ✅ التحقق من حالة المستخدم
void checkUserStatus(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && user.emailVerified) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // ✅ استدعاء الـ Provider

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smartvestment',
      theme: ThemeData(primarySwatch: Colors.grey),
      locale: languageProvider.locale, // ✅ تحديث اللغة فورًا
      supportedLocales: const [
        Locale('en', ''), // الإنجليزية
        Locale('ar', ''), // العربية
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const IntroScreen(), // ✅ بدون تغيير الصفحة الرئيسية
    );
  }
}