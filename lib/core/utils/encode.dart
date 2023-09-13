String encode(String url, [String replaceWith = '%20']) =>
    Uri.encodeQueryComponent(url).replaceAll('+', replaceWith);
