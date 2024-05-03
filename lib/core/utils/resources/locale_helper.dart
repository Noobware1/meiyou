import 'dart:io';

import 'package:nice_dart/nice_dart.dart';

class LocaleHelper {
  /// Sorts by display name, except keeps the "all" (displayed as "Multi") locale at the top.
  static int comparator(String a, String b) {
    if (a == "all") return -1;
    if (b == "all") return 1;
    return getLocalizedDisplayName(a).compareTo(getLocalizedDisplayName(b));
  }

  /// Returns display name of a string language code.
  static String getSourceDisplayName(String? lang) {
    switch (lang) {
      case _lastUsed_key:
        return "Last Used";
      case _pinned_key:
        return "Pinned";
      case "other":
        return "Other";
      case "all":
        return "Multi";
      default:
        return getLocalizedDisplayName(lang);
    }
  }

  /// Returns display name of a string language code.
  ///
  /// @param lang empty for system language
  static String getLocalizedDisplayName(String? lang) {
    if (lang == null) return "";
    return _getLanguageFromlangaugeCode(
          lang.isEmpty ? Platform.localeName.substringBeforeLast('-') : lang,
        ) ??
        "";
  }

  /// Return the default languages enabled for the sources.
  static Set<String> getDefaultEnabledLanguages() {
    return {"all", "en", Platform.localeName};
  }

  static const _pinned_key = "pinned";
  static const _lastUsed_key = "last_used";
}

// modified version of https://github.com/kodjodevf/mangayomi/blob/85b3e2ee1f2678ebd40dae0f1701271740f10585/lib/utils/language.dart

String? _getLanguageFromlangaugeCode(String langaugeCode) {
  return _langaugeCodeTolanguageMap[langaugeCode.toLowerCase()] ?? langaugeCode;
}

const _langaugeCodeTolanguageMap = {
  "all": "Multi",
  "fr": "Français",
  "ca": "Català",
  "en": "English",
  "vi": "Tiếng:  Việt",
  "th": "ไทย",
  "ar": "العربية",
  "pt": "Português",
  "ko": "한국어",
  "pt-br": "Português (Brasil)",
  "it": "Italiano",
  "es": "Español",
  "ru": "Pусский язык",
  "es-419": "Español (Latinoamérica)",
  "id": "Indonesia",
  "hi": "हिन्दी",
  "ja": "日本語",
  "pl": "Polski",
  "tr": "Türkçe",
  "de": "Deutsch",
  "zh": "中文 (Zhōngwén)",
  "zh-hk": "繁體中文(Hong Kong)",
  "fil": "Filipino",
  "el": "Ελληνικά",
  "da": "dansk",
  "bn": "বাংলা",
  "af": "Afrikaans",
  "am": "አማርኛ",
  "az": "Azərbaycan",
  "be": "беларуская",
  "bs": "bosanski",
  "sv": "svenska",
  "fi": "suomi",
  "fa": "فارسی",
  "eu": "euskara",
  "nb-no": "Norwegian Bokmål (Norway)",
  "lt": "lietuvių kalba",
  "sh": "srpskohrvatski",
  "no": "Norsk",
  "he": "עברית",
  "mn": "Монгол",
  "ml": "മലയാളം",
  "uk": "Українська",
  "zu": "isiZulu",
  "xh": "isiXhosa",
  "nl": "Nederlands",
  "my": "ဗမာစာ",
  "ms": "Malaysia",
  "hr": "Hrvatski",
  "ro": "Română",
  "bg": "Bulgaria",
  // "bg": "български",
  "cs": "čeština",
  "ku": "Kurdî",
  "hu": "Magyar",
  "ceb": "Cebuano",
  "en-us": "English (United States)",
  "eo": "Esperanto",
  "et": "Estonian",
  "fo": "Faroese",
  "ga": "Irish",
  "gn": "Guarani",
  "gu": "Gujarati",
  "ha": "Hausa",
  "ht": "Haitian Creole",
  "hy": "Armenian",
  "ig": "Igbo",
  "is": "Icelandic",
  "ka": "Georgian",
  "jv": "Javanese",
  "kk": "Kazakh",
  "km": "Cambodian",
  "kn": "Kannada",
  "ky": "Kyrgyz",
  "lb": "Luxembourgish",
  "lo": "Laothian",
  "lv": "Latvian",
  "mg": "Malagasy",
  "mi": "Maori",
  "mk": "Macedonian",
  "mr": "Marathi",
  "mt": "Maltese",
  "ne": "Nepali",
  "ny": "Nyanja",
  "ps": "Pashto",
  "pt-pt": "Portuguese (Portugal)",
  "rm": "Romansh",
  "sd": "Sindhi",
  "si": "Sinhalese",
  "sk": "Slovak",
  "sl": "Slovenian",
  "sm": "Samoan",
  "sn": "Shona",
  "so": "Somali",
  "sq": "Albanian",
  "sr": "Serbian",
  "st": "Sesotho",
  "sw": "Swahili",
  "ta": "Tamil",
  "tg": "Tajik",
  "ti": "Tigrinya",
  "tk": "Turkmen",
  "to": "Tonga",
  "ur": "Urdu",
  "yo": "Yoruba",
  "zh-tw": "Chinese (Traditional)",
  "la": "Latin",
  "uz": "Uzbek",
  "tl": "Tagalog",
};
