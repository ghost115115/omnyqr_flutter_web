part of 'user_search_bloc.dart';

enum UserSearchStatus{  init,
  loading,
  networkError,
  error,
  }

class UserSearchState extends Equatable {
  final List<User>? users;
  final UserSearchStatus? status;
  final String? name;
  final bool? isLoading;
  const UserSearchState({this.users, this.name, this.isLoading = false,this.status});

  UserSearchState copyWith({List<User>? users, String? name, bool? isLoading,UserSearchStatus? status}) {
    return UserSearchState(
        users: users ?? this.users,
        status: status ?? this.status,
        name: name ?? this.name,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [users,status, name, isLoading];
}

class UserSearchInitial extends UserSearchState {}
