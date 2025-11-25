import 'package:e_commerce_crafty_bay_updated/presentation/ui/screens/auth/verify_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../state_holders/auth_controller.dart';
import '../../helping_widgets/app_logo.dart';
import '../main_bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future<void> moveToNextScreen() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    AuthController auth = Get.find<AuthController>();
    await auth.initialize();

    if (auth.isTokenNotNull) {
      Get.offAll(const MainBottomNavScreen());
    } else {
      Get.offAll(() => const VerifyEmailScreen());
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
            children: [
              Spacer(),
              AppLogo(),
              Spacer(),
              CircularProgressIndicator(),
              SizedBox(
                height: 16,
              ),
              Text('Version 1.1'),
              SizedBox(
                height: 16,
              ),
            ],
          )),
    );
  }
}