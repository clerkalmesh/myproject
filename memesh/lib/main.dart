import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:memesh/controllers/auth_controllers.dart';
import 'package:memesh/services/auth_services.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:memesh/theme/app_theme.dart';
import 'package:memesh/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MemeshApp());
}

class MemeshApp extends StatelessWidget {
  const MemeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Memesh Network',
    //  theme: AppTheme.themeLight,
    //  themeMode: ThemeMode.light,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      // 🔴 TAMBAHKAN INI UNTUK INITIALIZE CONTROLLER
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController()); // <-- PENTING!
      }),
    );
  }
}
