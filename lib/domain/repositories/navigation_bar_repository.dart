import 'package:meiyou/domain/models/navigation_bar_item.dart';

abstract interface class NavigationBarRepository {
  /// Returns the list of icons to be used in the main navigation bar
  /// The first icon is the unselected (outlined) icon, the second icon is the selected icon
  List<NavigationBarItem> getIcons();
}
