import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/interview_model.dart';

/// Defines the contract for external interview data operations.
abstract class InterviewsRemoteDataSource {
  Future<List<InterviewModel>> fetchInterviews({int limit = 50});
}

/// Supabase concrete implementation. ONLY this class talks to Supabase.
class SupabaseInterviewsRemoteDataSource implements InterviewsRemoteDataSource {
  final SupabaseClient _client;

  SupabaseInterviewsRemoteDataSource(this._client);

  String _currentUserId() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found.');
    }
    return user.id;
  }

  @override
  Future<List<InterviewModel>> fetchInterviews({int limit = 50}) async {
    final userId = _currentUserId();

    final response = await _client
        .from('interviews')
        .select()
        .eq('user_id', userId)
        .order('scheduled_at', ascending: false)
        .limit(limit);

    return response.map((json) => InterviewModel.fromJson(json)).toList();
  }
}
