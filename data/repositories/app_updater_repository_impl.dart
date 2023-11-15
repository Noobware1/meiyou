class AppUpdaterRepositoryImpl {
  getUpdate() async {}
}

class GithubRelease {
  final String htmlUrl;
  final String tagName; // Version code
  final String body;
  
  
  
  //Desc
  // final String target_commitish; // branch
  // final String prerelease;
  // final String node_id;

  GithubRelease({
    required this.tagName,
    required this.body,
    // required this.target_commitish,
    // required this.prerelease,
    // required this.node_id,
    required this.htmlUrl,
  });
}
