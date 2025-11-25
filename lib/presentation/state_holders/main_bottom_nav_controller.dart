import 'package:get/get.dart';
import 'auth_controller.dart';

class MainBottomNavController extends GetxController {
  int _selectedIndex = 0;

  int get currentIndex => _selectedIndex;

  void changeIndex(int index) {
    if (index == _selectedIndex) return;

    // ✔ Update selected index
    _selectedIndex = index;
    update();
  }

  void backToHome() {
    changeIndex(0);
  }
}
