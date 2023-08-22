// import 'package:flutter_test/flutter_test.dart';
// import 'package:meiyou/core/resources/response_state.dart';
// import 'package:meiyou/data/data_source/providers/meta_providers/anilist.dart';
// import 'package:meiyou/data/data_source/providers/meta_providers/tmdb.dart';
// import 'package:meiyou/data/models/results.dart';
// import 'package:meiyou/data/repositories/meta_resilts_repository_impl.dart';
// // import 'package:meiyou/domain/repositories/meta_results_repository.dart';
// import 'package:mockito/mockito.dart';

// // class MockMetaResultsRepository extends Mock implements MetaResultsRepositoryImpl {

// // }

// void main() {
//   Anlist anilist;
//   TMDB tmdb;
//   late MetaResultsRepositoryImpl repository;

//   setUp(() {
//     anilist = Anlist();
//     tmdb = TMDB();
//     repository = MetaResultsRepositoryImpl(anilist, tmdb);
//   });

//   test('should get search results', () async {
//     final data = await repository.getSearch('one piece');
//     expect(data.data.metaResponses.f, ResponseSuccess<MetaResults>);
//   });
// }
