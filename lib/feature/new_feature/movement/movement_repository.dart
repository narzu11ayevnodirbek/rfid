import 'package:rfid/feature/new_feature/movement/services/movement_service.dart';
import 'package:rfid/feature/new_feature/movement/models/movement_item.dart';

class MovementRepository {
  MovementRepository(this.apiService);

  final MovementService apiService;

  Future<List<MovementItem>> fetchMovementItems(int movementId) => apiService.getMovementItems(
        movementId: movementId,
      );
}
