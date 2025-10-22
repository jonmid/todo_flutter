import '../../domain/entities/map_point_entity.dart';

class MapPointModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String userId;

  MapPointModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.userId,
  });

  factory MapPointModel.fromJson(Map<String, dynamic> json) {
    return MapPointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  MapPointEntity toEntity() {
    return MapPointEntity(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      userId: userId,
    );
  }
}