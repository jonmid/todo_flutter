import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';

class StorageService {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _bucket = 'task-images';

  Future<String> uploadTaskImage({
    required Uint8List bytes,
    required String userId,
    String? filename,
    String? contentType,
  }) async {
    final name = filename ?? 'image-${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '$userId/${DateTime.now().millisecondsSinceEpoch}/$name';

    // Upload file with robust error handling
    try {
      await _client.storage
          .from(_bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              upsert: false,
              contentType: contentType ?? 'image/jpeg',
            ),
          );
    } on StorageException catch (e) {
      // Propagate a clear error to the caller (likely due to bucket/policies)
      throw Exception('Fallo al subir imagen al bucket "$_bucket": ${e.message}');
    } catch (e) {
      throw Exception('Fallo inesperado al subir imagen: $e');
    }

    // Try to return a signed URL (works for private buckets). If it fails, fallback to public URL.
    try {
      final signedUrl = await _client.storage
          .from(_bucket)
          .createSignedUrl(path, 60 * 60); // 1 hora
      return signedUrl;
    } catch (_) {
      // If bucket is public, this URL will work
      final publicUrl = _client.storage.from(_bucket).getPublicUrl(path);
      return publicUrl;
    }
  }
}