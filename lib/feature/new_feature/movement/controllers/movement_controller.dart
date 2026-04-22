import 'package:get/get.dart';
import '../../utils/app_snackbar.dart';
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
      movements.value = await _service.getTasks();
      AppSnackbar.showSuccess('Успешно', 'Данные обновлены');
    } catch (e) {
      AppSnackbar.showError('Ошибка', 'Не удалось обновить данные');
    } finally {
      isRefreshing.value = false;
    }
  }

}
