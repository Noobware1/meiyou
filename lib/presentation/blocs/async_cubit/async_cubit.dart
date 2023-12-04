import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meiyou/core/resources/expections.dart';

part 'async_state.dart';


class AsyncCubit<T> extends Cubit<AsyncState<T>> {
  AsyncCubit([AsyncState<T>? state]) : super(state ?? AsyncStateLoading<T>());

  
}
