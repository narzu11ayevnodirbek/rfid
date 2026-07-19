import 'package:get/get.dart';
import 'package:rfid/feature/new_feature/utils/app_snackbar.dart';
import 'package:rfid/feature/new_feature/movement/models/movement_task_model.dart';
import 'package:rfid/feature/new_feature/movement/services/movement_task_service.dart';

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

  Future<void> refreshMovements() async {
    try {
      isRefreshing.value = true;
      movements.value = await _service.getTasks();
      AppSnackbar.showSuccess('Успешно', 'Данные обновлены');
    } catch (e) {
      AppSnackbar.showError('Ошибка', 'Не удалось обновить данные');
    } finally {
      isRefreshing.value = false;
    }
  }
}
