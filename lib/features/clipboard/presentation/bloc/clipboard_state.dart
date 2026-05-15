import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'clipboard_state.freezed.dart';

@freezed
abstract class ClipboardState with _$ClipboardState {
  const ClipboardState._();

  const factory ClipboardState({
    @Default(<ClipboardItem>[]) List<ClipboardItem> items,
    @Default('') String searchQuery,
  }) = _ClipboardState;

  List<ClipboardItem> get pinnedItems =>
      items.where((item) => item.isPinned).toList(growable: false);

  int get pinnedCount => pinnedItems.length;

  bool get hasSearchQuery => searchQuery.trim().isNotEmpty;

  List<ClipboardItem> visibleItems({required bool pinnedOnly}) {
    final source = pinnedOnly ? pinnedItems : items;
    if (!hasSearchQuery) {
      return source;
    }

    return source
        .where((item) => item.matchesQuery(searchQuery))
        .toList(growable: false);
  }
}
