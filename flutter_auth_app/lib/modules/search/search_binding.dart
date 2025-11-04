import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_controller.dart' show SearchControllerX;

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchControllerX>(() => SearchControllerX());
  }
}
