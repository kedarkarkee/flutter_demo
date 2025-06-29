import 'package:demo/core/api/client/app_client.dart';
import 'package:demo/core/api/client/base_app_client.dart';
import 'package:demo/core/api/http_logger/http_logger.dart';
import 'package:demo/core/api/interceptor/http_interceptor.dart';
import 'package:demo/core/db/database.dart';
import 'package:demo/features/form/data/sources/form_source.dart';
import 'package:demo/features/form/domain/repository/form_repository.dart';
import 'package:demo/features/product/data/sources/product_local_source.dart';
import 'package:demo/features/product/data/sources/product_remote_source.dart';
import 'package:demo/features/product/domain/repo/product_repository.dart';
import 'package:demo/features/todo/data/sources/todo_local_source.dart';
import 'package:demo/features/todo/domain/repo/todo_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> registerModules() async {
  GetIt.instance.registerLazySingletonAsync<SharedPreferencesWithCache>(
    () => SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
  );
  locator.registerSingleton<TodoLocalSource>(
    TodoLocalSource(AppDatabase.instance),
  );
  locator.registerSingleton<FormSource>(FormSource());
  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(locator<TodoLocalSource>()),
  );
  locator.registerLazySingleton<FormRepository>(
    () => FormRepository(locator<FormSource>()),
  );
  await locator.isReady<SharedPreferencesWithCache>();
  locator.registerLazySingleton<AppClient>(
    () => AppClient(
      BaseHttpClient(
        Client(),
        interceptors: [AuthInterceptor(locator<SharedPreferencesWithCache>())],
      ),
      HttpLogger(),
      locator<SharedPreferencesWithCache>(),
    ),
  );

  locator.registerSingleton<ProductLocalSource>(
    ProductLocalSource(AppDatabase.instance),
  );
  locator.registerLazySingleton<ProductRemoteSource>(
    () => ProductRemoteSource(locator<AppClient>()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      locator<ProductLocalSource>(),
      locator<ProductRemoteSource>(),
    ),
  );
}
