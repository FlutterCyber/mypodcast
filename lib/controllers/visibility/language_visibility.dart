import 'package:get/get.dart';

class LanguageVisibleController extends GetxController{
  var isVisible = false.obs;
  void changeVisibility() {
    isVisible.value = !isVisible.value;
  }

}