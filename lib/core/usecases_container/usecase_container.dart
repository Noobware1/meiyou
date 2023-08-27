import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show RepositoryProvider;
import 'package:meiyou/core/usecases/usecase.dart';

abstract class UseCaseContainer<Container> {
  Map<String, UseCase> get usecases;

  T get<T>(String key) {
    return usecases[key] as T;
  }

  RepositoryProvider<Container> inject() =>
      RepositoryProvider.value(value: this as Container);

  RepositoryProvider<Container> createProvider({required Widget child}) {
    return RepositoryProvider.value(
      value: this as Container,
      child: child,
    );
  }
}
