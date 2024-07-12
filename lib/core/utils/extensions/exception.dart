extension ObjectToExpection on Object {
  Exception asException() {
    return this is Exception ? (this as Exception) : Exception(toString());
  }
}
