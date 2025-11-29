import 'package:flutter/material.dart';

/// ユーザータイプに応じた認証バッジを表示するウィジェット
///
/// - PREMIUM: 青いチェックマークバッジ
/// - OFFICIAL: 金色のチェックマークバッジ
/// - NORMAL: バッジなし（空のSizedBox）
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({
    super.key,
    required this.userType,
    this.size = VerifiedBadgeSize.medium,
  });

  /// ユーザータイプ（'NORMAL', 'PREMIUM', 'OFFICIAL'）
  final String userType;

  /// バッジのサイズ
  final VerifiedBadgeSize size;

  /// ユーザータイプがバッジ表示対象かどうかを判定
  static bool shouldShowBadge(String? userType) {
    if (userType == null) return false;
    final normalized = userType.toUpperCase();
    return normalized == 'PREMIUM' || normalized == 'OFFICIAL';
  }

  @override
  Widget build(BuildContext context) {
    final normalized = userType.toUpperCase();

    if (normalized != 'PREMIUM' && normalized != 'OFFICIAL') {
      return const SizedBox.shrink();
    }

    final isOfficial = normalized == 'OFFICIAL';
    final iconSize = size.iconSize;
    final containerSize = size.containerSize;

    // OFFICIAL は金色、PREMIUM は青色
    final badgeColor = isOfficial
        ? const Color(0xFFFFD700) // ゴールド
        : Colors.blue;

    final backgroundColor = isOfficial
        ? const Color(0xFFFFF8DC) // コーンシルク（薄い金色）
        : Colors.blue.shade50;

    return Tooltip(
      message: isOfficial ? '公式アカウント' : 'Proメンバー',
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.verified,
          size: iconSize,
          color: badgeColor,
        ),
      ),
    );
  }
}

/// バッジのサイズ設定
enum VerifiedBadgeSize {
  /// 小さいサイズ（リスト内やコンパクトな表示用）
  small(iconSize: 14, containerSize: 16),

  /// 中サイズ（投稿カード等の通常表示用）
  medium(iconSize: 18, containerSize: 20),

  /// 大きいサイズ（プロフィール画面用）
  large(iconSize: 24, containerSize: 28);

  const VerifiedBadgeSize({
    required this.iconSize,
    required this.containerSize,
  });

  final double iconSize;
  final double containerSize;
}

/// ユーザー名とバッジを横並びで表示するヘルパーウィジェット
class UserNameWithBadge extends StatelessWidget {
  const UserNameWithBadge({
    super.key,
    required this.displayName,
    required this.userType,
    this.style,
    this.badgeSize = VerifiedBadgeSize.medium,
    this.spacing = 4,
  });

  final String displayName;
  final String userType;
  final TextStyle? style;
  final VerifiedBadgeSize badgeSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            displayName,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (VerifiedBadge.shouldShowBadge(userType)) ...[
          SizedBox(width: spacing),
          VerifiedBadge(userType: userType, size: badgeSize),
        ],
      ],
    );
  }
}
