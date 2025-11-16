import 'package:characters/characters.dart';

import '../../data/models/typing_models.dart';

/// カスタムキーボードからのキー入力をハングルの音節に組み立てるコンポーザー
class HangulComposer {
  static const _initials = [
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ',
  ];

  static const _medials = [
    'ㅏ',
    'ㅐ',
    'ㅑ',
    'ㅒ',
    'ㅓ',
    'ㅔ',
    'ㅕ',
    'ㅖ',
    'ㅗ',
    'ㅘ',
    'ㅙ',
    'ㅚ',
    'ㅛ',
    'ㅜ',
    'ㅝ',
    'ㅞ',
    'ㅟ',
    'ㅠ',
    'ㅡ',
    'ㅢ',
    'ㅣ',
  ];

  static const _finals = [
    '',
    'ㄱ',
    'ㄲ',
    'ㄳ',
    'ㄴ',
    'ㄵ',
    'ㄶ',
    'ㄷ',
    'ㄹ',
    'ㄺ',
    'ㄻ',
    'ㄼ',
    'ㄽ',
    'ㄾ',
    'ㄿ',
    'ㅀ',
    'ㅁ',
    'ㅂ',
    'ㅄ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ',
  ];

  static const _consonants = {
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ',
  };

  static const _vowels = {
    'ㅏ',
    'ㅐ',
    'ㅑ',
    'ㅒ',
    'ㅓ',
    'ㅔ',
    'ㅕ',
    'ㅖ',
    'ㅗ',
    'ㅘ',
    'ㅙ',
    'ㅚ',
    'ㅛ',
    'ㅜ',
    'ㅝ',
    'ㅞ',
    'ㅟ',
    'ㅠ',
    'ㅡ',
    'ㅢ',
    'ㅣ',
  };

  static const _medialCombinations = {
    'ㅗ+ㅏ': 'ㅘ',
    'ㅗ+ㅐ': 'ㅙ',
    'ㅗ+ㅣ': 'ㅚ',
    'ㅜ+ㅓ': 'ㅝ',
    'ㅜ+ㅔ': 'ㅞ',
    'ㅜ+ㅣ': 'ㅟ',
    'ㅡ+ㅣ': 'ㅢ',
  };

  static const _medialDecompositions = {
    'ㅘ': ['ㅗ', 'ㅏ'],
    'ㅙ': ['ㅗ', 'ㅐ'],
    'ㅚ': ['ㅗ', 'ㅣ'],
    'ㅝ': ['ㅜ', 'ㅓ'],
    'ㅞ': ['ㅜ', 'ㅔ'],
    'ㅟ': ['ㅜ', 'ㅣ'],
    'ㅢ': ['ㅡ', 'ㅣ'],
  };

  static const _finalCombinations = {
    'ㄱ+ㅅ': 'ㄳ',
    'ㄴ+ㅈ': 'ㄵ',
    'ㄴ+ㅎ': 'ㄶ',
    'ㄹ+ㄱ': 'ㄺ',
    'ㄹ+ㅁ': 'ㄻ',
    'ㄹ+ㅂ': 'ㄼ',
    'ㄹ+ㅅ': 'ㄽ',
    'ㄹ+ㅌ': 'ㄾ',
    'ㄹ+ㅍ': 'ㄿ',
    'ㄹ+ㅎ': 'ㅀ',
    'ㅂ+ㅅ': 'ㅄ',
  };

  static const _finalDecompositions = {
    'ㄳ': ['ㄱ', 'ㅅ'],
    'ㄵ': ['ㄴ', 'ㅈ'],
    'ㄶ': ['ㄴ', 'ㅎ'],
    'ㄺ': ['ㄹ', 'ㄱ'],
    'ㄻ': ['ㄹ', 'ㅁ'],
    'ㄼ': ['ㄹ', 'ㅂ'],
    'ㄽ': ['ㄹ', 'ㅅ'],
    'ㄾ': ['ㄹ', 'ㅌ'],
    'ㄿ': ['ㄹ', 'ㅍ'],
    'ㅀ': ['ㄹ', 'ㅎ'],
    'ㅄ': ['ㅂ', 'ㅅ'],
  };

  final List<String> _committed = [];
  String? _initial;
  String? _medial;
  String? _final;

  void reset() {
    _committed.clear();
    _initial = null;
    _medial = null;
    _final = null;
  }

  void loadFromText(String text) {
    reset();
    if (text.isEmpty) return;
    for (final char in text.characters) {
      _committed.add(char);
    }
  }

  void input(String char) {
    if (char.trim().isEmpty) {
      addSpace();
      return;
    }

    if (_isConsonant(char)) {
      _handleConsonant(char);
      return;
    }

    if (_isVowel(char)) {
      _handleVowel(char);
      return;
    }

    _commitCurrent();
    _committed.add(char);
  }

  void addSpace() {
    _commitCurrent();
    _committed.add(' ');
  }

  void addNewLine() {
    _commitCurrent();
    _committed.add('\n');
  }

  void backspace() {
    if (_final != null) {
      final decomposition = _finalDecompositions[_final!];
      if (decomposition != null) {
        _final = decomposition.first;
      } else {
        _final = null;
      }
      return;
    }

    if (_medial != null) {
      final decomposition = _medialDecompositions[_medial!];
      if (decomposition != null) {
        _medial = decomposition.first;
      } else {
        _medial = null;
      }
      return;
    }

    if (_initial != null) {
      _initial = null;
      return;
    }

    if (_committed.isNotEmpty) {
      _committed.removeLast();
    }
  }

  String consumeText() {
    _commitCurrent();
    final result = _committed.join();
    _committed.clear();
    return result;
  }

  String get text => _committed.join() + _composeCurrent();

  JamoState get jamoState =>
      JamoState(initial: _initial, medial: _medial, finalConsonant: _final);

  bool _isConsonant(String char) => _consonants.contains(char);

  bool _isVowel(String char) => _vowels.contains(char);

  void _handleConsonant(String char) {
    if (_medial == null) {
      if (_initial == null) {
        _initial = char;
      } else {
        _commitCurrent();
        _initial = char;
      }
      return;
    }

    if (_final == null) {
      _final = char;
      return;
    }

    final combination = _finalCombinations['$_final+$char'];
    if (combination != null) {
      _final = combination;
      return;
    }

    _commitCurrent();
    _initial = char;
  }

  void _handleVowel(String char) {
    // 母音のみの場合は自動でㅇを追加しない（標準キーボード動作）
    if (_medial == null) {
      _medial = char;
      return;
    }

    final combination = _medialCombinations['$_medial+$char'];
    if (combination != null) {
      _medial = combination;
      return;
    }

    if (_final != null) {
      final decomposition = _finalDecompositions[_final!];
      if (decomposition != null) {
        _final = decomposition.first;
        final carry = decomposition.last;
        _commitCurrent();
        _initial = carry;
        _medial = char;
        return;
      } else {
        final carry = _final;
        _final = null;
        _commitCurrent();
        _initial = carry;
        _medial = char;
        return;
      }
    }

    _commitCurrent();
    _medial = char;
  }

  void _commitCurrent() {
    final current = _composeCurrent();
    if (current.isNotEmpty) {
      _committed.add(current);
    }
    _initial = null;
    _medial = null;
    _final = null;
  }

  String _composeCurrent() {
    if (_medial == null) {
      return _initial ?? '';
    }

    // 初声がない場合は母音のみを返す（標準キーボード動作）
    if (_initial == null) {
      return _medial! + (_final ?? '');
    }

    final initialIndex = _initials.indexOf(_initial!);
    final medialIndex = _medials.indexOf(_medial!);
    final finalIndex = _final != null ? _finals.indexOf(_final!) : 0;

    if (initialIndex == -1 || medialIndex == -1 || finalIndex == -1) {
      return _initial! + _medial! + (_final ?? '');
    }

    final codePoint =
        0xAC00 + (initialIndex * 21 * 28) + (medialIndex * 28) + finalIndex;
    return String.fromCharCode(codePoint);
  }

  static List<String> decomposeText(String text) {
    final result = <String>[];
    for (final char in text.characters) {
      result.addAll(decomposeSyllable(char));
    }
    return result;
  }

  static List<String> decomposeSyllable(String char) {
    if (char == ' ') {
      return [' '];
    }
    if (char == '\n') {
      return ['\n'];
    }
    final code = char.codeUnitAt(0);
    if (code < 0xAC00 || code > 0xD7A3) {
      return [char];
    }
    final index = code - 0xAC00;
    final initialIndex = index ~/ 588;
    final medialIndex = (index % 588) ~/ 28;
    final finalIndex = index % 28;

    final result = <String>[_initials[initialIndex]];

    // 中声を分解（複合母音を基本字母に分解）
    final medial = _medials[medialIndex];
    final medialDecomp = _medialDecompositions[medial];
    if (medialDecomp != null) {
      result.addAll(medialDecomp);
    } else {
      result.add(medial);
    }

    // 終声を分解（二重パッチムを基本字母に分解）
    if (finalIndex > 0 && finalIndex < _finals.length) {
      final final_ = _finals[finalIndex];
      final finalDecomp = _finalDecompositions[final_];
      if (finalDecomp != null) {
        result.addAll(finalDecomp);
      } else {
        result.add(final_);
      }
    }

    return result;
  }
}
