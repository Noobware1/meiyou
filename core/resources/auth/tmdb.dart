import 'package:meiyou/core/constants/api_constants.dart';
import 'package:meiyou/core/resources/client.dart';
import 'package:meiyou/core/resources/expections.dart';
import 'package:meiyou/core/resources/prefrences.dart';
import 'package:meiyou/core/try_catch.dart';

class TMDBAuth {
  getRequestToken() async {
    client.post('$TMDB_API_URL/authentication/token/new', headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $TMDB_AUTHTOKEN"
    });
  }

  Future<SessionId> getSessionId(AcessToken acessToken) async {
    throw UnimplementedError();
    //   try {
    //  final savedSession = await tryAsync(() => loadData(savePath: '', transFormer: ));

    //     return (await client.get(
    //             '$TMDB_API_URL/authentication/session/new?api_key=$TMDB_APIKEY&request_token=${acessToken.token}'))
    //         .json((json) => SessionId.fromTMDB(json, acessToken.expiresAt));
    //   } catch (e, s) {
    //     throw MeiyouException.fromAuth(s);
    //   }
  }
}

class SessionId {
  final DateTime expires;
  final String sessionId;

  SessionId(this.sessionId, this.expires);

  factory SessionId.fromTMDB(dynamic json, DateTime expires) {
    return SessionId(json['session_id'], expires);
  }

  // factory SessionId.fromTMDB(dynamic json, DateTime expires) {
  //   return SessionId(json['session_id'] , expires);
  // }
}

class AcessToken {
  final DateTime expiresAt;
  final String token;

  AcessToken(this.expiresAt, this.token);

  factory AcessToken.fromTMDb(dynamic json) {
    return AcessToken(
        DateTime.parse(
            (json['expires_at'] as String).replaceFirst('UTC', '').trim()),
        json['request_token']);
  }
}

void main(List<String> args) {
  const testToken = 'd69cb1341acfc4d109c75e4da02632ba7af7ae6a';
}
