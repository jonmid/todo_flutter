import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../domain/entities/map_point_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../models/map_point_model.dart';

class MapRepositoryImpl implements MapRepository {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _tableName = 'map_points';

  @override
  Future<List<MapPointEntity>> getUserPoints(String userId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map<MapPointEntity>((json) => MapPointModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener puntos del mapa: $e');
    }
  }

  @override
  Future<MapPointEntity> addPoint({
    required String name,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    try {
      final insertPayload = {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'user_id': userId,
      };

      final response = await _client
          .from(_tableName)
          .insert(insertPayload)
          .select()
          .single();

      return MapPointModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al guardar punto en Supabase: $e');
    }
  }
}