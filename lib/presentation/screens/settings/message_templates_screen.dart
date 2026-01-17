/// Message templates screen for managing invoice/receipt/reminder templates.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/message_template.dart';

/// Screen to manage message templates for invoices, receipts, and reminders.
class MessageTemplatesScreen extends ConsumerStatefulWidget {
  const MessageTemplatesScreen({super.key});

  @override
  ConsumerState<MessageTemplatesScreen> createState() =>
      _MessageTemplatesScreenState();
}

class _MessageTemplatesScreenState extends ConsumerState<MessageTemplatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Templates'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Invoice'),
            Tab(text: 'Receipt'),
            Tab(text: 'Reminder'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TemplateList(type: TemplateType.invoice),
          _TemplateList(type: TemplateType.receipt),
          _TemplateList(type: TemplateType.reminder),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTemplateDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Template'),
      ),
    );
  }

  void _showAddTemplateDialog(BuildContext context) {
    final type = TemplateType.values[_tabController.index];
    showDialog(
      context: context,
      builder: (context) => _TemplateDialog(
        templateType: type,
        onSave: (name, body, isDefault) async {
          final repo = ref.read(billingRepositoryProvider);
          await repo.createMessageTemplate(
            templateType: type,
            name: name,
            body: body,
            isDefault: isDefault,
          );
          ref.invalidate(messageTemplatesProvider);
          ref.invalidate(messageTemplatesByTypeProvider(type));
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
}

/// List of templates for a specific type.
class _TemplateList extends ConsumerWidget {
  final TemplateType type;

  const _TemplateList({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(messageTemplatesByTypeProvider(type));

    return templatesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (templates) {
        if (templates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${type.name} templates yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to create one',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            final template = templates[index];
            return _TemplateCard(template: template, type: type);
          },
        );
      },
    );
  }
}

/// Card displaying a single template.
class _TemplateCard extends ConsumerWidget {
  final MessageTemplate template;
  final TemplateType type;

  const _TemplateCard({required this.template, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showEditDialog(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (template.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'DEFAULT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(context, ref);
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref);
                      } else if (value == 'default') {
                        _setAsDefault(ref);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      if (!template.isDefault)
                        const PopupMenuItem(
                          value: 'default',
                          child: ListTile(
                            leading: Icon(Icons.star),
                            title: Text('Set as Default'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  template.body.length > 150
                      ? '${template.body.substring(0, 150)}...'
                      : template.body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Created: ${_formatDate(template.createdAt)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _TemplateDialog(
        templateType: type,
        existingTemplate: template,
        onSave: (name, body, isDefault) async {
          final repo = ref.read(billingRepositoryProvider);
          await repo.updateMessageTemplate(
            id: template.id,
            name: name,
            body: body,
            isDefault: isDefault,
          );
          ref.invalidate(messageTemplatesProvider);
          ref.invalidate(messageTemplatesByTypeProvider(type));
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Are you sure you want to delete "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final repo = ref.read(billingRepositoryProvider);
              await repo.deleteMessageTemplate(template.id);
              ref.invalidate(messageTemplatesProvider);
              ref.invalidate(messageTemplatesByTypeProvider(type));
              if (context.mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(WidgetRef ref) async {
    final repo = ref.read(billingRepositoryProvider);
    await repo.updateMessageTemplate(id: template.id, isDefault: true);
    ref.invalidate(messageTemplatesProvider);
    ref.invalidate(messageTemplatesByTypeProvider(type));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Dialog for creating/editing templates.
class _TemplateDialog extends StatefulWidget {
  final TemplateType templateType;
  final MessageTemplate? existingTemplate;
  final Future<void> Function(String name, String body, bool isDefault) onSave;

  const _TemplateDialog({
    required this.templateType,
    this.existingTemplate,
    required this.onSave,
  });

  @override
  State<_TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<_TemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bodyController;
  late bool _isDefault;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingTemplate?.name ?? '',
    );
    _bodyController = TextEditingController(
      text: widget.existingTemplate?.body ?? _getDefaultBody(),
    );
    _isDefault = widget.existingTemplate?.isDefault ?? false;
  }

  String _getDefaultBody() {
    switch (widget.templateType) {
      case TemplateType.invoice:
        return '''Dear {tenantName},

Your invoice is ready!

Type: {billType}
Period: {period}
Amount: ₹{amount}
Due Date: {dueDate}

Please pay at your earliest convenience.

Thank you,
{landlordName}''';
      case TemplateType.receipt:
        return '''Dear {tenantName},

Payment Received!

Amount: ₹{amount}
Mode: {paymentMode}

Bill: {billType} - {period}
Status: Paid

Thank you,
{landlordName}''';
      case TemplateType.reminder:
        return '''Dear {tenantName},

This is a reminder for your pending bill.

Type: {billType}
Period: {period}
Pending: ₹{amount}
Due Date: {dueDate}

Please make the payment soon.

Thank you,
{landlordName}''';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTemplate != null;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Text(
                  isEditing
                      ? 'Edit Template'
                      : 'New ${widget.templateType.name.toUpperCase()} Template',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              // Form
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Template Name',
                          hintText: 'e.g., Standard Invoice',
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          labelText: 'Message Body',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 10,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Body is required' : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Available placeholders: {tenantName}, {landlordName}, {billType}, '
                        '{period}, {amount}, {dueDate}, {billNumber}, {roomNumber}, {paymentMode}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _isDefault,
                        onChanged: (v) =>
                            setState(() => _isDefault = v ?? false),
                        title: const Text('Set as default template'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              isEditing ? 'Save Changes' : 'Create Template',
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await widget.onSave(
        _nameController.text,
        _bodyController.text,
        _isDefault,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
