import 'package:equatable/equatable.dart';

abstract class AboutEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAboutEvent extends AboutEvent {}
