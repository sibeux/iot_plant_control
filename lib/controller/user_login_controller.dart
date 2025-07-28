import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iot_plant_control/components/colorize_terminal.dart';
import 'package:iot_plant_control/controller/jwt_controller.dart';
import 'package:iot_plant_control/screen/persistent_bar_screen.dart';

class UserLoginController extends GetxController {
  var isLoading = false.obs;
  var isLoginSuccess = true.obs;
  var isRedirecting = false.obs;
  var isObscure = true.obs;

  var currentType = ''.obs;

  var formData = RxMap({
    'usernameLogin': {
      'text': '',
      'type': 'usernameLogin',
      'controller': TextEditingController(),
    },
    'passwordLogin': {
      'text': '',
      'type': 'passwordLogin',
      'controller': TextEditingController(),
    },
  });

  @override
  void onInit() {
    super.onInit();
    isLoading.value = false;
    isLoginSuccess.value = true;
    isRedirecting.value = false;
  }

  void onChanged(String value, String type) {
    final currentController = formData[type]?['controller'];
    // Memperbarui referensi map
    formData[type] = {
      'text': value,
      'type': type,
      'controller': currentController!,
    };
    update();
  }

  void onTap(String type, bool isFocus) {
    final currentController = formData[type]?['controller'];
    final currentText = formData[type]?['text'];
    formData[type] = {
      'text': currentText!,
      'type': type,
      'controller': currentController!,
    };
    currentType.value = isFocus ? type : '';
    update();
  }

  void onClearController(String type) {
    final currentController =
        formData[type]?['controller'] as TextEditingController;
    currentController.clear();
    formData[type] = {
      'text': '',
      'type': type,
      'controller': currentController,
    };
    update();
  }

  void toggleObscure() {
    isObscure.value = !isObscure.value;
    update();
  }

  bool getIsDataLoginValid() {
    final usernameValue = formData['usernameLogin']!['text'].toString();
    return usernameValue.isNotEmpty &&
        formData['passwordLogin']!['text'].toString().isNotEmpty;
  }

  get isObscureValue => isObscure.value;

  Future<void> generateJwtLogin({
    required String username,
    required String password,
  }) async {
    isLoading.value = true;

    final jwtController = Get.find<JwtController>();
    const String url = 'https://sibeux.my.id/project/myplant-php-jwt/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        isLoginSuccess.value = true;
        isLoading.value = false;
        isRedirecting.value = true;
        final jsonResponse = jsonDecode(response.body);
        await jwtController.setToken(
          token: jsonResponse['token'],
          username: username,
        );
        logSuccess('Login successful, token: ${response.body}');
        Get.offAll(
          () => PersistentBarScreen(),
          transition: Transition.rightToLeftWithFade,
          fullscreenDialog: true,
          popGesture: false,
        );
      } else {
        isLoginSuccess.value = false;

        logError('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      logError('error from generateJwtLogin: $e');
    } finally {
      isLoading.value = false;
      isRedirecting.value = false;
    }
  }
}
