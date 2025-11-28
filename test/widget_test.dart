// Ceci est un test de base pour les widgets Flutter.
//
// Pour effectuer une interaction avec un widget dans votre test, utilisez le WidgetTester
// dans le package flutter_test. Par exemple, vous pouvez envoyer des gestes tactiles et de défilement.
// Vous pouvez aussi utiliser WidgetTester pour trouver des widgets enfants dans l'arbre des widgets,
// lire du texte, et vérifier que les valeurs des propriétés des widgets sont correctes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:projet_flutter/main.dart';
import 'package:projet_flutter/services/auth_service.dart';

void main() {
  setUp(() async {
    // Nettoyer les préférences partagées avant chaque test
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('LoginScreen s\'affiche correctement', (WidgetTester tester) async {
    // Construire notre application et déclencher un frame.
    await tester.pumpWidget(const MyApp());
    
    // Attendre que l'application se charge
    await tester.pumpAndSettle();

    // Vérifier que le titre de la page de connexion est affiché.
    expect(find.text('Connexion'), findsOneWidget);
    
    // Vérifier que les champs de connexion sont présents.
    expect(find.byType(TextField), findsNWidgets(2));
    
    // Vérifier que le bouton de connexion est présent.
    expect(find.text('Se connecter'), findsOneWidget);
    
    // Vérifier que le lien d'inscription est présent.
    expect(find.text('Créer un compte'), findsOneWidget);
  });
  
  testWidgets('RegistrationScreen s\'affiche après clic sur Créer un compte', (WidgetTester tester) async {
    // Construire notre application et déclencher un frame.
    await tester.pumpWidget(const MyApp());
    
    // Attendre que l'application se charge
    await tester.pumpAndSettle();
    
    // Cliquer sur le lien d'inscription
    await tester.tap(find.text('Créer un compte'));
    
    // Attendre la fin de l'animation
    await tester.pumpAndSettle();
    
    // Vérifier que le titre de la page d'inscription est affiché.
    expect(find.text('Créer un compte'), findsOneWidget);
    
    // Vérifier que les champs d'inscription sont présents.
    expect(find.byType(TextField), findsNWidgets(3));
    
    // Vérifier que le bouton d'inscription est présent.
    expect(find.text('Créer mon compte'), findsOneWidget);
    
    // Vérifier que le lien de connexion est présent.
    expect(find.text('J\'ai déjà un compte'), findsOneWidget);
  });
  
  testWidgets('ProductListScreen s\'affiche après inscription', (WidgetTester tester) async {
    // Construire notre application et déclencher un frame.
    await tester.pumpWidget(const MyApp());
    
    // Attendre que l'application se charge
    await tester.pumpAndSettle();
    
    // Cliquer sur le lien d'inscription
    await tester.tap(find.text('Créer un compte'));
    
    // Attendre la fin de l'animation
    await tester.pumpAndSettle();
    
    // Remplir les champs d'inscription
    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    
    // Cliquer sur le bouton d'inscription
    await tester.tap(find.text('Créer mon compte'));
    
    // Attendre la fin de l'opération d'inscription
    await tester.pumpAndSettle();
    
    // Vérifier que le titre de la page des produits est affiché.
    expect(find.text('Liste des Produits'), findsOneWidget);
    
    // Vérifier que le bouton d'ajout flottant est présent.
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
  
  testWidgets('Login avec identifiants valides', (WidgetTester tester) async {
    // Enregistrer un utilisateur de test
    await AuthService.registerUser('test@example.com', 'password123');
    
    // Construire notre application et déclencher un frame.
    await tester.pumpWidget(const MyApp());
    
    // Attendre que l'application se charge
    await tester.pumpAndSettle();
    
    // Remplir les champs de connexion
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    
    // Cliquer sur le bouton de connexion
    await tester.tap(find.text('Se connecter'));
    
    // Attendre la fin de l'opération de connexion
    await tester.pumpAndSettle();
    
    // Vérifier que le titre de la page des produits est affiché.
    expect(find.text('Liste des Produits'), findsOneWidget);
  });
  
  testWidgets('Login avec identifiants invalides', (WidgetTester tester) async {
    // Construire notre application et déclencher un frame.
    await tester.pumpWidget(const MyApp());
    
    // Attendre que l'application se charge
    await tester.pumpAndSettle();
    
    // Remplir les champs de connexion avec des identifiants invalides
    await tester.enterText(find.byType(TextField).at(0), 'invalid@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrongpassword');
    
    // Cliquer sur le bouton de connexion
    await tester.tap(find.text('Se connecter'));
    
    // Attendre la fin de l'opération de connexion
    await tester.pumpAndSettle();
    
    // Vérifier que le message d'erreur est affiché
    expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
  });
  
  testWidgets('Accès refusé sans authentification', (WidgetTester tester) async {
    // Simuler une session invalide
    await AuthService.logout();
    
    // Construire notre application et déclencher un frame.
    await tester.pumpWidget(const MyApp());
    
    // Attendre que l'application se charge
    await tester.pumpAndSettle();
    
    // Vérifier que l'écran de connexion est affiché (pas l'écran des produits)
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Liste des Produits'), findsNothing);
  });
}