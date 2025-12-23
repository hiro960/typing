import 'package:chaletta/core/constants/hangul_data.dart';
import 'package:chaletta/features/wordbook/domain/providers/wordbook_providers.dart';
import 'package:chaletta/ui/app_spacing.dart';
import 'package:chaletta/ui/app_theme.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// カナダラ表画面
///
/// 韓国語の子音・母音を一覧で表示し、初心者が参照しやすいUIを提供します。
class KanadaRaScreen extends StatefulWidget {
  const KanadaRaScreen({super.key});

  @override
  State<KanadaRaScreen> createState() => _KanadaRaScreenState();
}

class _KanadaRaScreenState extends State<KanadaRaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'カナダラ表',
      showBackButton: true,
      safeBottom: true,
      child: Column(
        children: [
          _TabSelector(
            controller: _tabController,
            onTabChanged: (index) {
              _tabController.animateTo(index);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _ConsonantTabContent(),
                _VowelTabContent(),
                _PanjeolTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// タブセレクター（子音/母音/反切表の切り替え）
class _TabSelector extends StatelessWidget {
  const _TabSelector({
    required this.controller,
    required this.onTabChanged,
  });

  final TabController controller;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Row(
              children: [
                _buildTab(context, 0, '子音', Iconsax.text),
                _buildTab(context, 1, '母音', Iconsax.record),
                _buildTab(context, 2, '反切表', Iconsax.grid_1),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    int index,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = controller.index == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 子音タブのコンテンツ
class _ConsonantTabContent extends StatelessWidget {
  const _ConsonantTabContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            context,
            title: '基本子音（平音）',
            subtitle: '語頭と語中で音が変わる音',
            items: HangulData.plainConsonants,
            accentColor: AppColors.primaryBright,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildSection(
            context,
            title: '激音',
            subtitle: '息を強く出す音',
            items: HangulData.aspiratedConsonants,
            accentColor: AppColors.secondary,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildSection(
            context,
            title: '濃音（双子音）',
            subtitle: '詰まった音',
            items: HangulData.tenseConsonants,
            accentColor: AppColors.accentEnd,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<HangulConsonant> items,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((item) => _ConsonantCell(
                    item: item,
                    accentColor: accentColor,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

/// 子音セル
class _ConsonantCell extends ConsumerWidget {
  const _ConsonantCell({
    required this.item,
    required this.accentColor,
  });

  final HangulConsonant item;
  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 64,
      child: InkWell(
        onTap: () => _showDetail(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.character,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.romanization,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                item.japanese,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.character,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Iconsax.volume_high, size: 32),
                    onPressed: () {
                      ref
                          .read(wordAudioServiceProvider.notifier)
                          .speakKorean(item.pronounceable);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: accentColor.withValues(alpha: 0.2),
                      foregroundColor: accentColor,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Iconsax.text,
              label: 'ローマ字',
              value: item.romanization,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Iconsax.translate,
              label: '日本語',
              value: item.japanese,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.lamp_charge,
                    size: 20,
                    color: accentColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 母音タブのコンテンツ
class _VowelTabContent extends StatelessWidget {
  const _VowelTabContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            context,
            title: '基本母音',
            subtitle: '10個の基本的な母音',
            items: HangulData.basicVowels,
            accentColor: AppColors.primaryBright,
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildSection(
            context,
            title: '複合母音',
            subtitle: '基本母音を組み合わせた音',
            items: HangulData.compoundVowels,
            accentColor: AppColors.secondary,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<HangulVowel> items,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((item) => _VowelCell(
                    item: item,
                    accentColor: accentColor,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

/// 母音セル
class _VowelCell extends ConsumerWidget {
  const _VowelCell({
    required this.item,
    required this.accentColor,
  });

  final HangulVowel item;
  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 64,
      child: InkWell(
        onTap: () => _showDetail(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.character,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.romanization,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                item.japanese,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.character,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Iconsax.volume_high, size: 32),
                    onPressed: () {
                      ref
                          .read(wordAudioServiceProvider.notifier)
                          .speakKorean(item.pronounceable);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: accentColor.withValues(alpha: 0.2),
                      foregroundColor: accentColor,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              icon: Iconsax.text,
              label: 'ローマ字',
              value: item.romanization,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Iconsax.translate,
              label: '日本語',
              value: item.japanese,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.lamp_charge,
                    size: 20,
                    color: accentColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 反切表タブのコンテンツ
///
/// 子音と母音の組み合わせをテーブル形式で表示します。
class _PanjeolTabContent extends ConsumerWidget {
  const _PanjeolTabContent();

  // 初声（子音）のインデックス（Unicode計算用）
  static const Map<String, int> _choseongIndex = {
    'ㄱ': 0, 'ㄲ': 1, 'ㄴ': 2, 'ㄷ': 3, 'ㄸ': 4,
    'ㄹ': 5, 'ㅁ': 6, 'ㅂ': 7, 'ㅃ': 8, 'ㅅ': 9,
    'ㅆ': 10, 'ㅇ': 11, 'ㅈ': 12, 'ㅉ': 13, 'ㅊ': 14,
    'ㅋ': 15, 'ㅌ': 16, 'ㅍ': 17, 'ㅎ': 18,
  };

  // 中声（母音）のインデックス（Unicode計算用）
  static const Map<String, int> _jungseongIndex = {
    'ㅏ': 0, 'ㅐ': 1, 'ㅑ': 2, 'ㅒ': 3, 'ㅓ': 4,
    'ㅔ': 5, 'ㅕ': 6, 'ㅖ': 7, 'ㅗ': 8, 'ㅘ': 9,
    'ㅙ': 10, 'ㅚ': 11, 'ㅛ': 12, 'ㅜ': 13, 'ㅝ': 14,
    'ㅞ': 15, 'ㅟ': 16, 'ㅠ': 17, 'ㅡ': 18, 'ㅢ': 19, 'ㅣ': 20,
  };

  // 子音のカタカナ読み
  static const Map<String, String> _consonantKatakana = {
    'ㄱ': 'カ', 'ㄲ': 'ッカ', 'ㄴ': 'ナ', 'ㄷ': 'タ', 'ㄸ': 'ッタ',
    'ㄹ': 'ラ', 'ㅁ': 'マ', 'ㅂ': 'パ', 'ㅃ': 'ッパ', 'ㅅ': 'サ',
    'ㅆ': 'ッサ', 'ㅇ': '', 'ㅈ': 'チャ', 'ㅉ': 'ッチャ', 'ㅊ': 'チャ',
    'ㅋ': 'カ', 'ㅌ': 'タ', 'ㅍ': 'パ', 'ㅎ': 'ハ',
  };

  // 母音のカタカナ読み
  static const Map<String, String> _vowelKatakana = {
    'ㅏ': 'ア', 'ㅑ': 'ヤ', 'ㅓ': 'オ', 'ㅕ': 'ヨ', 'ㅗ': 'オ',
    'ㅛ': 'ヨ', 'ㅜ': 'ウ', 'ㅠ': 'ユ', 'ㅡ': 'ウ', 'ㅣ': 'イ',
  };

  // 子音+母音の組み合わせカタカナ（特殊ケース対応）
  static const Map<String, Map<String, String>> _syllableKatakana = {
    'ㄱ': {'ㅏ': 'カ', 'ㅑ': 'キャ', 'ㅓ': 'コ', 'ㅕ': 'キョ', 'ㅗ': 'コ', 'ㅛ': 'キョ', 'ㅜ': 'ク', 'ㅠ': 'キュ', 'ㅡ': 'ク', 'ㅣ': 'キ'},
    'ㄲ': {'ㅏ': 'ッカ', 'ㅑ': 'ッキャ', 'ㅓ': 'ッコ', 'ㅕ': 'ッキョ', 'ㅗ': 'ッコ', 'ㅛ': 'ッキョ', 'ㅜ': 'ック', 'ㅠ': 'ッキュ', 'ㅡ': 'ック', 'ㅣ': 'ッキ'},
    'ㄴ': {'ㅏ': 'ナ', 'ㅑ': 'ニャ', 'ㅓ': 'ノ', 'ㅕ': 'ニョ', 'ㅗ': 'ノ', 'ㅛ': 'ニョ', 'ㅜ': 'ヌ', 'ㅠ': 'ニュ', 'ㅡ': 'ヌ', 'ㅣ': 'ニ'},
    'ㄷ': {'ㅏ': 'タ', 'ㅑ': 'ティャ', 'ㅓ': 'ト', 'ㅕ': 'ティョ', 'ㅗ': 'ト', 'ㅛ': 'ティョ', 'ㅜ': 'トゥ', 'ㅠ': 'テュ', 'ㅡ': 'トゥ', 'ㅣ': 'ティ'},
    'ㄸ': {'ㅏ': 'ッタ', 'ㅑ': 'ッティャ', 'ㅓ': 'ット', 'ㅕ': 'ッティョ', 'ㅗ': 'ット', 'ㅛ': 'ッティョ', 'ㅜ': 'ットゥ', 'ㅠ': 'ッテュ', 'ㅡ': 'ットゥ', 'ㅣ': 'ッティ'},
    'ㄹ': {'ㅏ': 'ラ', 'ㅑ': 'リャ', 'ㅓ': 'ロ', 'ㅕ': 'リョ', 'ㅗ': 'ロ', 'ㅛ': 'リョ', 'ㅜ': 'ル', 'ㅠ': 'リュ', 'ㅡ': 'ル', 'ㅣ': 'リ'},
    'ㅁ': {'ㅏ': 'マ', 'ㅑ': 'ミャ', 'ㅓ': 'モ', 'ㅕ': 'ミョ', 'ㅗ': 'モ', 'ㅛ': 'ミョ', 'ㅜ': 'ム', 'ㅠ': 'ミュ', 'ㅡ': 'ム', 'ㅣ': 'ミ'},
    'ㅂ': {'ㅏ': 'パ', 'ㅑ': 'ピャ', 'ㅓ': 'ポ', 'ㅕ': 'ピョ', 'ㅗ': 'ポ', 'ㅛ': 'ピョ', 'ㅜ': 'プ', 'ㅠ': 'ピュ', 'ㅡ': 'プ', 'ㅣ': 'ピ'},
    'ㅃ': {'ㅏ': 'ッパ', 'ㅑ': 'ッピャ', 'ㅓ': 'ッポ', 'ㅕ': 'ッピョ', 'ㅗ': 'ッポ', 'ㅛ': 'ッピョ', 'ㅜ': 'ップ', 'ㅠ': 'ッピュ', 'ㅡ': 'ップ', 'ㅣ': 'ッピ'},
    'ㅅ': {'ㅏ': 'サ', 'ㅑ': 'シャ', 'ㅓ': 'ソ', 'ㅕ': 'ショ', 'ㅗ': 'ソ', 'ㅛ': 'ショ', 'ㅜ': 'ス', 'ㅠ': 'シュ', 'ㅡ': 'ス', 'ㅣ': 'シ'},
    'ㅆ': {'ㅏ': 'ッサ', 'ㅑ': 'ッシャ', 'ㅓ': 'ッソ', 'ㅕ': 'ッショ', 'ㅗ': 'ッソ', 'ㅛ': 'ッショ', 'ㅜ': 'ッス', 'ㅠ': 'ッシュ', 'ㅡ': 'ッス', 'ㅣ': 'ッシ'},
    'ㅇ': {'ㅏ': 'ア', 'ㅑ': 'ヤ', 'ㅓ': 'オ', 'ㅕ': 'ヨ', 'ㅗ': 'オ', 'ㅛ': 'ヨ', 'ㅜ': 'ウ', 'ㅠ': 'ユ', 'ㅡ': 'ウ', 'ㅣ': 'イ'},
    'ㅈ': {'ㅏ': 'チャ', 'ㅑ': 'チャ', 'ㅓ': 'チョ', 'ㅕ': 'チョ', 'ㅗ': 'チョ', 'ㅛ': 'チョ', 'ㅜ': 'チュ', 'ㅠ': 'チュ', 'ㅡ': 'チュ', 'ㅣ': 'チ'},
    'ㅉ': {'ㅏ': 'ッチャ', 'ㅑ': 'ッチャ', 'ㅓ': 'ッチョ', 'ㅕ': 'ッチョ', 'ㅗ': 'ッチョ', 'ㅛ': 'ッチョ', 'ㅜ': 'ッチュ', 'ㅠ': 'ッチュ', 'ㅡ': 'ッチュ', 'ㅣ': 'ッチ'},
    'ㅊ': {'ㅏ': 'チャ', 'ㅑ': 'チャ', 'ㅓ': 'チョ', 'ㅕ': 'チョ', 'ㅗ': 'チョ', 'ㅛ': 'チョ', 'ㅜ': 'チュ', 'ㅠ': 'チュ', 'ㅡ': 'チュ', 'ㅣ': 'チ'},
    'ㅋ': {'ㅏ': 'カ', 'ㅑ': 'キャ', 'ㅓ': 'コ', 'ㅕ': 'キョ', 'ㅗ': 'コ', 'ㅛ': 'キョ', 'ㅜ': 'ク', 'ㅠ': 'キュ', 'ㅡ': 'ク', 'ㅣ': 'キ'},
    'ㅌ': {'ㅏ': 'タ', 'ㅑ': 'ティャ', 'ㅓ': 'ト', 'ㅕ': 'ティョ', 'ㅗ': 'ト', 'ㅛ': 'ティョ', 'ㅜ': 'トゥ', 'ㅠ': 'テュ', 'ㅡ': 'トゥ', 'ㅣ': 'ティ'},
    'ㅍ': {'ㅏ': 'パ', 'ㅑ': 'ピャ', 'ㅓ': 'ポ', 'ㅕ': 'ピョ', 'ㅗ': 'ポ', 'ㅛ': 'ピョ', 'ㅜ': 'プ', 'ㅠ': 'ピュ', 'ㅡ': 'プ', 'ㅣ': 'ピ'},
    'ㅎ': {'ㅏ': 'ハ', 'ㅑ': 'ヒャ', 'ㅓ': 'ホ', 'ㅕ': 'ヒョ', 'ㅗ': 'ホ', 'ㅛ': 'ヒョ', 'ㅜ': 'フ', 'ㅠ': 'ヒュ', 'ㅡ': 'フ', 'ㅣ': 'ヒ'},
  };

  // 反切表で使用する子音（平音・激音・濃音すべて）
  static const List<String> _consonants = [
    // 平音
    'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ',
    // 激音
    'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
    // 濃音
    'ㄲ', 'ㄸ', 'ㅃ', 'ㅆ', 'ㅉ',
  ];

  // 反切表で使用する基本母音
  static const List<String> _vowels = [
    'ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ',
  ];

  /// カタカナ読みを取得
  String _getKatakana(String consonant, String vowel) {
    return _syllableKatakana[consonant]?[vowel] ?? '';
  }

  /// 子音と母音を組み合わせて韓国語文字を生成
  String _combineHangul(String consonant, String vowel) {
    final cho = _choseongIndex[consonant];
    final jung = _jungseongIndex[vowel];
    if (cho == null || jung == null) return '';

    // 韓国語音節 = (初声 * 21 + 中声) * 28 + 終声 + 0xAC00
    // 終声なしの場合は終声 = 0
    final code = (cho * 21 + jung) * 28 + 0xAC00;
    return String.fromCharCode(code);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 説明テキスト
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBright.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  size: 18,
                  color: AppColors.primaryBright,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '子音（縦）と母音（横）を組み合わせた文字一覧です',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // テーブル
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildTable(context, ref),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const cellWidth = 56.0;
    const cellHeight = 64.0;
    const headerCellWidth = 40.0;
    const headerCellHeight = 44.0;

    return Table(
      defaultColumnWidth: const FixedColumnWidth(cellWidth),
      border: TableBorder.all(
        color: theme.colorScheme.outline.withValues(alpha: 0.2),
        width: 1,
      ),
      children: [
        // ヘッダー行（母音）
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
          ),
          children: [
            // 左上の空セル
            SizedBox(
              width: headerCellWidth,
              height: headerCellHeight,
              child: Center(
                child: Text(
                  '',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
            // 母音ヘッダー
            ..._vowels.map((vowel) => SizedBox(
                  width: cellWidth,
                  height: headerCellHeight,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          vowel,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          _vowelKatakana[vowel] ?? '',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.secondary.withValues(alpha: 0.7),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
        // データ行（子音 × 母音）
        ..._consonants.asMap().entries.map((entry) {
          final consonant = entry.value;
          final rowIndex = entry.key;
          final isEvenRow = rowIndex % 2 == 0;
          // 濃音行は別の背景色
          final isTenseRow = rowIndex >= 14;

          return TableRow(
            decoration: BoxDecoration(
              color: isTenseRow
                  ? AppColors.accentEnd.withValues(alpha: 0.05)
                  : isEvenRow
                      ? Colors.transparent
                      : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            children: [
              // 子音ヘッダー
              Container(
                width: headerCellWidth,
                height: cellHeight,
                decoration: BoxDecoration(
                  color: isTenseRow
                      ? AppColors.accentEnd.withValues(alpha: 0.15)
                      : AppColors.primaryBright.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        consonant,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isTenseRow ? AppColors.accentEnd : AppColors.primaryBright,
                        ),
                      ),
                      Text(
                        _consonantKatakana[consonant] ?? '',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: (isTenseRow ? AppColors.accentEnd : AppColors.primaryBright).withValues(alpha: 0.7),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 組み合わせセル
              ..._vowels.map((vowel) {
                final syllable = _combineHangul(consonant, vowel);
                final katakana = _getKatakana(consonant, vowel);
                return InkWell(
                  onTap: () => _showSyllableDetail(context, ref, consonant, vowel, syllable),
                  child: SizedBox(
                    width: cellWidth,
                    height: cellHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          syllable,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          katakana,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }

  void _showSyllableDetail(
    BuildContext context,
    WidgetRef ref,
    String consonant,
    String vowel,
    String syllable,
  ) {
    final theme = Theme.of(context);
    final katakana = _getKatakana(consonant, vowel);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  syllable,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 72,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Iconsax.volume_high, size: 32),
                  onPressed: () {
                    ref
                        .read(wordAudioServiceProvider.notifier)
                        .speakKorean(syllable);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryBright.withValues(alpha: 0.2),
                    foregroundColor: AppColors.primaryBright,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
            Text(
              katakana,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryBright.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    consonant,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryBright,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '+',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Text(
                    vowel,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '=',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  Text(
                    syllable,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '子音「$consonant」と母音「$vowel」を組み合わせた文字',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
