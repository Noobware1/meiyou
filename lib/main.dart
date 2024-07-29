import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/core/utils/extensions/context.dart';
import 'package:meiyou/features/details/presentation/media_details_screen.dart';
import 'package:meiyou/features/home/presentation/screens/home/home_screen.dart';
import 'package:meiyou/l.dart';
import 'package:meiyou/shared/presentation/widgets/multi_nav_scaffold/multi_nav_scaffold.dart';
import 'package:meiyou/shared/presentation/widgets/navigation_bar/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      child: MaterialApp(
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
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const List<Destination> destinations = [
      Destination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home'),
      Destination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person),
          label: 'Library'),
      Destination(
          icon: Icon(Icons.history_outlined),
          selectedIcon: Icon(Icons.history),
          label: 'History'),
      Destination(
          icon: Icon(Icons.more_horiz_outlined),
          selectedIcon: Icon(Icons.more_horiz),
          label: 'More'),
    ];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
// MultiNav
    return Scaffold(
      // bottomNavigationBar: CustomNavigationBar(
      //   destinations: destinations,
      //   selectedIndex: selectedIndex,
      //   onDestinationSelected: (index) {
      //     setState(() {
      //       selectedIndex = index;
      //     });
      //   },
      //   type: NavigationBarType.bottom,
      // ),
      // sideNavigatonBar: CustomNavigationBar(
      //   destinations: destinations,
      //   selectedIndex: selectedIndex,
      //   onDestinationSelected: (index) {
      //     setState(() {
      //       selectedIndex = index;
      //     });
      //   },
      //   type: NavigationBarType.side,
      // ),
      body: const MediaScreen(
          // mediaDetailsId: 1,
          ),
    );
  }
}
