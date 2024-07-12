import 'package:nice_dart/nice_dart.dart';

abstract class UseCase<Value, Params> {
  Value call(Params params);
}
