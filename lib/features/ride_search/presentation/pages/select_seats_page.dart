import 'package:flutter/material.dart';

class SelectSeatsPage extends StatefulWidget {
  final int initialSeats;

  const SelectSeatsPage({super.key, required this.initialSeats});

  @override
  State<SelectSeatsPage> createState() => _SelectSeatsPageState();
}

class _SelectSeatsPageState extends State<SelectSeatsPage> {
  late int _seats;

  @override
  void initState() {
    super.initState();
    _seats = widget.initialSeats;
  }

  void _submit() {
    Navigator.of(context).pop(_seats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select seats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Number of seats: $_seats',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Slider(
              min: 1,
              max: 6,
              divisions: 5,
              label: '$_seats',
              value: _seats.toDouble(),
              onChanged: (value) {
                setState(() {
                  _seats = value.round();
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
