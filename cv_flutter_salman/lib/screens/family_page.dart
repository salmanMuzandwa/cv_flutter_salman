import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../services/api_service.dart';

class FamilyPage extends StatefulWidget {
  final ApiService? apiService;
  final ImagePicker? imagePicker;

  const FamilyPage({super.key, this.apiService, this.imagePicker});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late final ApiService _apiService;
  late final ImagePicker _imagePicker;
  late Future<List<FamilyMember>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _imagePicker = widget.imagePicker ?? ImagePicker();
    _membersFuture = _apiService.getFamilyMembers();
  }

  void _reload() {
    setState(() {
      _membersFuture = _apiService.getFamilyMembers();
    });
  }

  Future<void> _openMemberForm({FamilyMember? member}) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _MemberFormDialog(
        apiService: _apiService,
        imagePicker: _imagePicker,
        member: member,
      ),
    );
    if (!mounted || saved != true) return;

    _reload();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          member == null
              ? 'Membre ajouté avec succès.'
              : 'Membre modifié avec succès.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDelete(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text(
          'Voulez-vous vraiment supprimer ${member.fullName} ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    try {
      await _apiService.supprimerMembre(member.id);
      if (!mounted) return;
      _reload();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membre supprimé avec succès.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    } catch (_) {
      if (mounted) _showError('Impossible de supprimer ce membre.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openDetails(FamilyMember member) async {
    final shouldEdit = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _MemberDetailsPage(member: member)),
    );
    if (!mounted || shouldEdit != true) return;

    await _openMemberForm(member: member);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _openMemberForm(),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: FutureBuilder<List<FamilyMember>>(
        future: _membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      error is ApiException
                          ? error.message
                          : 'Impossible de charger les membres de famille.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final members = snapshot.data ?? const <FamilyMember>[];
          if (members.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.family_restroom_outlined,
                      size: 56,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Aucun membre de famille enregistré.\nAppuyez sur « Ajouter » pour commencer.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: members.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final member = members[index];
              return _FamilyMemberCard(
                member: member,
                onTap: () => _openDetails(member),
                onEdit: () => _openMemberForm(member: member),
                onDelete: () => _confirmDelete(member),
              );
            },
          );
        },
      ),
    );
  }
}

enum _MemberAction { edit, delete }

class _FamilyMemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FamilyMemberCard({
    required this.member,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          member.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
        trailing: PopupMenuButton<_MemberAction>(
          tooltip: 'Actions',
          onSelected: (action) {
            switch (action) {
              case _MemberAction.edit:
                onEdit();
              case _MemberAction.delete:
                onDelete();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: _MemberAction.edit,
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Modifier'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: _MemberAction.delete,
              child: ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Supprimer'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberDetailsPage extends StatelessWidget {
  final FamilyMember member;

  const _MemberDetailsPage({required this.member});

  @override
  Widget build(BuildContext context) {
    final initials = '${member.prenom[0]}${member.nom[0]}'.toUpperCase();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du membre'),
        actions: [
          IconButton(
            tooltip: 'Modifier le membre',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: member.imageUrl == null
                  ? Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : ClipOval(
                      child: Image.network(
                        member.imageUrl!,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Text(initials),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              member.fullName,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  _DetailRow(label: 'Nom', value: member.nom),
                  _DetailRow(label: 'Postnom', value: member.postnom),
                  _DetailRow(label: 'Prénom', value: member.prenom),
                  _DetailRow(label: 'Parenté', value: member.parente),
                  _DetailRow(
                    label: 'Lieu de naissance',
                    value: member.lieuNaissance,
                  ),
                  _DetailRow(
                    label: 'Date de naissance',
                    value: member.dateNaissance,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _MemberFormDialog extends StatefulWidget {
  final ApiService apiService;
  final ImagePicker imagePicker;
  final FamilyMember? member;

  const _MemberFormDialog({
    required this.apiService,
    required this.imagePicker,
    this.member,
  });

  @override
  State<_MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends State<_MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _postnomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _lieuController;
  late final TextEditingController _dateController;
  late final TextEditingController _parenteController;
  Uint8List? _imageBytes;
  String? _imageName;
  bool _isPickingImage = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    _nomController = TextEditingController(text: member?.nom);
    _postnomController = TextEditingController(text: member?.postnom);
    _prenomController = TextEditingController(text: member?.prenom);
    _lieuController = TextEditingController(text: member?.lieuNaissance);
    _dateController = TextEditingController(text: member?.dateNaissance);
    _parenteController = TextEditingController(text: member?.parente);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _postnomController.dispose();
    _prenomController.dispose();
    _lieuController.dispose();
    _dateController.dispose();
    _parenteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isSaving || _isPickingImage) return;

    setState(() {
      _isPickingImage = true;
      _errorMessage = null;
    });

    try {
      final image = await widget.imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (!mounted || image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      if (bytes.length > 2 * 1024 * 1024) {
        setState(() {
          _errorMessage = 'L’image ne doit pas dépasser 2 Mo.';
        });
        return;
      }

      setState(() {
        _imageBytes = bytes;
        _imageName = image.name;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de sélectionner cette image.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final currentDate = DateTime.tryParse(_dateController.text) ?? today;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate.isAfter(today) ? today : currentDate,
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: 'Date de naissance',
    );
    if (!mounted || selectedDate == null) return;
    _dateController.text = _formatDate(selectedDate);
  }

  Future<void> _save() async {
    if (_isSaving || !(_formKey.currentState?.validate() ?? false)) return;
    final dialogContext = context;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      if (widget.member == null) {
        await widget.apiService.ajouterMembre(
          nom: _nomController.text,
          postnom: _postnomController.text,
          prenom: _prenomController.text,
          lieuNaissance: _lieuController.text,
          dateNaissance: _dateController.text,
          parente: _parenteController.text,
          imageBytes: _imageBytes,
          imageName: _imageName,
        );
      } else {
        await widget.apiService.modifierMembre(
          id: widget.member!.id,
          nom: _nomController.text,
          postnom: _postnomController.text,
          prenom: _prenomController.text,
          lieuNaissance: _lieuController.text,
          dateNaissance: _dateController.text,
          parente: _parenteController.text,
          imageBytes: _imageBytes,
          imageName: _imageName,
        );
      }

      if (!dialogContext.mounted) return;
      Navigator.pop(dialogContext, true);
    } on ApiException catch (error) {
      if (dialogContext.mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (dialogContext.mounted) {
        setState(() => _errorMessage = 'Impossible d’enregistrer ce membre.');
      }
    } finally {
      if (dialogContext.mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.member != null;

    return PopScope(
      canPop: !_isSaving,
      child: AlertDialog(
        title: Text(isEditing ? 'Modifier le membre' : 'Ajouter un membre'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildImageField(),
                  const SizedBox(height: 18),
                  _buildField(label: 'Nom', controller: _nomController),
                  const SizedBox(height: 12),
                  _buildField(label: 'Postnom', controller: _postnomController),
                  const SizedBox(height: 12),
                  _buildField(label: 'Prénom', controller: _prenomController),
                  const SizedBox(height: 12),
                  _buildField(
                    label: 'Lieu de naissance',
                    controller: _lieuController,
                    maxLength: 100,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dateController,
                    enabled: !_isSaving,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date de naissance',
                      hintText: 'AAAA-MM-JJ',
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                    validator: (value) =>
                        _validateRequired(value, 'La date de naissance', 10),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  _buildField(label: 'Parenté', controller: _parenteController),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEditing ? 'Enregistrer' : 'Ajouter'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageField() {
    final member = widget.member;
    final existingImageUrl = member?.imageUrl;
    final hasImage =
        _imageBytes != null || (existingImageUrl?.isNotEmpty ?? false);
    final initials = member == null
        ? ''
        : '${member.prenom[0]}${member.nom[0]}'.toUpperCase();

    return Column(
      children: [
        SizedBox(
          width: 112,
          height: 112,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.light,
                ),
                child: _imageBytes != null
                    ? Image.memory(
                        _imageBytes!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _buildImageFallback(initials),
                      )
                    : existingImageUrl?.isNotEmpty == true
                    ? Image.network(
                        existingImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _buildImageFallback(initials),
                      )
                    : _buildImageFallback(initials),
              ),
              if (_isPickingImage)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black38,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _isSaving || _isPickingImage ? null : _pickImage,
          icon: Icon(
            hasImage
                ? Icons.photo_camera_outlined
                : Icons.add_photo_alternate_outlined,
          ),
          label: Text(hasImage ? 'Modifier l’image' : 'Ajouter une image'),
        ),
        const SizedBox(height: 6),
        Text(
          'JPG, PNG, GIF ou WebP — 2 Mo maximum.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildImageFallback(String initials) {
    return Center(
      child: initials.isEmpty
          ? const Icon(Icons.person_outline, size: 52, color: AppColors.primary)
          : Text(
              initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    int maxLength = 50,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_isSaving,
      maxLength: maxLength,
      decoration: InputDecoration(labelText: label),
      validator: (value) => _validateRequired(value, label, maxLength),
    );
  }

  String? _validateRequired(String? value, String label, int maxLength) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label est obligatoire.';
    if (text.length > maxLength) {
      return '$label ne doit pas dépasser $maxLength caractères.';
    }
    return null;
  }
}

String _formatDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
