import 'package:rf_id_test/feature/new_feature/movement/services/movement_service.dart';
import 'models/movement_item.dart';

class MovementRepository {
  MovementRepository(this.apiService);

  final MovementService apiService;

  Future<List<MovementItem>> fetchMovementItems(int movementId) =>
      apiService.getMovementItems(
        movementId: movementId,
      );
}
