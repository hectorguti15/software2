import 'package:get_it/get_it.dart';
import 'package:ulima_app/data/datasource/menu_datasource.dart';
import 'package:ulima_app/data/datasource/pedido_datasource.dart';
import 'package:ulima_app/data/datasource/resena_datasource.dart';
import 'package:ulima_app/data/repositoryImp/menu_repository_imp.dart';
import 'package:ulima_app/data/repositoryImp/pedido_repository_imp.dart';
import 'package:ulima_app/data/repositoryImp/resena_repository_imp.dart';
import 'package:ulima_app/domain/repository/menu_repository.dart';
import 'package:ulima_app/domain/repository/pedido_repository.dart';
import 'package:ulima_app/domain/repository/resena_repository.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';
import 'package:ulima_app/domain/usecase/pedido_usecase.dart';
import 'package:ulima_app/domain/usecase/resena_usecase.dart';

final injector = GetIt.instance;

void setup() {
  // DataSource
  injector.registerLazySingleton<MenuDatasource>(() => MenuDataSourceImpl());
  injector
      .registerLazySingleton<ResenaDatasource>(() => ResenaDataSourceImpl());
  injector
      .registerLazySingleton<PedidoDataSource>(() => PedidoDataSourceImpl());

  // Repository
  injector.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(remoteDataSource: injector()),
  );
  injector.registerLazySingleton<ResenaRepository>(
    () => ResenaRepositoryImpl(remoteDataSource: injector()),
  );
  injector.registerLazySingleton<PedidoRepository>(
    () => PedidoRepositoryImpl(remoteDataSource: injector()),
  );

  // UseCases
  injector.registerLazySingleton(() => GetMenuItems(injector()));
  injector.registerLazySingleton(() => GetMenuItemDetail(injector()));
  injector.registerLazySingleton(() => GetResenaItem(injector()));
  injector.registerLazySingleton(() => AgregarResena(injector()));
  injector.registerLazySingleton(() => GetHistorial(injector()));
}
