import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chaletta/features/ranking_game/data/models/ranking_game_models.dart';
import 'package:chaletta/features/ranking_game/domain/providers/ranking_providers.dart';
import 'package:chaletta/features/ranking_game/presentation/widgets/pixel_character_widget.dart';

/// ランキング画面
class RankingLeaderboardScreen extends ConsumerStatefulWidget {
  const RankingLeaderboardScreen({
    super.key,
    this.initialDifficulty = 'all',
  });

  final String initialDifficulty;

  @override
  ConsumerState<RankingLeaderboardScreen> createState() =>
      _RankingLeaderboardScreenState();
}

class _RankingLeaderboardScreenState
    extends ConsumerState<RankingLeaderboardScreen>
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
    final rankingAsync = ref.watch(
      rankingDataProvider(
        difficulty: _selectedDifficulty,
        period: _selectedPeriod,
        followingOnly: _followingOnly,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'ランキング',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4CAF50),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: '月間'),
            Tab(text: '週間'),
          ],
        ),
      ),
      body: Column(
        children: [
          // フィルターエリア
          _buildFilterArea(),

          // ランキングリスト
          Expanded(
            child: rankingAsync.when(
              data: (data) => _buildRankingList(data),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ランキングの取得に失敗しました',
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(rankingDataProvider(
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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 難易度フィルター
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
                    selectedColor: const Color(0xFF4CAF50),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // フォロー中フィルター
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
                selectedColor: const Color(0xFF4CAF50).withOpacity(0.3),
                backgroundColor: Colors.white.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: _followingOnly ? Colors.white : Colors.grey[400],
                  fontSize: 12,
                ),
                checkmarkColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList(RankingDataResponse data) {
    if (data.rankings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'まだランキングデータがありません',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ゲームをプレイしてランキングに参加しましょう！',
              style: TextStyle(
                color: Colors.grey[600],
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
              ref.invalidate(rankingDataProvider(
                difficulty: _selectedDifficulty,
                period: _selectedPeriod,
                followingOnly: _followingOnly,
              ));
            },
            color: const Color(0xFF4CAF50),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: data.rankings.length,
              itemBuilder: (context, index) {
                final entry = data.rankings[index];
                return _buildRankingEntry(entry, index);
              },
            ),
          ),
        ),
        // 自分のランキング固定表示
        if (data.myRanking != null) _buildMyRankingRow(data.myRanking!),
      ],
    );
  }

  Widget _buildMyRankingRow(MyRankingInfo myRanking) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.15),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              // 順位
              SizedBox(
                width: 40,
                child: Text(
                  '${myRanking.position}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // キャラクター（サーバーから返されたcharacterLevelを使用）
              SizedBox(
                width: 40,
                height: 40,
                child: PixelCharacterWidget(
                  evolutionLevel: myRanking.characterLevel,
                  pixelSize: 1.25,
                ),
              ),
              const SizedBox(width: 12),

              // ユーザー情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'あなた',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    Text(
                      'Lv.${myRanking.characterLevel}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // スコア
              Text(
                '${myRanking.score}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankingEntry(RankingEntry entry, int index) {
    final rank = index + 1;
    final isTopThree = rank <= 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTopThree
            ? _getRankColor(rank).withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
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
          // 順位
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
                      color: Colors.grey[400],
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // キャラクター（サーバーから返されたcharacterLevelを使用）
          SizedBox(
            width: 40,
            height: 40,
            child: PixelCharacterWidget(
              evolutionLevel: entry.characterLevel,
              pixelSize: 1.25,
            ),
          ),
          const SizedBox(width: 12),

          // ユーザー情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.user.displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '@${entry.user.username}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // スコア
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.score}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isTopThree ? _getRankColor(rank) : Colors.white,
                ),
              ),
              Text(
                'コンボ: ${entry.maxCombo}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
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
