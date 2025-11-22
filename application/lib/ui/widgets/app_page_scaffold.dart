import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Common wrapper around [FScaffold] that applies a consistent SafeArea.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    this.scaffoldStyle,
    this.toasterStyle,
    this.header,
    this.childPad = true,
    this.sidebar,
    this.footer,
    this.safeTop = false,
    this.safeBottom = false,
    required this.child,
  });

  final FScaffoldStyle Function(FScaffoldStyle style)? scaffoldStyle;
  final FToasterStyle Function(FToasterStyle style)? toasterStyle;
  final Widget? header;
  final bool childPad;
  final Widget child;
  final Widget? sidebar;
  final Widget? footer;
  final bool safeTop;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
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
        child: child,
      ),
    );
  }
}
