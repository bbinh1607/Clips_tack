import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

enum _AppButtonVariant { primary, outline, text, icon }

class AppButton extends StatelessWidget {
  const AppButton.primary({
    required this.label,
    required this.onPressed,
    super.key,
    this.leadingIcon,
    this.tooltip,
    this.expanded = true,
  }) : _variant = _AppButtonVariant.primary,
       icon = null;

  const AppButton.outline({
    required this.label,
    required this.onPressed,
    super.key,
    this.leadingIcon,
    this.tooltip,
    this.expanded = true,
  }) : _variant = _AppButtonVariant.outline,
       icon = null;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    super.key,
    this.leadingIcon,
    this.tooltip,
    this.expanded = false,
  }) : _variant = _AppButtonVariant.text,
       icon = null;

  const AppButton.icon({
    required this.icon,
    required this.onPressed,
    super.key,
    this.tooltip,
  }) : _variant = _AppButtonVariant.icon,
       label = null,
       leadingIcon = null,
       expanded = false;

  final _AppButtonVariant _variant;
  final String? label;
  final IconData? leadingIcon;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return switch (_variant) {
      _AppButtonVariant.primary => _buildPrimary(context),
      _AppButtonVariant.outline => _buildOutline(context),
      _AppButtonVariant.text => _buildText(context),
      _AppButtonVariant.icon => _buildIcon(),
    };
  }

  Widget _buildPrimary(BuildContext context) {
    final button = leadingIcon == null
        ? FilledButton(
            onPressed: onPressed,
            style: _buttonStyle(),
            child: Text(label!),
          )
        : FilledButton.icon(
            onPressed: onPressed,
            style: _buttonStyle(),
            icon: Icon(leadingIcon),
            label: Text(label!),
          );

    return _wrapExpanded(button);
  }

  Widget _buildOutline(BuildContext context) {
    final button = leadingIcon == null
        ? OutlinedButton(
            onPressed: onPressed,
            style: _buttonStyle(),
            child: Text(label!),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            style: _buttonStyle(),
            icon: Icon(leadingIcon),
            label: Text(label!),
          );

    return _wrapExpanded(button);
  }

  Widget _buildText(BuildContext context) {
    final button = leadingIcon == null
        ? TextButton(
            onPressed: onPressed,
            style: _buttonStyle(),
            child: Text(label!),
          )
        : TextButton.icon(
            onPressed: onPressed,
            style: _buttonStyle(),
            icon: Icon(leadingIcon),
            label: Text(label!),
          );

    return _wrapExpanded(button);
  }

  Widget _buildIcon() {
    return IconButton(onPressed: onPressed, tooltip: tooltip, icon: Icon(icon));
  }

  ButtonStyle _buttonStyle() {
    return const ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, AppSize.primaryButtonHeight)),
    );
  }

  Widget _wrapExpanded(Widget child) {
    if (!expanded) {
      return child;
    }

    return SizedBox(width: double.infinity, child: child);
  }
}
