// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// abstract class BlocConsumerWidget<B extends StateStreamable<S>, S>
//     extends BlocConsumerStatefulWidget<B, S> {
//   const BlocConsumerWidget({super.key});

//   /// Returns a widget based on the `BuildContext` and current [state].
//   Widget build(BuildContext context, S state);

//   void onDispose() {}

//   @override
//   BlocConsumerState<B, S> createState() => _CosumerState<B, S>();
// }

// abstract class BlocConsumerStatefulWidget<B extends StateStreamable<S>, S>
//     extends StatefulWidget {
//   const BlocConsumerStatefulWidget({super.key, this.bloc});

//   /// The [bloc] that the [BlocConsumerWidget] will interact with.
//   /// If omitted, [BlocConsumerWidget] will automatically perform a lookup using
//   /// [BlocProvider] and the current `BuildContext`.
//   final B? bloc;

//   bool buildwhen(S previous, S current) {
//     return true;
//   }

//   bool listenWhen(S previous, S current) {
//     return true;
//   }

//   void listener(BuildContext context, S state) {}

//   @override
//   BlocConsumerState<B, S> createState();

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<B?>('bloc', bloc));
//   }
// }

// abstract class BlocConsumerState<B extends StateStreamable<S>, S>
//     extends State<BlocConsumerStatefulWidget<B, S>> {
//   late B _bloc;

//   @override
//   void initState() {
//     super.initState();
//     _bloc = widget.bloc ?? context.read<B>();
//   }

//   @override
//   void didUpdateWidget(BlocConsumerWidget<B, S> oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final oldBloc = oldWidget.bloc ?? context.read<B>();
//     final currentBloc = widget.bloc ?? oldBloc;
//     if (oldBloc != currentBloc) _bloc = currentBloc;
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final bloc = widget.bloc ?? context.read<B>();
//     if (_bloc != bloc) _bloc = bloc;
//   }

//   Widget buildWithState(BuildContext context, S state);

//   @protected
//   @override
//   Widget build(BuildContext context) {
//     if (widget.bloc == null) {
//       // Trigger a rebuild if the bloc reference has changed.
//       // See https://github.com/felangel/bloc/issues/2127.
//       context.select<B, bool>((bloc) => identical(_bloc, bloc));
//     }
//     return BlocBuilder<B, S>(
//       bloc: _bloc,
//       builder: buildWithState,
//       buildWhen: (previous, current) {
//         if (widget.listenWhen(previous, current)) {
//           widget.listener(context, current);
//         }
//         return widget.buildwhen(previous, current);
//       },
//     );
//   }
// }

// class _CosumerState<B extends StateStreamable<S>, S>
//     extends BlocConsumerState<B, S> {
//   @override
//   Widget buildWithState(BuildContext context, S state) {
//     return (widget as BlocConsumerWidget).build(context, state);
//   }

//   @override
//   void dispose() {
//     (widget as BlocConsumerWidget).onDispose();
//     super.dispose();
//   }
// }
