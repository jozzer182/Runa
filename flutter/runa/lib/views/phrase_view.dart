import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/phrase_controller.dart';

class PhraseView extends StatefulWidget {
  const PhraseView({super.key});

  @override
  State<PhraseView> createState() => _PhraseViewState();
}

class _PhraseViewState extends State<PhraseView> with TickerProviderStateMixin {
  final PhraseController _controller = PhraseController.instance;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configurar animaciones
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    
    // Escuchar cambios del controlador
    _controller.addListener(_onControllerChange);
    
    // Inicializar
    _initializeApp();
  }

  void _onControllerChange() {
    if (mounted) {
      setState(() {});
      
      // Animar cuando cambie la frase
      if (_controller.currentPhrase != null) {
        _fadeController.forward();
      }
    }
  }

  Future<void> _initializeApp() async {
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onPhraseTap() async {
    // Animación de escala al tocar
    await _scaleController.forward();
    _scaleController.reverse();
    
    // Fade out y obtener siguiente frase
    await _fadeController.reverse();
    await _controller.getNextPhrase();
  }

  void _copyPhrase() {
    if (_controller.currentPhrase != null) {
      Clipboard.setData(ClipboardData(text: _controller.currentPhrase!.text));
      
      // Mostrar snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Frase copiada al portapapeles'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          SizedBox(height: 24),
          Text(
            'Preparando tu frase del día...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 24),
            Text(
              _controller.errorMessage ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _controller.forceReload(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhraseView() {
    final phrase = _controller.currentPhrase;
    if (phrase == null) return _buildErrorView();

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Título
                        const Text(
                          'Tu frase del día',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Frase principal (clickeable)
                        GestureDetector(
                          onTap: _onPhraseTap,
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '"${phrase.text}"',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Toca para la siguiente →',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Botón copiar
                            IconButton(
                              onPressed: _copyPhrase,
                              icon: const Icon(Icons.copy),
                              iconSize: 28,
                              color: Colors.deepPurple,
                              tooltip: 'Copiar frase',
                            ),
                            
                            // Botón recargar
                            IconButton(
                              onPressed: () => _controller.forceReload(),
                              icon: const Icon(Icons.refresh),
                              iconSize: 28,
                              color: Colors.deepPurple,
                              tooltip: 'Nueva frase',
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Indicador de fuente
                        Text(
                          _getSourceText(phrase.source),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getSourceText(String source) {
    switch (source) {
      case 'gemini':
        return '✨ GENERADA CON IA';
      case 'firestore':
        return '☁️ DESDE LA NUBE';
      case 'base':
        return '📖 FRASE CLÁSICA';
      default:
        return '💫 FRASE MOTIVACIONAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo/título
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Runa',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            // Contenido principal
            Expanded(
              child: _controller.isLoading
                  ? _buildLoadingView()
                  : _controller.errorMessage != null
                      ? _buildErrorView()
                      : _buildPhraseView(),
            ),
          ],
        ),
      ),
    );
  }
}
