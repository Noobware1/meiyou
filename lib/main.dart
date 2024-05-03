import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:injecktor/injecktor.dart';
import 'package:meiyou/core/config/routes/router_provider.dart';
import 'package:meiyou/core/utils/resources/meiyou_core.dart';

void main() async {
  await MeiyouCore.ensureInitialized();

  runApp(const Meiyou());
}

class Meiyou extends StatelessWidget {
  const Meiyou({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   builder: BotToastInit(),
    //   navigatorObservers: [BotToastNavigatorObserver()],
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: const Color(0xFFACC7FF),
    //       brightness: Brightness.dark,
    //       onPrimary: const Color(0xFF143062),
    //       secondary: const Color(0xFF444651),
    //       onSecondary: const Color(0xFFE0E1EB),
    //     ),
    //     useMaterial3: true,
    //   ),
    //   themeMode: ThemeMode.dark,
    //   home: PlayerUI(),
    // );
    return MaterialApp.router(
      routerConfig: InjectKtor.get<RouterProvider>().router,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      title: 'Meiyou',
      builder: BotToastInit(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFACC7FF),
          brightness: Brightness.dark,
          onPrimary: const Color(0xFF143062),
          secondary: const Color(0xFF444651),
          onSecondary: const Color(0xFFE0E1EB),
        ),
        useMaterial3: true,
      ),
    );
  }
}
