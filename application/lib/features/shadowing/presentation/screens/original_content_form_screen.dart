import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../ui/app_spacing.dart';
import '../../../../ui/app_theme.dart';
import '../../../translation/data/services/deepl_translation_service.dart';
import '../../data/models/original_content.dart';
import '../../data/models/shadowing_models.dart';
import '../../data/services/tts_generator_service.dart';
import '../../domain/providers/original_content_providers.dart';

/// オリジナル文章作成・編集画面
class OriginalContentFormScreen extends ConsumerStatefulWidget {
  const OriginalContentFormScreen({
    super.key,
    this.content,
  });

  /// 編集時は既存のコンテンツを渡す
  final OriginalContent? content;

  bool get isEditing => content != null;

  @override
  ConsumerState<OriginalContentFormScreen> createState() =>
      _OriginalContentFormScreenState();
}

class _OriginalContentFormScreenState
    extends ConsumerState<OriginalContentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _koreanTextController;

  bool _isSaving = false;
  bool _isGeneratingAudio = false;
  String? _audioPath;
  int _audioDuration = 0;
  List<TextSegment> _segments = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.content?.title ?? '');
    _koreanTextController =
        TextEditingController(text: widget.content?.text ?? '');
    _audioPath = widget.content?.audioPath;
    _audioDuration = widget.content?.durationSeconds ?? 0;
    _segments = widget.content?.segments ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _koreanTextController.dispose();
    super.dispose();
  }

  /// テキストを「.」や「。」で分割してセグメントを作成
  List<String> _splitTextToSegments(String text) {
    // 「.」と「。」の後で分割し、区切り文字を保持する（後読みを使用）
    final segments = text
        .split(RegExp(r'(?<=[.。])'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = FeatureGradients.shadowing.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? '文章を編集' : '新規作成'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // タイトル入力
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                hintText: '例：自己紹介、買い物フレーズ',
                prefixIcon: Icon(Iconsax.text),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'タイトルを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // 韓国語テキスト入力
            TextFormField(
              controller: _koreanTextController,
              decoration: InputDecoration(
                labelText: '韓国語テキスト',
                hintText: '練習したい韓国語の文章を入力してください',
                prefixIcon: const Icon(Iconsax.document_text),
                alignLabelWithHint: true,
                suffixIcon: _koreanTextController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Iconsax.close_circle),
                        onPressed: () {
                          _koreanTextController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              maxLines: 18,
              minLines: 14,
              maxLength: 700,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '韓国語テキストを入力してください';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),

            // セグメント分割の説明
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: isDark ? 0.3 : 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 18,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '「.」で文が区切られ、セグメントとして登録されます。\n日本語訳はDeepLで自動翻訳されます。',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // TTS音声生成セクション
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Iconsax.volume_high,
                        color: accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'TTS音声',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_audioPath != null &&
                          _audioPath!.isNotEmpty &&
                          _segments.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.tick_circle,
                                size: 14,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '生成済み (${_segments.length}セグメント)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '韓国語テキストからネイティブ音声を生成します。',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isGeneratingAudio ||
                              _koreanTextController.text.trim().isEmpty
                          ? null
                          : _generateAudio,
                      icon: _isGeneratingAudio
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Iconsax.microphone),
                      label: Text(
                        _isGeneratingAudio
                            ? '生成中...'
                            : (_audioPath != null && _audioPath!.isNotEmpty
                                ? '音声を再生成'
                                : '音声を生成'),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: accentColor,
                        side: BorderSide(color: accentColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ヒント
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.lamp_charge,
                    size: 18,
                    color: Colors.amber.shade700,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'ヒント：短いフレーズから始めると効果的です。'
                      '20回練習するとマスター達成になります。',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAudio() async {
    final koreanText = _koreanTextController.text.trim();
    if (koreanText.isEmpty) return;

    setState(() => _isGeneratingAudio = true);

    try {
      // 1. テキストをセグメントに分割
      final segmentTexts = _splitTextToSegments(koreanText);
      if (segmentTexts.isEmpty) {
        throw Exception('セグメントが見つかりません。文末に「.」または「。」を入れてください。');
      }

      // 2. 各セグメントを日本語に翻訳
      final deeplService = DeepLTranslationService();
      final meanings = <String>[];
      for (final text in segmentTexts) {
        final meaning = await deeplService.translateKoToJa(text);
        meanings.add(meaning);
      }

      // 3. 初期セグメントを作成（タイムスタンプは仮）
      final initialSegments = <TextSegment>[];
      for (var i = 0; i < segmentTexts.length; i++) {
        initialSegments.add(TextSegment(
          index: i,
          text: segmentTexts[i],
          meaning: meanings[i],
          startTime: 0,
          endTime: 0,
        ));
      }

      // 4. TTS音声を生成してタイムスタンプを取得
      final ttsService = TtsGeneratorService();
      final repository = ref.read(originalContentRepositoryProvider);

      // コンテンツID（新規作成時は一時ID）
      final contentId =
          widget.content?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';
      final audioPath = await repository.generateAudioFilePath(contentId);

      final result = await ttsService.generateAudioWithSegments(
        text: koreanText,
        segments: initialSegments,
        outputPath: audioPath,
      );

      if (mounted) {
        setState(() {
          _audioPath = result.audioPath;
          _audioDuration = result.durationSeconds;
          _segments = result.segments;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('音声を生成しました（${result.segments.length}セグメント）'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('音声生成に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingAudio = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // 音声が生成されていない場合は警告
    if (_segments.isEmpty) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('音声が生成されていません'),
          content: const Text('音声を生成せずに保存しますか？\n後から音声を追加することもできます。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('保存する'),
            ),
          ],
        ),
      );

      if (shouldSave != true) return;
    }

    setState(() => _isSaving = true);

    try {
      final saver = ref.read(originalContentSaverProvider.notifier);
      await saver.save(
        id: widget.content?.id,
        title: _titleController.text.trim(),
        text: _koreanTextController.text.trim(),
        segments: _segments,
        audioPath: _audioPath,
        durationSeconds: _audioDuration,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEditing ? '更新しました' : '作成しました'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
