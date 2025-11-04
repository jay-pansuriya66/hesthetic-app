import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
        actions: [
          // Theme toggle button
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                themeController.toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display different text based on theme
            Obx(() => Text(
                  themeController.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: Theme.of(context).textTheme.displayLarge,
                )),
            const SizedBox(height: 20),
            // Example button with theme styling
            ElevatedButton(
              onPressed: () {
                // Show a snackbar with current theme info
                Get.snackbar(
                  'Theme Changed',
                  'Current theme: ${themeController.isDarkMode ? 'Dark' : 'Light'} Mode',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('Show Theme Info'),
            ),
            const SizedBox(height: 20),
            // Example card with theme colors
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Welcome to the App',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This text will automatically adapt to the current theme',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
