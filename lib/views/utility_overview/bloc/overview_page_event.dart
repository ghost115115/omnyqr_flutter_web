part of 'overview_page_bloc.dart';

class OverviewPageEvent extends Equatable {
  const OverviewPageEvent();

  @override
  List<Object> get props => [];
}

class OverviewPageInitEvent extends OverviewPageEvent {
  final Association? association;
  final int? index;
  final bool? isReal;
  const OverviewPageInitEvent({this.association, this.isReal, this.index});
}

class DeleteUtilityEvent extends OverviewPageEvent {
  final String? associationId;
  final String? utilityId;
  const DeleteUtilityEvent({this.associationId, this.utilityId});
}

class GetQrEvemt extends OverviewPageEvent {
  final String? associationId;
  const GetQrEvemt({this.associationId});
}

class ResetDialog extends OverviewPageEvent {}

class OnOffUtility extends OverviewPageEvent {
  final String? associationId;
  final String? utilityId;
  const OnOffUtility({this.associationId, this.utilityId});
}

class DeleteUserEvent extends OverviewPageEvent {
  final String? associationId;
  final String? utilityId;
  const DeleteUserEvent({
    this.associationId,
    this.utilityId,
  });
}

class PublicPrivateUtility extends OverviewPageEvent {
  final bool? value;
  final String? associationId;
  final String? utilityId;
  const PublicPrivateUtility({
    this.associationId,
    this.utilityId,
    this.value,
  });
}
