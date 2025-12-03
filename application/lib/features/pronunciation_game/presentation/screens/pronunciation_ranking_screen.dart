import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chaletta/features/pronunciation_game/data/models/pronunciation_game_models.dart';
import 'package:chaletta/features/pronunciation_game/domain/providers/pronunciation_ranking_providers.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';
import 'package:chaletta/ui/widgets/app_page_scaffold.dart';

/// 発音ゲームランキング画面
class PronunciationRankingScreen extends ConsumerStatefulWidget {
  const PronunciationRankingScreen({
    super.key,
    this.initialDifficulty = 'all',
  });

  final String initialDifficulty;

  @override
  ConsumerState<PronunciationRankingScreen> createState() =>
      _PronunciationRankingScreenState();
}

class _PronunciationRankingScreenState
    extends ConsumerState<PronunciationRankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDifficulty = 'all';
  String _selectedPeriod = 'monthly';
  bool _followingOnly = false;

  final List<Map<String, String>> _difficulties = [
    {'value': 'all', 'label': '全て'},
    {'value': 'beginner', 'label': '初級'},
    {'value': 'intermediate', 'label': '中級'},
    {'value': 'advanced', 'label': '高級'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.initialDifficulty;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedPeriod = _tabController.index == 0 ? 'monthly' : 'weekly';
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final rankingAsync = ref.watch(
      pronunciationRankingDataProvider(
        difficulty: _selectedDifficulty,
        period: _selectedPeriod,
        followingOnly: _followingOnly,
      ),
    );

    return AppPageScaffold(
      title: '発音ランキング',
      showBackButton: true,
      childPad: false,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.onSurface,
            unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
            tabs: const [
              Tab(text: '月間'),
              Tab(text: '週間'),
            ],
          ),
          _buildFilterArea(),
          Expanded(
            child: rankingAsync.when(
              data: (data) => _buildRankingList(context, data),
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ランキングの取得に失敗しました',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(pronunciationRankingDataProvider(
                          difficulty: _selectedDifficulty,
                          period: _selectedPeriod,
                          followingOnly: _followingOnly,
                        ));
                      },
                      child: const Text('再試行'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterArea() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _difficulties.map((diff) {
                final isSelected = _selectedDifficulty == diff['value'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(diff['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDifficulty = diff['value']!;
                        });
                      }
                    },
                    selectedColor: colorScheme.primary,
                    backgroundColor: colorScheme.surface,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilterChip(
                label: const Text('フォロー中のみ'),
                selected: _followingOnly,
                onSelected: (selected) {
                  setState(() {
                    _followingOnly = selected;
                  });
                },
                selectedColor: colorScheme.primary.withOpacity(0.3),
                backgroundColor: colorScheme.surface,
                labelStyle: TextStyle(
                  color: _followingOnly
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
                checkmarkColor: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList(
      BuildContext context, PronunciationRankingDataResponse data) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (data.rankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'まだランキングデータがありません',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '発音ゲームをプレイしてランキングに参加しましょう！',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(pronunciationRankingDataProvider(
                difficulty: _selectedDifficulty,
                period: _selectedPeriod,
                followingOnly: _followingOnly,
              ));
            },
            color: colorScheme.primary,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: data.rankings.length,
              itemBuilder: (context, index) {
                final entry = data.rankings[index];
                return _buildRankingEntry(context, entry, index);
              },
            ),
          ),
        ),
        if (data.myRanking != null)
          _buildMyRankingRow(context, data.myRanking!),
      ],
    );
  }

  Widget _buildMyRankingRow(
      BuildContext context, MyPronunciationRankingInfo myRanking) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.15),
        border: Border(
          top: BorderSide(
            color: colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '${myRanking.position}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 40,
                height: 40,
                child: PixelCharacterWidget(
                  evolutionLevel: myRanking.characterLevel,
                  pixelSize: 1.25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'あなた',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Lv.${myRanking.characterLevel}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${myRanking.score}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingEntry(
      BuildContext context, PronunciationRankingEntry entry, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rank = index + 1;
    final isTopThree = rank <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTopThree
            ? _getRankColor(rank).withOpacity(0.1)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isTopThree
            ? Border.all(
                color: _getRankColor(rank).withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: isTopThree
                ? _buildRankBadge(rank)
                : Text(
                    '$rank',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            height: 40,
            child: PixelCharacterWidget(
              evolutionLevel: entry.characterLevel,
              pixelSize: 1.25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.user.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '@${entry.user.username}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.score}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      isTopThree ? _getRankColor(rank) : colorScheme.onSurface,
                ),
              ),
              Text(
                'コンボ: ${entry.maxCombo}',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    IconData icon;
    Color color;

    switch (rank) {
      case 1:
        icon = Icons.emoji_events;
        color = const Color(0xFFFFD700);
        break;
      case 2:
        icon = Icons.emoji_events;
        color = const Color(0xFFC0C0C0);
        break;
      case 3:
        icon = Icons.emoji_events;
        color = const Color(0xFFCD7F32);
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 28);
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.grey;
    }
  }
}
