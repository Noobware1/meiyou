import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

abstract class BlocConsumerWidget<B extends StateStreamable<S>, S> {
 
  Widget build(BuildContext context, S state);
}


