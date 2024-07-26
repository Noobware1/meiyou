import 'package:flutter/material.dart';
import 'package:meiyou/shared/presentation/widgets/paging_source/paging_source_view_model.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class PagingSource<Value, Params> {
  final Params params;
  final Value value;

  PagingSource({
    required this.value,
    required this.params,
  });

  Future<Result<Value>> load(Params params);

  Params loadParams(Value value, Params params) {
    return params;
  }

  Value map(Value a, Value b);
}

mixin PagingSourceStateMixin<Value, Params, Widget extends StatefulWidget>
    on State<Widget> {
  late final PagingSourceViewModel<Value, Params> viewModel;

  late Value pageState;

  @override
  void initState() {
    super.initState();
    viewModel = createViewModel();
    pageState = viewModel.state;
  // viewModel.addListener(() {
  //     setState(() {
  //       pageState = viewModel.state;
  //     });
  //   });
  }

  PagingSourceViewModel<Value, Params> createViewModel();
}
