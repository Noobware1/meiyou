import 'package:meiyou/data/models/row.dart';
import 'package:meiyou/domain/entities/main_page.dart';

class MainPage extends MainPageEntity {
  @override
  List<MetaRow> get rows => super.rows as List<MetaRow>;

  const MainPage(List<MetaRow> rows) : super(rows);
}
