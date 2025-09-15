import 'package:equatable/equatable.dart';

abstract class FamilyDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitFamilyDetailEvent extends FamilyDetailEvent {
  final String fathersName;
  final String fathersOccupation;
  final String fathersContact;
  final String mothersName;
  final String mothersOccupation;
  final String mothersContact;
  final String noOfBrothers;
  final String noOfSisters;
  final String familyType;
  final String familyStatus;
  final String familyValues;
  final String maternalUncleMamasName;
  final String maternalUncleMamasVillage;
  final String mamasKulClan;
  final String relativesFamilySurnames;

  SubmitFamilyDetailEvent({
    required this.fathersName,
    required this.fathersOccupation,
    required this.fathersContact,
    required this.mothersName,
    required this.mothersOccupation,
    required this.mothersContact,
    required this.noOfBrothers,
    required this.noOfSisters,
    required this.familyType,
    required this.familyStatus,
    required this.familyValues,
    required this.maternalUncleMamasName,
    required this.maternalUncleMamasVillage,
    required this.mamasKulClan,
    required this.relativesFamilySurnames,
  });

  @override
  List<Object?> get props => [
    fathersName,
    fathersOccupation,
    fathersContact,
    mothersName,
    mothersOccupation,
    mothersContact,
    noOfBrothers,
    noOfSisters,
    familyType,
    familyStatus,
    familyValues,
    maternalUncleMamasName,
    maternalUncleMamasVillage,
    mamasKulClan,
    relativesFamilySurnames,
  ];
}
