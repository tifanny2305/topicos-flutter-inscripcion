import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/grupo.dart';
import '../services/grupo_service.dart';

final grupoServiceProvider = Provider((ref) => GrupoService());
final gruposProvider = FutureProvider.family<List<Grupo>, int>((
  ref,
  materiaId,
) async {
  final s = ref.watch(grupoServiceProvider);
  return s.getGruposPorMateria(materiaId);
});
