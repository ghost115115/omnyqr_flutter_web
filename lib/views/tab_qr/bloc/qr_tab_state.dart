part of 'qr_tab_bloc.dart';

enum QrScanStatus {
  init,
  success,
  error,
  networkError,
  notFound,
  wrongPosition,
  pushSent,
  notOmnyQr,
  private
}

class QrTabState extends Equatable {
  final bool showCamera;
  final bool? isLoading;
  final QrScanStatus status;
  final Association? association;
  final String? associationId;

  const QrTabState(
      {this.showCamera = false,
      this.isLoading,
      this.status = QrScanStatus.init,
      this.association,
      this.associationId});
  QrTabState copyWith(
      {bool? showCamera,
      bool? isLoading,
      QrScanStatus? status,
      Association? association,
      String? associationId}) {
    return QrTabState(
        showCamera: showCamera ?? this.showCamera,
        isLoading: isLoading ?? this.isLoading,
        status: status ?? this.status,
        association: association ?? this.association,
        associationId: associationId ?? this.associationId);
  }

  @override
  List<Object?> get props =>
      [showCamera, isLoading, status, association, associationId];
}

class QrTabInitial extends QrTabState {}
