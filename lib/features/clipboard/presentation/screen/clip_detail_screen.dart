import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/clipboard/presentation/models/clip_editor_payload.dart';
import 'package:clips_tack/features/clipboard/presentation/widgets/clip_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const double _detailCardHorizontalInset = 10;
const double _detailCardMaxWidth = 640;
const double _detailCardRadius = 34;
const double _detailCardDragRadius = 10;
const double _detailCardViewportFraction = 0.88;
const double _detailCardBottomClearance = 92;
const double _verticalDismissThreshold = 70;

class ClipDetailScreen extends StatelessWidget {
  const ClipDetailScreen({
    required this.initialItem,
    this.initialItems = const <ClipboardItem>[],
    super.key,
  });

  final ClipboardItem initialItem;
  final List<ClipboardItem> initialItems;

  @override
  Widget build(BuildContext context) {
    return _ClipDetailView(
      initialItem: initialItem,
      initialItems: initialItems,
    );
  }
}

class _ClipDetailView extends StatefulWidget {
  const _ClipDetailView({
    required this.initialItem,
    required this.initialItems,
  });

  final ClipboardItem initialItem;
  final List<ClipboardItem> initialItems;

  @override
  State<_ClipDetailView> createState() => _ClipDetailViewState();
}

class _ClipDetailViewState extends State<_ClipDetailView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _contentController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final PageController _pageController;
  late final List<ClipboardItem> _routeItems;

  double _verticalDismissDragOffset = 0;
  Offset? _pointerStart;
  bool _isVerticalDismissDrag = false;
  bool _isClosing = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    final blocItems = context.read<ClipboardBloc>().state.items;
    _routeItems = _seedItems(
      widget.initialItems.isEmpty ? blocItems : widget.initialItems,
      widget.initialItem,
    );
    final initialIndex = _indexOf(_routeItems, widget.initialItem.id);

    _pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: _detailCardViewportFraction,
    );
    _contentController = AnimationController(
      vsync: this,
      duration: AppDuration.clipDetailContent,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    Future<void>.delayed(const Duration(milliseconds: 170), () {
      if (mounted && !_isClosing) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _copyItem(ClipboardItem item) async {
    await context.read<ClipboardBloc>().copyClip(item);
    if (!mounted) {
      return;
    }

    _showSnackBar(context.l10n.copiedMessage);
  }

  void _togglePin(ClipboardItem item) {
    context.read<ClipboardBloc>().togglePin(item.id);
    _showSnackBar(
      item.isPinned ? context.l10n.unpinnedMessage : context.l10n.pinnedMessage,
    );
  }

  Future<void> _editItem(ClipboardItem item) async {
    final message = await context.pushNamed<String>(
      AppRoutes.editor,
      extra: ClipEditorPayload(clipId: item.id, initialContent: item.content),
    );

    if (!mounted || message == null) {
      return;
    }

    _showSnackBar(message);
  }

  void _deleteItem(ClipboardItem item) {
    context.read<ClipboardBloc>().deleteClip(item.id);
    _closeDetail(result: context.l10n.deletedMessage);
  }

  Future<void> _closeDetail({String? result, double closeDirection = 1}) async {
    if (_isClosing || !mounted) {
      return;
    }

    final screenHeight = MediaQuery.sizeOf(context).height;
    final direction = closeDirection < 0 ? -1.0 : 1.0;

    _isClosing = true;
    setState(() {
      _verticalDismissDragOffset = direction * screenHeight;
    });

    await Future<void>.delayed(AppDuration.clipCollapse);
    if (!mounted) {
      return;
    }

    setState(() {
      _allowPop = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.pop(result);
      }
    });
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerStart = event.position;
    _isVerticalDismissDrag = false;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final start = _pointerStart;
    if (start == null || _isClosing) {
      return;
    }

    final offset = event.position - start;
    final dx = offset.dx.abs();
    final dy = offset.dy.abs();

    if (!_isVerticalDismissDrag) {
      if (dy < AppSpace.xxl || dy < dx * 1.25) {
        return;
      }

      _isVerticalDismissDrag = true;
    }

    setState(() {
      _verticalDismissDragOffset = offset.dy
          .clamp(-context.height, context.height)
          .toDouble();
    });
  }

  void _onPointerEnd(PointerEvent event) {
    _pointerStart = null;

    if (!_isVerticalDismissDrag) {
      return;
    }

    _isVerticalDismissDrag = false;

    if (_verticalDismissDragOffset.abs() > _verticalDismissThreshold) {
      _closeDetail(closeDirection: _verticalDismissDragOffset < 0 ? -1 : 1);
      return;
    }

    setState(() {
      _verticalDismissDragOffset = 0;
    });
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: AppText.bodyMedium(message)));
  }

  List<ClipboardItem> _itemsFromState(List<ClipboardItem> stateItems) {
    final stateItemsById = {for (final item in stateItems) item.id: item};

    return _seedItems([
      for (final item in _routeItems) stateItemsById[item.id] ?? item,
    ], widget.initialItem);
  }

  List<ClipboardItem> _seedItems(
    List<ClipboardItem> items,
    ClipboardItem initialItem,
  ) {
    final seeded = <ClipboardItem>[];
    final seenIds = <String>{};

    for (final item in items) {
      if (seenIds.add(item.id)) {
        seeded.add(item);
      }
    }

    if (!seenIds.contains(initialItem.id)) {
      seeded.insert(0, initialItem);
    }

    return seeded.isEmpty ? [initialItem] : seeded;
  }

  int _indexOf(List<ClipboardItem> items, String id) {
    final index = items.indexWhere((item) => item.id == id);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final items = _itemsFromState(context.watch<ClipboardBloc>().state.items);
    final verticalDragProgress = context.height == 0
        ? 0.0
        : (_verticalDismissDragOffset.abs() / context.height).clamp(0.0, 1.0);
    final dragScale = 1 - (verticalDragProgress * 0.08);
    final cardRadius =
        _detailCardRadius + (verticalDragProgress * _detailCardDragRadius);
    final mediaPadding = MediaQuery.paddingOf(context);
    final panelTopInset = mediaPadding.top + AppSpace.xxxl;
    final panelBottomInset =
        mediaPadding.bottom +
        (context.height < 680 ? AppSpace.xxxl : _detailCardBottomClearance);

    return PopScope<String>(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _isClosing) {
          return;
        }

        _closeDetail(result: result);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Listener(
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerEnd,
          onPointerCancel: _onPointerEnd,
          child: AnimatedContainer(
            duration: _isClosing
                ? AppDuration.clipCollapse
                : _verticalDismissDragOffset == 0
                ? AppDuration.short
                : Duration.zero,
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..translateByDouble(0, _verticalDismissDragOffset, 0, 1)
              ..scaleByDouble(dragScale, dragScale, 1, 1),
            transformAlignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                top: panelTopInset,
                bottom: panelBottomInset,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: AnimatedOpacity(
                    opacity: _isClosing ? 0 : 1,
                    duration: AppDuration.clipCollapse,
                    curve: Curves.easeOutCubic,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: items.length,
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: _detailCardHorizontalInset,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: _detailCardMaxWidth,
                              ),
                              child: SizedBox.expand(
                                child: ClipDetailCard(
                                  key: ValueKey('clip-detail-card-${item.id}'),
                                  item: item,
                                  radius: cardRadius,
                                  onCopy: () => _copyItem(item),
                                  onTogglePin: () => _togglePin(item),
                                  onEdit: () => _editItem(item),
                                  onDelete: () => _deleteItem(item),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
