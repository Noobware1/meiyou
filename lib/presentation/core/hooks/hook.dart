// import 'package:flutter/material.dart';
// import 'package:meiyou/core/utils/resources/get_it/get_it.dart';

// typedef UseCallBack<T> = T Function();

// abstract class Hook {
//   // void use<T>(UseCallBack<T> callBack);
//   void dispose();
// }

// abstract class HookElement extends Element {
//   HookElement(HookWidget widget) : super(widget);

//   void useHook<T extends Hook>(T hook);

//   void releaseHooks();

//   @override
//   void unmount() {
//     super.unmount();
//     releaseHooks();
//   }
// }

// class StatelessHookElement extends StatelessElement implements HookElement {
//   final Map<int, Hook> _hooks = {};

//   StatelessHookElement(StatelessHookWidget widget) : super(widget);

//   @override
//   void useHook<T extends Hook>() {

//   }

//   @override
//   void releaseHooks() {
//     _hooks.forEach((key, value) {
//       value.dispose();
//     });
//     _hooks.clear();
//   }
// }

// abstract class HookWidget extends Widget {}

// abstract class StatelessHookWidget extends StatelessWidget
//     implements HookWidget {
//   @override
//   StatelessHookElement createElement() => StatelessHookElement(this);
// }
