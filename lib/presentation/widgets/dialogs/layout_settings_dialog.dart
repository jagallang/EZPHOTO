import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../domain/entities/layout_config.dart';

/// Dialog for configuring layout settings
class LayoutSettingsDialog extends StatefulWidget {
  final LayoutConfig initialConfig;
  final Function(LayoutConfig) onConfigChanged;

  const LayoutSettingsDialog({
    super.key,
    required this.initialConfig,
    required this.onConfigChanged,
  });

  @override
  State<LayoutSettingsDialog> createState() => _LayoutSettingsDialogState();

  static Future<void> show(
    BuildContext context,
    LayoutConfig initialConfig,
    Function(LayoutConfig) onConfigChanged,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => LayoutSettingsDialog(
        initialConfig: initialConfig,
        onConfigChanged: onConfigChanged,
      ),
    );
  }
}

class _LayoutSettingsDialogState extends State<LayoutSettingsDialog> {
  late LayoutConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('layout_settings'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _GridSizeSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
            const SizedBox(height: 20),
            _SpacingSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
            const SizedBox(height: 20),
            _BorderSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
            const SizedBox(height: 20),
            _PageNumberSection(
              config: _config,
              onConfigChanged: (config) => setState(() => _config = config),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfigChanged(_config);
            Navigator.pop(context);
          },
          child: Text('apply'.tr()),
        ),
      ],
    );
  }
}

class _GridSizeSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _GridSizeSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'grid_size'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _NumberSelector(
                label: 'columns'.tr(),
                value: config.columns,
                min: 1,
                max: 4,
                onChanged: (value) => onConfigChanged(
                  config.copyWith(columns: value),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _NumberSelector(
                label: 'rows'.tr(),
                value: config.rows,
                min: 1,
                max: 4,
                onChanged: (value) => onConfigChanged(
                  config.copyWith(rows: value),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SpacingSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _SpacingSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'spacing'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: config.spacing,
          min: 0,
          max: 20,
          divisions: 20,
          label: config.spacing.round().toString(),
          onChanged: (value) => onConfigChanged(
            config.copyWith(spacing: value),
          ),
        ),
      ],
    );
  }
}

class _BorderSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _BorderSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'border_width'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Slider(
          value: config.borderWidth,
          min: 0,
          max: 5,
          divisions: 10,
          label: config.borderWidth.toString(),
          onChanged: (value) => onConfigChanged(
            config.copyWith(borderWidth: value),
          ),
        ),
      ],
    );
  }
}

class _PageNumberSection extends StatelessWidget {
  final LayoutConfig config;
  final Function(LayoutConfig) onConfigChanged;

  const _PageNumberSection({
    required this.config,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'page_numbers'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Switch(
              value: config.showPageNumbers,
              onChanged: (value) => onConfigChanged(
                config.copyWith(showPageNumbers: value),
              ),
            ),
          ],
        ),
        if (config.showPageNumbers) ...[
          const SizedBox(height: 8),
          _NumberSelector(
            label: 'starting_page'.tr(),
            value: config.startingPageNumber,
            min: 1,
            max: 999,
            onChanged: (value) => onConfigChanged(
              config.copyWith(startingPageNumber: value),
            ),
          ),
        ],
      ],
    );
  }
}

class _NumberSelector extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const _NumberSelector({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove),
              iconSize: 20,
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add),
              iconSize: 20,
            ),
          ],
        ),
      ],
    );
  }
}