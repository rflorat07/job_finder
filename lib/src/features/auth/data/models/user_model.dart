import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/user_entity.dart';

/// Extension of UserEntity that handles serialization from Supabase objects.
/// Lives in the Data layer.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
  });

  /// Factory constructor to create a UserModel from a Supabase User object
  factory UserModel.fromSupabase(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
    );
  }
}
