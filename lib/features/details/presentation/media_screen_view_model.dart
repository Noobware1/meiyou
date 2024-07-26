import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou/shared/domain/models/repositories_params/media_repository_params.dart';
import 'package:meiyou/shared/presentation/notifers/async_state_notifer.dart';

// class MediaScreenViewModel {
//   MediaScreenViewModel({
//     required int mediaDetailsId,
//     required ExtensionCategory category,
//     required GetMediaById getMediaById,
//   }) {
//     final details = getMediaById(GetMediaByIdParams(
//       category: category,
//       id: mediaDetailsId,
//     ));

//     stateListenable = details == null
//         ? AsyncStateNotifier.loading()
//         : AsyncStateNotifier.data(details);
//   }

//   late final AsyncStateNotifier<Media> stateListenable;
// }
