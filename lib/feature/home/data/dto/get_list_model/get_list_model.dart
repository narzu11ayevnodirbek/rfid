import 'package:rfid/feature/home/domain/entity/get_list_entity/get_list_entity.dart';

class GetListModel implements MappableToEntity {
  const GetListModel();

  GetListModel.fromJson(json);

  @override
  GetListEntity toEntity() {
    throw UnimplementedError();
  }
}

abstract class MappableToEntity<T extends GetListEntity> {
  T toEntity();
}
