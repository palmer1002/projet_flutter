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
}