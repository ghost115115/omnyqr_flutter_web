part of 'association_create_bloc.dart';

enum AssociationStatus { init, error, complete,networkError }

class AssociationCreateState extends Equatable {
  final String? title;
  final String? labelTitle;
  final String? name;
  final String? address;
  final String? associationType;
  final AssociationStatus? status;
  final bool? isLoading;
  final double? lat;
  final double? long;
  const AssociationCreateState(
      {this.title,
      this.labelTitle,
      this.name,
      this.address,
      this.associationType,
      this.status = AssociationStatus.init,
      this.lat,
      this.long,
      this.isLoading = false});

  AssociationCreateState copyWith(
      {String? title,
      String? labelTitle,
      String? name,
      String? address,
      String? associationType,
      AssociationStatus? status,
      double? lat,
      double? long,
      bool? isLoading}) {
    return AssociationCreateState(
        title: title ?? this.title,
        labelTitle: labelTitle ?? this.labelTitle,
        name: name ?? this.name,
        address: address ?? this.address,
        associationType: associationType ?? this.associationType,
        status: status ?? this.status,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [
        title,
        labelTitle,
        name,
        address,
        associationType,
        status,
        isLoading,
        lat,
        long
      ];
}

class AssociationCreateInitial extends AssociationCreateState {}
