import 'package:equatable/equatable.dart';
import 'package:omnyqr/commons/constants/omny_account_type.dart';
import 'package:omnyqr/models/thread.dart';
import 'package:omnyqr/models/user.dart';
import '../../../models/associations.dart';

enum UtilityStatus {
  init,
  loading,
  loaded,
  networkError,
  error,
  accountDeleted,
  pushSent,
  initFail
}

enum UserAvailability { idle, busy }

class ContainerState extends Equatable {
  final List<Thread>? threads;
  final int bottomBarSelected;
  final bool showLoading;
  final bool? isLoading;
  final List<Association>? associations;
  final UtilityStatus? status;
  final User? user;
  final String? callerId;
  final bool? isAccepted;
  final UserAvailability availability;
  final AccountType? accountType;
  final bool? pushSent;
  final int callIndex;

  const ContainerState({
    this.bottomBarSelected = 0,
    this.threads,
    this.showLoading = false,
    this.isLoading,
    this.status = UtilityStatus.loading,
    this.associations,
    this.availability = UserAvailability.idle,
    this.user,
    this.accountType,
    this.isAccepted = false,
    this.pushSent = false,
    this.callerId,
    this.callIndex = 0,
  });

  ContainerState copyWith({
    int? bottomIndex,
    bool? showLoading,
    bool? isLoading,
    List<Thread>? threads,
    List<Association>? associations,
    AccountType? accountType,
    UtilityStatus? status,
    bool? isAccepted,
    UserAvailability? availability,
    User? user,
    String? callerId,
    bool? pushSent,
    bool? loadedMessage,
    int? callIndex,
  }) {
    return ContainerState(
      bottomBarSelected: bottomIndex ?? bottomBarSelected,
      showLoading: showLoading ?? this.showLoading,
      isLoading: isLoading ?? this.isLoading,
      isAccepted: isAccepted ?? this.isAccepted,
      associations: associations ?? this.associations,
      availability: availability ?? this.availability,
      status: status ?? this.status,
      threads: threads ?? this.threads,
      user: user ?? this.user,
      accountType: accountType ?? this.accountType,
      callerId: callerId ?? this.callerId,
      pushSent: pushSent ?? this.pushSent,
      callIndex: callIndex ?? this.callIndex,
    );
  }

  @override
  List<Object?> get props => [
        bottomBarSelected,
        pushSent,
        threads,
        showLoading,
        availability,
        isAccepted,
        isLoading,
        associations,
        status,
        user,
        callerId,
        accountType,
        callIndex,
      ];
}

class ContainerInitializing extends ContainerState {}
