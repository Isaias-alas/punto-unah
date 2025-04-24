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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a UNAH-VS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'web/favicon.png', // Assuming you have the logo here
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _buildingController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'[1-6]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Edificio (1-6)',
                  border: OutlineInputBorder(),
                ),
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
                  hintText: _buildingController.text == '6'
                      ? 'Ingrese cualquier número'
                      : 'Piso-Aula (ej. 101)',
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
    // 1. Definir límites del campus UNAH-VS
    final campusBounds = LatLngBounds(
      const LatLng(15.527346, -88.039573), // Suroeste
      const LatLng(15.531895, -88.035293), // Noreste
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa UNAH-VS')),
      body: FlutterMap(
        options: MapOptions(
          // 2. Centrado inicial
          initialCenter: const LatLng(15.529605, -88.037299),
          initialZoom: 16.0,

          // 3. Restricción permanente al área del campus
          cameraConstraint: CameraConstraint.contain(bounds: campusBounds),

          // 4. Límites de zoom permitidos
          minZoom: 14.0,
          maxZoom: 18.0,

          // 5. Gestos habilitados (pan + zoom, sin rotación)
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          // Aquí puedes agregar MarkerLayer, PolygonLayer, etc.
        ],
      ),
    );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa UNAH‑VS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapScreen(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage2> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above. The Flutter framework has been
    // optimized to make rerunning build methods fast, so that you can just
    // rebuild anything that needs updating rather than having to individually
    // change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent
        child: Column(
          // Column is also a layout widget. It takes a list of children and arranges them vertically.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
