// ignore_for_file: unused_import, prefer_const_constructors

// นำเข้าการตั้งค่าต่าง ๆ และ dependency ที่จำเป็น
import 'package:budget_tracker_application_2/firebase_options.dart'; // การตั้งค่า Firebase
import 'package:budget_tracker_application_2/screens/splashscreen.dart'; // หน้าจอเริ่มต้น SplashScreen
import 'package:budget_tracker_application_2/widgets/auth_gate.dart';
import 'package:budget_tracker_application_2/screens/stock_screen.dart'; // เพิ่มหน้าจอหุ้น
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ใช้สำหรับการตั้งค่าฟอนต์
import 'package:flutter_localizations/flutter_localizations.dart'; // รองรับการแปลภาษาในแอป

// main ฟังก์ชันเริ่มต้นแอป
Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // ทำให้ Flutter รอการเริ่มต้น Firebase ก่อน
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // ใช้การตั้งค่า Firebase สำหรับแพลตฟอร์มปัจจุบัน
  );
  runApp(const MyApp());
}

// คลาส MyApp เป็น StatelessWidget หลักของแอปพลิเคชัน
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ปิดการแสดงแถบ debug
      title: 'Budget Tracker',
      locale: const Locale('th', 'TH'), // ตั้งค่าเริ่มต้นให้รองรับภาษาไทย
      supportedLocales: const [
        Locale('en', 'US'), // รองรับภาษาอังกฤษ
        Locale('th', 'TH'), // รองรับภาษาไทย
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0), // ปรับการสเกลของข้อความ
          ),
          child: child!,
        );
      },
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme, // ใช้ฟอนต์ Prompt ซึ่งรองรับภาษาไทย
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple), // ตั้งค่าโทนสีเริ่มต้น
        useMaterial3: true, // ใช้องค์ประกอบของ Material Design 3
      ),
      home: const SplashScreen(), // หน้าเริ่มต้นคือ SplashScreen
      routes: {
        '/stock': (context) => StockScreenUI(), // เส้นทางใหม่สำหรับหน้าจอหุ้น
      },
    );
  }
}
