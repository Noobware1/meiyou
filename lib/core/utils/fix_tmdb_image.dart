String? getImageUrl(String? url) {
  if (url == null) return null;
  return url.startsWith('/') ? 'https://image.tmdb.org/t/p/w500$url' : url;
}

String? getOriImageUrl(String? url) {
  if (url == null) return null;
  return url.startsWith('/') ? 'https://image.tmdb.org/t/p/original$url' : url;
}
