import 'package:ulima_app/domain/entity/material_entity.dart';

abstract class MaterialesState {}

class MaterialesInitial extends MaterialesState {}

class MaterialesLoading extends MaterialesState {}

class MaterialesLoaded extends MaterialesState {
  final List<Material> materiales;
  MaterialesLoaded(this.materiales);
}

class MaterialesError extends MaterialesState {
  final String message;
  MaterialesError(this.message);
}
