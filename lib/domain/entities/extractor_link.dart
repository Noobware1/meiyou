class ExtractorLinkEntity {
  final String name;
  final String url;
  final Map<String, String>? headers;
  final String? referer;
  final Map<String, dynamic>? extra;

  ExtractorLinkEntity(
      {required this.name , required this.url , this.headers, this.referer, this.extra});
}
