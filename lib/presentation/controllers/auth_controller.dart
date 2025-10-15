import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';

class AuthController extends GetxController {
  final SupabaseClient _client = SupabaseConfig.client;

  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Si hay sesión, el AuthGate redirigirá al Home automáticamente
      return res.session != null;
    } catch (e) {
      _errorMessage.value = 'Error al iniciar sesión: $e';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final res = await _client.auth.signUp(
        email: email,
        password: password,
      );

      // En Supabase, tras signUp puede requerirse verificación de email
      // Si la sesión llega, el AuthGate redirigirá. Si no, mostramos mensaje.
      return res.user != null;
    } catch (e) {
      _errorMessage.value = 'Error al registrarse: $e';
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      _errorMessage.value = 'Error al cerrar sesión: $e';
    }
  }
}