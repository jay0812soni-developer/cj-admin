import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/audio_chime_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioChimeService.init();
  runApp(const AdminApp());
}
