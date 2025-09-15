import 'package:equatable/equatable.dart';

abstract class FamilyDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FamilyDetailInitial extends FamilyDetailState {}

class FamilyDetailLoading extends FamilyDetailState {}

class FamilyDetailSuccess extends FamilyDetailState {
  final String message;
  FamilyDetailSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FamilyDetailFailure extends FamilyDetailState {
  final String message;
  FamilyDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}
