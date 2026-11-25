import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:cv_flutter_salman/constants.dart';
import 'package:cv_flutter_salman/main.dart';
import 'package:cv_flutter_salman/screens/contact_page.dart';
import 'package:cv_flutter_salman/screens/family_page.dart';
import 'package:cv_flutter_salman/services/api_service.dart';

void main() {
  testWidgets('L’application affiche la page de connexion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MonCvApp());

    expect(find.text('CV - Chuma Salman'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  test('La connexion ignore les espaces autour des identifiants', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api-test/public/accounts/login');
      expect(jsonDecode(request.body), {
        'email': 'chumasalman0@gmail.com',
        'password': 'GOMA2026',
      });
      return http.Response(
        '{"success":true,"message":"Connexion réussie"}',
        200,
      );
    });
    addTearDown(client.close);

    final service = ApiService(client: client);
    await service.seConnecter(' chumasalman0@gmail.com ', ' GOMA2026 ');
  });

  testWidgets('La carte affiche le nom et ouvre les détails', (tester) async {
    final member = {
      'id': 1,
      'nom': 'Test',
      'postnom': 'Automatise',
      'prenom': 'TP2',
      'lieu_naissance': 'Goma',
      'date_naissance': '2004-12-09',
      'image': null,
      'image_url': null,
      'parente': 'Frère',
    };
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      return http.Response(
        jsonEncode({
          'success': true,
          'data': [member],
        }),
        200,
      );
    });
    addTearDown(client.close);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FamilyPage(apiService: ApiService(client: client)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Automatise TP2'), findsOneWidget);
    expect(find.text('Goma'), findsNothing);
    expect(find.text('2004-12-09'), findsNothing);
    expect(find.text('Frère'), findsNothing);

    final addButton = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(addButton.backgroundColor, AppColors.primary);
    expect(addButton.foregroundColor, Colors.white);

    await tester.tap(find.text('Test Automatise TP2'));
    await tester.pumpAndSettle();

    expect(find.text('Détails du membre'), findsOneWidget);
    expect(find.text('Goma'), findsOneWidget);
    expect(find.text('2004-12-09'), findsOneWidget);
    expect(find.text('Frère'), findsOneWidget);
    expect(find.byTooltip('Modifier le membre'), findsOneWidget);

    await tester.tap(find.byTooltip('Modifier le membre'));
    await tester.pumpAndSettle();

    expect(find.text('Modifier le membre'), findsOneWidget);
    final fields = find.byType(TextFormField);
    expect(tester.widget<TextFormField>(fields.at(0)).controller!.text, 'Test');
    expect(
      tester.widget<TextFormField>(fields.at(1)).controller!.text,
      'Automatise',
    );
    expect(tester.widget<TextFormField>(fields.at(2)).controller!.text, 'TP2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('L’ajout d’un membre recharge la liste sans erreur', (
    tester,
  ) async {
    final members = <Map<String, dynamic>>[];
    final client = MockClient((request) async {
      if (request.method == 'GET') {
        return http.Response(
          jsonEncode({'success': true, 'data': members}),
          200,
        );
      }
      if (request.method == 'POST') {
        final data = jsonDecode(request.body) as Map<String, dynamic>;
        members.add({'id': 1, ...data, 'image': null, 'image_url': null});
        return http.Response(
          jsonEncode({
            'success': true,
            'message': 'Membre créé',
            'data': members.single,
          }),
          201,
        );
      }
      throw StateError('Requête inattendue : ${request.method}');
    });
    addTearDown(client.close);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FamilyPage(apiService: ApiService(client: client)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Test');
    await tester.enterText(fields.at(1), 'Automatise');
    await tester.enterText(fields.at(2), 'TP2');
    await tester.enterText(fields.at(3), 'Goma');
    await tester.tap(fields.at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(5), 'Frère');

    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter'));
    await tester.pumpAndSettle();

    expect(find.text('Test Automatise TP2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Les coordonnées sont affichées avant toute redirection', (
    tester,
  ) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final launches = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          launches.add(call);
          return true;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ContactPage())),
    );

    final fields = <({String title, String value, String action})>[
      (title: 'Téléphone', value: CvData.phone, action: 'Appeler'),
      (title: 'E-mail', value: CvData.email, action: 'Envoyer'),
      (title: 'Adresse', value: CvData.location, action: 'Ouvrir la carte'),
      (title: 'LinkedIn', value: CvData.linkedinUrl, action: 'Ouvrir LinkedIn'),
      (title: 'GitHub', value: CvData.githubUrl, action: 'Ouvrir GitHub'),
    ];

    for (final field in fields) {
      await tester.ensureVisible(find.text(field.title));
      await tester.tap(find.text(field.title));
      await tester.pumpAndSettle();

      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      expect(
        find.descendant(of: dialog, matching: find.text(field.title)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.text(field.value)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.text(field.action)),
        findsOneWidget,
      );
      expect(launches, isEmpty);

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(launches, isEmpty);
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('Les informations personnelles sont visibles avant de fermer', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ContactPage())),
    );

    await tester.ensureVisible(find.text('Personal information'));
    await tester.tap(find.text('Personal information'));
    await tester.pumpAndSettle();

    final dialog = find.byType(AlertDialog);
    expect(dialog, findsOneWidget);
    expect(
      find.descendant(
        of: dialog,
        matching: find.text('${CvData.name}\n${CvData.title}'),
      ),
      findsOneWidget,
    );
    expect(find.text('Fermer'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);

    await tester.tap(find.text('Fermer'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Une action de contact est lancée après confirmation', (
    tester,
  ) async {
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final launches = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          launches.add(call);
          return true;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ContactPage())),
    );

    await tester.ensureVisible(find.text('Téléphone'));
    await tester.tap(find.text('Téléphone'));
    await tester.pumpAndSettle();
    expect(launches, isEmpty);

    await tester.tap(find.text('Appeler'));
    await tester.pumpAndSettle();

    expect(launches, hasLength(1));
    expect(launches.single.method, 'launch');
    expect(launches.single.arguments['url'], 'tel:${CvData.phoneUri}');
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
