part of 'overview_page_bloc.dart';

enum DeleteStatus {
  init,
  loading,
  success,
  error,
  networkError,
  showQr,
  logoutUser
}

class OverviewPageState extends Equatable {
  final Utility? utility;
  final String? title;
  final String? subTitle;
  final String? type;
  final String? associationName;
  // conf
  final String? registryLabel;
  final String? intercomNameLabel;
  final String? addressLabel;
  final String? urlLabel;
  final String? groupLabel;
  final String? groupCheckBoxLabel;
  final String? qrUrl;
  // bool
  final bool? showName;
  final bool? isActive;
  final bool? showIntercom;
  final bool? showAddress;
  final bool? showUrl;
  final bool? showDate;
  final bool? showMember;
  final bool? showCondominium;
  final bool? isLoading;
  final bool? showfile;
  final bool? justUpdated;


  //
  final String? associationId;

  final DeleteStatus? status;

  final bool? privatePublicToggle;

  const OverviewPageState({
    this.title,
    this.subTitle,
    this.type,
    this.utility,
    this.associationName,
    this.justUpdated,

    // conf
    this.addressLabel,
    this.groupCheckBoxLabel,
    this.groupLabel,
    this.intercomNameLabel,
    this.registryLabel,
    this.urlLabel,
    this.qrUrl,
    // bool
    this.isActive = false,
    this.showAddress = false,
    this.showCondominium = false,
    this.showDate = false,
    this.showIntercom = false,
    this.showMember = false,
    this.showName = false,
    this.showUrl = false,
    this.isLoading = false,
    this.showfile = false,
    //
    this.associationId,
    this.status,
    this.privatePublicToggle,
  });

  OverviewPageState copyWith(
      {String? title,
      String? subTitle,
      String? type,
      Utility? utility,

        String? associationName,
      //conf
      String? addressLabel,
      String? groupLabel,
      String? groupCheckBoxLabel,
      String? intercomNameLabel,
      String? urlLabel,
      String? registryLabel,
      String? qrUrl,

      // bool
      bool? isActive,
      bool? showAddress,
      bool? showCondominium,
      bool? showDate,
      bool? isLoading,
      bool? showIntercom,
      bool? showMember,
      bool? showName,
      bool? showUrl,
      bool? showfile,
      bool? justUpdated, // <-- aggiungi anche qui

        //
      String? associationId,
      DeleteStatus? status,
      bool? privatePublicToggle}) {
    return OverviewPageState(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      type: type ?? this.type,
      utility: utility ?? this.utility,
      justUpdated: justUpdated ?? this.justUpdated, // <-- qui
      qrUrl: qrUrl ?? this.qrUrl,
      associationName: associationName ?? this.associationName,
      addressLabel: addressLabel ?? this.addressLabel,
      groupLabel: groupLabel ?? this.groupLabel,
      groupCheckBoxLabel: groupCheckBoxLabel ?? this.groupCheckBoxLabel,
      intercomNameLabel: intercomNameLabel ?? this.intercomNameLabel,
      urlLabel: urlLabel ?? this.urlLabel,
      registryLabel: registryLabel ?? this.registryLabel,
      showAddress: showAddress ?? this.showAddress,
      showCondominium: showCondominium ?? this.showCondominium,
      showDate: showDate ?? this.showDate,
      showIntercom: showIntercom ?? this.showIntercom,
      showMember: showMember ?? this.showMember,
      showName: showName ?? this.showName,
      showUrl: showUrl ?? this.showUrl,
      isLoading: isLoading ?? this.isLoading,
      showfile: showfile ?? this.showfile,
      isActive: isActive ?? this.isActive,
      //
      associationId: associationId ?? associationId,
      status: status ?? this.status,
      privatePublicToggle: privatePublicToggle ?? this.privatePublicToggle,
    );
  }

  @override
  List<Object?> get props => [
        title,
        subTitle,
        type,
        utility,
        qrUrl,
        associationName,
        addressLabel,
        groupLabel,
        groupCheckBoxLabel,
        intercomNameLabel,
        urlLabel,
        registryLabel,
        showAddress,
        showCondominium,
        showDate,
        showIntercom,
        showMember,
        showName,
        showUrl,
        associationId,
        status,
        isLoading,
        showfile,
        privatePublicToggle,
      ];
}

class OverviewPageInitial extends OverviewPageState {}
