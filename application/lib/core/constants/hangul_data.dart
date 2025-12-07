/// ハングル（韓国語文字）のデータ定義
///
/// カナダラ表で使用する子音・母音のデータを提供します。

/// 子音の種類
enum ConsonantType {
  /// 平音（基本子音）
  plain,

  /// 激音（息を強く出す音）
  aspirated,

  /// 濃音（詰まった音）
  tense,
}

/// 母音の種類
enum VowelType {
  /// 基本母音
  basic,

  /// 複合母音
  compound,
}

/// 子音データ
class HangulConsonant {
  const HangulConsonant({
    required this.character,
    required this.romanization,
    required this.japanese,
    required this.description,
    required this.type,
  });

  /// 韓国語文字
  final String character;

  /// ローマ字表記
  final String romanization;

  /// 日本語発音ガイド
  final String japanese;

  /// 発音の説明
  final String description;

  /// 子音の種類
  final ConsonantType type;
}

/// 母音データ
class HangulVowel {
  const HangulVowel({
    required this.character,
    required this.romanization,
    required this.japanese,
    required this.description,
    required this.type,
  });

  /// 韓国語文字
  final String character;

  /// ローマ字表記
  final String romanization;

  /// 日本語発音ガイド
  final String japanese;

  /// 発音の説明
  final String description;

  /// 母音の種類
  final VowelType type;
}

/// ハングルデータセット
class HangulData {
  HangulData._();

  /// 平音（基本子音）- 9文字
  static const List<HangulConsonant> plainConsonants = [
    HangulConsonant(
      character: 'ㄱ',
      romanization: 'g / k',
      japanese: 'カ行',
      description: '語頭では「カ」に近く、語中では「ガ」に近い音。語末では「ク」。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㄴ',
      romanization: 'n',
      japanese: 'ナ行',
      description: '日本語の「ナ行」とほぼ同じ音。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㄷ',
      romanization: 'd / t',
      japanese: 'タ行',
      description: '語頭では「タ」に近く、語中では「ダ」に近い音。語末では「ッ」。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㄹ',
      romanization: 'r / l',
      japanese: 'ラ行',
      description: '語頭・語中では「ラ行」、語末では「ル」に近い音。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㅁ',
      romanization: 'm',
      japanese: 'マ行',
      description: '日本語の「マ行」とほぼ同じ音。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㅂ',
      romanization: 'b / p',
      japanese: 'パ行',
      description: '語頭では「パ」に近く、語中では「バ」に近い音。語末では「プ」。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㅅ',
      romanization: 's',
      japanese: 'サ行',
      description: '日本語の「サ行」に近い音。「シ」は「シ」ではなく「スィ」に近い。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㅇ',
      romanization: '- / ng',
      japanese: '無音/ン',
      description: '語頭では無音（母音のみ）、語末では「ン」の音。',
      type: ConsonantType.plain,
    ),
    HangulConsonant(
      character: 'ㅈ',
      romanization: 'j',
      japanese: 'チャ行',
      description: '語頭では「チャ」に近く、語中では「ジャ」に近い音。',
      type: ConsonantType.plain,
    ),
  ];

  /// 激音 - 5文字
  static const List<HangulConsonant> aspiratedConsonants = [
    HangulConsonant(
      character: 'ㅊ',
      romanization: 'ch',
      japanese: 'チャ',
      description: '息を強く出す「チャ」の音。',
      type: ConsonantType.aspirated,
    ),
    HangulConsonant(
      character: 'ㅋ',
      romanization: 'k',
      japanese: 'カ',
      description: '息を強く出す「カ」の音。',
      type: ConsonantType.aspirated,
    ),
    HangulConsonant(
      character: 'ㅌ',
      romanization: 't',
      japanese: 'タ',
      description: '息を強く出す「タ」の音。',
      type: ConsonantType.aspirated,
    ),
    HangulConsonant(
      character: 'ㅍ',
      romanization: 'p',
      japanese: 'パ',
      description: '息を強く出す「パ」の音。',
      type: ConsonantType.aspirated,
    ),
    HangulConsonant(
      character: 'ㅎ',
      romanization: 'h',
      japanese: 'ハ行',
      description: '日本語の「ハ行」とほぼ同じ音。',
      type: ConsonantType.aspirated,
    ),
  ];

  /// 濃音（双子音）- 5文字
  static const List<HangulConsonant> tenseConsonants = [
    HangulConsonant(
      character: 'ㄲ',
      romanization: 'kk',
      japanese: 'ッカ',
      description: '詰まった「カ」の音。「っか」のように発音。',
      type: ConsonantType.tense,
    ),
    HangulConsonant(
      character: 'ㄸ',
      romanization: 'tt',
      japanese: 'ッタ',
      description: '詰まった「タ」の音。「った」のように発音。',
      type: ConsonantType.tense,
    ),
    HangulConsonant(
      character: 'ㅃ',
      romanization: 'pp',
      japanese: 'ッパ',
      description: '詰まった「パ」の音。「っぱ」のように発音。',
      type: ConsonantType.tense,
    ),
    HangulConsonant(
      character: 'ㅆ',
      romanization: 'ss',
      japanese: 'ッサ',
      description: '詰まった「サ」の音。「っさ」のように発音。',
      type: ConsonantType.tense,
    ),
    HangulConsonant(
      character: 'ㅉ',
      romanization: 'jj',
      japanese: 'ッチャ',
      description: '詰まった「チャ」の音。「っちゃ」のように発音。',
      type: ConsonantType.tense,
    ),
  ];

  /// 全ての子音
  static List<HangulConsonant> get allConsonants => [
        ...plainConsonants,
        ...aspiratedConsonants,
        ...tenseConsonants,
      ];

  /// 基本母音 - 10文字
  static const List<HangulVowel> basicVowels = [
    HangulVowel(
      character: 'ㅏ',
      romanization: 'a',
      japanese: 'ア',
      description: '日本語の「ア」とほぼ同じ音。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅑ',
      romanization: 'ya',
      japanese: 'ヤ',
      description: '日本語の「ヤ」とほぼ同じ音。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅓ',
      romanization: 'eo',
      japanese: 'オ',
      description: '口を大きく開けた「オ」。日本語の「オ」より口を縦に開く。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅕ',
      romanization: 'yeo',
      japanese: 'ヨ',
      description: '「ㅓ」に「ヤ」を付けた音。口を大きく開けた「ヨ」。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅗ',
      romanization: 'o',
      japanese: 'オ',
      description: '唇を丸めた「オ」。日本語の「オ」より唇を突き出す。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅛ',
      romanization: 'yo',
      japanese: 'ヨ',
      description: '「ㅗ」に「ヤ」を付けた音。唇を丸めた「ヨ」。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅜ',
      romanization: 'u',
      japanese: 'ウ',
      description: '唇を丸めた「ウ」。日本語の「ウ」より唇を突き出す。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅠ',
      romanization: 'yu',
      japanese: 'ユ',
      description: '「ㅜ」に「ヤ」を付けた音。唇を丸めた「ユ」。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅡ',
      romanization: 'eu',
      japanese: 'ウ',
      description: '唇を横に引いた「ウ」。口を「イ」の形にして「ウ」と発音。',
      type: VowelType.basic,
    ),
    HangulVowel(
      character: 'ㅣ',
      romanization: 'i',
      japanese: 'イ',
      description: '日本語の「イ」とほぼ同じ音。',
      type: VowelType.basic,
    ),
  ];

  /// 複合母音 - 11文字
  static const List<HangulVowel> compoundVowels = [
    HangulVowel(
      character: 'ㅐ',
      romanization: 'ae',
      japanese: 'エ',
      description: '「ア」と「イ」を合わせた音。現代では「エ」に近い。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅒ',
      romanization: 'yae',
      japanese: 'イェ',
      description: '「ㅐ」に「ヤ」を付けた音。現代では「イェ」に近い。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅔ',
      romanization: 'e',
      japanese: 'エ',
      description: '「エ」と「イ」を合わせた音。現代では「ㅐ」とほぼ同じ。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅖ',
      romanization: 'ye',
      japanese: 'イェ',
      description: '「ㅔ」に「ヤ」を付けた音。現代では「ㅒ」とほぼ同じ。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅘ',
      romanization: 'wa',
      japanese: 'ワ',
      description: '「ㅗ」と「ㅏ」を合わせた音。「ワ」。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅙ',
      romanization: 'wae',
      japanese: 'ウェ',
      description: '「ㅗ」と「ㅐ」を合わせた音。「ウェ」。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅚ',
      romanization: 'oe',
      japanese: 'ウェ',
      description: '「ㅗ」と「ㅣ」を合わせた音。現代では「ウェ」に近い。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅝ',
      romanization: 'wo',
      japanese: 'ウォ',
      description: '「ㅜ」と「ㅓ」を合わせた音。「ウォ」。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅞ',
      romanization: 'we',
      japanese: 'ウェ',
      description: '「ㅜ」と「ㅔ」を合わせた音。「ウェ」。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅟ',
      romanization: 'wi',
      japanese: 'ウィ',
      description: '「ㅜ」と「ㅣ」を合わせた音。「ウィ」。',
      type: VowelType.compound,
    ),
    HangulVowel(
      character: 'ㅢ',
      romanization: 'ui',
      japanese: 'ウィ',
      description: '「ㅡ」と「ㅣ」を合わせた音。「ウィ」または「イ」。',
      type: VowelType.compound,
    ),
  ];

  /// 全ての母音
  static List<HangulVowel> get allVowels => [
        ...basicVowels,
        ...compoundVowels,
      ];
}
