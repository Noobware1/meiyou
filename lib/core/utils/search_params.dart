class SearchParams {
  final String query;
  final int page;
  final bool isAdult;

  const SearchParams(
      {required this.query, this.page = 1, this.isAdult = false});
}
