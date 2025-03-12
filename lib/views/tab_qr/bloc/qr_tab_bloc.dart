import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:omnyqr/commons/constants/omny_qr_type.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/associations.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/create_edit_qr/bloc/create_edit_qr_bloc.dart';
part 'qr_tab_event.dart';
part 'qr_tab_state.dart';

class QrTabBloc extends Bloc<QrTabEvent, QrTabState> {
  final UtilityRepository _utilityRepository;

  final MessageRepository _messageRepository;
  QrTabBloc(this._utilityRepository, this._messageRepository)
      : super(QrTabInitial()) {
    on<InitEvent>(_onInit);
    on<HideCameraEvent>(_onHide);
    on<GetAssociation>(_onGet);
    on<ResetDialogEvent>(_onReset);
    on<AssociationChangeEvent>(_onAssociationChange);
  }

  _onInit(InitEvent event, Emitter<QrTabState> emit) {
    emit(state.copyWith(showCamera: true));
  }

  _onHide(HideCameraEvent event, Emitter<QrTabState> emit) {
    emit(state.copyWith(showCamera: false));
  }

  _onGet(GetAssociation event, Emitter<QrTabState> emit) async {
    String newString = event.id ?? '';

    // ISFROMSCAN  IS ALWAYS TRUE IF WE COME FORM SCANPAGE

    // ID MANUALLY INSERTED
    if (event.isFromScan == false) {
      await startSearchActivity(emit, event.id ?? '');

      // CASO SIA UN QR SCANNERIZZATO
    } else if (newString.contains('https') && newString.contains('omnyqr')) {
      // Trova l'indice del simbolo di cancelletto
      int? hashIndex = event.id?.indexOf("#");
      // Estrai l'ID dalla parte dell'URL dopo il simbolo di cancelletto
      String? id = hashIndex != -1 ? event.id?.substring(hashIndex! + 2) : "";

      await startSearchActivity(emit, id ?? '');
    } else if (newString.contains('omnydelivery')) {
      // questo tipo di qr viene generato esternamente. la forma della stirnga è sempre questa "omnydelivery:IDUTENZA"
      List<String> splittedString = newString.split(':');
      String key = splittedString[0];
      String value = splittedString[1];

      if (key == 'omnydelivery') {
        await sendPush(value, emit);
      }
    } else {
      emit(state.copyWith(status: QrScanStatus.notOmnyQr, isLoading: false));
    }
  }

  _onReset(ResetDialogEvent event, Emitter<QrTabState> emit) {
    emit(state.copyWith(status: QrScanStatus.init));
  }

  _onAssociationChange(AssociationChangeEvent event, Emitter<QrTabState> emit) {
    emit(state.copyWith(associationId: event.id?.toUpperCase()));
  }

  Future<bool> _checkCurrentLocation(
      String address, double latitude, double longitude) async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      double calculateDistance(Position pos1, Position pos2) {
        const int earthRadius = 6371000; // Raggio della Terra in metri
        double lat1 = pos1.latitude * (pi / 180);
        double lon1 = pos1.longitude * (pi / 180);
        double lat2 = pos2.latitude * (pi / 180);
        double lon2 = pos2.longitude * (pi / 180);

        double dLat = lat2 - lat1;
        double dLon = lon2 - lon1;

        double a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
        double c = 2 * atan2(sqrt(a), sqrt(1 - a));

        double distance = earthRadius * c;

        return distance;
      }

      // ignore: unused_local_variable
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      // Esempio di due posizioni
      Position pos1 = Position(
          longitude: longitude,
          latitude: latitude,
          timestamp: DateTime.now(),
          accuracy: 200,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0);
      Position pos2 = Position(
          longitude: currentPosition.longitude,
          latitude: currentPosition.latitude,
          timestamp: DateTime.now(),
          accuracy: 200,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0);

      // Calcola la distanza tra le due posizioni
      double distance = calculateDistance(pos1, pos2);

      // Confronta la distanza con uno scarto di 200 metri
      double scartoDesiderato = 200.0;

      if (distance <= scartoDesiderato) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  startSearchActivity(Emitter<QrTabState> emit, String id) async {
    emit(state.copyWith(isLoading: true));
    await checkPermission();
    await getAssociation(id, emit);
  }

  checkPermission() async {
    // check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      // ignore: unused_local_variable
      LocationPermission permission = await Geolocator.requestPermission();
    }
  }

  getAssociation(String id, Emitter<QrTabState> emit) async {
    ApiResponse<Association> response =
        await _utilityRepository.getAssociation(id ?? '');

    if (response.isSuccess) {
      switch (getQrType(response.value?.associationType ?? '')) {
        case QrType.mine:
          bool value = await _checkCurrentLocation(
              response.value?.address ?? '',
              response.value?.latitude ?? 0.0,
              response.value?.longitude ?? 0.0);
          if (value == true) {
            emit(state.copyWith(
                isLoading: false,
                association: response.value,
                status: QrScanStatus.success));
          } else {
            emit(state.copyWith(
                isLoading: false, status: QrScanStatus.wrongPosition));
          }
          break;
        // ELIMINARE QUESTI COMMENTI PER AGGIUNGERE CONTROLLO SULLA POSIZIONE
        /*
             *    case QrType.going:
                      bool value =
                          await _checkCurrentLocation(response.value?.address ?? '');

                      if (value == true) {
                        emit(state.copyWith(
                            isLoading: false,
                            association: response.value,
                            status: QrScanStatus.success));
                      } else {
                        emit(state.copyWith(
                            isLoading: false, status: QrScanStatus.wrongPosition));
                      }
                      break;
                    case QrType.assistance:
                      bool value =
                          await _checkCurrentLocation(response.value?.address ?? '');
                      if (value == true) {
                        emit(state.copyWith(
                            isLoading: false,
                            association: response.value,
                            status: QrScanStatus.success));
                      } else {
                        emit(state.copyWith(
                            isLoading: false, status: QrScanStatus.wrongPosition));
                      }
                      break;
                  */
        default:
          emit(state.copyWith(
              isLoading: false,
              association: response.value,
              status: QrScanStatus.success));
      }
    } else {
      // here we handle the exeptions
      await checkResponse(response.message ?? '', emit);
    }
  }

  checkResponse(String errorMessage, Emitter<QrTabState> emit) async {
    // QUI AGGIUNGIAMO TUTTI I CONTORLLI PER GLI ERROR CODE

    switch (errorMessage) {
      case "connectionError":
        emit(state.copyWith(
            status: QrScanStatus.networkError, isLoading: false));
        break;
      case "NOT_FOUND":
        emit(state.copyWith(status: QrScanStatus.notFound, isLoading: false));
        break;
      case 'FORBIDDEN_PRIVATE':
        emit(state.copyWith(status: QrScanStatus.private, isLoading: false));
        break;
      default:
        emit(state.copyWith(status: QrScanStatus.error, isLoading: false));
    }
  }

  sendPush(String value, Emitter<QrTabState> emit) async {
    ApiResponse<String> response =
        await _messageRepository.sendPush(value, 'DELIVERY', '');
    if (response.isSuccess) {
      emit(state.copyWith(status: QrScanStatus.pushSent));
    } else {
      checkResponse(response.message ?? '', emit);
    }
  }
}
