import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Écran d'inscription de l'application
class RegistrationScreen extends StatefulWidget {
  /// Fonction de rappel lors de l'inscription
  final Function onRegister;
  
  /// Fonction de rappel lors du clic sur le bouton de connexion
  final Function onLoginPressed;

  /// Constructeur de l'écran d'inscription
  const RegistrationScreen({
    super.key,
    required this.onRegister,
    required this.onLoginPressed,
  });

  /// Création de l'état du widget
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

/// État de l'écran d'inscription
class _RegistrationScreenState extends State<RegistrationScreen> {
  /// Contrôleur pour le champ nom complet
  final nameCtrl = TextEditingController();
  
  /// Contrôleur pour le champ email
  final emailCtrl = TextEditingController();
  
  /// Contrôleur pour le champ mot de passe
  final passCtrl = TextEditingController();
  
  /// Indique si l'inscription est en cours
  bool isLoading = false;
  
  /// Message d'erreur
  String errorMessage = '';

  /// Fonction d'inscription sécurisée
  Future<void> _handleRegister() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Valider les champs
      if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
        setState(() {
          errorMessage = 'Veuillez remplir tous les champs';
          isLoading = false;
        });
        return;
      }

      // Valider le format de l'email
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailCtrl.text)) {
        setState(() {
          errorMessage = 'Veuillez entrer un email valide';
          isLoading = false;
        });
        return;
      }

      // Valider la longueur du mot de passe
      if (passCtrl.text.length < 6) {
        setState(() {
          errorMessage = 'Le mot de passe doit contenir au moins 6 caractères';
          isLoading = false;
        });
        return;
      }

      // Tenter d'enregistrer l'utilisateur
      final success = await AuthService.registerUser(emailCtrl.text.trim(), passCtrl.text);
      
      if (success) {
        // Inscription réussie
        widget.onRegister();
      } else {
        // L'utilisateur existe déjà
        setState(() {
          errorMessage = 'Cet email est déjà utilisé';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Une erreur est survenue lors de l\'inscription';
        isLoading = false;
      });
    }
  }

  /// Construction de l'interface utilisateur de l'écran d'inscription
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titre de l'écran
            const Text(
              "Créer un compte",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 30),

            // Message d'erreur
            if (errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),

            // Champ de saisie pour le nom complet
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nom complet",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 12),

            // Champ de saisie pour l'email
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 12),

            // Champ de saisie pour le mot de passe
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: Icon(Icons.lock),
              ),
              onSubmitted: (_) => _handleRegister(), // Inscription avec Entrée
            ),

            const SizedBox(height: 20),

            // Bouton d'inscription
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleRegister,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Créer mon compte"),
              ),
            ),

            const SizedBox(height: 10),

            // Bouton pour accéder à la connexion
            TextButton(
              onPressed: () => widget.onLoginPressed(),
              child: const Text("J'ai déjà un compte"),
            ),
          ],
        ),
      ),
    );
  }

  /// Libération des ressources
  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}