import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Widget qui protège les routes nécessitant une authentification
class ProtectedRoute extends StatefulWidget {
  /// Widget à afficher si l'utilisateur est authentifié
  final Widget child;
  
  /// Widget à afficher si l'utilisateur n'est pas authentifié
  final Widget fallback;

  /// Constructeur de la route protégée
  const ProtectedRoute({
    super.key,
    required this.child,
    required this.fallback,
  });

  @override
  State<ProtectedRoute> createState() => _ProtectedRouteState();
}

class _ProtectedRouteState extends State<ProtectedRoute> {
  /// Indique si la vérification de l'authentification est en cours
  bool _checkingAuth = true;
  
  /// Indique si l'utilisateur est authentifié
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  /// Vérifie l'authentification de l'utilisateur
  Future<void> _checkAuthentication() async {
    try {
      final isAuthenticated = await AuthService.isSessionValid();
      setState(() {
        _isAuthenticated = isAuthenticated;
        _checkingAuth = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _checkingAuth = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un indicateur de chargement pendant la vérification
    if (_checkingAuth) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Afficher le widget approprié selon l'état d'authentification
    return _isAuthenticated ? widget.child : widget.fallback;
  }
}