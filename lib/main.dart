import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/product.dart';



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
      home: const AuthWrapper(),
    );
  }
}


/// Widget wrapper pour gérer l'authentification
class AuthWrapper extends StatefulWidget {
  /// Constructeur avec clé optionnelle
  const AuthWrapper({super.key});

  /// Création de l'état du widget
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

/// État du wrapper d'authentification
class _AuthWrapperState extends State<AuthWrapper> {
  /// Indique si l'utilisateur est connecté
  bool isLogged = false;
  
  /// Indique si l'application est en cours de chargement
  bool loading = true;
  
  /// Indique si l'écran d'inscription doit être affiché
  bool showRegister = false;

  /// Initialisation de l'état du widget
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  /// Vérification de l'état de connexion de l'utilisateur
  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    isLogged = prefs.getBool("isLogged") ?? false;
    loading = false;
    setState(() {});
  }

  /// Fonction de connexion de l'utilisateur
  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogged", true);
    setState(() => isLogged = true);
  }

  /// Fonction de déconnexion de l'utilisateur
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogged", false);
    setState(() => isLogged = false);
  }

  /// Construction de l'interface utilisateur en fonction de l'état d'authentification
  @override
  Widget build(BuildContext context) {
    // Affichage d'un indicateur de chargement pendant la vérification
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      );
    }

    // Affichage de l'écran de produits si l'utilisateur est connecté
    if (isLogged) {
      return ProductListScreen(onLogout: _logout);
    }

    // Affichage de l'écran d'inscription ou de connexion
    return showRegister
        ? RegistrationScreen(
            onRegister: _login,
            onLoginPressed: () => setState(() => showRegister = false),
          )
        : LoginScreen(
            onLogin: _login,
            onRegisterPressed: () => setState(() => showRegister = true),
          );
  }
}