import 'package:clips_tack/app/app.dart';
import 'package:clips_tack/core/error/failure.dart';
import 'package:clips_tack/core/di/injection.dart';
import 'package:clips_tack/core/typedef/typedef.dart';
import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:clips_tack/features/auth/domain/repositories/auth_repository.dart';
import 'package:clips_tack/features/clipboard/data/services/clipboard_service.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
    await getIt.unregister<AuthRepository>();
    getIt
      ..unregister<ClipboardService>()
      ..registerLazySingleton<AuthRepository>(_FakeAuthRepository.new)
      ..registerLazySingleton<ClipboardService>(_FakeClipboardService.new);
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

class _FakeClipboardService implements ClipboardService {
  @override
  Future<String?> readText() async => null;

  @override
  Future<void> writeText(String text) async {}

  @override
  Future<List<ClipboardItem>> loadLocal() async => <ClipboardItem>[];

  @override
  Future<void> saveLocal(List<ClipboardItem> items) async {}
}
