part of 'call_deviation_bloc.dart';

enum CallDeviationError {
  error,
  networkError,
  noUser,
  success,
  none,
}

class CallDeviationState extends Equatable {
  final List<UtilityUnavailability>? utilityUnavailability;
  final bool? isLoading;

  final CallDeviationError? message;

  const CallDeviationState({
    this.utilityUnavailability,
    this.isLoading,
    this.message,
  });

  CallDeviationState copyWith({
    List<UtilityUnavailability>? utilityUnavailability,
    bool? isLoading,
    CallDeviationError? message,
  }) {
    return CallDeviationState(
      utilityUnavailability:
          utilityUnavailability ?? this.utilityUnavailability,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        utilityUnavailability,
        isLoading,
        message,
      ];
}

class CallDeviationInitial extends CallDeviationState {}
