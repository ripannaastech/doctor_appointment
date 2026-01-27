import 'package:doctor_appointment/features/appointment/presentation/ui/controller/booking_controller.dart';
import 'package:doctor_appointment/features/auth/presentation/ui/controller/auth_controller.dart';
import 'package:doctor_appointment/features/dashboard/presentation/ui/controller/dashboard_controller.dart';
import 'package:doctor_appointment/features/home/presentation/ui/controller/home_controller.dart';
import 'package:doctor_appointment/features/lab_test/presentation/ui/controller/lab_report_controller.dart';
import 'package:doctor_appointment/features/profile/presentation/ui/controller/profle_controller.dart';
import 'package:get/get.dart';
import 'controllers/language_controller.dart';



class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LanguageController(), permanent: true);
    Get.lazyPut<AuthControllerGetx>(() => AuthControllerGetx(), fenix: true);
    Get.lazyPut<ProfileControllerGetx>(() => ProfileControllerGetx(), fenix: true);
    Get.lazyPut<BookingController>(() => BookingController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<LabReportController>(() => LabReportController(), fenix: true);
    Get.lazyPut<LabReportController>(() => LabReportController(), fenix: true);
  }
}
