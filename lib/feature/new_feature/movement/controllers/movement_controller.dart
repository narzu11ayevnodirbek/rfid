import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/movement_task_model.dart';
import '../services/movement_task_service.dart';

class MovementController extends GetxController {
  final MovementTaskService _service = MovementTaskService();

  RxList<MovementTaskModel> movements = <MovementTaskModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    fetchMovements();
    super.onInit();
  }

  Future<void> fetchMovements() async {
    isLoading.value = true;
    movements.value = await _service.getTasks();
    isLoading.value = false;
  }

  // Future<void> refreshMovements() async {
  //   isRefreshing.value = true;
  //   movements.value = await _service.getTasks();
  //   isRefreshing.value = false;
  // }

  Future<void> refreshMovements() async {
    try {
      isRefreshing.value = true;

      // Loading snackbar
      Get.snackbar(
        'Yangilanmoqda...',
        "Ma'lumotlar yuklanmoqda",
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
        duration: const Duration(seconds: 2),
      );

      movements.value = await _service.getTasks();

      // Success snackbar
      Get.snackbar(
        'Muvaffaqiyatli ✅',
        "Ma'lumotlar yangilandi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Error snackbar
      Get.snackbar(
        'Xatolik ❌',
        "Qayta urunib ko'ring",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration:   Duration(seconds: 3),
      );
    } finally {
      isRefreshing.value = false;
    }
  }

}
