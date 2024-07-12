import 'package:meiyou_extensions_lib/preference.dart';
import 'package:nice_dart/nice_dart.dart';

abstract class PreferenceImpl<T> extends Preference<T> {
  final SharedPreferences _preferences;
  final String _key;
  final T _defaultValue;
  final Stream<String> _keyFlow;

  PreferenceImpl({
    required SharedPreferences preferences,
    required String key,
    required T defaultValue,
    required Stream<String> keyFlow,
  })  : _preferences = preferences,
        _key = key,
        _defaultValue = defaultValue,
        _keyFlow = keyFlow;

  T read(SharedPreferences preferences, String key, T defaultValue);

  void write(SharedPreferences preferences, String key, T value);

  @override
  String key() => _key;

  @override
  T get() => read(_preferences, _key, _defaultValue);

  @override
  T getAndSet(T value) {
    final result = get();
    set(value);
    return result;
  }

  @override
  void set(T value) => write(_preferences, _key, value);

  @override
  bool isSet() => _preferences.containsKey(_key);

  @override
  void delete() => _preferences.remove(_key);

  @override
  T defaultValue() => _defaultValue;

  @override
  Stream<T> changes() {
    return _keyFlow.where((key) => key == _key).map((_) => get());
  }
}

class DoublePrimitive extends PreferenceImpl<double> {
  DoublePrimitive({
    required super.preferences,
    required super.key,
    required super.defaultValue,
    required super.keyFlow,
  });

  @override
  double read(SharedPreferences preferences, String key, double defaultValue) {
    return preferences.getDouble(key) ?? defaultValue;
  }

  @override
  void write(SharedPreferences preferences, String key, double value) {
    preferences.setDouble(key, value);
  }

  /// A preference that should not be exposed in places like backups without user consent.
  bool isPrivate(String key) {
    return key.startsWith(_privateStatePrefix);
  }

  String privateKey(String key) {
    return '$_privateStatePrefix$key';
  }

  /// A preference used for internal app state that isn't really a user preference
  /// and therefore should not be in places like backups.
  bool isAppState(String key) {
    return key.startsWith(_appStatePrefix);
  }

  String appStateKey(String key) {
    return '$_appStatePrefix$key';
  }

  static const _appStatePrefix = "__APP_STATE_";
  static const _privateStatePrefix = "__PRIVATE_";
}

class BoolPrimitive extends PreferenceImpl<bool> {
  BoolPrimitive({
    required super.preferences,
    required super.key,
    required super.defaultValue,
    required super.keyFlow,
  });

  @override
  bool read(SharedPreferences preferences, String key, bool defaultValue) {
    return preferences.getBool(key, defaultValue) ?? defaultValue;
  }

  @override
  void write(SharedPreferences preferences, String key, bool value) {
    preferences.setBool(key, value);
  }
}

class IntPrimitive extends PreferenceImpl<int> {
  IntPrimitive({
    required super.preferences,
    required super.key,
    required super.defaultValue,
    required super.keyFlow,
  });

  @override
  int read(SharedPreferences preferences, String key, int defaultValue) {
    return preferences.getInt(key, defaultValue) ?? defaultValue;
  }

  @override
  void write(SharedPreferences preferences, String key, int value) {
    preferences.setInt(key, value);
  }
}

class StringPrimitive extends PreferenceImpl<String> {
  StringPrimitive({
    required super.preferences,
    required super.key,
    required super.defaultValue,
    required super.keyFlow,
  });

  @override
  String read(SharedPreferences preferences, String key, String defaultValue) {
    return preferences.getString(key) ?? defaultValue;
  }

  @override
  void write(SharedPreferences preferences, String key, String value) {
    preferences.setString(key, value);
  }
}

class StringListPrimitive extends PreferenceImpl<List<String>> {
  StringListPrimitive({
    required super.preferences,
    required super.key,
    required super.defaultValue,
    required super.keyFlow,
  });

  @override
  List<String> read(
      SharedPreferences preferences, String key, List<String> defaultValue) {
    return preferences.getStringList(key) ?? defaultValue;
  }

  @override
  void write(SharedPreferences preferences, String key, List<String> value) {
    preferences.setStringList(key, value);
  }
}

class ObjectPrimitive<T> extends PreferenceImpl<T> {
  final String Function(T) _serializer;
  final T Function(String) _deserializer;

  ObjectPrimitive({
    required super.preferences,
    required super.key,
    required super.defaultValue,
    required super.keyFlow,
    required String Function(T) serializer,
    required T Function(String) deserializer,
  })  : _serializer = serializer,
        _deserializer = deserializer;

  @override
  T read(SharedPreferences preferences, String key, T defaultValue) {
    return runCatching(() {
      final value = preferences.getString(key);
      if (value == null) return defaultValue;
      return _deserializer(value);
    }).getOrDefault(defaultValue);
  }

  @override
  void write(SharedPreferences preferences, String key, T value) {
    preferences.setString(key, _serializer(value));
  }
}

class EnumPrimitive<T extends Enum> extends PreferenceImpl<T> {
  final List<T> _values;
  EnumPrimitive({
    required super.preferences,
    required super.key,
    required super.defaultValue,
    required super.keyFlow,
    required List<T> values,
  }) : _values = values;

  @override
  T read(SharedPreferences preferences, String key, T defaultValue) {
    return runCatching(
            () => _values[preferences.getInt(key, defaultValue.index)!])
        .getOrDefault(defaultValue);
  }

  @override
  void write(SharedPreferences preferences, String key, T value) {
    preferences.setInt(key, value.index);
  }
}
