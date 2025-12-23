import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_step_scaffold.dart';
import '../../../vehicle/presentation/providers/vehicle_provider.dart';

class AddVehiclePage extends StatefulWidget {
  final String? from;
  const AddVehiclePage({super.key, this.from});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _plate = TextEditingController(text: 'ABC-***');
  final _seats = TextEditingController(text: '4');

  @override
  Widget build(BuildContext context) {
    return AppStepScaffold(
      title: 'Add vehicle',
      primaryCta: 'Save',
      onPrimary: () async {
        final seats = int.tryParse(_seats.text.trim()) ?? 4;
        await context.read<VehicleProvider>().addVehicle(
          make: _make.text.trim().isEmpty ? 'Toyota' : _make.text.trim(),
          model: _model.text.trim().isEmpty ? 'Corolla' : _model.text.trim(),
          plateMasked: _plate.text.trim().isEmpty ? 'ABC-***' : _plate.text.trim(),
          seats: seats,
        );

        if (!mounted) return;
        context.go(widget.from ?? '/post-ride/publish-comments');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add your car to publish rides'),
          const SizedBox(height: 12),
          TextField(controller: _make, decoration: const InputDecoration(labelText: 'Make', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _model, decoration: const InputDecoration(labelText: 'Model', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _plate, decoration: const InputDecoration(labelText: 'Plate (masked)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _seats, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Seats', border: OutlineInputBorder())),
        ],
      ),
    );
  }
}
