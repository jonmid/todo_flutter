class MapPointEntity {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String userId;

  MapPointEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.userId,
  });
}