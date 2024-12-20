import 'package:eat_easy_assignment/core/utils/imports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
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
          BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
          Provider<MoviesRepository>(create: (_) => getIt<MoviesRepository>()),
          BlocProvider<MoviesBloc>(create: (_) => getIt<MoviesBloc>()),
          BlocProvider<MovieDetailsBloc>(
              create: (_) => getIt<MovieDetailsBloc>()),
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
