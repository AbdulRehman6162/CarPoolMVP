import 'package:flutter/material.dart';

class SelectDatePage extends StatelessWidget {
  final DateTime initialDate;

  const SelectDatePage({super.key, required this.initialDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select date'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: now.subtract(const Duration(days: 365)),
              lastDate: now.add(const Duration(days: 365)),
            );
            if (picked != null && context.mounted) {
              Navigator.of(context).pop(picked);
            }
          },
          child: const Text('Pick a date'),
        ),
      ),
    );
  }
}
