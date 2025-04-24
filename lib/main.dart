import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNAH-VS Navigator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _classroomController = TextEditingController();
  int? _edificioSeleccionado;

  @override
  void dispose() {
    _buildingController.dispose();
    _classroomController.dispose();
    super.dispose();
  }

  void _navigateToMapScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String hintAula = _edificioSeleccionado == 6
        ? 'Ingrese cualquier número'
        : 'Piso-Aula (ej. 101)';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a UNAH-VS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'web/campus.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<int>(
                value: _edificioSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Edificio',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(6, (index) => index + 1).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _edificioSeleccionado = newValue;
                    _buildingController.text = newValue.toString();
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _classroomController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Aula',
                  hintText: hintAula,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToMapScreen,
              child: const Text('Ir'),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final campusBounds = LatLngBounds(
      const LatLng(15.527346, -88.039573), // Suroeste
      const LatLng(15.531895, -88.035293), // Noreste
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa UNAH-VS')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(15.529605, -88.037299),
          initialZoom: 16.0,
          cameraConstraint: CameraConstraint.contain(bounds: campusBounds),
          minZoom: 14.0,
          maxZoom: 18.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
        ],
      ),
    );
  }
}
