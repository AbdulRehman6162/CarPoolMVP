
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Real DB
  await Supabase.initialize(
    url: 'https://kwsuczkbjbmqwumsjvcm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3c3VjemtiamJtcXd1bXNqdmNtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyNDc2NzEsImV4cCI6MjA4MDgyMzY3MX0.mne7DQRwoKhA-KaHbTe7iqrxzbRfmgzreOWz7eWNJ2c',
  );
  // Warp your app in ProviderScope for Riverpod to work
  runApp(const ProviderScope(child: CarpoolApp()));
}