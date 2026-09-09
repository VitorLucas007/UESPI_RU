import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../viewmodels/location_viewmodel.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationViewModel _viewModel = LocationViewModel();

  @override
  Widget build(BuildContext context) {
    final loc = _viewModel.localizacao;
    final centerCoordinates = LatLng(loc.latitude, loc.longitude);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF003366)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Localização',
          style: TextStyle(
            color: Color(0xFF003366),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Metade Superior: Mapa interativo FlutterMap v8.3.2
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: centerCoordinates,
                    initialZoom: 17.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'br.uespi.ru',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: centerCoordinates,
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.location_on,
                            size: 48,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Badge flutuante indicando o Campus no mapa
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.near_me, size: 14, color: Color(0xFF003366)),
                        SizedBox(width: 4),
                        Text(
                          'Teresina - PI',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Metade Inferior: Bottom sheet fixo
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle cinza centralizado
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Tag amarela "CAMPUS TORQUATO NETO"
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFFFEEBA)),
                    ),
                    child: Text(
                      loc.campus,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF856404),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Título "RESTAURANTE UNIVERSITÁRIO - RU"
                  Text(
                    loc.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF003366),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Pontos de Referência
                  Row(
                    children: [
                      const Icon(Icons.account_balance_outlined, size: 18, color: Color(0xFF555555)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          loc.pontoReferencia,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF424242),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.directions_walk_rounded, size: 18, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 8),
                      Text(
                        loc.tempoCaminhada,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Botão azul "Abrir no Google Maps"
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _viewModel.abrirNoGoogleMaps(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.map_outlined, size: 20),
                      label: const Text(
                        'Abrir no Google Maps',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
