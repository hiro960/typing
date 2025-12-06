import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Common wrapper around [FScaffold] that applies a consistent SafeArea and FHeader.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    this.titleIcon,
    this.actions,
    this.showBackButton = false,
    this.onBack,
    this.onRefresh,
    this.scaffoldStyle,
    this.headerStyle,
    this.toasterStyle,
    this.childPad = false,
    this.sidebar,
    this.footer,
    this.safeTop = false,
    this.safeBottom = false,
    required this.child,
  });

  /// Page title (required)
  final String title;

  /// Icon displayed before the title (optional)
  final IconData? titleIcon;

  /// Header action buttons (optional)
  /// Accepts any widgets, typically FHeaderAction but can also be FButton, Container, etc.
  final List<Widget>? actions;

  /// Show back button in header (optional)
  final bool showBackButton;

  /// Custom back button callback (optional, defaults to Navigator.maybePop)
  final VoidCallback? onBack;

  /// Pull-to-refresh callback (optional)
  final Future<void> Function()? onRefresh;

  final FScaffoldStyle Function(FScaffoldStyle style)? scaffoldStyle;

  /// Header style customization (optional)
  final FHeaderStyle Function(FHeaderStyle style)? headerStyle;

  final FToasterStyle Function(FToasterStyle style)? toasterStyle;
  final bool childPad;
  final Widget child;
  final Widget? sidebar;
  final Widget? footer;
  final bool safeTop;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build title widget
    Widget titleWidget;
    if (titleIcon != null) {
      titleWidget = Row(
        children: [
          Icon(
            titleIcon,
            size: 22,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 8),
          Text(title, style: theme.textTheme.headlineSmall),
        ],
      );
    } else {
      titleWidget = Text(title, style: theme.textTheme.headlineSmall);
    }

    // Build header
    final Widget header;
    if (showBackButton && Navigator.of(context).canPop()) {
      header = FHeader.nested(
        title: titleWidget,
        style: headerStyle,
        prefixes: [
          FHeaderAction.back(
            onPress: onBack ?? () => Navigator.of(context).maybePop(),
          ),
        ],
        suffixes: actions ?? [],
      );
    } else {
      header = FHeader(
        title: titleWidget,
        style: headerStyle,
        suffixes: actions ?? [],
      );
    }

    // Build child with optional RefreshIndicator
    Widget content = child;
    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        child: child,
      );
    }

    return FScaffold(
      scaffoldStyle: scaffoldStyle,
      toasterStyle: toasterStyle,
      header: header,
      childPad: childPad,
      sidebar: sidebar,
      footer: footer,
      child: SafeArea(
        top: safeTop,
        bottom: safeBottom,
        child: content,
      ),
    );
  }
}
