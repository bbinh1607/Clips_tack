import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.drawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bodyPadding,
    this.useSafeArea = false,
    this.extendBody = false,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry? bodyPadding;
  final bool useSafeArea;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (bodyPadding != null) {
      content = Padding(padding: bodyPadding!, child: content);
    }

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: drawer,
      extendBody: extendBody,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (title == null &&
        titleWidget == null &&
        actions == null &&
        leading == null) {
      return null;
    }

    return AppBar(
      leading: leading,
      title: titleWidget ?? (title == null ? null : AppText.titleLarge(title!)),
      actions: actions,
    );
  }
}
