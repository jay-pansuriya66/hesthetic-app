import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_auth_app/routes/app_pages.dart';
import 'package:flutter_auth_app/services/api_service.dart';
import 'package:flutter_auth_app/services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Modular App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _apiService = ApiService();
  final _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Add a small delay for splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if token exists
    final hasToken = await _storageService.hasToken();

    if (!hasToken) {
      // No token, navigate to login
      _navigateToLogin();
      return;
    }

    // Token exists, validate it
    final response = await _apiService.validateToken();

    if (!mounted) return;

    if (response.success && response.user != null) {
      // Token is valid, navigate to home
      Get.offAllNamed(Routes.HOME);
    } else {
      // Token is invalid, navigate to login
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade600,
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                'Flutter Auth App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
