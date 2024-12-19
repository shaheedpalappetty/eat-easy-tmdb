// main.dart
import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/features/movies/data/movies_repository_impl.dart';
import 'package:eat_easy_assignment/features/movies/domain/movies_repository.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MultiProvider(
        providers: [
          Provider<MoviesRepository>(
            create: (_) => MoviesRepositoryImpl(),
          ),
          BlocProvider<MoviesBloc>(
            create: (context) => MoviesBloc(
              context.read<MoviesRepository>(),
            )..add(FetchMovies()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie App',
          themeMode: ThemeMode.dark,
          darkTheme: AppTheme.darkTheme,
          home: const MovieListScreen(),
        ),
      ),
    );
  }
}
