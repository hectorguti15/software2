import 'package:ulima_app/data/datasource/resena_datasource.dart';
import 'package:ulima_app/domain/entity/resena_entity.dart';
import 'package:ulima_app/domain/repository/resena_repository.dart';

class ResenaRepositoryImpl implements ResenaRepository {
  final ResenaDatasource remoteDataSource;
  ResenaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ResenaItem> getResenaItem(String id) async {
    final model = await remoteDataSource.getResenaItem(id);
    return model.toEntity();
  }
}
