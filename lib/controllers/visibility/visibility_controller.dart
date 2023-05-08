import 'package:get/get.dart';

class VisibleController extends GetxController {
  var isVisible = false.obs;
  var badgeIsVisible = false.obs;

  void changeVisibility() {
    isVisible.value = !isVisible.value;
  }
}
