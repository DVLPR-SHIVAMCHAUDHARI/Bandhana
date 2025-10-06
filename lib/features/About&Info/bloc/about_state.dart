import 'package:equatable/equatable.dart';
import '../model/about_model.dart';

abstract class AboutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  final AboutModel about;

  AboutLoaded(this.about);

  @override
  List<Object?> get props => [about];
}

class AboutError extends AboutState {
  final String message;

  AboutError(this.message);

  @override
  List<Object?> get props => [message];
}
