import 'dart:async';

import 'package:meiyou_extensions_lib/preference.dart';
import 'package:meiyou/core/utils/resources/preference/preference_impl.dart';

class PreferenceStoreImpl implements PreferenceStore {
  final SharedPreferences _preferences;

  final StreamController<String> _controller = StreamController.broadcast();

  void _listener(SharedPreferences preferences, String key) {
    _controller.add(key);
  }

  late final _keyFlow = _controller.stream;

  PreferenceStoreImpl([SharedPreferences? preferences])
      : _preferences = preferences ?? SharedPreferences() {
    _preferences.addListener(_listener);
  }

  @override
  Set<String> getKeys() => _preferences.getKeys();

  @override
  Preference<String> getString(String key, String defaultValue) {
    return StringPrimitive(
      preferences: _preferences,
      key: key,
      defaultValue: defaultValue,
      keyFlow: _keyFlow,
    );
  }

  @override
  Preference<int> getInt(String key, int defaultValue) {
    return IntPrimitive(
      preferences: _preferences,
      key: key,
      defaultValue: defaultValue,
      keyFlow: _keyFlow,
    );
  }

  @override
  Preference<double> getDouble(String key, double defaultValue) {
    return DoublePrimitive(
      preferences: _preferences,
      key: key,
      defaultValue: defaultValue,
      keyFlow: _keyFlow,
    );
  }

  @override
  Preference<bool> getBool(String key, bool defaultValue) {
    return BoolPrimitive(
      preferences: _preferences,
      key: key,
      defaultValue: defaultValue,
      keyFlow: _keyFlow,
    );
  }

  @override
  Preference<List<String>> getStringList(
      String key, List<String> defaultValue) {
    return StringListPrimitive(
      preferences: _preferences,
      key: key,
      defaultValue: defaultValue,
      keyFlow: _keyFlow,
    );
  }

  @override
  Preference<T> getObject<T>(
    String key,
    T defaultValue,
    Serializer<T> serializer,
    Deserializer<T> deserializer,
  ) {
    return ObjectPrimitive(
      preferences: _preferences,
      key: key,
      defaultValue: defaultValue,
      serializer: serializer,
      deserializer: deserializer,
      keyFlow: _keyFlow,
    );
  }

  @override
  Preference<T> getEnum<T extends Enum>(
    String key,
    T defaultValue,
    List<T> values,
  ) {
    return EnumPrimitive(
      preferences: _preferences,
      key: key,
      defaultValue: defaultValue,
      values: values,
      keyFlow: _keyFlow,
    );
  }

  @override
  Map<String, dynamic> getAll() => _preferences.getAll();

  void close() {
    _controller.close();
    _preferences.removeListener(_listener);
  }
}

extension LOL on PreferenceStore {
  Stream<String> keyFlow() {
    return (this as PreferenceStoreImpl)._keyFlow;
  }
}
