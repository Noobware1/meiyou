double compareTwoStrings(String first, String second) {
  first = first.replaceAll(RegExp(r'\s+'), '');
  second = second.replaceAll(RegExp(r'\s+'), '');

  if (first == second) return 1; // identical or empty
  if (first.length < 2 || second.length < 2) {
    return 0; // if either is a 0-letter or 1-letter string
  }

  Map<String, int> firstBigrams = {};
  for (int i = 0; i < first.length - 1; i++) {
    final bigram = first.substring(i, i + 2);
    final count =
        firstBigrams.containsKey(bigram) ? firstBigrams[bigram]! + 1 : 1;

    firstBigrams[bigram] = count;
  }

  int intersectionSize = 0;
  for (int i = 0; i < second.length - 1; i++) {
    final bigram = second.substring(i, i + 2);
    final count = firstBigrams.containsKey(bigram) ? firstBigrams[bigram]! : 0;

    if (count > 0) {
      firstBigrams[bigram] = count - 1;
      intersectionSize++;
    }
  }

  return (2.0 * intersectionSize) / (first.length + second.length - 2);
}

MatchStats findBestMatch(String mainString, List<String> targetStrings) {
  
    final List<MatchStats> ratings = [];
    int bestMatchIndex = 0;

    for (var i = 0; i < targetStrings.length; i++) {
      final currentTargetString = targetStrings[i];
      final currentRating = compareTwoStrings(
          mainString.toUpperCase(), currentTargetString.toUpperCase());
      ratings.add(MatchStats(
          rating: currentRating, target: currentTargetString, index: i));
      if (currentRating > ratings[bestMatchIndex].rating) {
        bestMatchIndex = i;
      }
    }

    final bestMatch = ratings[bestMatchIndex];

    return bestMatch;
  
}

class MatchStats {
  final double rating;
  final String target;
  final int index;
  MatchStats({required this.rating, required this.target, required this.index});
}
