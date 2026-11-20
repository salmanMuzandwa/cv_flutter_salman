// Test de fumée basique de l'application CV.
import 'package:flutter_test/flutter_test.dart';

import 'package:cv_flutter_salman/main.dart';

void main() {
  testWidgets('L\'application affiche la page de connexion',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CvApp());

    // Vérifier que la page de connexion est affichée
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
