import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ClipEditorForm extends StatelessWidget {
  const ClipEditorForm({
    required this.controller,
    required this.isEditing,
    required this.canSave,
    required this.onSave,
    super.key,
  });

  final TextEditingController controller;
  final bool isEditing;
  final bool canSave;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final buttonLabel = isEditing ? l10n.updateClipButton : l10n.saveClipButton;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodyLarge(
          isEditing ? l10n.editorEditDescription : l10n.editorCreateDescription,
        ),
        const SizedBox(height: AppSpace.xxl),
        Expanded(
          child: TextField(
            controller: controller,
            autofocus: true,
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: l10n.editorHint,
              alignLabelWithHint: true,
            ),
          ),
        ),
        const SizedBox(height: AppSpace.xxl),
        AppButton.primary(
          label: buttonLabel,
          leadingIcon: Icons.save_rounded,
          onPressed: canSave ? onSave : null,
        ),
      ],
    );
  }
}
