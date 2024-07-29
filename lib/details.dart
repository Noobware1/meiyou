import 'dart:convert';

import 'package:meiyou/shared/domain/models/extension_category.dart';
import 'package:meiyou/shared/domain/models/media.dart';
import 'package:meiyou_extensions_lib/models.dart';
import 'package:nice_dart/nice_dart.dart';
import 'package:path/path.dart';

Media getDetails() {
  return Media.formIMedia(IMedia.fromJson(jsonDecode(r'''
{
  "title": "Jujutsu Kaisen 2nd Season",
  "format": "anime",
  "url": "",
  "other_titles": [
    "呪術廻戦 懐玉・玉折／渋谷事変"
  ],
  "status": "completed",
  "banner": "https://kickassanimes.io/image/banner/jujutsu-kaisen-2nd-season-6138-hq.webp",
  "poster": "https://kickassanimes.io/image/poster/jujutsu-kaisen-2nd-season-d1c5-hq.webp",
  "score": null,
  "description": "The year is 2006, and the halls of Tokyo Prefectural Jujutsu High School echo with the endless bickering and intense debate between two inseparable best friends. Exuding unshakeable confidence, Satoru Gojou and Suguru Getou believe there is no challenge too great for young and powerful Special Grade sorcerers such as themselves. They are tasked with safely delivering a sensible girl named Riko Amanai to the entity whose existence is the very essence of the jujutsu world. However, the mission plunges them into an exhausting swirl of moral conflict that threatens to destroy the already feeble amity between sorcerers and ordinary humans.\n\nTwelve years later, students and sorcerers are the frontline defense against the rising number of high-level curses born from humans' negative emotions. As the entities grow in power, their self-awareness and ambition increase too. The curses unite for the common goal of eradicating humans and creating a world of only cursed energy users, led by a dangerous, ancient cursed spirit. To dispose of their greatest obstacle—the strongest sorcerer, Gojou—they orchestrate an attack at Shibuya Station on Halloween. Dividing into teams, the sorcerers enter the fight prepared to risk everything to protect the innocent and their own kind.",
  "genres": [
    "Action",
    "Fantasy",
    "School",
    "Shounen"
  ],
  "initalized": true
}
''')), 1, ExtensionCategory.video);
}

List<IMediaContent> getContentList() {
  return List.from(jsonDecode(r'''
[{
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-1-08a28b",
  "name": "Hidden Inventory",
  "number": 1,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-1-ffcb-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-2-92eb06",
  "name": "Hidden Inventory 2",
  "number": 2,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-2-91c0-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-3-44ccb1",
  "name": "Hidden Inventory 3",
  "number": 3,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-3-61c0-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-4-6b9e0b",
  "name": "Hidden Inventory 4",
  "number": 4,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-4-5d60-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-5-56469c",
  "name": "Premature Death",
  "number": 5,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-5-77f3-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-5.5-21595e",
  "name": "Idle Talk Part 1",
  "number": 5,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-5-5-0bb1-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-5.9-6d11aa",
  "name": null,
  "number": 5,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-5-9-6e3f-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-6-22c257",
  "name": "It's Like That",
  "number": 6,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-6-04c9-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-7-adb693",
  "name": "Evening Festival",
  "number": 7,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-7-0b88-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-8-bb26a9",
  "name": "Shibuya Incident",
  "number": 8,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-8-5b3a-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-9-af9593",
  "name": "Shibuya Incident - Gate, Open",
  "number": 9,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-9-63b6-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-10-788c26",
  "name": "Pandemonium",
  "number": 10,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-10-cbdd-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-11-f2a22d",
  "name": "Seance",
  "number": 11,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-11-719c-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-12-41064a",
  "name": "Dull Knife",
  "number": 12,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-12-330b-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-13-227bb0",
  "name": "Red Scale",
  "number": 13,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-13-a813-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-14-f32a1b",
  "name": "Fluctuations",
  "number": 14,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-14-d5d6-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-15-019f4c",
  "name": "Fluctuations, Part 2",
  "number": 15,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-15-8aff-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-16-abe1a0",
  "name": "Thunderclap",
  "number": 16,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-16-8f55-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-17-a1811a",
  "name": "Thunderclap, Part 2",
  "number": 17,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-17-dff3-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-18-c8238a",
  "name": "Right and Wrong",
  "number": 18,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-18-7e51-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-19-9b8a5e",
  "name": "Right and Wrong, Part 2",
  "number": 19,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-19-f13b-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-20-d805b9",
  "name": "Right and Wrong, Part 3",
  "number": 20,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-20-4c42-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-21-327b43",
  "name": "Metamorphosis",
  "number": 21,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-21-d685-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-22-621819",
  "name": "Metamorphosis, Part 2",
  "number": 22,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-22-ed28-sm.webp",
  "isFiller": null,
  "description": null
}, {
  "url": "/jujutsu-kaisen-2nd-season-fe6b/ep-23-1e558a",
  "name": "Shibuya Incident - Gate, Close",
  "number": 23,
  "image": "https://kickassanimes.io/image/thumbnail/642602529d33f3e832425b5f/ep-23-cf50-sm.webp",
  "isFiller": null,
  "description": null
}]
''')).mapList((e) => IMediaContent.fromJson(e));
}
