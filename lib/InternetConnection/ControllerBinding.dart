import 'package:get/get.dart';

import 'ConnectionManagerController.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectionManagerController>(
            () => ConnectionManagerController());
  }
}