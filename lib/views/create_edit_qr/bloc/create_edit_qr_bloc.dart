import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_qr_type.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/commons/utils/link_utils.dart';
import 'package:omnyqr/models/associations.dart';
import 'package:omnyqr/models/referent.dart';
import 'package:omnyqr/models/utility.dart';
import 'package:omnyqr/repositories/preferences/preferences_repo.dart';
import '../../../models/user.dart';
import '../../../repositories/utilities/utility_repo.dart';
part 'create_edit_qr_event.dart';
part 'create_edit_qr_state.dart';

class CreateEditQrBloc extends Bloc<CreateEditQrEvent, CreateEditQrState> {
  PreferencesRepo preferencesRepo;
  final UtilityRepository _utilityRepository;
  CreateEditQrBloc(this.preferencesRepo, this._utilityRepository)
      : super(CreateEditQrInitial()) {
    on<InitEvent>(_onInit);
    on<ToggleShowCheckBoxEvent>(_onToggle);
    on<ToggleShowSwitchEvent>(_onSwitch);
    on<RegistryChangeEvent>(_onRegistry);
    on<IntercomNameChangeEvent>(_onIntercomName);
    on<AddressChangeEvent>(_onAddress);
    on<ReferentsChangeEvemt>(_onReferent);
    on<StartDateChangeEvent>(_onStart);
    on<EndDateChangeEvent>(_onEnd);
    on<UrlChangeEvent>(_onUrl);
    on<AssociationChangeEvent>(_onAssociation);
    on<RemoveReferentEvent>(_onRemove);
    on<SendFormEvent>(_onSend);
    on<PickDocument>(_onPick);
    on<PublicPrivateEvent>(_onPublicPrivate);
    on<SecretaryChangeEvent>(_onSecretaryChangeEvent);
    on<SecretaryDeleteEvent>(_onSecretaryDeleteEvent);
  }

  _onInit(InitEvent event, Emitter<CreateEditQrState> emit) async {
    User? user = await preferencesRepo.getUser();
    List<Referent>? referentsList =
        event.association?.utilities?[event.index ?? 0].referents ?? [];
    Referent? backupReferent =
        event.association?.utilities?[event.index ?? 0].backupReferent;
    User? secretary = User(
        status: backupReferent?.status,
        name: backupReferent?.name,
        surname: backupReferent?.surname,
        id: backupReferent?.user);
    List<User>? users = [];
    for (var obj in referentsList) {
      users.add(User(
          status: obj.status,
          name: obj.name,
          surname: obj.surname,
          id: obj.user));
    }

    switch (getQrType(event.association?.associationType ?? '')) {
      case QrType.mine:
        emit(state.copyWith(
          headerClr: AppColors.mineColor,
          title: tr('mine_title'),
          showName: true,
          lat: event.association?.utilities?[event.index ?? 0].latitude,
          long: event.association?.utilities?[event.index ?? 0].longitude,
          showCheckBox: user?.isAdmin ?? false,
          isActive: event.association?.utilities?[event.index ?? 0].isActive,
          isChecked: event.association?.isRealAssociation == true,
          showGroup: event.association?.isRealAssociation == true,
          showRegistry: true,
          showAddress: true,
          showResident: true,
          name: tr('intercon_name'),
          nameHint: tr('intercon_name'),
          checkBoxLabel: tr('utils_checkbox_txt'),
          residentName: tr('residents'),
          residentHint: tr('residents_hint'),
          groupName: tr('condominium'),
          groupHint: tr('no_condominium'),
          groupButtonLabel: tr('add_condominium'),
          intercomName:
              event.association?.utilities?[event.index ?? 0].intercomName,
          referents: users,
          secretary: () => secretary,
          type: event.association?.associationType,
          associationName: event.association?.name,
          address: event.association?.utilities?[event.index ?? 0].address,
          registry: event.association?.utilities?[event.index ?? 0].details,
          isEdit: event.isEdit,
          associationId: event.association?.id,
          utilityId: event.association?.utilities?[event.index ?? 0].id,
          privatePublicToggle: false,
        ));
        break;
      case QrType.business:
        emit(state.copyWith(
            headerClr: AppColors.businessColor,
            title: tr('business_title'),
            showName: true,
            isActive: event.association?.utilities?[event.index ?? 0].isActive,
            showCheckBox: user?.isAdmin ?? false,
            isChecked: event.association?.isRealAssociation == true,
            showGroup: event.association?.isRealAssociation == true,
            showAddress: true,
            showResident: true,
            name: tr('name'),
            nameHint: tr('name'),
            checkBoxLabel: tr('utils_checkbox_office_txt'),
            residentName: tr('occupants'),
            residentHint: tr('occupants_hint'),
            groupName: tr('agency'),
            groupHint: tr('no_agency'),
            groupButtonLabel: tr('add_agency'),
            referents: users,
            secretary: () => secretary,
            intercomName:
                event.association?.utilities?[event.index ?? 0].intercomName,
            type: event.association?.associationType,
            associationName: event.association?.name,
            address: event.association?.utilities?[event.index ?? 0].address,
            registry: event.association?.utilities?[event.index ?? 0].details,
            isEdit: event.isEdit,
            associationId: event.association?.id,
            utilityId: event.association?.utilities?[event.index ?? 0].id,
            privatePublicToggle: false));
        break;
      case QrType.lost:
        emit(state.copyWith(
            headerClr: AppColors.lostColor,
            isActive: event.association?.utilities?[event.index ?? 0].isActive,
            title: tr('lost_title'),
            showName: true,
            showResident: true,
            name: tr('name'),
            nameHint: tr('name'),
            residentName: tr('referents'),
            residentHint: tr('referents_hint'),
            intercomName:
                event.association?.utilities?[event.index ?? 0].intercomName,
            referents: users,
            secretary: () => secretary,
            type: event.association?.associationType,
            associationName: event.association?.name,
            address: event.association?.utilities?[event.index ?? 0].address,
            registry: event.association?.utilities?[event.index ?? 0].details,
            isEdit: event.isEdit,
            associationId: event.association?.id,
            utilityId: event.association?.utilities?[event.index ?? 0].id));
        break;
      case QrType.going:
        emit(
          state.copyWith(
              headerClr: AppColors.goingColor,
              isActive:
                  event.association?.utilities?[event.index ?? 0].isActive,
              title: tr('going_on_title'),
              showName: true,
              showResident: true,
              lat: event.association?.utilities?[event.index ?? 0].latitude,
              long: event.association?.utilities?[event.index ?? 0].longitude,
              showAddress: true,
              showDates: true,
              name: tr('event_name'),
              nameHint: tr('name'),
              residentName: tr('referents'),
              residentHint: tr('referents_hint'),
              referents: users,
              secretary: () => secretary,
              startDate: event.association?.utilities?[0].startDate != null
                  ? fromDateTimeToDate(
                      event.association?.utilities?[0].startDate ?? '')
                  : null,
              endDate: event.association?.utilities?[0].endDate != null
                  ? fromDateTimeToDate(
                      event.association?.utilities?[0].endDate ?? '')
                  : null,
              intercomName:
                  event.association?.utilities?[event.index ?? 0].intercomName,
              type: event.association?.associationType,
              associationName: event.association?.name,
              address: event.association?.utilities?[event.index ?? 0].address,
              registry: event.association?.utilities?[event.index ?? 0].details,
              isEdit: event.isEdit,
              associationId: event.association?.id,
              utilityId: event.association?.utilities?[event.index ?? 0].id),
        );
        break;
      case QrType.emergency:
        emit(state.copyWith(
            headerClr: AppColors.emergencyColor,
            isActive: event.association?.utilities?[event.index ?? 0].isActive,
            title: tr('emergency_title'),
            showName: true,
            showResident: true,
            name: tr('name'),
            nameHint: tr('name'),
            residentName: tr('referents'),
            residentHint: tr('referents_hint'),
            referents: users,
            secretary: () => secretary,
            type: event.association?.associationType,
            intercomName:
                event.association?.utilities?[event.index ?? 0].intercomName,
            associationName: event.association?.name,
            address: event.association?.utilities?[event.index ?? 0].address,
            registry: event.association?.utilities?[event.index ?? 0].details,
            isEdit: event.isEdit,
            associationId: event.association?.id,
            utilityId: event.association?.utilities?[event.index ?? 0].id));
        break;
      case QrType.price:
        emit(state.copyWith(
            headerClr: AppColors.priceColor,
            isActive: event.association?.utilities?[event.index ?? 0].isActive,
            title: tr('fork_title'),
            showName: true,
            showLink: true,
            showSwitch: true,
            name: tr('menu_name'),
            nameHint: tr('menu_name'),
            referents: users,
            secretary: () => secretary,
            type: event.association?.associationType,
            intercomName:
                event.association?.utilities?[event.index ?? 0].intercomName,
            associationName: event.association?.name,
            address: event.association?.utilities?[event.index ?? 0].address,
            registry: event.association?.utilities?[event.index ?? 0].details,
            url: verifyUrl(
                event.association?.utilities?[event.index ?? 0].utilityLink ??
                    ''),
            isEdit: event.isEdit,
            associationId: event.association?.id,
            utilityId: event.association?.utilities?[event.index ?? 0].id));
        break;
      case QrType.assistance:
        emit(state.copyWith(
            headerClr: AppColors.assistanceColor,
            isActive: event.association?.utilities?[event.index ?? 0].isActive,
            title: tr('assistance_title'),
            showName: true,
            showResident: true,
            name: tr('registry'),
            nameHint: tr('name'),
            residentName: tr('referents'),
            residentHint: tr('referents_hint'),
            referents: users,
            secretary: () => secretary,
            type: event.association?.associationType,
            intercomName:
                event.association?.utilities?[event.index ?? 0].intercomName,
            associationName: event.association?.name,
            address: event.association?.utilities?[event.index ?? 0].address,
            registry: event.association?.utilities?[event.index ?? 0].details,
            isEdit: event.isEdit,
            associationId: event.association?.id,
            utilityId: event.association?.utilities?[event.index ?? 0].id));
        break;
      default:
    }
  }

  _onToggle(ToggleShowCheckBoxEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(
        isChecked: !state.isChecked, showGroup: !state.showGroup));
  }

  _onSwitch(ToggleShowSwitchEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(
        toggleSwitch: !state.toggleSwitch,
        showFile: !state.showFile,
        showLink: !state.showLink));
  }

  _onRegistry(RegistryChangeEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(registry: event.value));
  }

  _onIntercomName(
      IntercomNameChangeEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(intercomName: event.value));
  }

  _onAddress(AddressChangeEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(
        address: event.value,
        lat: double.parse(event.lat ?? '0.0'),
        long: double.parse(event.lng ?? '0.0')));
  }

  _onReferent(ReferentsChangeEvemt event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(isLoading: true));
    List<User> referents = state.referents ?? [];

    referents.add(event.value ?? User());
    List<User> newList = referents;

    if (event.value == null) {
      emit(state.copyWith(referents: [], isLoading: false));
    } else {
      emit(state.copyWith(referents: newList, isLoading: false));
    }
  }

  _onRemove(RemoveReferentEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(isLoading: true));
    List<User>? referents = state.referents;

    referents?.removeAt(event.id ?? 0);

    emit(state.copyWith(referents: referents, isLoading: false));
  }

  _onStart(StartDateChangeEvent event, Emitter<CreateEditQrState> emit) {
    DateTime newDate =
        dateAndTimeJoin(event.value.toString(), event.time ?? TimeOfDay.now());

    emit(state.copyWith(
      startDate: formattedDate(newDate),
    ));
  }

  _onEnd(EndDateChangeEvent event, Emitter<CreateEditQrState> emit) {
    DateTime newDate =
        dateAndTimeJoin(event.value.toString(), event.time ?? TimeOfDay.now());

    emit(state.copyWith(
      endDate: formattedDate(newDate),
    ));
  }

  _onUrl(UrlChangeEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(url: event.value));
  }

  _onPick(PickDocument event, Emitter<CreateEditQrState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      emit(state.copyWith(file: file));
    } else {}
  }

  _onAssociation(
      AssociationChangeEvent event, Emitter<CreateEditQrState> emit) {
    if (event.value == null) {
      emit(state.copyWith(associationName: '', associationId: ''));
    } else {
      emit(state.copyWith(
          associationName: event.value, associationId: event.associationId));
    }
  }

  _onSend(SendFormEvent event, Emitter<CreateEditQrState> emit) async {
    emit(state.copyWith(isLoading: true));
    List<User> users = state.referents ?? [];
    User? myUser = await preferencesRepo.getUser();

    List<Referent>? referentsList = [];

    for (var obj in users) {
      String? valid;
      // this part is crucial when we send invitation

      // if we are trying to add ourself
      if (myUser?.id == obj.id) {
        valid = 'accepted';
      } else if (obj.status == null) {
        //this is called when we try to add new refeent
        valid = 'pending';
      } else {
        // this is user when we update old referents
        valid = obj.status;
      }

      referentsList.add(Referent(user: obj.id, status: valid));
    }

    // The parameter 'IS CHECKED' is used to identify whether it's a true association or not
    if (state.file == null) {
      Utility utility = Utility(
        type: state.type,
        intercomName: state.intercomName,
        isActive: state.isActive,
        details: state.registry,
        address: state.address,
        utilityLink: state.url,
        latitude: state.lat,
        longitude: state.long,
        startDate: state.startDate != null
            ? parseDateString(state.startDate ?? '').toString()
            : null,
        endDate: state.endDate != null
            ? parseDateString(state.endDate ?? '').toString()
            : null,
        referents: referentsList,
        isRealAssociation: state.isChecked,
        id: state.associationId,
        isPrivate: state.privatePublicToggle,
        backupReferent: Referent(user: state.secretary?.id),
      );
      if (state.isEdit == true) {
        ApiResponse<List<Association>> response =
            await _utilityRepository.updateUtility(
                state.associationId ?? '', state.utilityId ?? '', utility);
        if (response.isSuccess) {
          emit(state.copyWith(
              status: CreateStatus.updateSuccess, isLoading: false));
        } else {
          emit(state.copyWith(
              status: CreateStatus.updateError, isLoading: false));
        }
      } else {
        ApiResponse<List<Association>> response =
            await _utilityRepository.sendUtility(utility);
        if (response.isSuccess) {
          emit(state.copyWith(status: CreateStatus.success, isLoading: false));
        } else {
          emit(state.copyWith(status: CreateStatus.error, isLoading: false));
        }
      }
    } else {
      if (state.isEdit == true) {
        var utility = FormData.fromMap({
          'file': [
            await MultipartFile.fromFile(state.file?.path ?? '',
                filename: state.file?.name)
          ],
          'intercomName': state.intercomName,
          'isRealAssociation': state.isChecked,
        });
        ApiResponse<List<Association>> response =
            await _utilityRepository.updateUtilityFormData(
                state.associationId ?? '', state.utilityId ?? '', utility);
        if (response.isSuccess) {
          emit(state.copyWith(
              status: CreateStatus.updateSuccess, isLoading: false));
        } else {
          emit(state.copyWith(
              status: CreateStatus.updateError, isLoading: false));
        }
      } else {
        var utility = FormData.fromMap({
          'file': [
            await MultipartFile.fromFile(state.file?.path ?? '',
                filename: state.file?.name)
          ],
          'type': state.type,
          'intercomName': state.intercomName,
          'isRealAssociation': state.isChecked,
        });
        ApiResponse<List<Association>> response =
            await _utilityRepository.sendUtilityForm(utility);
        if (response.isSuccess) {
          emit(state.copyWith(status: CreateStatus.success, isLoading: false));
        } else {
          emit(state.copyWith(status: CreateStatus.error, isLoading: false));
        }
      }
    }
  }

  _onPublicPrivate(PublicPrivateEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(privatePublicToggle: event.value));
  }

  _onSecretaryChangeEvent(
      SecretaryChangeEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(secretary: () => event.value));
  }

  _onSecretaryDeleteEvent(
      SecretaryDeleteEvent event, Emitter<CreateEditQrState> emit) {
    emit(state.copyWith(secretary: () => null));
  }

  DateTime dateAndTimeJoin(String data, TimeOfDay hour) {
    DateTime formattedDate = DateTime.parse(data);
    return DateTime(
      formattedDate.year,
      formattedDate.month,
      formattedDate.day,
      hour.hour,
      hour.minute,
    );
  }

  String formattedDate(DateTime dateTime) {
    DateFormat newFormat = DateFormat('dd/MM/yyyy - HH:mm');
    return newFormat.format(dateTime);
  }

  DateTime parseDateString(String string) {
    // Separare la data e l'ora dalla stringa
    List<String> parts = string.split(' - ');

// Separare la data nei suoi componenti
    List<String> dateParts = parts[0].split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

// Separare l'ora nei suoi componenti
    List<String> timeParts = parts[1].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

// Creare l'oggetto DateTime
    DateTime dateTime = DateTime(year, month, day, hour, minute);
    // Questo è il tuo oggetto DateTime
    return dateTime;
  }

  String fromDateTimeToDate(String date) {
    String inputString = date;
    DateTime dateTime = DateTime.parse(inputString);

    String formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);

    return formattedDate;
  }
}
