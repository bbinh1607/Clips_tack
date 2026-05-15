import 'package:clips_tack/app/app.dart';
import 'package:clips_tack/core/error/failure.dart';
import 'package:clips_tack/core/di/injection.dart';
import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
    await getIt.unregister<AuthRepository>();
    getIt
      ..unregister<ClipboardRepository>()
      ..registerLazySingleton<AuthRepository>(_FakeAuthRepository.new)
      ..registerLazySingleton<ClipboardRepository>(
        _FakeClipboardRepository.new,
      );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders ClipStack home chrome', (WidgetTester tester) async {
    await tester.pumpWidget(const ClipStackApp());
    await tester.pumpAndSettle();

    expect(find.text('ClipStack'), findsOneWidget);
    expect(find.text('Search clipboard...'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.byIcon(Icons.content_paste_rounded), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  static const _user = UserEntity(id: 'test-user', email: 'test@gmail.com');

  @override
  DataState<bool> isLoggedIn() async => const Right<Failure, bool>(true);

  @override
  DataState<UserEntity?> currentUser() async {
    return const Right<Failure, UserEntity?>(_user);
  }

  @override
  DataState<UserEntity> login(String email, String password) async {
    return const Right<Failure, UserEntity>(_user);
  }

  @override
  DataState<UserEntity> loginWithGoogle() async {
    return const Right<Failure, UserEntity>(_user);
  }

  @override
  DataState<void> logout() async => const Right<Failure, void>(null);

  @override
  DataState<UserEntity> register(
    String email,
    String password, {
    String? name,
    String? avatarUrl,
    String? username,
  }) async {
    return const Right<Failure, UserEntity>(_user);
  }
}

class _FakeClipboardRepository implements ClipboardRepository {
  @override
  Future<String?> readClipboardText() async => null;

  @override
  Future<void> writeClipboardText(String text) async {}

  @override
  Future<List<ClipboardItem>> loadItems() async => <ClipboardItem>[];

  @override
  Future<void> saveItems(List<ClipboardItem> items) async {}
}
