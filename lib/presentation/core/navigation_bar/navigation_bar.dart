import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meiyou/domain/repositories/navigation_bar_repository.dart';

abstract interface class NavigationBar {
  abstract final NavigationBarRepository repository;
  abstract final StatefulNavigationShell shell;

  Widget build(BuildContext context);
}
