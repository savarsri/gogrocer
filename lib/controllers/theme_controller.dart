import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable for current theme mode
  var isDarkMode = false.obs;

  // Toggle between light and dark mode
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Initialize the theme based on system setting
  @override
  void onInit() {
    isDarkMode.value = Get.isDarkMode;
    super.onInit();
  }
}
