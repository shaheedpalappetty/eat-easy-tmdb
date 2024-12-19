import 'package:eat_easy_assignment/core/utils/imports.dart';

class ScreenUtilInitWrapper {
  static Widget init({required Widget child}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => child,
    );
  }
}
