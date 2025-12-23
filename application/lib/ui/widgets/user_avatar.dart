import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 共通のユーザーアバターコンポーネント
///
/// プロフィール画像URLが存在する場合は画像を表示し、
/// 存在しない場合はdisplayNameの最初の文字（イニシャル）を表示します。
///
/// 安全なイニシャル取得を実装しており、空文字列や絵文字にも対応しています。
class UserAvatar extends StatelessWidget {
  /// ユーザーの表示名（必須）
  ///
  /// イニシャル表示に使用されます。
  final String displayName;

  /// プロフィール画像のURL（オプション）
  ///
  /// nullの場合はイニシャルが表示されます。
  final String? imageUrl;

  /// アバターの半径サイズ
  ///
  /// デフォルトは20.0です。
  final double radius;

  /// 背景色（オプション）
  ///
  /// nullの場合はテーマの`primary`カラーを透明度12%で使用します。
  final Color? backgroundColor;

  /// 前景色（オプション）
  ///
  /// nullの場合はテーマの`primary`カラーを使用します。
  final Color? foregroundColor;

  /// イニシャルのテキストスタイル（オプション）
  ///
  /// nullの場合はデフォルトのスタイルが適用されます。
  final TextStyle? textStyle;

  /// CachedNetworkImageを使用するかどうか
  ///
  /// trueの場合は画像キャッシュが有効になります。
  /// デフォルトはfalseです。
  final bool useCachedImage;

  /// タップ時のコールバック（オプション）
  ///
  /// 指定するとアバターがタップ可能になります。
  final VoidCallback? onTap;

  /// バッジウィジェット（オプション）
  ///
  /// アバターの右下に表示される小さなウィジェット（編集アイコンなど）。
  final Widget? badge;

  /// 影を表示するかどうか
  ///
  /// デフォルトはfalseです。
  final bool showShadow;

  /// ローディングインジケーターを表示するかどうか
  ///
  /// デフォルトはfalseです。
  final bool showLoadingIndicator;

  const UserAvatar({
    super.key,
    required this.displayName,
    this.imageUrl,
    this.radius = 20.0,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.useCachedImage = false,
    this.onTap,
    this.badge,
    this.showShadow = false,
    this.showLoadingIndicator = false,
  });

  /// displayNameから安全にイニシャルを取得します
  ///
  /// 空文字列やマルチバイト文字（絵文字など）にも対応しています。
  String _getInitial() {
    if (displayName.isEmpty) return '?';
    final trimmed = displayName.trim();
    return trimmed.isEmpty ? '?' : trimmed.characters.first;
  }

  /// 画像プロバイダーを取得します
  ImageProvider? _getImageProvider() {
    if (imageUrl == null || imageUrl!.isEmpty) return null;

    if (useCachedImage) {
      return CachedNetworkImageProvider(imageUrl!);
    } else {
      return NetworkImage(imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 背景色と前景色のデフォルト値
    final effectiveBackgroundColor = backgroundColor ??
        theme.colorScheme.primary.withValues(alpha: 0.12);
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.primary;

    Widget avatarWidget = CircleAvatar(
      radius: radius,
      backgroundImage: _getImageProvider(),
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      child: showLoadingIndicator
          ? SizedBox(
              width: radius * 0.6,
              height: radius * 0.6,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  effectiveForegroundColor,
                ),
              ),
            )
          : (imageUrl == null || imageUrl!.isEmpty)
              ? Text(
                  _getInitial(),
                  style: textStyle ??
                      TextStyle(
                        fontSize: radius * 0.6,
                        fontWeight: FontWeight.bold,
                      ),
                )
              : null,
    );

    // バッジがある場合はStackで配置
    if (badge != null) {
      avatarWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: badge!,
          ),
        ],
      );
    }

    // 影がある場合はContainerでラップ
    if (showShadow) {
      avatarWidget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: avatarWidget,
      );
    }

    // タップ可能な場合はGestureDetectorでラップ
    if (onTap != null) {
      avatarWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}
