import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/pages/home_page.dart';
import 'core/constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPurple),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
