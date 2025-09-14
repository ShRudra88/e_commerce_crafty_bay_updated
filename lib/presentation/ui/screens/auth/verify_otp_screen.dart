import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../state_holders/verify_otp_controller.dart';
import '../../helping_widgets/app_logo.dart';
import '../../helping_widgets/center_circular_progress_indicator.dart';
import '../../utility/app_colors.dart';
import '../auth/complete_profile_screen.dart';
import 'package:get/get.dart';

import '../main_bottom_nav_screen.dart';


class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int start = 120;
  late String count;

  @override
  void initState() {
    super.initState();
    countOTPTimer();
  }

  void countOTPTimer() {
   // const oneSec = Duration(milliseconds: 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                const AppLogo(
                  height: 80,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Enter OTP Code',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'A 4 digit OTP code has been sent',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 24,
                ),
                PinCodeTextField(
                  controller: _otpTEController,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      inactiveColor: AppColors.primaryColor,
                      selectedFillColor: Colors.transparent,
                      selectedColor: Colors.purple),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  appContext: context,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: GetBuilder<VerifyOTPController>(
                      builder: (verifyOtpController) {
                        return Visibility(
                          visible: verifyOtpController.inProgress == false,
                          replacement: const CenterCircularProgressIndicator(),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final bool response = await verifyOtpController.verifyOTP(
                                    widget.email, _otpTEController.text);
                                if (response) {
                                  if (verifyOtpController.shouldNavigateCompleteProfile) {
                                    Get.to(() => const CompleteProfileScreen());
                                  } else {
                                    Get.offAll(() => const MainBottomNavScreen());
                                  }
                                } else {
                                  Get.showSnackbar(GetSnackBar(
                                    title: 'OTP verification failed',
                                    message: verifyOtpController.errorMessage,
                                    duration: const Duration(seconds: 2),
                                    isDismissible: true,
                                  ));
                                }
                              }
                            },
                            child: const Text('Next'),
                          ),
                        );
                      }
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(text: 'This code will expire in '),
                      // TODO - make this timer workable
                      TextSpan(
                        text: '$start',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      start = 120;
                    });
                    countOTPTimer();
                  },
                  child: const Text(
                    'Resend Code',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}