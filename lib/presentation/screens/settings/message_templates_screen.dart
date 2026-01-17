/// Message templates screen for managing invoice/receipt/reminder templates.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/message_template.dart';
import '../../../services/template_service.dart';

/// Screen to manage message templates for invoices, receipts, and reminders.
/// Each template type (Invoice, Receipt, Reminder) has exactly ONE editable template.
class MessageTemplatesScreen extends ConsumerWidget {
  const MessageTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Templates')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(context),
          const SizedBox(height: 16),
          _TemplateEditor(type: TemplateType.invoice),
          const SizedBox(height: 16),
          _TemplateEditor(type: TemplateType.receipt),
          const SizedBox(height: 16),
          _TemplateEditor(type: TemplateType.reminder),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.05),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Edit templates used for invoices, receipts, and reminders. '
                'Use placeholders like {tenantName}, {amount}, etc.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Editor card for a single template type
class _TemplateEditor extends ConsumerStatefulWidget {
  final TemplateType type;

  const _TemplateEditor({required this.type});

  @override
  ConsumerState<_TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends ConsumerState<_TemplateEditor> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _hasChanges = false;
  String _originalBody = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasChanges = _controller.text != _originalBody;
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  String _getTypeLabel() {
    return switch (widget.type) {
      TemplateType.invoice => 'Invoice',
      TemplateType.receipt => 'Receipt',
      TemplateType.reminder => 'Reminder',
    };
  }

  IconData _getTypeIcon() {
    return switch (widget.type) {
      TemplateType.invoice => Icons.description_outlined,
      TemplateType.receipt => Icons.receipt_outlined,
      TemplateType.reminder => Icons.notifications_outlined,
    };
  }

  Color _getTypeColor() {
    return switch (widget.type) {
      TemplateType.invoice => Colors.blue,
      TemplateType.receipt => Colors.green,
      TemplateType.reminder => Colors.orange,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templateAsync = ref.watch(defaultTemplateProvider(widget.type));
    final typeColor = _getTypeColor();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_getTypeIcon(), color: typeColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getTypeLabel()} Template',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Used when sharing ${_getTypeLabel().toLowerCase()}s',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          templateAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $e'),
            ),
            data: (template) {
              // Initialize controller with template body
              if (!_isEditing && template != null) {
                _controller.text = template.body;
                _originalBody = template.body;
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_isEditing) ...[
                      // Edit mode
                      TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Message Body',
                          alignLabelWithHint: true,
                          helperText:
                              'Placeholders: {tenantName}, {landlordName}, {amount}, {billType}, {period}, {dueDate}',
                          helperMaxLines: 2,
                        ),
                        maxLines: 8,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Action buttons
                      Row(
                        children: [
                          // Reset button
                          TextButton.icon(
                            onPressed: _hasChanges ? _resetToOriginal : null,
                            icon: const Icon(Icons.undo, size: 18),
                            label: const Text('Discard'),
                          ),
                          const Spacer(),
                          // Cancel button
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _controller.text = _originalBody;
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          // Save button
                          ElevatedButton.icon(
                            onPressed: _isSaving || !_hasChanges
                                ? null
                                : _saveTemplate,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.check, size: 18),
                            label: const Text('Save'),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Preview mode
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          template?.body ??
                              TemplateService.getDefaultBody(widget.type),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Action buttons
                      Row(
                        children: [
                          // Reset to default button
                          TextButton.icon(
                            onPressed: () =>
                                _confirmResetToDefault(template?.body),
                            icon: const Icon(Icons.restart_alt, size: 18),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.orange,
                            ),
                            label: const Text('Reset to Default'),
                          ),
                          const Spacer(),
                          // Edit button
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                                _controller.text =
                                    template?.body ??
                                    TemplateService.getDefaultBody(widget.type);
                                _originalBody = _controller.text;
                              });
                            },
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _resetToOriginal() {
    setState(() {
      _controller.text = _originalBody;
    });
  }

  void _confirmResetToDefault(String? currentBody) {
    final defaultBody = TemplateService.getDefaultBody(widget.type);
    if (currentBody == defaultBody) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template is already at default')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Default'),
        content: const Text(
          'This will replace your current template with the original default template. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _resetToDefault();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetToDefault() async {
    setState(() => _isSaving = true);
    try {
      final templateService = ref.read(templateServiceProvider);
      await templateService.resetToDefault(widget.type);
      ref.invalidate(defaultTemplateProvider(widget.type));
      ref.invalidate(messageTemplatesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Template reset to default')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveTemplate() async {
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(billingRepositoryProvider);
      final template = await ref.read(
        defaultTemplateProvider(widget.type).future,
      );

      if (template != null) {
        await repo.updateMessageTemplate(
          id: template.id,
          body: _controller.text,
        );
      }

      ref.invalidate(defaultTemplateProvider(widget.type));
      ref.invalidate(messageTemplatesProvider);

      if (mounted) {
        setState(() {
          _isEditing = false;
          _originalBody = _controller.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Template saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
