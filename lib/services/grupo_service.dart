import '../core/api_client.dart';
import '../core/endpoints.dart';
import '../models/grupo.dart';


class GrupoService {
final client = ApiClient();


Future<List<Grupo>> getGruposPorMateria(int materiaId) async {
final res = await client.get('${Endpoints.baseGrupos}/by-materia/$materiaId');
final data = res.data as Map<String, dynamic>;
final list = data['grupos'] as List<dynamic>? ?? [];
return list.map((e) => Grupo.fromJson(e as Map<String, dynamic>)).toList();
}
}