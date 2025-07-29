# Solucion alternativa: Crear MSIX que funcione en Microsoft Store
# Aunque requiera runFullTrust, optimizamos para evitar el problema de "carga infinita"

param(
    [string]$Version = "1.0.10.0"
)

Write-Host "Creando MSIX optimizado para Microsoft Store..." -ForegroundColor Green

# Primero, vamos a modificar el main.dart para una mejor inicializacion
$MainDartPath = "lib\main.dart"
$BackupMainDart = "lib\main.dart.backup"

# Hacer backup del main.dart original
if (-not (Test-Path $BackupMainDart)) {
    Copy-Item $MainDartPath $BackupMainDart
}

Write-Host "Optimizando inicializacion de la app..." -ForegroundColor Yellow

# Crear una version mejorada del main.dart
$optimizedMainDart = @'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/phrase_view.dart';

void main() async {
  // Asegurar que Flutter este completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuracion especifica para Microsoft Store
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Inicializacion robusta de Firebase con timeout
  bool firebaseAvailable = false;
  try {
    // Timeout para evitar carga infinita en la Store
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        debugPrint('Firebase initialization timeout - continuando sin Firebase');
        throw TimeoutException('Firebase timeout', const Duration(seconds: 10));
      },
    );
    firebaseAvailable = true;
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will continue with local data only');
    // La app puede funcionar sin Firebase usando solo datos locales
  }
  
  // Mostrar splash screen minimo antes de cargar la app principal
  runApp(SplashApp(firebaseAvailable: firebaseAvailable));
}

class SplashApp extends StatefulWidget {
  final bool firebaseAvailable;
  
  const SplashApp({super.key, required this.firebaseAvailable});
  
  @override
  State<SplashApp> createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  @override
  void initState() {
    super.initState();
    // Delay minimo para evitar pantalla en blanco en la Store
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {});
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runa - Motivacion Diaria',
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
      home: RunaApp(firebaseAvailable: widget.firebaseAvailable),
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
'@

$optimizedMainDart | Out-File -FilePath $MainDartPath -Encoding UTF8

# Compilar con las optimizaciones
Write-Host "Compilando Flutter con optimizaciones para Store..." -ForegroundColor Yellow
& flutter clean
& flutter pub get
& flutter build windows --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error en la compilacion de Flutter" -ForegroundColor Red
    # Restaurar backup
    Copy-Item $BackupMainDart $MainDartPath -Force
    return
}

# Actualizar la configuracion MSIX para la nueva version
Write-Host "Actualizando configuracion MSIX..." -ForegroundColor Yellow
$PubspecPath = "pubspec.yaml"
$PubspecContent = Get-Content $PubspecPath -Raw
$PubspecContent = $PubspecContent -replace 'msix_version: \d+\.\d+\.\d+\.\d+', "msix_version: $Version"
$PubspecContent | Out-File -FilePath $PubspecPath -Encoding UTF8

# Crear MSIX optimizado
Write-Host "Creando MSIX optimizado..." -ForegroundColor Yellow
& dart run msix:create

if ($LASTEXITCODE -eq 0) {
    $OriginalMsix = "build\windows\x64\runner\Release\runa.msix"
    $OptimizedMsix = "Runa-Store-Optimized-v$Version.msix"
    
    if (Test-Path $OriginalMsix) {
        Copy-Item $OriginalMsix $OptimizedMsix -Force
        Write-Host "MSIX optimizado creado: $OptimizedMsix" -ForegroundColor Green
        Write-Host "" -ForegroundColor Green
        Write-Host "OPTIMIZACIONES APLICADAS:" -ForegroundColor Cyan
        Write-Host "- Inicializacion robusta con timeout" -ForegroundColor White
        Write-Host "- Splash screen para evitar pantalla en blanco" -ForegroundColor White
        Write-Host "- Manejo de errores mejorado" -ForegroundColor White
        Write-Host "- Funcionamiento offline si Firebase falla" -ForegroundColor White
        Write-Host "" -ForegroundColor Green
        Write-Host "Este MSIX deberia resolver el problema de 'carga infinita' en la Store" -ForegroundColor Green
    }
} else {
    Write-Host "Error al crear MSIX optimizado" -ForegroundColor Red
}

# Restaurar main.dart original
Write-Host "Restaurando main.dart original..." -ForegroundColor Yellow
Copy-Item $BackupMainDart $MainDartPath -Force

Write-Host "Proceso completado!" -ForegroundColor Green
'@

$optimizedScript | Out-File -FilePath "create_optimized_msix.ps1" -Encoding UTF8
