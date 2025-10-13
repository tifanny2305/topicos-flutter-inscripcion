import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/materia.dart';
import '../services/materia_service.dart';

final materiaServiceProvider = Provider((ref) => MateriaService());
final materiasProvider = FutureProvider<List<Materia>>((ref) async {
  final s = ref.watch(materiaServiceProvider);
  return s.getMaterias();
});
