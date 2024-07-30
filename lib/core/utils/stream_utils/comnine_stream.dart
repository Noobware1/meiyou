import 'dart:async';

import 'package:nice_dart/nice_dart.dart';

extension on Iterable<StreamSubscription<void>> {
  void pauseAll([Future<void>? resumeSignal]) {
    for (final s in this) {
      s.pause(resumeSignal);
    }
  }

  void resumeAll() {
    for (final s in this) {
      s.resume();
    }
  }
}

extension on Iterable<StreamSubscription<void>> {
  Future<void>? cancelAll() =>
      waitFuturesList([for (final s in this) s.cancel()]);
}

/// An optimized version of [Future.wait].
Future<void>? waitFuturesList(List<Future<void>> futures) {
  switch (futures.length) {
    case 0:
      return null;
    case 1:
      return futures[0];
    default:
      return Future.wait(futures).then(_ignore);
  }
}

/// Helper function to ignore future callback
void _ignore(Object? _) {}

class CombineStream<T, R> extends StreamView<R> {
  /// Constructs a [Stream] that observes an [Iterable] of [Stream]
  /// and builds a [List] containing all latest events emitted by the provided [Iterable] of [Stream].
  /// The [combiner] maps this [List] into a new event of type [R]
  CombineStream(
    Iterable<Stream<T>> streams,
    R Function(List<T> values) combiner, {
    required List<T> intialData,
  }) : super(
          _buildController(streams, combiner, initialData: intialData).stream,
        );

  /// Constructs a [CombineStream] using a default combiner, which simply
  /// yields a [List] of all latest events emitted by the provided [Iterable] of [Stream].
  static CombineStream<T, List<T>> list<T>(
    Iterable<Stream<T>> streams,
    List<T> intialData,
  ) =>
      CombineStream<T, List<T>>(
        streams,
        (List<T> values) => values,
        intialData: intialData,
      );

  /// Constructs a [CombineStream] from a pair of [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine2<A, B, R>(
    Stream<A> streamOne,
    Stream<B> streamTwo,
    R Function(A a, B b) combiner, {
    required A initalDataOne,
    required B initalDataTwo,
  }) =>
      CombineStream<dynamic, R>(
        [streamOne, streamTwo],
        (List<dynamic> values) => combiner(values[0] as A, values[1] as B),
        intialData: [initalDataOne, initalDataTwo],
      );

  /// Constructs a [CombineStream] from 3 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine3<A, B, C, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    R Function(A a, B b, C c) combiner, {
    required A initalDataA,
    required B initalDataB,
    required C initalDataC,
  }) =>
      CombineStream<dynamic, R>(
        [streamA, streamB, streamC],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
          );
        },
        intialData: [initalDataA, initalDataB, initalDataC],
      );

  /// Constructs a [CombineStream] from 4 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine4<A, B, C, D, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    R Function(A a, B b, C c, D d) combiner, {
    required A initalDataA,
    required B initalDataB,
    required C initalDataC,
    required D initalDataD,
  }) =>
      CombineStream<dynamic, R>(
        [streamA, streamB, streamC, streamD],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
          );
        },
        intialData: [initalDataA, initalDataB, initalDataC, initalDataD],
      );

  /// Constructs a [CombineStream] from 5 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine5<A, B, C, D, E, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    R Function(A a, B b, C c, D d, E e) combiner, {
    required A initalDataA,
    required B initalDataB,
    required C initalDataC,
    required D initalDataD,
    required E initalDataE,
  }) =>
      CombineStream<dynamic, R>(
        [streamA, streamB, streamC, streamD, streamE],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
          );
        },
        intialData: [
          initalDataA,
          initalDataB,
          initalDataC,
          initalDataD,
          initalDataE
        ],
      );

  /// Constructs a [CombineStream] from 6 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine6<A, B, C, D, E, F, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    R Function(A a, B b, C c, D d, E e, F f) combiner, {
    required A initalDataA,
    required B initalDataB,
    required C initalDataC,
    required D initalDataD,
    required E initalDataE,
    required F initalDataF,
  }) =>
      CombineStream<dynamic, R>(
        [streamA, streamB, streamC, streamD, streamE, streamF],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
            values[5] as F,
          );
        },
        intialData: [
          initalDataA,
          initalDataB,
          initalDataC,
          initalDataD,
          initalDataE,
          initalDataF
        ],
      );

  /// Constructs a [CombineStream] from 7 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine7<A, B, C, D, E, F, G, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    Stream<G> streamG,
    R Function(A a, B b, C c, D d, E e, F f, G g) combiner, {
    required A initalDataA,
    required B initalDataB,
    required C initalDataC,
    required D initalDataD,
    required E initalDataE,
    required F initalDataF,
    required G initalDataG,
  }) =>
      CombineStream<dynamic, R>(
        [streamA, streamB, streamC, streamD, streamE, streamF, streamG],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
            values[5] as F,
            values[6] as G,
          );
        },
        intialData: [
          initalDataA,
          initalDataB,
          initalDataC,
          initalDataD,
          initalDataE,
          initalDataF,
          initalDataG
        ],
      );

  /// Constructs a [CombineStream] from 8 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine8<A, B, C, D, E, F, G, H, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    Stream<G> streamG,
    Stream<H> streamH,
    R Function(A a, B b, C c, D d, E e, F f, G g, H h) combiner, {
    required A initalDataA,
    required B initalDataB,
    required C initalDataC,
    required D initalDataD,
    required E initalDataE,
    required F initalDataF,
    required G initalDataG,
    required H initalDataH,
  }) =>
      CombineStream<dynamic, R>(
        [
          streamA,
          streamB,
          streamC,
          streamD,
          streamE,
          streamF,
          streamG,
          streamH
        ],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
            values[5] as F,
            values[6] as G,
            values[7] as H,
          );
        },
        intialData: [
          initalDataA,
          initalDataB,
          initalDataC,
          initalDataD,
          initalDataE,
          initalDataF,
          initalDataG,
          initalDataH
        ],
      );

  /// Constructs a [CombineStream] from 9 [Stream]s
  /// where [combiner] is used to create a new event of type [R], based on the
  /// latest events emitted by the provided [Stream]s.
  static CombineStream<dynamic, R> combine9<A, B, C, D, E, F, G, H, I, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    Stream<C> streamC,
    Stream<D> streamD,
    Stream<E> streamE,
    Stream<F> streamF,
    Stream<G> streamG,
    Stream<H> streamH,
    Stream<I> streamI,
    R Function(A a, B b, C c, D d, E e, F f, G g, H h, I i) combiner, {
    required A initalDataA,
    required B initalDataB,
    required C initalDataC,
    required D initalDataD,
    required E initalDataE,
    required F initalDataF,
    required G initalDataG,
    required H initalDataH,
    required I initalDataI,
  }) =>
      CombineStream<dynamic, R>(
        [
          streamA,
          streamB,
          streamC,
          streamD,
          streamE,
          streamF,
          streamG,
          streamH,
          streamI
        ],
        (List<dynamic> values) {
          return combiner(
            values[0] as A,
            values[1] as B,
            values[2] as C,
            values[3] as D,
            values[4] as E,
            values[5] as F,
            values[6] as G,
            values[7] as H,
            values[8] as I,
          );
        },
        intialData: [
          initalDataA,
          initalDataB,
          initalDataC,
          initalDataD,
          initalDataE,
          initalDataF,
          initalDataG,
          initalDataH,
          initalDataI
        ],
      );

  static StreamController<R> _buildController<T, R>(
    Iterable<Stream<T>> streams,
    R Function(List<T> values) combiner, {
    required List<T> initialData,
  }) {
    assert(streams.length == initialData.length);
    final controller = StreamController<R>(sync: true);
    late List<StreamSubscription<T>> subscriptions;
    List<T?>? values;

    controller.onListen = () {
      var completed = 0;

      void onDone() {
        if (++completed == subscriptions.length) {
          controller.close();
        }
      }

      subscriptions = streams.mapIndexed((index, stream) {
        return stream.listen(
          (T value) {
            if (values == null) {
              return;
            }

            values![index] = value;

            if (values!.contains(null)) {
              return;
            }

            final R combined;
            try {
              combined = combiner(List<T>.unmodifiable(values!));
            } catch (e, s) {
              controller.addError(e, s);
              return;
            }
            controller.add(combined);
          },
          onError: controller.addError,
          onDone: onDone,
        );
      }).toList(growable: false);
      if (subscriptions.isEmpty) {
        controller.close();
      } else {
        values = List<T?>.filled(subscriptions.length, null);

        for (var i = 0; i < initialData.length; i++) {
          values![i] = initialData[i];
        }
      }
    };
    controller.onPause = () => subscriptions.pauseAll();
    controller.onResume = () => subscriptions.resumeAll();
    controller.onCancel = () {
      values = null;
      return subscriptions.cancelAll();
    };

    return controller;
  }
}
