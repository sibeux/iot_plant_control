import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iot_plant_control/controller/user_login_controller.dart';
import 'package:iot_plant_control/widgets/login_widget/button_login_widget.dart';
import 'package:iot_plant_control/widgets/login_widget/form_login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authController = Get.put(AuthFormController());
    final userLoginController = Get.put(UserLoginController());
    return Stack(
      children: [
        Scaffold(
          backgroundColor: HexColor('#fefffe'),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(backgroundColor: HexColor('#fefffe'), titleSpacing: 0),
          body: Column(
            children: [
              SizedBox(height: 30.h),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 69, 214, 149),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Mohon masuk ke dalam akun anda',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30.h),
              const UsernameLoginForm(),
              SizedBox(height: 10.h),
              const PasswordLoginForm(),
              Obx(
                () =>
                    !userLoginController.isLoginSuccess.value
                        ? Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 5.h),
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            '*Username atau password tidak sesuai',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.red.withValues(alpha: 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                        : const SizedBox(),
              ),
              SizedBox(height: 30.h),
              Obx(
                () =>
                    userLoginController.getIsDataLoginValid()
                        ? userLoginController.isLoading.value
                            ? const AbsorbPointer(child: AuthButtonLoading())
                            : const LoginSubmitButtonEnable()
                        : const AbsorbPointer(
                          child: LoginSubmitButtonDisable(),
                        ),
              ),
            ],
          ),
        ),
        Obx(
          () =>
              userLoginController.isRedirecting.value
                  ? const Opacity(
                    opacity: 0.8,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.black,
                    ),
                  )
                  : const SizedBox(),
        ),
        Obx(
          () =>
              userLoginController.isRedirecting.value
                  ? Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : const SizedBox(),
        ),
      ],
    );
  }
}
