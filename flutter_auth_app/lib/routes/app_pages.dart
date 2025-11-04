import 'package:flutter_auth_app/modules/home/home_binding.dart';
import 'package:flutter_auth_app/modules/home/home_view.dart';
import 'package:flutter_auth_app/modules/login/login_binding.dart';
import 'package:flutter_auth_app/modules/login/login_view.dart';
import 'package:flutter_auth_app/modules/register/register_binding.dart';
import 'package:flutter_auth_app/modules/register/register_view.dart';
import 'package:flutter_auth_app/modules/search/search_binding.dart';
import 'package:flutter_auth_app/modules/search/search_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(userData: Get.arguments),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: '/search',
      page: () => const SearchView(),
      binding: SearchBinding(),
    )
  ];
}
