import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'views/phrase_view.dart';

void main() async {
  // Asegurar que Flutter esté completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuración específica para Microsoft Store - evitar orientaciones problemáticas
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Inicialización robusta de Firebase con timeout para evitar carga infinita
  bool firebaseAvailable = false;
  try {
    // Timeout para evitar carga infinita en la Store
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        debugPrint('⚠️ Firebase initialization timeout - continuando sin Firebase');
        throw TimeoutException('Firebase timeout', const Duration(seconds: 8));
      },
    );
    firebaseAvailable = true;
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
    debugPrint('🔄 App will continue with local data only');
    // La app puede funcionar sin Firebase usando solo datos locales
  }
  
  // Mostrar splash screen mínimo antes de cargar la app principal
  runApp(SplashApp(firebaseAvailable: firebaseAvailable));
}

class SplashApp extends StatefulWidget {
  final bool firebaseAvailable;
  
  const SplashApp({super.key, required this.firebaseAvailable});
  
  @override
  State<SplashApp> createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  bool _isReady = false;
  
  @override
  void initState() {
    super.initState();
    // Delay mínimo para evitar pantalla en blanco en la Store
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    // Simular tiempo de inicialización mínimo para evitar problemas en la Store
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runa - Motivación Diaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        fontFamily: 'Segoe UI',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: _isReady 
        ? RunaApp(firebaseAvailable: widget.firebaseAvailable)
        : const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
            SizedBox(height: 24),
            Text(
              'Cargando Runa...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunaApp extends StatelessWidget {
  final bool firebaseAvailable;
  
  const RunaApp({super.key, required this.firebaseAvailable});

  @override
  Widget build(BuildContext context) {
    return PhraseView(firebaseAvailable: firebaseAvailable);
  }
}
