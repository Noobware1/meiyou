import 'package:flutter/material.dart';
import 'package:meiyou/core/injection/injection.dart';
import 'package:meiyou/features/home/presentation/view_models/home_screen_view_model.dart';
import 'package:meiyou/shared/presentation/widgets/state_listenable_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeScreenViewModel(
      getFulHomePageUseCase: getIt(),
      getHomePageUseCase: getIt(),
      sourcePreferences: getIt(),
      sourceManager: getIt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateListenableBuilder(
          stateListenable: viewModel.stateListenable,
          builder: (context, state, _) {
            return Container();
          }),
    );
  }
}
