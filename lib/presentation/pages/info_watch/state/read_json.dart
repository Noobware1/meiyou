import 'dart:convert';
import 'dart:io';
import 'package:meiyou/data/models/media_details.dart';
import 'package:meiyou/domain/entities/media_details.dart';

MediaDetailsEntity readMedia() {
  // final File file = File('assets/lol.json');
  // final string = await file.readAsString();
  return MediaDetails.fromAnilist(json);
}

const json = {
  "data": {
    "Media": {
      "id": 101922,
      "title": {
        "romaji": "Kimetsu no Yaiba",
        "english": "Demon Slayer: Kimetsu no Yaiba",
        "native": "鬼滅の刃",
        "userPreferred": "Kimetsu no Yaiba"
      },
      "coverImage": {
        "extraLarge":
            "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx101922-PEn1CTc93blC.jpg",
        "large":
            "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx101922-PEn1CTc93blC.jpg",
        "medium":
            "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx101922-PEn1CTc93blC.jpg"
      },
      "startDate": {"year": 2019, "month": 4, "day": 6},
      "endDate": {"year": 2019, "month": 9, "day": 28},
      "bannerImage":
          "https://s4.anilist.co/file/anilistcdn/media/anime/banner/101922-YfZhKBUDDS6L.jpg",
      "format": "TV",
      "genres": ["Action", "Adventure", "Drama", "Fantasy", "Supernatural"],
      "meanScore": 84,
      "description":
          "It is the Taisho Period in Japan. Tanjiro, a kindhearted boy who sells charcoal for a living, finds his family slaughtered by a demon. To make matters worse, his younger sister Nezuko, the sole survivor, has been transformed into a demon herself. Though devastated by this grim reality, Tanjiro resolves to become a “demon slayer” so that he can turn his sister back into a human, and kill the demon that massacred his family.<br>\n<br>\n(Source: Crunchyroll)",
      "idMal": 38000,
      "status": "FINISHED",
      "nextAiringEpisode": null,
      "episodes": 26,
      "characters": {
        "edges": [
          {
            "role": "SUPPORTING",
            "node": {
              "id": 137773,
              "name": {
                "first": "Sakonji",
                "middle": null,
                "last": "Urokodaki",
                "full": "Sakonji Urokodaki",
                "native": "鱗滝左近次 ",
                "userPreferred": "Sakonji Urokodaki"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b137773-kOv2te9wLAzQ.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b137773-kOv2te9wLAzQ.jpg"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 130050,
              "name": {
                "first": "Giyuu",
                "middle": null,
                "last": "Tomioka",
                "full": "Giyuu Tomioka",
                "native": "冨岡義勇",
                "userPreferred": "Giyuu Tomioka"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b130050-qsLThJs5VIbz.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b130050-qsLThJs5VIbz.png"
              }
            }
          },
          {
            "role": "MAIN",
            "node": {
              "id": 129130,
              "name": {
                "first": "Inosuke",
                "middle": null,
                "last": "Hashibira",
                "full": "Inosuke Hashibira",
                "native": "嘴平伊之助",
                "userPreferred": "Inosuke Hashibira"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/n129130-SJC0Kn1DU39E.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/n129130-SJC0Kn1DU39E.jpg"
              }
            }
          },
          {
            "role": "MAIN",
            "node": {
              "id": 126071,
              "name": {
                "first": "Tanjirou",
                "middle": null,
                "last": "Kamado",
                "full": "Tanjirou Kamado",
                "native": "竈門炭治郎",
                "userPreferred": "Tanjirou Kamado"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b126071-BTNEc1nRIv68.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b126071-BTNEc1nRIv68.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 137776,
              "name": {
                "first": "Genya",
                "middle": null,
                "last": "Shinazugawa",
                "full": "Genya Shinazugawa",
                "native": "不死川玄弥",
                "userPreferred": "Genya Shinazugawa"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b137776-E0QuFD7y19OQ.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b137776-E0QuFD7y19OQ.jpg"
              }
            }
          },
          {
            "role": "MAIN",
            "node": {
              "id": 129131,
              "name": {
                "first": "Zenitsu",
                "middle": null,
                "last": "Agatsuma",
                "full": "Zenitsu Agatsuma",
                "native": "我妻善逸",
                "userPreferred": "Zenitsu Agatsuma"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b129131-FZrQ7lSlxmEr.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b129131-FZrQ7lSlxmEr.png"
              }
            }
          },
          {
            "role": "MAIN",
            "node": {
              "id": 127518,
              "name": {
                "first": "Nezuko",
                "middle": null,
                "last": "Kamado",
                "full": "Nezuko Kamado",
                "native": "竈門禰豆子",
                "userPreferred": "Nezuko Kamado"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b127518-NRlq1CQ1v1ro.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b127518-NRlq1CQ1v1ro.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 137810,
              "name": {
                "first": "Matsuemon",
                "middle": null,
                "last": "Tennouji",
                "full": "Matsuemon Tennouji",
                "native": "天王寺松右衛門",
                "userPreferred": "Matsuemon Tennouji"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b137810-x5JEOQTuxd86.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b137810-x5JEOQTuxd86.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 137808,
              "name": {
                "first": "Kagaya",
                "middle": null,
                "last": "Ubuyashiki",
                "full": "Kagaya Ubuyashiki",
                "native": "産屋敷耀哉",
                "userPreferred": "Kagaya Ubuyashiki"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b137808-4yA8XQUDrAho.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b137808-4yA8XQUDrAho.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 137806,
              "name": {
                "first": "Makomo",
                "middle": null,
                "last": null,
                "full": "Makomo",
                "native": "真菰",
                "userPreferred": "Makomo"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b137806-43Lqae34Vzqu.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b137806-43Lqae34Vzqu.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 137809,
              "name": {
                "first": "Sabito",
                "middle": null,
                "last": null,
                "full": "Sabito",
                "native": "錆兎",
                "userPreferred": "Sabito"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b137809-6Tkle99lCBl8.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b137809-6Tkle99lCBl8.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 129132,
              "name": {
                "first": "Muzan",
                "middle": null,
                "last": "Kibutsuji",
                "full": "Muzan Kibutsuji",
                "native": "鬼舞辻無惨",
                "userPreferred": "Muzan Kibutsuji"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b129132-4nIZakUZ1o8W.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b129132-4nIZakUZ1o8W.jpg"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 138812,
              "name": {
                "first": "Numa Oni",
                "middle": null,
                "last": null,
                "full": "Numa Oni",
                "native": "沼鬼",
                "userPreferred": "Numa Oni"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138812-Imqj3sSfpcso.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138812-Imqj3sSfpcso.jpg"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 138811,
              "name": {
                "first": "Yahaba",
                "middle": null,
                "last": null,
                "full": "Yahaba",
                "native": "矢琶羽",
                "userPreferred": "Yahaba"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138811-V9NNgNp9dAjq.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138811-V9NNgNp9dAjq.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 138810,
              "name": {
                "first": "Susamaru",
                "middle": null,
                "last": "",
                "full": "Susamaru",
                "native": " 朱紗丸",
                "userPreferred": "Susamaru"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138810-hILrFac1OjKd.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138810-hILrFac1OjKd.png"
              }
            }
          },
          {
            "role": "BACKGROUND",
            "node": {
              "id": 138988,
              "name": {
                "first": "Teoni",
                "middle": null,
                "last": null,
                "full": "Teoni",
                "native": "手鬼",
                "userPreferred": "Teoni"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138988-xU0pGFRXSweT.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138988-xU0pGFRXSweT.png"
              }
            }
          },
          {
            "role": "BACKGROUND",
            "node": {
              "id": 138989,
              "name": {
                "first": "Odou no Oni",
                "middle": null,
                "last": null,
                "full": "Odou no Oni",
                "native": "お堂の鬼",
                "userPreferred": "Odou no Oni"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138989-2ZWGyfLbCxtV.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138989-2ZWGyfLbCxtV.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 138990,
              "name": {
                "first": "Hotaru",
                "middle": null,
                "last": "Haganezuka",
                "full": "Hotaru Haganezuka",
                "native": " 鋼鐵塚蛍",
                "userPreferred": "Hotaru Haganezuka"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138990-E5kiUoLigpyX.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138990-E5kiUoLigpyX.jpg"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 138847,
              "name": {
                "first": "Tamayo",
                "middle": null,
                "last": null,
                "full": "Tamayo",
                "native": "珠世",
                "userPreferred": "Tamayo"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138847-rOwIPLKaR5Ux.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138847-rOwIPLKaR5Ux.jpg"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 138846,
              "name": {
                "first": "Yushirou",
                "middle": null,
                "last": null,
                "full": "Yushirou",
                "native": "愈史郎",
                "userPreferred": "Yushirou"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b138846-i8frJEl8baly.jpg",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b138846-i8frJEl8baly.jpg"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 139739,
              "name": {
                "first": "Rui",
                "middle": null,
                "last": null,
                "full": "Rui",
                "native": "累",
                "userPreferred": "Rui"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b139739-BP0eUt2P9pRv.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b139739-BP0eUt2P9pRv.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 141692,
              "name": {
                "first": "Kumo Oni Haha",
                "middle": null,
                "last": null,
                "full": "Kumo Oni Haha",
                "native": "蜘蛛鬼「母」",
                "userPreferred": "Kumo Oni Haha"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b141692-WQtsdIB6qfUF.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b141692-WQtsdIB6qfUF.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 139740,
              "name": {
                "first": "Kumo Oni Ani",
                "middle": null,
                "last": null,
                "full": "Kumo Oni Ani",
                "native": "蜘蛛鬼「兄」",
                "userPreferred": "Kumo Oni Ani"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b139740-0mwob6HrCIQN.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b139740-0mwob6HrCIQN.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 141693,
              "name": {
                "first": "Kumo Oni Chichi",
                "middle": null,
                "last": null,
                "full": "Kumo Oni Chichi",
                "native": "蜘蛛鬼「父」",
                "userPreferred": "Kumo Oni Chichi"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b141693-18yNfOx3iopF.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b141693-18yNfOx3iopF.png"
              }
            }
          },
          {
            "role": "SUPPORTING",
            "node": {
              "id": 141690,
              "name": {
                "first": "Kumo Oni Ane",
                "middle": null,
                "last": null,
                "full": "Kumo Oni Ane",
                "native": "蜘蛛鬼「姉」",
                "userPreferred": "Kumo Oni Ane"
              },
              "image": {
                "large":
                    "https://s4.anilist.co/file/anilistcdn/character/large/b141690-wUzkOrrX8HGJ.png",
                "medium":
                    "https://s4.anilist.co/file/anilistcdn/character/medium/b141690-wUzkOrrX8HGJ.png"
              }
            }
          }
        ]
      },
      "recommendations": {
        "edges": [
          {
            "node": {
              "id": 45037,
              "mediaRecommendation": {
                "id": 113415,
                "title": {
                  "romaji": "Jujutsu Kaisen",
                  "english": "JUJUTSU KAISEN",
                  "native": "呪術廻戦",
                  "userPreferred": "Jujutsu Kaisen"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx113415-bbBWj4pEFseh.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx113415-bbBWj4pEFseh.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx113415-bbBWj4pEFseh.jpg"
                },
                "startDate": {"year": 2020, "month": 10, "day": 3},
                "endDate": {"year": 2021, "month": 3, "day": 27},
                "genres": ["Action", "Drama", "Supernatural"],
                "description":
                    "A boy fights... for \"the right death.\"<br>\n<br>\nHardship, regret, shame: the negative feelings that humans feel become Curses that lurk in our everyday lives. The Curses run rampant throughout the world, capable of leading people to terrible misfortune and even death. What's more, the Curses can only be exorcised by another Curse.<br>\n<br>\nItadori Yuji is a boy with tremendous physical strength, though he lives a completely ordinary high school life. One day, to save a friend who has been attacked by Curses, he eats the finger of the Double-Faced Specter, taking the Curse into his own soul. From then on, he shares one body with the Double-Faced Specter. Guided by the most powerful of sorcerers, Gojou Satoru, Itadori is admitted to the Tokyo Metropolitan Technical High School of Sorcery, an organization that fights the Curses... and thus begins the heroic tale of a boy who became a Curse to exorcise a Curse, a life from which he could never turn back.\n<br><br>\n(Source: Crunchyroll)<br>\n<br>\n<i>Note: The first episode received an early web premiere on September 19th, 2020. The regular TV broadcast started on October 3rd, 2020.</i>",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/113415-jQBSkxWAAk83.jpg",
                "format": "TV",
                "idMal": 40748,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 24
              }
            }
          },
          {
            "node": {
              "id": 1763,
              "mediaRecommendation": {
                "id": 101347,
                "title": {
                  "romaji": "Dororo",
                  "english": "Dororo",
                  "native": "どろろ",
                  "userPreferred": "Dororo"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/nx101347-2J2p8qJpxpfZ.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/nx101347-2J2p8qJpxpfZ.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/nx101347-2J2p8qJpxpfZ.jpg"
                },
                "startDate": {"year": 2019, "month": 1, "day": 7},
                "endDate": {"year": 2019, "month": 6, "day": 24},
                "genres": ["Action", "Adventure", "Drama", "Supernatural"],
                "description":
                    "Dororo, a young orphan thief, meets Hyakkimaru, a powerful ronin. Hyakkimaru's father, a greedy feudal lord, had made a pact with 12 demons, offering his yet-unborn son's body parts in exchange for great power. Thus, Hyakkimaru - who was born without arms, legs, eyes, ears, a nose or a mouth - was abandoned in a river as a baby. Rescued and raised by Dr. Honma, who equips him with artificial limbs and teaches him sword-fighting techniques, Hyakkimaru discovers that each time he slays a demon, a piece of his body is restored. Now, he roams the war-torn countryside in search of demons.",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/n101347-tHurKfTlhtFl.jpg",
                "format": "TV",
                "idMal": 37520,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 24
              }
            }
          },
          {
            "node": {
              "id": 4675,
              "mediaRecommendation": {
                "id": 104276,
                "title": {
                  "romaji": "Boku no Hero Academia 4",
                  "english": "My Hero Academia Season 4",
                  "native": "僕のヒーローアカデミア４",
                  "userPreferred": "Boku no Hero Academia 4"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx104276-SnEowMvesWIE.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx104276-SnEowMvesWIE.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx104276-SnEowMvesWIE.png"
                },
                "startDate": {"year": 2019, "month": 10, "day": 12},
                "endDate": {"year": 2020, "month": 4, "day": 4},
                "genres": ["Action", "Adventure", "Comedy", "Sci-Fi"],
                "description":
                    "The villain world teeters on the brink of war now that All For One is out of the picture. Shigaraki of the League of Villains squares off with Overhaul of the yakuza, vying for total control of the shadows. Meanwhile, Deku gets tangled in another dangerous internship as he struggles to keep pace with his upperclassman—Mirio.<br><br>(Source: Crunchyroll)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/104276-PQO1pcNzzWT0.jpg",
                "format": "TV",
                "idMal": 38408,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 25
              }
            }
          },
          {
            "node": {
              "id": 8316,
              "mediaRecommendation": {
                "id": 269,
                "title": {
                  "romaji": "BLEACH",
                  "english": "Bleach",
                  "native": "BLEACH",
                  "userPreferred": "BLEACH"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx269-KxkqTIuQgJ6v.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx269-KxkqTIuQgJ6v.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx269-KxkqTIuQgJ6v.png"
                },
                "startDate": {"year": 2004, "month": 10, "day": 5},
                "endDate": {"year": 2012, "month": 3, "day": 27},
                "genres": ["Action", "Adventure", "Supernatural"],
                "description":
                    "Ichigo Kurosaki is a rather normal high school student apart from the fact he has the ability to see ghosts. This ability never impacted his life in a major way until the day he encounters the Shinigami Kuchiki Rukia, who saves him and his family's lives from a Hollow, a corrupt spirit that devours human souls. \n<br><br>\nWounded during the fight against the Hollow, Rukia chooses the only option available to defeat the monster and passes her Shinigami powers to Ichigo. Now forced to act as a substitute until Rukia recovers, Ichigo hunts down the Hollows that plague his town. \n\n\n",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/269-08ar2HJOUAuL.jpg",
                "format": "TV",
                "idMal": 269,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 366
              }
            }
          },
          {
            "node": {
              "id": 5540,
              "mediaRecommendation": {
                "id": 97940,
                "title": {
                  "romaji": "Black Clover",
                  "english": "Black Clover",
                  "native": "ブラッククローバー",
                  "userPreferred": "Black Clover"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx97940-O2LWFOG8bK1u.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx97940-O2LWFOG8bK1u.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx97940-O2LWFOG8bK1u.jpg"
                },
                "startDate": {"year": 2017, "month": 10, "day": 3},
                "endDate": {"year": 2021, "month": 3, "day": 30},
                "genres": ["Action", "Adventure", "Comedy", "Fantasy"],
                "description":
                    "In a world where magic is everything, Asta and Yuno are both found abandoned at a church on the same day. While Yuno is gifted with exceptional magical powers, Asta is the only one in this world without any. At the age of fifteen, both receive grimoires, magic books that amplify their holder’s magic. Asta’s is a rare Grimoire of Anti-Magic that negates and repels his opponent’s spells. Being opposite but good rivals, Yuno and Asta are ready for the hardest of challenges to achieve their common dream: to be the Wizard King. Giving up is never an option!<br>\n<br>\n(Source: Crunchyroll)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/97940-1URQdQ4U1a0b.jpg",
                "format": "TV",
                "idMal": 34572,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 170
              }
            }
          },
          {
            "node": {
              "id": 16569,
              "mediaRecommendation": {
                "id": 5114,
                "title": {
                  "romaji": "Hagane no Renkinjutsushi: FULLMETAL ALCHEMIST",
                  "english": "Fullmetal Alchemist: Brotherhood",
                  "native": "鋼の錬金術師 FULLMETAL ALCHEMIST",
                  "userPreferred":
                      "Hagane no Renkinjutsushi: FULLMETAL ALCHEMIST"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx5114-KJTQz9AIm6Wk.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx5114-KJTQz9AIm6Wk.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx5114-KJTQz9AIm6Wk.jpg"
                },
                "startDate": {"year": 2009, "month": 4, "day": 5},
                "endDate": {"year": 2010, "month": 7, "day": 4},
                "genres": ["Action", "Adventure", "Drama", "Fantasy"],
                "description":
                    "\"In order for something to be obtained, something of equal value must be lost.\"\n<br><br>\nAlchemy is bound by this Law of Equivalent Exchange—something the young brothers Edward and Alphonse Elric only realize after attempting human transmutation: the one forbidden act of alchemy. They pay a terrible price for their transgression—Edward loses his left leg, Alphonse his physical body. It is only by the desperate sacrifice of Edward's right arm that he is able to affix Alphonse's soul to a suit of armor. Devastated and alone, it is the hope that they would both eventually return to their original bodies that gives Edward the inspiration to obtain metal limbs called \"automail\" and become a state alchemist, the Fullmetal Alchemist.\n<br><br>\nThree years of searching later, the brothers seek the Philosopher's Stone, a mythical relic that allows an alchemist to overcome the Law of Equivalent Exchange. Even with military allies Colonel Roy Mustang, Lieutenant Riza Hawkeye, and Lieutenant Colonel Maes Hughes on their side, the brothers find themselves caught up in a nationwide conspiracy that leads them not only to the true nature of the elusive Philosopher's Stone, but their country's murky history as well. In between finding a serial killer and racing against time, Edward and Alphonse must ask themselves if what they are doing will make them human again... or take away their humanity.\n<br><br>\n(Source: MAL Rewrite)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/5114-q0V5URebphSG.jpg",
                "format": "TV",
                "idMal": 5114,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 64
              }
            }
          },
          {
            "node": {
              "id": 7245,
              "mediaRecommendation": {
                "id": 249,
                "title": {
                  "romaji": "Inuyasha",
                  "english": "InuYasha",
                  "native": "犬夜叉",
                  "userPreferred": "Inuyasha"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx249-YN54jZrItGgZ.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx249-YN54jZrItGgZ.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx249-YN54jZrItGgZ.png"
                },
                "startDate": {"year": 2000, "month": 10, "day": 16},
                "endDate": {"year": 2004, "month": 9, "day": 13},
                "genres": [
                  "Action",
                  "Adventure",
                  "Comedy",
                  "Fantasy",
                  "Romance"
                ],
                "description":
                    "Kagome Higurashi, an average ninth grader, gets pulled into an ancient well by a demon, bringing her 500 years in the past to the feudal era. There, she meets Inuyasha, a half-demon who seeks the Shikon Jewel to make himself a full-fledged demon. With Inuyasha and new friends, Kagome's search for the Jewel of Four Souls begins...<br>\n<br>\n(Source: Viz Media)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/249-9ufXhmXxncry.jpg",
                "format": "TV",
                "idMal": 249,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 167
              }
            }
          },
          {
            "node": {
              "id": 202449,
              "mediaRecommendation": {
                "id": 128893,
                "title": {
                  "romaji": "Jigokuraku",
                  "english": "Hell’s Paradise",
                  "native": "地獄楽",
                  "userPreferred": "Jigokuraku"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx128893-l0R0GFHplDKW.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx128893-l0R0GFHplDKW.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx128893-l0R0GFHplDKW.jpg"
                },
                "startDate": {"year": 2023, "month": 4, "day": 1},
                "endDate": {"year": 2023, "month": 7, "day": 1},
                "genres": ["Action", "Adventure", "Mystery", "Supernatural"],
                "description":
                    "The Edo period is nearing its end. Gabimaru, a shinobi formerly known as the strongest in Iwagakure who is now a death row convict, is told that he will be acquitted and set free if he can bring back the Elixir of Life from an island that is rumored to be the Buddhist pure land Sukhavati. In hopes of reuniting with his beloved wife, Gabimaru heads to the island along with the executioner Yamada Asaemon Sagiri. Upon arriving there, they encounter other death row convicts in search of the Elixir of Life... as well as a host of unknown creatures, eerie manmade statues, and the hermits who rule the island. Can Gabimaru find the Elixir of Life on this mysterious island and make it back home alive?<br>\n<br>\n(Source: Crunchyroll)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/128893-pAA7PjY8l7dy.jpg",
                "format": "TV",
                "idMal": 46569,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 13
              }
            }
          },
          {
            "node": {
              "id": 6872,
              "mediaRecommendation": {
                "id": 11061,
                "title": {
                  "romaji": "HUNTER×HUNTER (2011)",
                  "english": "Hunter x Hunter (2011)",
                  "native": "HUNTER×HUNTER (2011)",
                  "userPreferred": "HUNTER×HUNTER (2011)"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx11061-sIpBprNRfzCe.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx11061-sIpBprNRfzCe.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx11061-sIpBprNRfzCe.png"
                },
                "startDate": {"year": 2011, "month": 10, "day": 2},
                "endDate": {"year": 2014, "month": 9, "day": 24},
                "genres": ["Action", "Adventure", "Fantasy"],
                "description":
                    "A new adaption of the manga of the same name by Togashi Yoshihiro.<br><br>\nA Hunter is one who travels the world doing all sorts of dangerous tasks. From capturing criminals to searching deep within uncharted lands for any lost treasures. Gon is a young boy whose father disappeared long ago, being a Hunter. He believes if he could also follow his father's path, he could one day reunite with him.<br><br>\nAfter becoming 12, Gon leaves his home and takes on the task of entering the Hunter exam, notorious for its low success rate and high probability of death to become an official Hunter. He befriends the revenge-driven Kurapika, the doctor-to-be Leorio and the rebellious ex-assassin Killua in the exam, with their friendship prevailing throughout the many trials and threats they come upon taking on the dangerous career of a Hunter.",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/11061-8WkkTZ6duKpq.jpg",
                "format": "TV",
                "idMal": 11061,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 148
              }
            }
          },
          {
            "node": {
              "id": 11282,
              "mediaRecommendation": {
                "id": 20,
                "title": {
                  "romaji": "NARUTO",
                  "english": "Naruto",
                  "native": "NARUTO -ナルト-",
                  "userPreferred": "NARUTO"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx20-YJvLbgJQPCoI.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx20-YJvLbgJQPCoI.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx20-YJvLbgJQPCoI.jpg"
                },
                "startDate": {"year": 2002, "month": 10, "day": 3},
                "endDate": {"year": 2007, "month": 2, "day": 8},
                "genres": [
                  "Action",
                  "Adventure",
                  "Comedy",
                  "Drama",
                  "Fantasy",
                  "Supernatural"
                ],
                "description":
                    "Naruto Uzumaki, a hyperactive and knuckle-headed ninja, lives in Konohagakure, the Hidden Leaf village. Moments prior to his birth, a huge demon known as the Kyuubi, the Nine-tailed Fox, attacked Konohagakure and wreaked havoc. In order to put an end to the Kyuubi's rampage, the leader of the village, the 4th Hokage, sacrificed his life and sealed the monstrous beast inside the newborn Naruto. <br><br>\nShunned because of the presence of the Kyuubi inside him, Naruto struggles to find his place in the village. He strives to become the Hokage of Konohagakure, and he meets many friends and foes along the way. <br><br>\n(Source: MAL Rewrite)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/20-HHxhPj5JD13a.jpg",
                "format": "TV",
                "idMal": 20,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 220
              }
            }
          },
          {
            "node": {
              "id": 27586,
              "mediaRecommendation": {
                "id": 20613,
                "title": {
                  "romaji": "Akame ga Kill!",
                  "english": "Akame ga Kill!",
                  "native": "アカメが斬る！",
                  "userPreferred": "Akame ga Kill!"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx20613-4VGGPacciJBL.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx20613-4VGGPacciJBL.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx20613-4VGGPacciJBL.jpg"
                },
                "startDate": {"year": 2014, "month": 7, "day": 7},
                "endDate": {"year": 2014, "month": 12, "day": 15},
                "genres": [
                  "Action",
                  "Adventure",
                  "Drama",
                  "Fantasy",
                  "Horror",
                  "Psychological",
                  "Thriller"
                ],
                "description":
                    "In a land where corruption rules and a ruthless Prime Minister has turned the puppet Emperor's armies of soldiers, assassins and secret police against the people, only one force dares to stand against them: Night Raid, an elite team of relentless killers, each equipped with an Imperial Arm - legendary weapons with unique and incredible powers created in the distant past.<br>\n<br>\nRescued from a fate worse than death by Night Raid, young Tatsumi is offered the chance to join their lethal ranks… but it's a deadly choice, as few can master an Imperial Arm and even fewer survive when two Arms go against each other in combat. The battle is on, and only the strongest will make it out alive.\n<br><br>\n(Source: Sentai Filmworks)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/20613-CoEQF4qKiWDX.jpg",
                "format": "TV",
                "idMal": 22199,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 24
              }
            }
          },
          {
            "node": {
              "id": 117161,
              "mediaRecommendation": {
                "id": 131573,
                "title": {
                  "romaji": "Jujutsu Kaisen 0",
                  "english": "JUJUTSU KAISEN 0",
                  "native": "呪術廻戦 0",
                  "userPreferred": "Jujutsu Kaisen 0"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx131573-rpl82vDEDRm6.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx131573-rpl82vDEDRm6.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx131573-rpl82vDEDRm6.jpg"
                },
                "startDate": {"year": 2021, "month": 12, "day": 24},
                "endDate": {"year": 2021, "month": 12, "day": 24},
                "genres": ["Action", "Supernatural"],
                "description":
                    "Yuta Okkotsu is a nervous high school student who is suffering from a serious problem—his childhood friend Rika has turned into a curse and won't leave him alone. Since Rika is no ordinary curse, his plight is noticed by Satoru Gojo, a teacher at Jujutsu High, a school where fledgling exorcists learn how to combat curses. Gojo convinces Yuta to enroll, but can he learn enough in time to confront the curse that haunts him?\n<br><br>\n(Source: Viz Media)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/131573-3veuVz5p0z2I.jpg",
                "format": "MOVIE",
                "idMal": 48561,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 1
              }
            }
          },
          {
            "node": {
              "id": 68409,
              "mediaRecommendation": {
                "id": 117193,
                "title": {
                  "romaji": "Boku no Hero Academia 5",
                  "english": "My Hero Academia Season 5",
                  "native": "僕のヒーローアカデミア５",
                  "userPreferred": "Boku no Hero Academia 5"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx117193-E75BlZmDh1aB.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx117193-E75BlZmDh1aB.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx117193-E75BlZmDh1aB.jpg"
                },
                "startDate": {"year": 2021, "month": 3, "day": 27},
                "endDate": {"year": 2021, "month": 9, "day": 25},
                "genres": ["Action", "Adventure", "Comedy", "Sci-Fi"],
                "description":
                    "The rivalry between Class 1-A and Class 1-B heats up in a joint training battle. Eager to be a part of the hero course, brainwashing buff Shinso is tasked with competing on both sides.\n<br><br>\nBut as each team faces their own weaknesses and discovers new strengths, this showdown might just become a toss-up.<br><br>\n(Source: Funimation)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/117193-37OySoeOMN0z.jpg",
                "format": "TV",
                "idMal": 41587,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 25
              }
            }
          },
          {
            "node": {
              "id": 56065,
              "mediaRecommendation": {
                "id": 114085,
                "title": {
                  "romaji": "Kemono Jihen",
                  "english": "Kemono Jihen",
                  "native": "怪物事変",
                  "userPreferred": "Kemono Jihen"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx114085-2w5rYZTOa7ER.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx114085-2w5rYZTOa7ER.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx114085-2w5rYZTOa7ER.jpg"
                },
                "startDate": {"year": 2021, "month": 1, "day": 10},
                "endDate": {"year": 2021, "month": 3, "day": 28},
                "genres": ["Action", "Drama", "Mystery", "Supernatural"],
                "description":
                    "Special detective Kohachi Inugami is sent to investigate a grisly phenomenon involving animal corpses near a remote mountain village. But after meeting a strange boy who agrees to help, he discovers cursed supernatural forces at work. Little by little, Inugami uncovers the truth behind the killings and the boy who may not even be human.<br>\n<br>\n(Source: Funimation)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/114085-kIiJwfwnY1qL.jpg",
                "format": "TV",
                "idMal": 40908,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 12
              }
            }
          },
          {
            "node": {
              "id": 406,
              "mediaRecommendation": {
                "id": 20829,
                "title": {
                  "romaji": "Owari no Seraph",
                  "english": "Seraph of the End: Vampire Reign",
                  "native": "終わりのセラフ",
                  "userPreferred": "Owari no Seraph"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx20829-PYKVvgUqJVUK.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx20829-PYKVvgUqJVUK.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx20829-PYKVvgUqJVUK.png"
                },
                "startDate": {"year": 2015, "month": 4, "day": 4},
                "endDate": {"year": 2015, "month": 6, "day": 20},
                "genres": [
                  "Action",
                  "Drama",
                  "Fantasy",
                  "Mystery",
                  "Supernatural"
                ],
                "description":
                    "The story takes place in a world where an unknown virus has killed the entire human population except for children under 13. Those children were then enslaved by vampires. The manga centers on Yuichiro Hyakuya, a human who dreams of becoming strong enough to kill all vampires.<br>\n<br>\n(Source: Anime News Network)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/20829-1BRrVJAxlEKT.jpg",
                "format": "TV",
                "idMal": 26243,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 12
              }
            }
          },
          {
            "node": {
              "id": 172603,
              "mediaRecommendation": {
                "id": 139630,
                "title": {
                  "romaji": "Boku no Hero Academia 6",
                  "english": "My Hero Academia Season 6",
                  "native": "僕のヒーローアカデミア６",
                  "userPreferred": "Boku no Hero Academia 6"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx139630-2Nvd1vqQ52Ik.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx139630-2Nvd1vqQ52Ik.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx139630-2Nvd1vqQ52Ik.jpg"
                },
                "startDate": {"year": 2022, "month": 10, "day": 1},
                "endDate": {"year": 2023, "month": 3, "day": 25},
                "genres": ["Action", "Adventure", "Comedy"],
                "description":
                    "With Tomura Shigaraki at its helm, the former Liberation Army is now known as the Paranormal Liberation Front. This organized criminal group poses an immense threat to the Hero Association, not only because of its sheer size and strength, but also the overpowering quirks of Jin \"Twice\" Bubaigawara and Gigantomachia.\n<br><br>\nAs new intel from the covert hero Keigo \"Hawks\" Takami confirms that Shigaraki is nowhere to be seen, the Hero Association decides to strike the enemy headquarters with a surprise attack using the entirety of its assets—and the UA students find themselves on the battlefield once again. As the fight rages on, the unsuspecting villains must regroup and push back, but the brave heroes are determined to eradicate every last one of them.\n<br><br>\n(Source: MAL Rewrite)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/139630-XLc90c6CJjZv.jpg",
                "format": "TV",
                "idMal": 49918,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 25
              }
            }
          },
          {
            "node": {
              "id": 61595,
              "mediaRecommendation": {
                "id": 129627,
                "title": {
                  "romaji":
                      "Chuukou Ikkan!! Kimetsu Gakuen Monogatari: Valentine-hen",
                  "english":
                      "Junior High and High School!! Kimetsu Academy Story: Valentine Edition",
                  "native": "中高一貫!!キメツ学園物語 ～バレンタイン編～",
                  "userPreferred":
                      "Chuukou Ikkan!! Kimetsu Gakuen Monogatari: Valentine-hen"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx129627-GiVeOqDUAqUC.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx129627-GiVeOqDUAqUC.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx129627-GiVeOqDUAqUC.png"
                },
                "startDate": {"year": 2021, "month": 2, "day": 14},
                "endDate": {"year": 2021, "month": 2, "day": 14},
                "genres": ["Comedy"],
                "description":
                    "Valentine's Day special for Kimetsu no Yaiba. The first three episodes will be released on Aniplex's official YouTube channel, while the fourth and final episode was streamed during the Kimetsu Matsuri Online: Anime 2nd Anniversary Festival and also available on Aniplex's channel after airing.<br><br>\n<i>Note: Related to the post-credit shorts after episodes 14, 17 on the TV broadcast of Kimetsu no Yaiba.</i>",
                "bannerImage": null,
                "format": "ONA",
                "idMal": 47398,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 4
              }
            }
          },
          {
            "node": {
              "id": 68873,
              "mediaRecommendation": {
                "id": 129664,
                "title": {
                  "romaji": "Jouran: THE PRINCESS OF SNOW AND BLOOD",
                  "english": "JORAN THE PRINCESS OF SNOW AND BLOOD",
                  "native": "擾乱 THE PRINCESS OF SNOW AND BLOOD",
                  "userPreferred": "Jouran: THE PRINCESS OF SNOW AND BLOOD"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx129664-YeovI2zsTwY9.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx129664-YeovI2zsTwY9.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx129664-YeovI2zsTwY9.jpg"
                },
                "startDate": {"year": 2021, "month": 3, "day": 31},
                "endDate": {"year": 2021, "month": 6, "day": 16},
                "genres": ["Action", "Supernatural"],
                "description":
                    "The year is 1931. Prince Tokugawa Yoshinobu is 94 years old and holds absolute control over Japan. Remnants of the Meiji era’s culture can be seen around the city, but scientific technology and Japanese esoteric cosmology Onmyodo are also developing, exuding a sense of modernity. Yet lurking behind the glitz is Kuchinawa, a dissident group planning the assassination of the prince, and effectively the fall of the regime. Tasked to extinguish these dissidents is Nue, the government’s secret executioner group. Sawa Yukimura, who works for this organization, suffered from an early age at the hands of the Kuchinawa boss. Her entire family was murdered and she dedicated her life to avenging their death.<br>\n<br>\n(Source: Crunchyroll)<br><br><i>Note: The show streamed the episodes on Hulu a week earlier than TV. The regular TV broadcast started on April 7, 2021.</i>",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/129664-IbKV1WXCzGy5.jpg",
                "format": "ONA",
                "idMal": 47250,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 12
              }
            }
          },
          {
            "node": {
              "id": 2686,
              "mediaRecommendation": {
                "id": 21459,
                "title": {
                  "romaji": "Boku no Hero Academia",
                  "english": "My Hero Academia",
                  "native": "僕のヒーローアカデミア",
                  "userPreferred": "Boku no Hero Academia"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx21459-DUKLgasrgeNO.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx21459-DUKLgasrgeNO.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx21459-DUKLgasrgeNO.jpg"
                },
                "startDate": {"year": 2016, "month": 4, "day": 3},
                "endDate": {"year": 2016, "month": 6, "day": 26},
                "genres": ["Action", "Adventure", "Comedy"],
                "description":
                    "What would the world be like if 80 percent of the population manifested extraordinary superpowers called “Quirks” at age four? Heroes and villains would be battling it out everywhere! Becoming a hero would mean learning to use your power, but where would you go to study? U.A. High's Hero Program of course! But what would you do if you were one of the 20 percent who were born Quirkless?<br><br>\n\nMiddle school student Izuku Midoriya wants to be a hero more than anything, but he hasn't got an ounce of power in him. With no chance of ever getting into the prestigious U.A. High School for budding heroes, his life is looking more and more like a dead end. Then an encounter with All Might, the greatest hero of them all gives him a chance to change his destiny…<br><br>\n\n(Source: Viz Media)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/21459-yeVkolGKdGUV.jpg",
                "format": "TV",
                "idMal": 31964,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 13
              }
            }
          },
          {
            "node": {
              "id": 174783,
              "mediaRecommendation": {
                "id": 127230,
                "title": {
                  "romaji": "Chainsaw Man",
                  "english": "Chainsaw Man",
                  "native": "チェンソーマン",
                  "userPreferred": "Chainsaw Man"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx127230-FlochcFsyoF4.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx127230-FlochcFsyoF4.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx127230-FlochcFsyoF4.png"
                },
                "startDate": {"year": 2022, "month": 10, "day": 12},
                "endDate": {"year": 2022, "month": 12, "day": 28},
                "genres": ["Action", "Drama", "Horror", "Supernatural"],
                "description":
                    "Denji is a teenage boy living with a Chainsaw Devil named Pochita. Due to the debt his father left behind, he has been living a rock-bottom life while repaying his debt by harvesting devil corpses with Pochita.<br><br>\nOne day, Denji is betrayed and killed. As his consciousness fades, he makes a contract with Pochita and gets revived as \"Chainsaw Man\" — a man with a devil's heart.<br>\n<br>\n(Source: Crunchyroll)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/127230-o8IRwCGVr9KW.jpg",
                "format": "TV",
                "idMal": 44511,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 12
              }
            }
          },
          {
            "node": {
              "id": 218270,
              "mediaRecommendation": {
                "id": 145064,
                "title": {
                  "romaji": "Jujutsu Kaisen 2nd Season",
                  "english": "JUJUTSU KAISEN Season 2",
                  "native": "呪術廻戦 第2期",
                  "userPreferred": "Jujutsu Kaisen 2nd Season"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx145064-5fa4ZBbW4dqA.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx145064-5fa4ZBbW4dqA.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx145064-5fa4ZBbW4dqA.jpg"
                },
                "startDate": {"year": 2023, "month": 7, "day": 6},
                "endDate": {"year": null, "month": null, "day": null},
                "genres": ["Action", "Drama", "Supernatural"],
                "description":
                    "The second season of <i>Jujutsu Kaisen</i>.<br>\n<br>\nThe past comes to light when second-year students Satoru Gojou and Suguru Getou are tasked with escorting young Riko Amanai to Master Tengen. But when a non-sorcerer user tries to kill them, their mission to protect the Star Plasma Vessel threatens to turn them into bitter enemies and cement their destinies—one as the world’s strongest sorcerer, and the other its most twisted curse user!<br>\n<br>\n(Source: Crunchyroll)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/145064-kH9vbOEitIhl.jpg",
                "format": "TV",
                "idMal": 51009,
                "status": "RELEASING",
                "nextAiringEpisode": {"episode": 6},
                "episodes": 23
              }
            }
          },
          {
            "node": {
              "id": 2078,
              "mediaRecommendation": {
                "id": 9919,
                "title": {
                  "romaji": "Ao no Exorcist",
                  "english": "Blue Exorcist",
                  "native": "青の祓魔師",
                  "userPreferred": "Ao no Exorcist"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx9919-nXS7JOZrWHfS.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx9919-nXS7JOZrWHfS.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx9919-nXS7JOZrWHfS.jpg"
                },
                "startDate": {"year": 2011, "month": 4, "day": 17},
                "endDate": {"year": 2011, "month": 10, "day": 2},
                "genres": ["Action", "Fantasy", "Supernatural"],
                "description":
                    "This world consists of two dimensions joined as one, like a mirror. The first is the world in which the humans live, Assiah. The other is the world of demons, Gehenna. Ordinarily, travel between the two, and indeed any kind of contact between the two, is impossible. However the demons can pass over into this world by possessing anything that exist within it. Satan the god of demons, but there's one thing that he doesn't have, and that's a substance in the human world that is powerful enough to contain him!! For that purpose he created Rin, his son from a human woman, but will his son agree to his plans? Or will he become something else...? An exorcist?\n",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/9919-S5idQm3GbZ80.jpg",
                "format": "TV",
                "idMal": 9919,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 25
              }
            }
          },
          {
            "node": {
              "id": 44491,
              "mediaRecommendation": {
                "id": 116006,
                "title": {
                  "romaji": "THE GOD OF HIGH SCHOOL",
                  "english": "The God of High School",
                  "native": "THE GOD OF HIGH SCHOOL ゴッド・オブ・ハイスクール",
                  "userPreferred": "THE GOD OF HIGH SCHOOL"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx116006-Wt8JSA1ZQxlM.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx116006-Wt8JSA1ZQxlM.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx116006-Wt8JSA1ZQxlM.png"
                },
                "startDate": {"year": 2020, "month": 7, "day": 6},
                "endDate": {"year": 2020, "month": 9, "day": 28},
                "genres": ["Action", "Comedy", "Supernatural"],
                "description":
                    "It all began as a fighting tournament to seek out for the best fighter among all high school students in Korea. Mori Jin, a Taekwondo specialist and a high school student, soon learns that there is something much greater beneath the stage of the tournament.<br><br>(Source: WEBTOONS)",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/116006-e7ZL1RJnabp1.jpg",
                "format": "TV",
                "idMal": 41353,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 13
              }
            }
          },
          {
            "node": {
              "id": 174587,
              "mediaRecommendation": {
                "id": 116674,
                "title": {
                  "romaji": "BLEACH: Sennen Kessen-hen",
                  "english": "BLEACH: Thousand-Year Blood War",
                  "native": "BLEACH 千年血戦篇",
                  "userPreferred": "BLEACH: Sennen Kessen-hen"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx116674-p3zK4PUX2Aag.jpg",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx116674-p3zK4PUX2Aag.jpg",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx116674-p3zK4PUX2Aag.jpg"
                },
                "startDate": {"year": 2022, "month": 10, "day": 11},
                "endDate": {"year": 2022, "month": 12, "day": 27},
                "genres": ["Action", "Adventure", "Supernatural"],
                "description":
                    "Was it all just a coincidence, or was it inevitable?\n<br><br>\nIchigo Kurosaki gained the powers of a Soul Reaper through a chance encounter. As a Substitute\nSoul Reaper, Ichigo became caught in the turmoil of the Soul Society, a place where deceased\nsouls gather. But with help from his friends, Ichigo overcame every challenge to become even\nstronger.\n<br><br>\nWhen new Soul Reapers and a new enemy appear in his hometown of Karakura, Ichigo jumps\nback into the battlefield with his Zanpakuto to help those in need. Meanwhile, the Soul Society\nis observing a sudden surge in the number of Hollows being destroyed in the World of the Living.\nThey also receive separate reports of residents in the Rukon District having gone missing. Finally,\nthe Seireitei, home of the Soul Reapers, comes under attack by a group calling themselves the\nWandenreich.\n<br><br>\nLed by Yhwach, the father of all Quincies, the Wandenreich declare war against the Soul Reapers\nwith the following message: <i>\"Five days from now, the Soul Society will be annihilated by the\nWandenreich.\"</i>\n<br><br>\nThe history and truth kept hidden by the Soul Reapers for a thousand long years is finally brought\nto light.\n<br><br>\nAll things must come to an end as Ichigo Kurosaki's final battle begins!",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/116674-l2YlIyJzvGSV.jpg",
                "format": "TV",
                "idMal": 41467,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 13
              }
            }
          },
          {
            "node": {
              "id": 34427,
              "mediaRecommendation": {
                "id": 104458,
                "title": {
                  "romaji": "Modao Zushi 2",
                  "english": "The Founder of Diabolism 2",
                  "native": "魔道祖师 第二季",
                  "userPreferred": "Modao Zushi 2"
                },
                "coverImage": {
                  "extraLarge":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx104458-b3PRaVB0vBM9.png",
                  "large":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx104458-b3PRaVB0vBM9.png",
                  "medium":
                      "https://s4.anilist.co/file/anilistcdn/media/anime/cover/small/bx104458-b3PRaVB0vBM9.png"
                },
                "startDate": {"year": 2019, "month": 8, "day": 3},
                "endDate": {"year": 2019, "month": 8, "day": 31},
                "genres": [
                  "Action",
                  "Adventure",
                  "Drama",
                  "Fantasy",
                  "Mystery",
                  "Supernatural"
                ],
                "description":
                    "Continuing his masquerade as the deranged lunatic from the Lanling Jin Clan, Wei Wuxian resides in the Cloud Recesses while his former cultivation classmate, Lan Wangji, searches for answers about the demonic severed arm they have in custody. With an overwhelming dark energy emanating from the arm, the two are forced to work together in order to keep it contained. However, the demonic arm is not the only dark force lurking in the region, and as spiritual tensions rise in the mountains of the Gusu Lan Clan, it is up to the two of them to try and restore the natural order.<br>\n<br>\nThe story of Wei Wuxian's fall from grace continues as more light is shed on his descent into the path of demonic cultivation. The demonic arm only further strains his mischievous spirit. This is the time for him to prove that he has truly broken free from the forbidden path and is not the maniacal sorcerer that everyone remembers him to be.\n",
                "bannerImage":
                    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/104458-pfJ8XuazfhYu.jpg",
                "format": "ONA",
                "idMal": 38450,
                "status": "FINISHED",
                "nextAiringEpisode": null,
                "episodes": 8
              }
            }
          }
        ]
      }
    }
  }
};
