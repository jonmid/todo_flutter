import '../../domain/entities/map_point_entity.dart';

abstract class MapRepository {
  Future<List<MapPointEntity>> getUserPoints(String userId);
  Future<MapPointEntity> addPoint({
    required String name,
    required double latitude,
    required double longitude,
    required String userId,
  });
}