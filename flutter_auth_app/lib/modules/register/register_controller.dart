import 'package:flutter/material.dart';
import 'package:flutter_auth_app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import '../../services/api_service.dart';

class Hotel {
  String name;
  String address;
  Map<String, dynamic> data;

  Hotel(this.name, this.address, this.data);
}

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final locationController = TextEditingController();
  final apiService = ApiService();
  final _apiService = ApiService();

  /// Text input by user
  var query = ''.obs;

  /// Search results list
  // var results = <SearchModel>[].obs;
  var results = <Hotel>[].obs;
  var address = <Map<String, dynamic>>[].obs;
  var data = <String, dynamic>{}.obs;
  var apiResponse;
  late List<SearchFieldListItem<Hotel>> hotelItems;

  /// Loading statea
  var isLoading = false.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var formSubmitted = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    debounce(query, (_) => searchItems(query.value),
        time: const Duration(milliseconds: 1000));
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> searchItems(String value) async {
    if (value.isEmpty) {
      results.clear();
      hotelItems.clear();
      return;
    }

    try {
      isLoading.value = true;

      // await Future.delayed(const Duration(seconds: 2));

      final response = await _apiService.searchHotel(value);
      apiResponse = response;

      // Map the API response to include both display name and type
      results.value = response.map<Hotel>((item) {
        final name = item['display_name']?.toString() ?? 'No name';
        final address = item['address']?.toString() ?? 'No address';
        return Hotel(name, address, Map<String, dynamic>.from(item));
      }).toList();

      print("response : api called");

      // Convert API response to List<Hotel>
      final hotels = response.map<Hotel>((item) {
        final name = item['display_name']?.toString() ?? 'No name';
        final address = item['address']?.toString() ?? 'No address';
        return Hotel(name, address, Map<String, dynamic>.from(item));
      }).toList();

      hotelItems = hotels.map(
        (Hotel ht) {
          return SearchFieldListItem<Hotel>(
            ht.name,
            value: ht.address, // you can change this to ht.name if you want
            item: ht,
          );
        },
      ).toList();
    } catch (e) {
      print('Error searching hotels: $e');
      // Optionally show error to user
      // Get.snackbar('Error', 'Failed to search for hotels');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAddress(String name) async {
    final filtered = apiResponse
        .where((item) => item['display_name'] == name)
        .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item['address'] ?? {}))
        .toList();

    address.value = filtered; // address is RxList<Map<String, dynamic>>
    data.assignAll(
        address.firstOrNull ?? {}); // safely assign first address map

    print(data["city"]);
    print(data["country"]);
    print(data["postcode"]);
    print(address);
  }

  Future<void> register() async {
    formSubmitted.value = true;

    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final response = await apiService.register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      location: locationController.text.trim(),
    );

    isLoading.value = false;

    if (response.success) {
      Get.snackbar(
        'Success',
        response.message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.HOME, arguments: response.user);
    } else {
      Get.snackbar(
        'Error',
        response.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
