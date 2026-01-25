import 'package:doctor_appointment/features/auth/presentation/ui/controller/auth_controller.dart';
import 'package:doctor_appointment/features/profile/presentation/ui/controller/profle_controller.dart';
import 'package:get/get.dart';

import 'controllers/language_controller.dart';



class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LanguageController(), permanent: true);
    Get.lazyPut<AuthControllerGetx>(() => AuthControllerGetx(), fenix: true);
    Get.lazyPut<ProfileControllerGetx>(() => ProfileControllerGetx(), fenix: true);

    // later you can enable:
    // Get.put(AuthController(), permanent: true);
    // Get.put(MainNavController(), permanent: true);
  }
}
