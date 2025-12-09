import 'dart:math';

/// 韓国語の紛らわしい文字を生成するサービス
class ConfusingCharService {
  ConfusingCharService();

  final _random = Random();

  // ハングルUnicode範囲
  static const int _hangulBase = 0xAC00;
  static const int _hangulEnd = 0xD7A3;
  static const int _initialCount = 19; // 初声の数
  static const int _medialCount = 21; // 中声の数
  static const int _finalCount = 28; // 終声の数（パッチムなし含む）

  // 初声リスト（Unicode順）
  static const _initials = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', //
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  // 中声リスト（Unicode順）
  static const _medials = [
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', //
    'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
  ];

  // 終声リスト（Unicode順、0番目は終声なし）
  static const _finals = [
    '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', //
    'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  // 初声の類似グループ（発音が似ている子音）
  static const Map<int, List<int>> _similarInitials = {
    0: [15, 1], // ㄱ → ㅋ, ㄲ
    1: [0, 15], // ㄲ → ㄱ, ㅋ
    3: [16, 4], // ㄷ → ㅌ, ㄸ
    4: [3, 16], // ㄸ → ㄷ, ㅌ
    7: [17, 8], // ㅂ → ㅍ, ㅃ
    8: [7, 17], // ㅃ → ㅂ, ㅍ
    9: [10], // ㅅ → ㅆ
    10: [9], // ㅆ → ㅅ
    12: [14, 13], // ㅈ → ㅊ, ㅉ
    13: [12, 14], // ㅉ → ㅈ, ㅊ
    14: [12, 13], // ㅊ → ㅈ, ㅉ
    15: [0, 1], // ㅋ → ㄱ, ㄲ
    16: [3, 4], // ㅌ → ㄷ, ㄸ
    17: [7, 8], // ㅍ → ㅂ, ㅃ
  };

  // 中声の類似グループ（発音が似ている母音）
  // 저/조、어/오などの紛らわしいペアを含む
  static const Map<int, List<int>> _similarMedials = {
    0: [1, 2], // ㅏ → ㅐ, ㅑ
    1: [0, 5], // ㅐ → ㅏ, ㅔ
    2: [0, 3], // ㅑ → ㅏ, ㅒ
    3: [2, 7], // ㅒ → ㅑ, ㅖ
    4: [5, 8], // ㅓ → ㅔ, ㅗ (어/오を紛らわしくする)
    5: [4, 1], // ㅔ → ㅓ, ㅐ
    6: [4, 8], // ㅕ → ㅓ, ㅗ (여/요を紛らわしくする)
    7: [6, 3], // ㅖ → ㅕ, ㅒ
    8: [4, 6], // ㅗ → ㅓ, ㅕ (오/어、오/여を紛らわしくする)
    12: [8, 17], // ㅛ → ㅗ, ㅠ
    13: [8, 17], // ㅜ → ㅗ, ㅠ
    17: [13, 12], // ㅠ → ㅜ, ㅛ
    18: [20, 13], // ㅡ → ㅣ, ㅜ
    20: [18, 19], // ㅣ → ㅡ, ㅢ
  };

  /// ハングル文字を初声・中声・終声のインデックスに分解
  (int initial, int medial, int final_)? decompose(String char) {
    if (char.isEmpty) return null;
    final code = char.codeUnitAt(0);
    if (code < _hangulBase || code > _hangulEnd) return null;

    final offset = code - _hangulBase;
    final initialIndex = offset ~/ (_medialCount * _finalCount);
    final medialIndex = (offset % (_medialCount * _finalCount)) ~/ _finalCount;
    final finalIndex = offset % _finalCount;

    return (initialIndex, medialIndex, finalIndex);
  }

  /// 初声・中声・終声のインデックスからハングル文字を合成
  String compose(int initial, int medial, int final_) {
    if (initial < 0 ||
        initial >= _initialCount ||
        medial < 0 ||
        medial >= _medialCount ||
        final_ < 0 ||
        final_ >= _finalCount) {
      return '';
    }

    final code = _hangulBase +
        (initial * _medialCount * _finalCount) +
        (medial * _finalCount) +
        final_;
    return String.fromCharCode(code);
  }

  /// 正解文字に対して紛らわしい選択肢を生成
  /// [correctChar] 正解の文字
  /// [count] 生成する選択肢の総数（正解含む）
  List<String> generateChoices(String correctChar, {int count = 8}) {
    final decomposed = decompose(correctChar);
    if (decomposed == null) {
      // 分解できない場合はランダムな文字を返す
      return _generateRandomChoices(correctChar, count);
    }

    final (initial, medial, final_) = decomposed;
    final choices = <String>{correctChar};

    // 1. 類似初声で生成（2つ）
    final similarInitialIndices = _similarInitials[initial] ?? [];
    for (final simInitial in similarInitialIndices) {
      if (choices.length >= count) break;
      final char = compose(simInitial, medial, final_);
      if (char.isNotEmpty) choices.add(char);
    }

    // 2. 類似中声で生成（2つ）
    final similarMedialIndices = _similarMedials[medial] ?? [];
    for (final simMedial in similarMedialIndices) {
      if (choices.length >= count) break;
      final char = compose(initial, simMedial, final_);
      if (char.isNotEmpty) choices.add(char);
    }

    // 3. 近い初声で生成
    for (var offset = 1; offset <= 3 && choices.length < count; offset++) {
      if (initial + offset < _initialCount) {
        final char = compose(initial + offset, medial, final_);
        if (char.isNotEmpty && char != correctChar) choices.add(char);
      }
      if (initial - offset >= 0 && choices.length < count) {
        final char = compose(initial - offset, medial, final_);
        if (char.isNotEmpty && char != correctChar) choices.add(char);
      }
    }

    // 4. 近い中声で生成
    for (var offset = 1; offset <= 3 && choices.length < count; offset++) {
      if (medial + offset < _medialCount) {
        final char = compose(initial, medial + offset, final_);
        if (char.isNotEmpty && char != correctChar) choices.add(char);
      }
      if (medial - offset >= 0 && choices.length < count) {
        final char = compose(initial, medial - offset, final_);
        if (char.isNotEmpty && char != correctChar) choices.add(char);
      }
    }

    // 5. それでも足りない場合はランダム
    while (choices.length < count) {
      final randInitial = _random.nextInt(_initialCount);
      final randMedial = _random.nextInt(_medialCount);
      final char = compose(randInitial, randMedial, final_);
      if (char.isNotEmpty && char != correctChar) {
        choices.add(char);
      }
    }

    final choiceList = choices.toList();
    choiceList.shuffle(_random);
    return choiceList;
  }

  /// ランダムな選択肢を生成（フォールバック用）
  List<String> _generateRandomChoices(String correctChar, int count) {
    final choices = <String>{correctChar};

    while (choices.length < count) {
      final randInitial = _random.nextInt(_initialCount);
      final randMedial = _random.nextInt(_medialCount);
      final randFinal = _random.nextInt(_finalCount);
      final char = compose(randInitial, randMedial, randFinal);
      if (char.isNotEmpty) {
        choices.add(char);
      }
    }

    final choiceList = choices.toList();
    choiceList.shuffle(_random);
    return choiceList;
  }
}
