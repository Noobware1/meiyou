import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou_extensions_lib/models.dart' hide Media;
import 'package:path/path.dart';

Media getDetails() {
  return Media(
    sourceId: 1,
    category: ExtensionCategory.video,
    title: "Spice and Wolf: Merchant Meets the Wise Wolf",
    url: "/spice-and-wolf",
    description:
        "With a cartload of fur pelts in tow, traveling merchant Kraft Lawrence stops by the village of Pasloe. According to local folklore, centuries ago, one of the villagers made a promise with the wolf deity Holo, who swore to bless Pasloe with bountiful harvests of wheat. Yet, as time passed, such stories became little more than relics of the past. After quickly finishing his business in the village, Lawrence sets out to his next destination. His journey, however, takes an unexpected turn when he discovers a nude, animal-eared girl sleeping among his pelts. Even more surprisingly, the youthful-looking woman claims to be Holo—the wolf of legend. Holo wishes to return to her hometown in the north, and though their first encounter is rocky, she convinces Lawrence to accompany her on her travels. In return, she vows to earn her keep, using her quick wits and lifetime of experience to help her newfound companion in his dealings. As they continue their journey, Lawrence and Holo take advantage of whatever economic opportunities they come across, often landing in situations that put both their business skills and their relationship to the test.",
    poster:
        "https://www1.kickassanime.mx/image/poster/merchant-meets-the-wise-wolf-b57f-hq.webp",
    format: MediaFormat.anime,
    status: Status.ongoing,
    otherTitles: [
      "狼と香辛料 MERCHANT MEETS THE WISE WOLF",
      "Ookami to Koushinryou: Merchant Meets the Wise Wolf",
    ],
    genres: [
      "Adult Cast",
      "Adventure",
      "Drama",
      "Fantasy",
      "Romance",
    ],
  );
}
