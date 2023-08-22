String httpify(String url) {
  if (url.startsWith('//')) {
    return 'https:$url';
  } else {
    return url;
  }
}
