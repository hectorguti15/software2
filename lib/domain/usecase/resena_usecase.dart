import 'package:ulima_app/domain/entity/resena_entity.dart';
import 'package:ulima_app/domain/repository/resena_repository.dart';

class GetResenaItem {
  final ResenaRepository repository;
  GetResenaItem(this.repository);

  Future<ResenaItem> call(String id) => repository.getResenaItem(id);
}
