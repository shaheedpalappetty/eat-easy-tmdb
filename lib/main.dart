import 'package:eat_easy_assignment/core/utils/imports.dart';

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
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie App',
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.darkTheme,
        home: const MovieListScreen(),
      ),
    );
  }
}
