import 'package:get/get.dart';

import 'controllers/language_controller.dart';



class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LanguageController(), permanent: true);

    // later you can enable:
    // Get.put(AuthController(), permanent: true);
    // Get.put(MainNavController(), permanent: true);
  }
}
