import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service d'authentification sécurisé
class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _sessionTokenKey = 'session_token';

  /// Génère un hash SHA-256 pour un mot de passe
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Génère un token de session aléatoire
  static String _generateSessionToken() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(random);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Enregistre un nouvel utilisateur
  static Future<bool> registerUser(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Vérifier si l'utilisateur existe déjà
      final usersString = prefs.getString(_usersKey) ?? '{}';
      final users = Map<String, dynamic>.from(json.decode(usersString));
      
      if (users.containsKey(email)) {
        return false; // L'utilisateur existe déjà
      }
      
      // Hasher le mot de passe
      final hashedPassword = _hashPassword(password);
      
      // Enregistrer l'utilisateur
      users[email] = hashedPassword;
      await prefs.setString(_usersKey, json.encode(users));
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Authentifie un utilisateur
  static Future<bool> loginUser(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Récupérer les utilisateurs
      final usersString = prefs.getString(_usersKey) ?? '{}';
      final users = Map<String, dynamic>.from(json.decode(usersString));
      
      // Vérifier si l'utilisateur existe
      if (!users.containsKey(email)) {
        return false;
      }
      
      // Vérifier le mot de passe
      final hashedPassword = _hashPassword(password);
      if (users[email] == hashedPassword) {
        // Générer un token de session
        final sessionToken = _generateSessionToken();
        
        // Enregistrer l'utilisateur courant et le token de session
        await prefs.setString(_currentUserKey, email);
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_sessionTokenKey, sessionToken);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Déconnecte l'utilisateur
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_sessionTokenKey);
  }

  /// Vérifie si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Récupère l'email de l'utilisateur courant
  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  /// Vérifie la validité de la session
  static Future<bool> isSessionValid() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Vérifier si l'utilisateur est connecté
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    if (!isLoggedIn) {
      return false;
    }
    
    // Vérifier si le token de session existe
    final sessionToken = prefs.getString(_sessionTokenKey);
    return sessionToken != null;
  }
}