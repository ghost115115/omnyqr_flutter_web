part of 'association_bloc.dart';

enum AssociationSearch {
  init,
  loading,
  networkError,
  error,
}

class AssociationState extends Equatable {
  final List<Association>? associations;
  final String? title;
  final bool? isLoading;
  final AssociationSearch? status;

  const AssociationState(
      {this.associations, this.title, this.isLoading, this.status});

  AssociationState copyWith(
      {List<Association>? associations,
      String? title,
      String? createPageTitle,
      AssociationSearch? status,
      bool? isLoading}) {
    return AssociationState(
        associations: associations ?? this.associations,
        title: title ?? this.title,
        isLoading: isLoading ?? this.isLoading,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [associations, status, title, isLoading];
}

class AssociationInitial extends AssociationState {}
