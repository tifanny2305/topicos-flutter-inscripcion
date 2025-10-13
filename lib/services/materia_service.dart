import '../core/api_client.dart';
import '../core/endpoints.dart';
import '../models/materia.dart';

class MateriaService {
  final client = ApiClient();

  Future<List<Materia>> getMaterias() async {
    final res = await client.get(Endpoints.baseMaterias);
    final data = res.data as Map<String, dynamic>;
    final list = data['materias'] as List<dynamic>? ?? [];
    return list
        .map((e) => Materia.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
