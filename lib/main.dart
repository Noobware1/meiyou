import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/router/router.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/features/home/presentation/screens/home/home_screen.dart';
import 'package:meiyou/shared/presentation/widgets/navigation_bar/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await initInjectionModules();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FloatingActionButton
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: context.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: context.brightness,
        statusBarColor: Colors.transparent,
      ),
      child: MaterialApp.router(
        routerConfig: getIt<RouterProvider>().router,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // themeMode: ThemeMode.light,
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.light),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
      ),
    );
  }
}
