import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../core/constants/demo_data.dart';

// Global Demo Mode Flag
final isDemoModeProvider = StateProvider<bool>((ref) => false);

// Firebase Auth state stream
final authStateProvider = StreamProvider<User?>((ref) {
  final isDemo = ref.watch(isDemoModeProvider);
  if (isDemo) return Stream.value(null); // No real Firebase user in demo mode
  return FirebaseAuth.instance.authStateChanges();
});

// Current user profile
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final isDemo = ref.watch(isDemoModeProvider);
  if (isDemo) return Stream.value(DemoData.demoUser);

  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.exists
              ? UserModel.fromMap(doc.data()!)
              : null);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Auth notifier for login/register/logout
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  void enterDemoMode() {
    ref.read(isDemoModeProvider.notifier).state = true;
    state = const AsyncValue.data(null);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required String role,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user!.updateDisplayName(displayName);

      final user = UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: displayName,
        role: role,
        phone: phone,
        createdAt: DateTime.now().toIso8601String(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toMap());

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    final isDemo = ref.read(isDemoModeProvider);
    if (isDemo) {
      ref.read(isDemoModeProvider.notifier).state = false;
    } else {
      await FirebaseAuth.instance.signOut();
    }
    state = const AsyncValue.data(null);
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref),
);
