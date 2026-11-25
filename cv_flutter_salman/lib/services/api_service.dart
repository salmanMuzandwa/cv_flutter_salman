import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

// Apache sur 8080. Port 80 : http://localhost/api-test/public
// Emulateur Android : http://10.0.2.2:8080/api-test/public
// Telephone physique : http://ADRESSE_IP_LOCALE:8080/api-test/public
class ApiService {
  static const String baseUrl = 'http://localhost:8080/api-test/public';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<void> testerConnexion() async {
    await _send('/famille-membres', 'GET');
  }

  Future<void> seConnecter(String email, String password) async {
    await _send('/accounts/login', 'POST', {
      'email': email.trim(),
      'password': password.trim(),
    });
  }

  Future<List<FamilyMember>> getFamilyMembers() async {
    final response = await _send('/famille-membres', 'GET');
    final data = response['data'];
    if (data is! List) {
      throw const ApiException('La liste des membres est invalide.');
    }
    return data
        .map((item) => FamilyMember.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> ajouterMembre({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final data = _memberData(
      nom: nom,
      postnom: postnom,
      prenom: prenom,
      lieuNaissance: lieuNaissance,
      dateNaissance: dateNaissance,
      parente: parente,
    );
    if (imageBytes != null) {
      await _sendMultipart(
        '/famille-membres',
        'POST',
        data,
        imageBytes,
        imageName,
      );
    } else {
      await _send('/famille-membres', 'POST', data);
    }
  }

  Future<void> modifierMembre({
    required int id,
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final data = _memberData(
      nom: nom,
      postnom: postnom,
      prenom: prenom,
      lieuNaissance: lieuNaissance,
      dateNaissance: dateNaissance,
      parente: parente,
    );
    if (imageBytes != null) {
      await _sendMultipart(
        '/famille-membres/$id',
        'POST',
        data,
        imageBytes,
        imageName,
      );
    } else {
      await _send('/famille-membres/$id', 'PUT', data);
    }
  }

  Future<void> supprimerMembre(int id) async {
    await _send('/famille-membres/$id', 'DELETE');
  }

  Map<String, dynamic> _memberData({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
  }) {
    return {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance,
      'parente': parente.trim(),
    };
  }

  Future<Map<String, dynamic>> _sendMultipart(
    String path,
    String method,
    Map<String, dynamic> fields,
    Uint8List imageBytes,
    String? imageName,
  ) async {
    final request = http.MultipartRequest(method, Uri.parse('$baseUrl$path'));
    for (final entry in fields.entries) {
      request.fields[entry.key] = entry.value.toString();
    }
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: imageName ?? 'membre.jpg',
      ),
    );

    try {
      final response = await http.Response.fromStream(
        await _client.send(request),
      ).timeout(const Duration(seconds: 20));
      return _decodeResponse(response);
    } on TimeoutException {
      throw const ApiException(
        'Le serveur met trop de temps à répondre. Vérifiez XAMPP et l’adresse de l’API.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Impossible de joindre le serveur. Vérifiez XAMPP, le port et l’adresse de l’API.',
      );
    } on FormatException {
      throw const ApiException('La réponse du serveur est invalide.');
    }
  }

  Future<Map<String, dynamic>> _send(
    String path,
    String method, [
    Map<String, dynamic>? body,
  ]) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = {'Content-Type': 'application/json; charset=utf-8'};

    try {
      final response = await (switch (method) {
        'GET' => _client.get(uri, headers: headers),
        'POST' => _client.post(uri, headers: headers, body: jsonEncode(body)),
        'PUT' => _client.put(uri, headers: headers, body: jsonEncode(body)),
        'DELETE' => _client.delete(uri, headers: headers),
        _ => throw ArgumentError.value(
          method,
          'method',
          'Méthode non prise en charge',
        ),
      }).timeout(const Duration(seconds: 20));
      return _decodeResponse(response);
    } on TimeoutException {
      throw const ApiException(
        'Le serveur met trop de temps à répondre. Vérifiez XAMPP et l’adresse de l’API.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Impossible de joindre le serveur. Vérifiez XAMPP, le port et l’adresse de l’API.',
      );
    } on FormatException {
      throw const ApiException('La réponse du serveur est invalide.');
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final Map<String, dynamic> payload;
    try {
      payload = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw const ApiException('La réponse du serveur est invalide.');
    } on TypeError {
      throw const ApiException('La réponse du serveur est invalide.');
    }

    final isSuccessful =
        response.statusCode >= 200 && response.statusCode < 300;
    if (!isSuccessful || payload['success'] != true) {
      final message = payload['message'];
      throw ApiException(
        message is String && message.isNotEmpty
            ? message
            : 'Erreur HTTP ${response.statusCode}.',
      );
    }

    return payload;
  }
}

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class FamilyMember {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String? imageUrl;
  final String parente;

  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.imageUrl,
    required this.parente,
  });

  String get fullName => '$nom $postnom $prenom'.trim();

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as int,
      nom: _requiredString(json, 'nom'),
      postnom: _requiredString(json, 'postnom'),
      prenom: _requiredString(json, 'prenom'),
      lieuNaissance: _requiredString(json, 'lieu_naissance'),
      dateNaissance: _requiredString(json, 'date_naissance'),
      imageUrl: json['image_url'] as String?,
      parente: _requiredString(json, 'parente'),
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw const ApiException('Une donnée du membre est invalide.');
  }
  return value;
}
