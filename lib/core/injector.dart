import 'package:get_it/get_it.dart';
import 'package:ulima_app/data/datasource/aulavirtual_datasource.dart';
import 'package:ulima_app/data/datasource/menu_datasource.dart';
import 'package:ulima_app/data/datasource/pedido_datasource.dart';
import 'package:ulima_app/data/datasource/resena_datasource.dart';
import 'package:ulima_app/data/datasource/usuario_datasource.dart';
import 'package:ulima_app/data/repositoryImp/aulavirtual_repository_imp.dart';
import 'package:ulima_app/data/repositoryImp/menu_repository_imp.dart';
import 'package:ulima_app/data/repositoryImp/pedido_repository_imp.dart';
import 'package:ulima_app/data/repositoryImp/resena_repository_imp.dart';
import 'package:ulima_app/data/repositoryImp/usuario_repository_imp.dart';
import 'package:ulima_app/domain/repository/aulavirtual_repository.dart';
import 'package:ulima_app/domain/repository/menu_repository.dart';
import 'package:ulima_app/domain/repository/pedido_repository.dart';
import 'package:ulima_app/domain/repository/resena_repository.dart';
import 'package:ulima_app/domain/repository/usuario_repository.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';
import 'package:ulima_app/domain/usecase/pedido_usecase.dart';
import 'package:ulima_app/domain/usecase/resena_usecase.dart'
    as resena_usecases;
import 'package:ulima_app/domain/usecase/usuario_usecase.dart';

final injector = GetIt.instance;

void setup() {
  // DataSource
  injector.registerLazySingleton<MenuDatasource>(() => MenuDataSourceImpl());
  injector
      .registerLazySingleton<ResenaDatasource>(() => ResenaDataSourceImpl());
  injector
      .registerLazySingleton<PedidoDataSource>(() => PedidoDataSourceImpl());
  injector.registerLazySingleton<AulavirtualDatasource>(
      () => AulavirtualDatasourceImpl());
  injector
      .registerLazySingleton<UsuarioDatasource>(() => UsuarioDatasourceImpl());

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
  injector.registerLazySingleton<AulavirtualRepository>(
    () => AulavirtualRepositoryImpl(remoteDataSource: injector()),
  );
  injector.registerLazySingleton<UsuarioRepository>(
    () => UsuarioRepositoryImpl(remoteDataSource: injector()),
  );

  // UseCases
  injector.registerLazySingleton(() => GetMenuItems(injector()));
  injector.registerLazySingleton(() => GetMenuItemDetail(injector()));
  injector
      .registerLazySingleton(() => resena_usecases.GetResenaItem(injector()));
  injector
      .registerLazySingleton(() => resena_usecases.AgregarResena(injector()));
  injector.registerLazySingleton(() => GetHistorial(injector()));
  injector.registerLazySingleton(() => CrearPedido(injector()));

  // Aula Virtual UseCases - Sprint 2
  injector.registerLazySingleton(() => GetSeccionesUsuario(injector()));
  injector.registerLazySingleton(() => GetSeccionDetail(injector()));
  injector.registerLazySingleton(() => GetMensajes(injector()));
  injector.registerLazySingleton(() => EnviarMensaje(injector()));
  injector.registerLazySingleton(() => GetMateriales(injector()));
  injector.registerLazySingleton(() => SubirMaterial(injector()));
  injector.registerLazySingleton(() => GetEventos(injector()));
  injector.registerLazySingleton(() => CrearEvento(injector()));

  // Usuario UseCases
  injector.registerLazySingleton(() => GetUsuarioActual(injector()));
  injector.registerLazySingleton(() => CambiarRolUsuario(injector()));
  injector.registerLazySingleton(() => GetUsuarioById(injector()));
}
