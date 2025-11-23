import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/entity/material_entity.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/materiales_state.dart';

class MaterialesCubit extends Cubit<MaterialesState> {
  final GetMateriales getMateriales;
  final SubirMaterial subirMaterial;

  MaterialesCubit({
    required this.getMateriales,
    required this.subirMaterial,
  }) : super(MaterialesInitial());

  Future<void> loadMateriales(String seccionId) async {
    try {
      emit(MaterialesLoading());
      final materiales = await getMateriales(seccionId);
      emit(MaterialesLoaded(materiales));
    } catch (e) {
      emit(MaterialesError('Error al cargar materiales: $e'));
    }
  }

  Future<void> subir(String seccionId, Material material) async {
    try {
      await subirMaterial(seccionId, material);
      await loadMateriales(seccionId); // Recargar materiales
    } catch (e) {
      emit(MaterialesError('Error al subir material: $e'));
    }
  }
}
