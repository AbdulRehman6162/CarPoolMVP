import 'dart:io';

/// A utility script to aggregate all Dart files in the 'lib' folder
/// into a single text file for LLM/AI Context usage.
void main() async {
  final rootDir = Directory.current;
  final libDir = Directory('${rootDir.path}/lib');
  final outputFile = File('${rootDir.path}/carpool_codebase_context.txt');

  if (!await libDir.exists()) {
    print('Error: Could not find "lib" folder. Make sure you run this from the project root.');
    return;
  }

  final buffer = StringBuffer();

  // Header for the AI
  buffer.writeln('PROJECT: CarPool MVP');
  buffer.writeln('ARCHITECTURE: Clean Architecture (Flutter)');
  buffer.writeln('GENERATED: ${DateTime.now()}');
  buffer.writeln('=' * 80);
  buffer.writeln('\n');

  int fileCount = 0;

  // Walk through the directory
  await for (final entity in libDir.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // Exclude generated files if necessary (e.g., .g.dart, .freezed.dart)
      if (entity.path.endsWith('.g.dart') || entity.path.endsWith('.freezed.dart')) {
        continue;
      }

      fileCount++;
      final relativePath = entity.path.replaceFirst('${rootDir.path}/', '');

      // Formatting specifically for LLM comprehension
      buffer.writeln('// ' + ('-' * 70));
      buffer.writeln('// FILE: $relativePath');
      buffer.writeln('// ' + ('-' * 70));
      buffer.writeln('');

      try {
        final content = await entity.readAsString();
        buffer.writeln(content);
        buffer.writeln('\n');
      } catch (e) {
        print('Could not read file: $relativePath');
      }
    }
  }

  await outputFile.writeAsString(buffer.toString());

  print('✅ Successfully generated context file.');
  print('📄 Output: ${outputFile.path}');
  print('📂 Files processed: $fileCount');
}