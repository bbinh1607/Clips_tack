import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_scaffold.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/clipboard/presentation/models/clip_editor_payload.dart';
import 'package:clips_tack/features/clipboard/presentation/widgets/clip_editor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
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

  Future<void> _save() async {
    final bloc = context.read<ClipboardBloc>();
    final l10n = context.l10n;
    final value = _controller.text.trim();
    final didSave = _isEditing
        ? await bloc.updateClip(id: widget.payload.clipId!, content: value)
        : await bloc.addClip(value);

    if (!mounted) {
      return;
    }

    context.pop(
      didSave
          ? (_isEditing ? l10n.updatedMessage : l10n.savedMessage)
          : l10n.duplicateClipMessage,
    );
  }

  void _saveFromShortcut() {
    if (!_canSave) {
      return;
    }

    _save();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = _isEditing ? l10n.editClipTitle : l10n.saveClipTitle;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyS, control: true):
            _saveFromShortcut,
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true):
            _saveFromShortcut,
      },
      child: AppScaffold(
        title: title,
        useSafeArea: true,
        bodyPadding: AppInsets.page,
        body: ClipEditorForm(
          controller: _controller,
          isEditing: _isEditing,
          canSave: _canSave,
          onSave: _save,
        ),
      ),
    );
  }
}
