import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // 1. Make it a singleton
  static ThemeController get to => Get.find();

  // 2. Store the current theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // 3. Initialize with system theme
  @override
  void onInit() {
    super.onInit();
    _themeMode.value = ThemeMode.system;
  }

  // 4. Toggle between light and dark theme
  void toggleTheme() {
    _themeMode.value = _themeMode.value == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
  }

  // 5. Check if dark mode is enabled
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;
}
