import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show RepositoryProvider;
import 'package:meiyou/core/usecases/usecase.dart';

abstract class UseCaseContainer<Container> {
  Set<UseCase> get usecases;

  T get<T>() {
    try {
      return usecases.firstWhere((it) => it is T) as T;
    } catch (_) {
      throw UseCaseNotFoundException();
    }
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

final class UseCaseNotFoundException implements Exception {}
