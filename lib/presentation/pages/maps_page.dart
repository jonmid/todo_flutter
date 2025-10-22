import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/map_controller.dart' as map_ctrl;

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late final map_ctrl.MapController _controller;
  LatLng? _deviceCenter;
  bool _locationChecked = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(map_ctrl.MapController());
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationChecked = true);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationChecked = true);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationChecked = true);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      setState(() {
        _deviceCenter = LatLng(position.latitude, position.longitude);
        _locationChecked = true;
      });
    } catch (e) {
      setState(() => _locationChecked = true);
    }
  }

  LatLng _initialCenter() {
    if (_controller.points.isNotEmpty) {
      final first = _controller.points.first;
      return LatLng(first.latitude, first.longitude);
    }
    if (_deviceCenter != null) {
      return _deviceCenter!;
    }
    return const LatLng(
      1.2150634405895513,
      -77.27832153004879,
    ); // Default Pasto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'Mapas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.white,
                child: Obx(() {
                  if (_controller.isLoading && _controller.points.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPurple,
                      ),
                    );
                  }

                  final markers = _controller.points
                      .map(
                        (p) => Marker(
                          point: LatLng(p.latitude, p.longitude),
                          width: 40,
                          height: 40,
                          child: Tooltip(
                            message: p.name,
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.primaryPurple,
                              size: 32,
                            ),
                          ),
                        ),
                      )
                      .toList();

                  return Column(
                    children: [
                      if (_locationChecked && _deviceCenter == null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          color: AppColors.lightPurple,
                          child: const Text(
                            'No se pudo obtener tu ubicación. Revisa permisos o GPS.',
                            style: TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                initialCenter: _initialCenter(),
                                initialZoom: 13,
                                onLongPress: (tapPos, latLng) {
                                  _askPointNameAndSave(
                                    context,
                                    _controller,
                                    latLng,
                                  );
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: ['a', 'b', 'c'],
                                  userAgentPackageName: 'com.example.todo',
                                ),
                                MarkerLayer(markers: markers),
                              ],
                            ),
                            // Botón de información flotante
                            Positioned(
                              top: 16,
                              right: 16,
                              child: FloatingActionButton(
                                mini: true,
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryPurple,
                                onPressed: () => _showInfoDialog(context),
                                child: const Icon(Icons.info_outline),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _askPointNameAndSave(
    BuildContext context,
    map_ctrl.MapController controller,
    LatLng latLng,
  ) async {
    final nameController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Guardar punto'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del punto',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && nameController.text.trim().isNotEmpty) {
      await controller.addPoint(
        name: nameController.text.trim(),
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );
      Get.snackbar('Punto guardado', nameController.text.trim());
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryPurple),
              SizedBox(width: 8),
              Text('Cómo usar el mapa'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Para agregar un punto al mapa:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.touch_app,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mantén pulsado (long press) sobre cualquier lugar del mapa',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.edit, color: AppColors.primaryPurple, size: 20),
                  SizedBox(width: 8),
                  Expanded(child: Text('Escribe un nombre para tu punto')),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.save, color: AppColors.primaryPurple, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('¡Listo! Tu punto se guardará en el mapa'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Entendido',
                style: TextStyle(color: AppColors.primaryPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}
