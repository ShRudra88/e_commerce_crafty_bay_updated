import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/create_profile_params.dart';
import '../../../state_holders/complete_profile_controller.dart';
import '../../../state_holders/verify_otp_controller.dart';
import '../../helping_widgets/app_logo.dart';
import '../../helping_widgets/center_circular_progress_indicator.dart';
import '../main_bottom_nav_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _cityTEController = TextEditingController();
  final TextEditingController _shippingAddressTEController =
  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------------- NEW APP BAR -------------------------
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Complete Profile"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),

                const AppLogo(height: 80),
                const SizedBox(height: 16),

                Text(
                  'Complete Profile',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Get started with us with your details',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),

                // ----------------- TEXT FIELDS -------------------------
                _buildTextField(_firstNameTEController, 'First name'),
                _gap(),
                _buildTextField(_lastNameTEController, 'Last name'),
                _gap(),
                _buildTextField(_mobileTEController, 'Mobile',
                    keyboardType: TextInputType.phone),
                _gap(),
                _buildTextField(_cityTEController, 'City'),
                _gap(),
                TextFormField(
                  controller: _shippingAddressTEController,
                  maxLines: 4,
                  decoration:
                  const InputDecoration(hintText: 'Shipping address'),
                  validator: (value) =>
                  value!.isEmpty ? "Enter your shipping address" : null,
                ),
                const SizedBox(height: 30),

                // ---------------- SUBMIT BUTTON ------------------------
                SizedBox(
                  width: double.infinity,
                  child: GetBuilder<CompleteProfileController>(
                      builder: (controller) {
                        return Visibility(
                          visible: controller.inProgress == false,
                          replacement: const CenterCircularProgressIndicator(),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final params = CreateProfileParams(
                                  firstName: _firstNameTEController.text.trim(),
                                  lastName: _lastNameTEController.text.trim(),
                                  mobile: _mobileTEController.text.trim(),
                                  city: _cityTEController.text.trim(),
                                  shippingAddress:
                                  _shippingAddressTEController.text.trim(),
                                );

                                final token =
                                    Get.find<VerifyOTPController>().token;

                                final bool result = await controller
                                    .createProfileData(token, params);

                                if (result) {
                                  Get.offAll(() => const MainBottomNavScreen());
                                } else {
                                  Get.showSnackbar(GetSnackBar(
                                    title: 'Complete profile failed',
                                    message: controller.errorMessage,
                                    duration: const Duration(seconds: 2),
                                  ));
                                }
                              }
                            },
                            child: const Text(
                              'Complete Profile',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Get.offAll(() => const MainBottomNavScreen());
                    },
                    child: const Text(
                      "Skip & Go to Home",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? "Enter $hint" : null,
    );
  }

  SizedBox _gap() => const SizedBox(height: 16);

  @override
  void dispose() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _cityTEController.dispose();
    _mobileTEController.dispose();
    _shippingAddressTEController.dispose();
    super.dispose();
  }
}
