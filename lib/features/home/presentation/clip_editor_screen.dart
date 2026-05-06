import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_scaffold.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/cubit/clipboard_cubit.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipEditorScreen extends StatefulWidget {
  const ClipEditorScreen({required this.payload, super.key});

  final ClipEditorPayload payload;

  @override
  State<ClipEditorScreen> createState() => _ClipEditorScreenState();
}

class _ClipEditorScreenState extends State<ClipEditorScreen> {
  late final TextEditingController _controller;

  bool get _canSave => _controller.text.trim().isNotEmpty;
  bool get _isEditing => widget.payload.clipId != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.payload.initialContent)
      ..selection = TextSelection.collapsed(
        offset: widget.payload.initialContent.length,
      )
      ..addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _save() {
    final cubit = context.read<ClipboardCubit>();
    final l10n = context.l10n;
    final value = _controller.text.trim();
    final didSave = _isEditing
        ? cubit.updateClip(id: widget.payload.clipId!, content: value)
        : cubit.addClip(value);

    context.pop(
      didSave
          ? (_isEditing ? l10n.updatedMessage : l10n.savedMessage)
          : l10n.duplicateClipMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = _isEditing ? l10n.editClipTitle : l10n.saveClipTitle;
    final buttonLabel = _isEditing
        ? l10n.updateClipButton
        : l10n.saveClipButton;

    return AppScaffold(
      title: title,
      useSafeArea: true,
      bodyPadding: AppInsets.page,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.bodyLarge(
            _isEditing
                ? l10n.editorEditDescription
                : l10n.editorCreateDescription,
          ),
          const SizedBox(height: AppSpace.xxl),
          Expanded(
            child: TextField(
              controller: _controller,
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
            onPressed: _canSave ? _save : null,
          ),
        ],
      ),
    );
  }
}
