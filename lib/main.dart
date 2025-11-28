import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/product.dart';
import 'services/auth_service.dart';
import 'widgets/protected_route.dart';

// **********************************************
// *             CONFIGURATION THEME            *
// **********************************************

/// Classe de configuration du thème de l'application
class AppTheme {
  /// Couleur primaire de l'application (teal)
  static const Color primaryColor = Colors.teal;
  
  /// Couleur d'accent de l'application (orange)
  static const Color accentColor = Colors.orange;

  /// Configuration du thème minimaliste de l'application
  static ThemeData minimalist() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      fontFamily: 'Roboto',

      // Configuration de la barre d'application
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),

      // Configuration des boutons élevés
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Configuration des champs de saisie
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// **********************************************
// *                  MAIN APP                  *
// **********************************************

/// Point d'entrée principal de l'application
void main() => runApp(const MyApp());

/// Widget principal de l'application
class MyApp extends StatelessWidget {
  /// Constructeur avec clé optionnelle
  const MyApp({super.key});

  /// Construction de l'interface utilisateur de l'application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gestion Produits",
      theme: AppTheme.minimalist(),
      debugShowCheckedModeBanner: false,
      home: const MainApp(),
    );
  }
}

/// Widget principal de l'application avec gestion de l'authentification
class MainApp extends StatefulWidget {
  /// Constructeur avec clé optionnelle
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  /// Indique si l'application est en cours de chargement
  bool loading = true;
  
  /// Indique si l'écran d'inscription doit être affiché
  bool showRegister = false;

  /// Initialisation de l'état du widget
  @override
  void initState() {
    super.initState();
  }

  /// Fonction de connexion de l'utilisateur
  Future<void> _handleLogin() async {
    setState(() {});
  }

  /// Fonction de déconnexion de l'utilisateur
  Future<void> _handleLogout() async {
    await AuthService.logout();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ProtectedRoute(
      child: ProductListScreen(onLogout: _handleLogout),
      fallback: showRegister
          ? RegistrationScreen(
              onRegister: _handleLogin,
              onLoginPressed: () => setState(() => showRegister = false),
            )
          : LoginScreen(
              onLogin: _handleLogin,
              onRegisterPressed: () => setState(() => showRegister = true),
            ),
    );
  }
}