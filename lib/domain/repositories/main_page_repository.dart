import 'package:meiyou/core/resources/response_state.dart';
import 'package:meiyou/domain/entities/main_page.dart';

abstract interface class MainPageRepository {
  Future<ResponseState<MainPageEntity>> getMainPage();
}
