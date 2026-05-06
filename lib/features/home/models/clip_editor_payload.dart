import 'package:freezed_annotation/freezed_annotation.dart';

part 'clip_editor_payload.freezed.dart';

@freezed
abstract class ClipEditorPayload with _$ClipEditorPayload {
  const factory ClipEditorPayload({
    String? clipId,
    @Default('') String initialContent,
  }) = _ClipEditorPayload;
}
