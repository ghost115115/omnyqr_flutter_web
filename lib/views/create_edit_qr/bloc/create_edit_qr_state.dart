part of 'create_edit_qr_bloc.dart';

enum QrType { init, mine, business, lost, going, emergency, price, assistance }

enum CreateStatus { init, success, error, updateSuccess, updateError }

class CreateEditQrState extends Equatable {
  final CreateStatus? status;
  final bool? isActive;
  final bool? isEdit;
  final bool? isLoading;
  final Color? headerClr;
  final String? title;
  final QrType? qrType;
  final bool? showName;
  final bool showDates;
  final bool showSwitch;
  final bool toggleSwitch;
  final bool showLink;
  final bool showFile;
  final String? name;
  final String? nameHint;
  final bool? showRegistry;
  final bool? showAddress;
  final bool? showResident;
  final String? residentName;
  final String? residentHint;
  final bool? showCheckBox;
  final String? checkBoxLabel;
  final bool showGroup;
  final String? groupName;
  final String? groupHint;
  final String? groupButtonLabel;
  final bool? toggleCheck;
  final bool isChecked;

  // field value
  final String? intercomName;
  final String? registry;
  final String? address;
  final double? lat;
  final double? long;
  final List<User>? referents;
  final String? startDate;
  final String? endDate;
  final String? url;
  final String? type;
  final String? associationName;
  final String? associationId;
  final String? utilityId;
  final PlatformFile? file;

  final bool? privatePublicToggle;

  final User? secretary;

  const CreateEditQrState({
    this.isEdit,
    this.qrType = QrType.init,
    this.status = CreateStatus.init,
    this.isLoading = false,
    this.headerClr,
    this.isActive,
    this.title,
    this.showName = false,
    this.showSwitch = false,
    this.showRegistry = false,
    this.showAddress = false,
    this.showFile = false,
    this.showLink = false,
    this.showResident = false,
    this.toggleCheck = false,
    this.toggleSwitch = false,
    this.showGroup = false,
    this.showCheckBox = false,
    // The parameter 'IS CHECKED' is used to identify whether it's a true association or not
    this.isChecked = false,
    this.showDates = false,
    this.name,
    this.nameHint,
    this.lat,
    this.long,
    this.residentName,
    this.residentHint,
    this.groupName,
    this.groupHint,
    this.checkBoxLabel,
    this.groupButtonLabel,
    this.file,

    // field value
    this.intercomName,
    this.registry,
    this.address,
    this.referents,
    this.startDate,
    this.endDate,
    this.url,
    this.type,
    this.associationId,
    this.utilityId,
    this.associationName,
    this.privatePublicToggle,
    this.secretary,
  });

  CreateEditQrState copyWith({
    QrType? qrType,
    bool? isEdit,
    bool? isActive,
    CreateStatus? status,
    Color? headerClr,
    String? title,
    bool? showName,
    bool? showDates,
    bool? showSwitch,
    bool? toggleSwitch,
    String? name,
    String? nameHint,
    bool? showLink,
    bool? showFile,
    bool? showRegistry,
    bool? showAddress,
    bool? showResident,
    String? residentName,
    String? residentHint,
    bool? toggleCheck,
    bool? showGroup,
    String? groupName,
    String? groupHint,
    bool? showCheckBox,
    String? checkBoxLabel,
    String? groupButtonLabel,
    bool? isChecked,
    bool? isLoading,
    // field value
    String? intercomName,
    double? long,
    double? lat,
    PlatformFile? file,
    String? registry,
    String? address,
    List<User>? referents,
    String? startDate,
    String? endDate,
    String? url,
    String? type,
    String? associationName,
    String? associationId,
    String? utilityId,
    bool? privatePublicToggle,
    ValueGetter<User?>? secretary,
  }) {
    return CreateEditQrState(
      title: title ?? this.title,
      isEdit: isEdit ?? this.isEdit,
      status: status ?? this.status,
      headerClr: headerClr ?? this.headerClr,
      qrType: qrType ?? this.qrType,
      isActive: isActive ?? this.isActive,
      showSwitch: showSwitch ?? this.showSwitch,
      toggleSwitch: toggleSwitch ?? this.toggleSwitch,
      showName: showName ?? this.showName,
      showFile: showFile ?? this.showFile,
      showLink: showLink ?? this.showLink,
      showDates: showDates ?? this.showDates,
      showRegistry: showRegistry ?? this.showRegistry,
      showAddress: showAddress ?? this.showAddress,
      showResident: showResident ?? this.showResident,
      toggleCheck: toggleCheck ?? this.toggleCheck,
      showGroup: showGroup ?? this.showGroup,
      showCheckBox: showCheckBox ?? this.showCheckBox,
      name: name ?? this.name,
      nameHint: nameHint ?? this.nameHint,
      residentHint: residentHint ?? this.residentHint,
      residentName: residentName ?? this.residentName,
      groupName: groupName ?? this.groupName,
      groupHint: groupHint ?? this.groupHint,
      checkBoxLabel: checkBoxLabel ?? this.checkBoxLabel,
      groupButtonLabel: groupButtonLabel ?? this.groupButtonLabel,
      isChecked: isChecked ?? this.isChecked,
      isLoading: isLoading ?? this.isLoading,
      // field value
      intercomName: intercomName ?? this.intercomName,
      file: file ?? this.file,
      long: long ?? this.long,
      lat: lat ?? this.lat,
      registry: registry ?? this.registry,
      address: address ?? this.address,
      referents: referents ?? this.referents,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      url: url ?? this.url,
      type: type ?? this.type,
      associationId: associationId ?? this.associationId,
      utilityId: utilityId ?? this.utilityId,
      associationName: associationName ?? this.associationName,
      privatePublicToggle: privatePublicToggle ?? this.privatePublicToggle,
      secretary: secretary != null ? secretary() : this.secretary,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isActive,
        isEdit,
        status,
        title,
        headerClr,
        qrType,
        showDates,
        showSwitch,
        toggleSwitch,
        showName,
        showLink,
        showFile,
        name,
        nameHint,
        showRegistry,
        showAddress,
        showResident,
        residentHint,
        residentName,
        showGroup,
        groupHint,
        groupName,
        toggleCheck,
        showCheckBox,
        groupButtonLabel,
        checkBoxLabel,
        isChecked,
        //field value
        intercomName,
        file,
        registry,
        address,
        referents,
        startDate,
        endDate,
        url,
        long,
        lat,
        type,
        associationId,
        utilityId,
        associationName,
        privatePublicToggle,
        secretary,
      ];
}

class CreateEditQrInitial extends CreateEditQrState {}
