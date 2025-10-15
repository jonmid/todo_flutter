import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/pages/auth_gate.dart';
import 'core/constants/app_colors.dart';
import 'core/config/supabase_config.dart';
import 'presentation/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Supabase
    await SupabaseConfig.initialize();
    // Register global AuthController
    Get.put(AuthController(), permanent: true);
    runApp(const MyApp());
  } catch (e) {
    // If Supabase initialization fails, show error and run app anyway
    print('Error initializing Supabase: $e');
    runApp(const MyApp());
  }
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
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
