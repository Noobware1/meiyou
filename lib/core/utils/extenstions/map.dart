import 'dart:convert';

extension MapUtils on Map<String, String> {
  toJson() => json.encode(this);
}
