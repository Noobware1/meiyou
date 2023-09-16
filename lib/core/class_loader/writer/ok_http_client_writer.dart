import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/utils/encode.dart';
import 'package:meiyou/core/utils/extenstions/iterable.dart';
import 'package:meiyou/core/utils/extenstions/string.dart';
import 'package:ok_http_dart/http.dart';
import 'package:ok_http_dart/ok_http_dart.dart';

class OkHttpClientRequest {
  final String url;
  final String method;
  final Map<String, dynamic>? stringsInterpoltes;
  final Map<String, String>? headers;

  OkHttpClientRequest({
    required this.url,
    required this.method,
    this.stringsInterpoltes,
    this.headers,
  });
}

class OkHttpClientCodeWriter {
  OkHttpClientRequest writeRequest(String code) {
    var matches =
        RegExp(r"client.(\w+\s*)\('(.*)\)'").firstMatch(code)!.groups([1, 2])!;
    final method = matches[0]!;
    var url = matches[1]!;

    final headers =
        readHeaders(RegExp(r'headers: {([^}]*)}').firstMatch(code)?.group(1));

    final stringInterpolations = <String, dynamic>{};
    var i = 0;
    RegExp(r'\${([^}]*)}').allMatches(url).forEach((element) {
      i++;
      final match = element.group(0)?.replaceAll("\${", "").replaceAll('}', '');

      if (match != null) {
        url = url.replaceAll(match, 'APPEND ${i - 1}');
        if (match.contains('(')) {
          stringInterpolations['function'] = {
            'name': match.substringBefore('('),
            'params': readFunctionParams(match)
          };
        } else {
          stringInterpolations['variable'] = match;
        }
      }
    });

    return OkHttpClientRequest(
        url: url,
        method: method.toUpperCase(),
        stringsInterpoltes:
            stringInterpolations.isEmpty ? null : stringInterpolations,
        headers: headers);
  }

  List<String>? readFunctionParams(String function) {
    // final params = [];
    return RegExp('(([^)]*)\)')
        .firstMatch(function.substringAfter('('))
        ?.group(1)!
        .split(",");
  }

  Map<String, String>? readHeaders(String? headers) {
    if (headers == null) return null;
    final trueHeaders = <String, String>{};
    headers = headers.trim();
    headers.split(',')
      ..removeWhere((element) => element.isEmpty)
      ..forEach((element) {
        try {
          var header = element.trim().split(':');
          trueHeaders[header[0]] = header[1];
        } catch (e) {}
      });
    return trueHeaders;
  }

  String generateUrl(OkHttpClientRequest request,
      {Map<String, dynamic>? params}) {
    var url = request.url;
    final list = request.stringsInterpoltes?.entries.toList();
    if (list == null) return url;
    if (url.contains('APPEND')) {
      for (var i = 0; i < list.length; i++) {
        final appendValue = params?.keys.tryfirstWhere((value) {
          if (list[i].value is Map) {
            return value == (list[i].value as Map)['name'];
          }
          return value == list[i].value;
        });

        if (params?[appendValue] != null) {
          url = url.replaceFirst(
              'APPEND $i',
              params![appendValue] is Function
                  ? params[appendValue]()
                  : params[appendValue]);
        }
      }
      return url.replaceAll('\${', '').replaceAll('}', '');
    }
    return url;
  }

  OKHttpRequest generateRequest(OkHttpClientRequest request,
      {Map<String, dynamic>? params}) {
    return OKHttpRequest.builder(
      method: request.method,
      url: generateUrl(request, params: params),
      headers: request.headers,
    );
  }
}

