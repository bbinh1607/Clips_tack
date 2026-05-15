import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class SettingsAccountIdentityTile extends StatelessWidget {
  const SettingsAccountIdentityTile({required this.user, super.key});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final email = _clean(user?.email);
    final displayName = _displayName(user, context.l10n.accountSectionTitle);

    return Row(
      children: [
        _AccountAvatar(
          imageUrl: _clean(user?.avatarUrl),
          displayName: displayName,
        ),
        const SizedBox(width: AppSpace.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMedium(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (email != null) ...[
                const SizedBox(height: AppSpace.xxs),
                AppText.bodySmall(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _displayName(UserEntity? user, String fallback) {
    return _firstFilled([
      user?.name,
      user?.username,
      _emailName(user?.email),
      fallback,
    ])!;
  }

  static String? _emailName(String? email) {
    final cleanEmail = _clean(email);

    if (cleanEmail == null) {
      return null;
    }

    return cleanEmail.split('@').first;
  }

  static String? _firstFilled(Iterable<String?> values) {
    for (final value in values) {
      final cleanValue = _clean(value);

      if (cleanValue != null) {
        return cleanValue;
      }
    }

    return null;
  }

  static String? _clean(String? value) {
    final cleanValue = value?.trim();

    if (cleanValue == null || cleanValue.isEmpty) {
      return null;
    }

    return cleanValue;
  }
}

class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.displayName, this.imageUrl});

  static const _size = 56.0;

  final String displayName;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final cleanImageUrl = imageUrl?.trim();
    final hasImage = cleanImageUrl != null && cleanImageUrl.isNotEmpty;

    return SizedBox.square(
      dimension: _size,
      child: ClipOval(
        child: hasImage
            ? Image.network(
                cleanImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _fallback(context);
                },
              )
            : _fallback(context),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    final initial = displayName.trim().isEmpty
        ? '?'
        : displayName.trim().substring(0, 1).toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colors.surface,
          context.colors.primary,
          AppOpacity.selectedSurface,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AppText.titleLarge(
          initial,
          color: context.colors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
