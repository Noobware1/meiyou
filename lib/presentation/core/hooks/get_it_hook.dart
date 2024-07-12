// import 'package:flutter/cupertino.dart';
// import 'package:meiyou/core/utils/resources/get_it/get_it.dart';
// import 'package:meiyou/presentation/core/hooks/hook.dart';

// mixin class GetItHookWidget {
//   void useGetIt<T>(BuildContext context, void Function() useGetIt) {
//     context as HookElement;
//     context.use<GetItHook>(() {
//       useGetIt();
//     });
//   }
// }

// class GetItHook extends Hook {
//   static const value = 0;

//   static final List<String?> _emptyNames = List<String?>.filled(0, null);
//   List<String?> _names = _emptyNames;

//   int _count = 0;

//   void add<T>(String? instanceName) {
//     if (_count == _names.length) {
//       if (_count == 0) {
//         _names = List<String?>.filled(1, null);
//       } else {
//         final List<String?> newNames =
//             List<String?>.filled(_names.length * 2, null);
//         for (int i = 0; i < _count; i++) {
//           newNames[i] = _names[i];
//         }
//         _names = newNames;
//       }
//     }
//     _names[_count++] = instanceName ?? T.toString();
//   }

//   @override
//   void dispose() {
//     for (int i = 0; i < _count; i++) {
//       getIt.unregister(instanceName: _names[i]);
//     }
//     _count = 0;
//     _names = _emptyNames;
//   }
// }
