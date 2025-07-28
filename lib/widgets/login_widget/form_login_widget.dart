import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/user_login_controller.dart';

class UsernameLoginForm extends StatelessWidget {
  const UsernameLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormBlueprint(
      formType: 'usernameLogin',
      formText: 'username',
      keyboardType: TextInputType.name,
      icon: Icons.person,
      autoFillHints: AutofillHints.username,
    );
  }
}

class PasswordLoginForm extends StatelessWidget {
  const PasswordLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormBlueprint(
      formType: 'passwordLogin',
      formText: 'password',
      keyboardType: TextInputType.visiblePassword,
      icon: Icons.lock,
      autoFillHints: '',
    );
  }
}

class FormBlueprint extends StatelessWidget {
  const FormBlueprint({
    super.key,
    required this.formType,
    required this.keyboardType,
    required this.icon,
    required this.formText,
    required this.autoFillHints,
  });

  final String formType, formText, autoFillHints;
  final TextInputType keyboardType;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final userLoginController = Get.put(UserLoginController());
    final controller = userLoginController.formData[formType]?['controller'];
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: TextFormField(
          controller: controller as TextEditingController?,
          cursorColor: HexColor('#575757'),
          textAlignVertical: TextAlignVertical.center,
          enableSuggestions: true,
          autofillHints: [autoFillHints],
          keyboardType: keyboardType,
          obscureText:
              formType.toLowerCase().contains('password')
                  ? userLoginController.isObscureValue
                  : false,
          onChanged: (value) {
            userLoginController.onChanged(value, formType);
          },
          onTap: () {
            userLoginController.onTap(formType, true);
          },
          onTapOutside: (event) {
            userLoginController.onTap(formType, false);
            FocusManager.instance.primaryFocus?.unfocus();
          },
          style: const TextStyle(color: Colors.black, fontSize: 12),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: HexColor('#575757')),
            suffixIcon:
                formType.toLowerCase().contains('password')
                    ? Obx(
                      () =>
                          userLoginController.isObscureValue == false
                              ? GestureDetector(
                                onTap: () {
                                  userLoginController.toggleObscure();
                                },
                                child: Icon(
                                  Icons.visibility_off,
                                  color: HexColor('#575757'),
                                ),
                              )
                              : GestureDetector(
                                onTap: () {
                                  userLoginController.toggleObscure();
                                },
                                child: Icon(
                                  Icons.visibility,
                                  color: HexColor('#575757'),
                                ),
                              ),
                    )
                    : null,
            filled: true,
            isDense: true,
            fillColor: HexColor('#fefffe'),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 12,
            ),
            hintText: formText.capitalize,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 45,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 45,
            ),
            enabledBorder: outlineInputBorder(formType),
            focusedBorder: outlineInputBorder(formType),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder outlineInputBorder(String formType) {
  final userLoginController = Get.put(UserLoginController());
  final textValue = userLoginController.formData[formType]?['text'].toString();
  final isCurrentType = userLoginController.currentType.value == formType;

  return OutlineInputBorder(
    borderSide: BorderSide(
      color:
          (isCurrentType || textValue!.isNotEmpty)
              ? formType.toLowerCase().contains('login') &&
                      !userLoginController.isLoginSuccess.value
                  ? HexColor('#ff0000').withValues(alpha: 0.5)
                  : Color.fromARGB(255, 69, 214, 149).withValues(alpha: 0.5)
              : HexColor('#575757').withValues(alpha: 0.5),
      width: 2,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(7)),
  );
}
