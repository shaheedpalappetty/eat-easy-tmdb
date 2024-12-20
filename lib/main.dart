import 'package:eat_easy_assignment/core/network/http_client.dart';
import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/features/movies/data/datasources/auth_local_datasource.dart';
import 'package:eat_easy_assignment/features/movies/data/datasources/auth_remote_datasource.dart';
import 'package:eat_easy_assignment/features/movies/data/datasources/auth_state_manager.dart';
import 'package:eat_easy_assignment/features/movies/data/repository/auth_repository_impl.dart';
import 'package:eat_easy_assignment/features/movies/data/repository/movies_repository_impl.dart';
import 'package:eat_easy_assignment/features/movies/domain/movies_repository.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/auth/auth_bloc.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/movie_details/movie_details_bloc.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'package:eat_easy_assignment/features/movies/presentation/screen/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authStateManager = AuthStateManager();
  final authLocalDataSource = AuthLocalDataSourceImpl(prefs: prefs);
  final authRemoteDataSource = AuthRemoteDataSourceImpl();

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
    authStateManager: authStateManager,
  );

  final authBloc = AuthBloc(authRepository: authRepository);
  runApp(MyApp(
    authBloc: authBloc,
    authLocalDataSource: authLocalDataSource,
  ));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final AuthLocalDataSource authLocalDataSource;
  const MyApp(
      {super.key, required this.authBloc, required this.authLocalDataSource});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MultiProvider(
        providers: [
          BlocProvider<AuthBloc>.value(
            value: authBloc,
          ),
          Provider<MoviesRepository>(
            create: (_) => MoviesRepositoryImpl(authLocalDataSource),
          ),
          BlocProvider<MoviesBloc>(
            create: (context) => MoviesBloc(
              context.read<MoviesRepository>(),
            )..add(FetchMovies()),
          ),
          BlocProvider<MovieDetailsBloc>(
            create: (context) => MovieDetailsBloc(
              repository: context.read<MoviesRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie App',
          themeMode: ThemeMode.dark,
          darkTheme: AppTheme.darkTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
