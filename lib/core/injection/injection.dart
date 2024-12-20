import 'package:eat_easy_assignment/core/utils/imports.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => prefs);
  getIt.registerLazySingleton<AuthStateManager>(() => AuthStateManager());
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(prefs: getIt()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        authStateManager: getIt(),
      ));

  getIt.registerFactory<AuthBloc>(() => AuthBloc(authRepository: getIt()));

  getIt.registerFactory<MoviesRepository>(() => MoviesRepositoryImpl(getIt()));

  getIt.registerFactory<MoviesBloc>(
      () => MoviesBloc(getIt())..add(FetchMovies()));

  getIt.registerFactory<MovieDetailsBloc>(
      () => MovieDetailsBloc(repository: getIt()));
}
