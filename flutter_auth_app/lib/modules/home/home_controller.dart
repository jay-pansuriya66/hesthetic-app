import 'package:flutter_auth_app/modules/login/login_view.dart';
import 'package:flutter_auth_app/routes/app_pages.dart' show Routes;
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString profileData = ''.obs;
  late final User user;

  @override
  void onInit() {
    super.onInit();
    // Get the user from arguments and ensure it's properly typed
    final userData = Get.arguments;
    if (userData is User) {
      user = userData;
    } else if (userData is Map<String, dynamic>) {
      // If the user data comes as a map, convert it to User object
      user = User.fromJson(userData);
    } else {
      // If we can't get the user, redirect back to login
      Get.offAllNamed('/login');
      return;
    }
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final profile = await _apiService.getProfile();
      profileData.value = 'Protected data loaded:\n${profile.toString()}';
    } catch (e) {
      profileData.value = 'Error loading profile: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
