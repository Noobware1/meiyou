void main(List<String> args) {
  final l = [1, 2, 3];
  l.swap(0, 1);
  print(l);
}

extension on List<int> {
  swap(int currentIndex, int newIndex) {
    final temp = this[currentIndex];
    this[currentIndex] = this[newIndex];
    this[newIndex] = temp;
  }
}
