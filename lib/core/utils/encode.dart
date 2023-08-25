String encode(String url) =>
    Uri.encodeQueryComponent(url).replaceAll('+', '%20');
