import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';
import '../../widgets/search_widget.dart';
import 'package:searchfield/searchfield.dart';

String lastValue = "";

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  final Rx<SearchFieldListItem<Hotel>?> selectedValue =
      Rx<SearchFieldListItem<Hotel>?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(11, 41, 65, 1),
              const Color.fromARGB(255, 79, 233, 212),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.person_add_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    SearchField<String>(
                      searchInputDecoration: SearchInputDecoration(
                        hintText: 'Search for Hotel',
                        fillColor: Color.fromARGB(249, 255, 255, 255),
                        prefixIcon: Icon(Icons.search),
                        suffix: Icon(Icons.expand_more),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSearchTextChanged: (query) async {
                        if (query.isNotEmpty) {
                          controller.query.value = query;
                          // lastValue = query;
                          if (query.isNotEmpty) {
                            // await Future.delayed(const Duration(seconds: 2));
                            if (lastValue == query) {
                              // await controller.searchItems();
                            }
                          } else {
                            // controller.results.clear();
                          }
                        }
                        return controller.hotelItems
                            .map((searchItem) => SearchFieldListItem<String>(
                                  searchItem.item?.name ??
                                      'No Name', // Added null check with fallback
                                  value: searchItem.item?.address ??
                                      'No Address', // Also added for consistency
                                  child: Text(searchItem.item?.name ??
                                      'No Name'), // And here
                                ))
                            .toList();
                      },
                      //selectedValue: selectedValue.value,
                      onSuggestionTap: (SearchFieldListItem<String> item) {
                        //selectedValue.value = item;
                        print('Selected: ${item.searchKey}');
                        print('Selected value: ${item.value}');

                        // controller.getAddress(item.value);
                      },
                      suggestions: controller.results
                          .map((hotel) => SearchFieldListItem<String>(
                                // Changed from Hotel to String
                                hotel.name, // Use hotel.name as the value
                                child: Text(hotel.name),
                              ))
                          .toList(),
                      suggestionState: Suggestion.expand,
                    ),

                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => TextFormField(
                        controller: controller.confirmPasswordController,
                        obscureText: controller.obscureConfirmPassword.value,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureConfirmPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed:
                                controller.toggleConfirmPasswordVisibility,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != controller.passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
