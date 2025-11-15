import '../../../lessons/data/models/lesson_models.dart';

class TypingSessionState {
  const TypingSessionState({
    required this.lessonId,
    required this.lesson,
    this.currentSectionIndex = 0,
    this.currentItemIndex = 0,
    this.inputBuffer = '',
    this.records = const [],
    this.jamoState = JamoState.empty,
    this.elapsedMs = 0,
    this.isRunning = false,
    this.isCompleted = false,
  });

  final String lessonId;
  final Lesson lesson;
  final int currentSectionIndex;
  final int currentItemIndex;
  final String inputBuffer;
  final List<InputRecord> records;
  final JamoState jamoState;
  final int elapsedMs;
  final bool isRunning;
  final bool isCompleted;

  TypingSessionState copyWith({
    int? currentSectionIndex,
    int? currentItemIndex,
    String? inputBuffer,
    List<InputRecord>? records,
    JamoState? jamoState,
    int? elapsedMs,
    bool? isRunning,
    bool? isCompleted,
    Lesson? lesson,
  }) {
    return TypingSessionState(
      lessonId: lessonId,
      lesson: lesson ?? this.lesson,
      currentSectionIndex: currentSectionIndex ?? this.currentSectionIndex,
      currentItemIndex: currentItemIndex ?? this.currentItemIndex,
      inputBuffer: inputBuffer ?? this.inputBuffer,
      records: records ?? this.records,
      jamoState: jamoState ?? this.jamoState,
      elapsedMs: elapsedMs ?? this.elapsedMs,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class JamoState {
  const JamoState({this.initial, this.medial, this.finalConsonant});

  final String? initial;
  final String? medial;
  final String? finalConsonant;

  static const empty = JamoState();

  bool get isEmpty =>
      initial == null && medial == null && finalConsonant == null;
}

class InputRecord {
  const InputRecord({
    required this.key,
    required this.isCorrect,
    required this.timestamp,
    this.expectedChar,
    this.sectionIndex,
    this.itemIndex,
  });

  final String key;
  final bool isCorrect;
  final DateTime timestamp;
  final String? expectedChar;
  final int? sectionIndex;
  final int? itemIndex;
}

class TypingStatsData {
  const TypingStatsData({
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.totalCount = 0,
    this.accuracy = 0,
    this.wpm = 0,
    this.elapsedMs = 0,
  });

  final int correctCount;
  final int incorrectCount;
  final int totalCount;
  final double accuracy;
  final int wpm;
  final int elapsedMs;
}

class PendingCompletion {
  const PendingCompletion({
    required this.id,
    required this.lessonId,
    required this.wpm,
    required this.accuracy,
    required this.timeSpentMs,
    this.device = 'ios',
    this.mode = 'standard',
    required this.createdAt,
    this.mistakeCharacters = const <String, int>{},
  });

  final String id;
  final String lessonId;
  final int wpm;
  final double accuracy;
  final int timeSpentMs;
  final String device;
  final String mode;
  final DateTime createdAt;
  final Map<String, int> mistakeCharacters;

  factory PendingCompletion.fromJson(Map<String, dynamic> json) {
    return PendingCompletion(
      id: json['id'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      wpm: json['wpm'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0,
      timeSpentMs: json['timeSpentMs'] as int? ?? 0,
      device: json['device'] as String? ?? 'ios',
      mode: json['mode'] as String? ?? 'standard',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      mistakeCharacters: (json['mistakeCharacters'] as Map<String, dynamic>? ??
              const {})
          .map(
        (key, value) => MapEntry(
          key,
          value is int ? value : (value as num?)?.toInt() ?? 0,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'wpm': wpm,
      'accuracy': accuracy,
      'timeSpentMs': timeSpentMs,
      'device': device,
      'mode': mode,
      'createdAt': createdAt.toIso8601String(),
      'mistakeCharacters': mistakeCharacters,
    };
  }
}
