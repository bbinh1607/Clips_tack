import 'package:clips_tack/features/auth/domain/entities/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? username,
    String? password,
  }) = _UserModel;
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? '',
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      username: username,
      password: password,
    );
  }

  factory UserModel.fromFirebase(dynamic user) {
    return UserModel(
      id: user.uid,
      email: user.email,
      name: user.displayName,
      avatarUrl: user.photoURL,
      username: user.displayName,
      password: user.password,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
