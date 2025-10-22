import 'package:get/get.dart';
import '../../core/config/supabase_config.dart';
import '../../domain/entities/map_point_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../../data/repositories/map_repository_impl.dart';

class MapController extends GetxController {
  final MapRepository _repository = MapRepositoryImpl();

  final RxList<MapPointEntity> _points = <MapPointEntity>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<MapPointEntity> get points => _points;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadPoints();
  }

  Future<void> loadPoints() async {
    final user = SupabaseConfig.currentUser;
    if (user == null) return;

    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final result = await _repository.getUserPoints(user.id);
      _points.assignAll(result);
    } catch (e) {
      _errorMessage.value = 'Error al cargar puntos: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addPoint({required String name, required double latitude, required double longitude}) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) return;

    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final saved = await _repository.addPoint(
        name: name,
        latitude: latitude,
        longitude: longitude,
        userId: user.id,
      );

      _points.insert(0, saved);
    } catch (e) {
      _errorMessage.value = 'Error al guardar el punto: $e';
    } finally {
      _isLoading.value = false;
    }
  }
}