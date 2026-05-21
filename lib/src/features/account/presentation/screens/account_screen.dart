import 'package:flutter/material.dart';
import 'package:job_design_system/job_design_system.dart';

import '../../../auth/data/datasources/datasources.dart';
import '../../../auth/data/repositories/repositories.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    final remoteDataSource = SupabaseAuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(remoteDataSource);
    authRepository.signOut(); // Just for testing, you can remove this later
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This is the Account Screen'),
            const SizedBox(height: 20),
            DSButton(
              onPressed: () {
                final remoteDataSource = SupabaseAuthRemoteDataSource();
                final authRepository = AuthRepositoryImpl(remoteDataSource);
                authRepository.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
