import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _guestModeKey = 'lico_guest_mode';

class AuthSession {
  final User? user;
  final bool isGuest;

  const AuthSession({required this.user, required this.isGuest});

  bool get canEnterApp => user != null || isGuest;
  String? get userId {
    if (isGuest) return 'guest';
    return user?.uid;
  }

  String get displayName {
    if (isGuest) return 'Tamu';
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return user?.email ?? 'Pengguna';
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseUserChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).userChanges();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AuthSession>>((ref) {
      return AuthController(ref);
    });

class AuthController extends StateNotifier<AsyncValue<AuthSession>> {
  final Ref _ref;
  late final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSubscription;
  bool _isCompletingSignUp = false;
  bool _isGuestSessionActive = false;

  AuthController(this._ref) : super(const AsyncValue.loading()) {
    _auth = _ref.read(firebaseAuthProvider);
    _init();
  }

  Future<void> _init() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_guestModeKey, false);
    _isGuestSessionActive = false;

    if (_auth.currentUser != null) {
      await _auth.signOut();
    }

    state = const AsyncValue.data(AuthSession(user: null, isGuest: false));

    _authSubscription = _auth.userChanges().listen((user) async {
      if (_isCompletingSignUp) return;

      state = AsyncValue.data(
        AuthSession(user: user, isGuest: user == null && _isGuestSessionActive),
      );
    });
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncValue.loading();
    _isCompletingSignUp = true;

    try {
      _isGuestSessionActive = false;
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_guestModeKey, false);

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final trimmedName = name.trim();
      if (trimmedName.isNotEmpty) {
        await credential.user?.updateDisplayName(trimmedName);
        await credential.user?.reload();
      }

      await _auth.signOut();
      state = const AsyncValue.data(AuthSession(user: null, isGuest: false));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      _isCompletingSignUp = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      _isGuestSessionActive = false;
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_guestModeKey, false);

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      state = AsyncValue.data(
        AuthSession(user: _auth.currentUser ?? credential.user, isGuest: false),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> enterGuestMode() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (_auth.currentUser != null) {
        await _auth.signOut();
      }

      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_guestModeKey, true);
      _isGuestSessionActive = true;
      return const AuthSession(user: null, isGuest: true);
    });
  }

  Future<void> exitGuestMode() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _isGuestSessionActive = false;
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_guestModeKey, false);
      return const AuthSession(user: null, isGuest: false);
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _isGuestSessionActive = false;
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_guestModeKey, false);

      if (_auth.currentUser != null) {
        await _auth.signOut();
      }

      return const AuthSession(user: null, isGuest: false);
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
