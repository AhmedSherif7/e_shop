import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import '../../../data/error/failure.dart';
import '../../../data/models/validation_models/city_input.dart';
import '../../../data/models/validation_models/email_input.dart';
import '../../../data/models/validation_models/first_name_input.dart';
import '../../../data/models/validation_models/governorate_input.dart';
import '../../../data/models/validation_models/last_name_input.dart';
import '../../../data/models/validation_models/phone_input.dart';
import '../../../data/models/validation_models/postal_code_input.dart';
import '../../../data/models/validation_models/street_input.dart';
import '../../../domain/use_cases/base_use_case.dart';
import '../../../domain/use_cases/get_image_from_gallery_use_case.dart';
import '../../../domain/use_cases/get_user_address_use_case.dart';
import '../../../domain/use_cases/get_user_location_use_case.dart';
import '../../../domain/use_cases/update_user_data_use_case.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit(
    this.getImageFromGalleryUseCase,
    this.updateUserDataUseCase,
    this.getUserLocationUseCase,
    this.getUserAddressUseCase,
  ) : super(const UserInfoState());

  final GetImageFromGalleryUseCase getImageFromGalleryUseCase;
  final UpdateUserDataUseCase updateUserDataUseCase;
  final GetUserLocationUseCase getUserLocationUseCase;
  final GetUserAddressUseCase getUserAddressUseCase;

  void startEditing() {
    emit(
      state.copyWith(
        screenStatus: ScreenStatus.editing,
      ),
    );
  }

  void changeImage() async {
    final result = await getImageFromGalleryUseCase(NoParams());
    result.fold(
      (error) {
        emit(
          state.copyWith(
            imageStatus: ImageStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (image) {
        emit(
          state.copyWith(
            imageStatus: ImageStatus.success,
            newImagePath: image.path,
          ),
        );
      },
    );
  }

  void reset() {
    emit(
      const UserInfoState(),
    );
  }

  void saveData({
    required String firstNameVal,
    required String lastNameVal,
    required String emailVal,
    required String phoneVal,
    required String governorateVal,
    required String cityVal,
    required String streetVal,
    required String postalCodeVal,
  }) async {
    emit(
      state.copyWith(
        screenStatus: ScreenStatus.loading,
      ),
    );

    final firstName = FirstNameInput.dirty(firstNameVal);
    final lastName = LastNameInput.dirty(lastNameVal);
    final email = EmailInput.dirty(emailVal);
    final phone = PhoneInput.dirty(phoneVal);
    final governorate = GovernorateInput.dirty(governorateVal);
    final city = CityInput.dirty(cityVal);
    final street = StreetInput.dirty(streetVal);
    final postalCode = PostalCodeInput.dirty(postalCodeVal);

    final List<FormzInput> changedFields = [
      firstName,
      lastName,
      email,
      phone,
      governorate,
      city,
      street,
      postalCode,
    ];

    final allInputsStatus = Formz.validate(changedFields);

    if (allInputsStatus.isInvalid) {
      emit(
        state.copyWith(
          screenStatus: ScreenStatus.editing,
          formStatus: allInputsStatus,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
          governorate: governorate,
          city: city,
          street: street,
          postalCode: postalCode,
          errorMessage: 'Some inputs are invalid',
        ),
      );
    } else {
      Map<String, String> updateData = {};
      for (var field in changedFields) {
        updateData.addAll({
          field.toString(): field.value,
        });
      }

      late Either<Failure, String> result;
      if (state.imageStatus == ImageStatus.success) {
        updateData.addAll({
          'imageUrl': state.newImagePath!,
        });

        result = await updateUserDataUseCase(updateData);
      } else {
        result = await updateUserDataUseCase(updateData);
      }

      result.fold(
        (error) {
          emit(
            state.copyWith(
              updateStatus: UpdateStatus.error,
              errorMessage: error.message,
            ),
          );
        },
        (imageUrl) {
          if (imageUrl.isNotEmpty) {
            emit(
              state.copyWith(
                imageUrl: imageUrl,
                formStatus: FormzStatus.pure,
                screenStatus: ScreenStatus.infoUpdated,
                updateStatus: UpdateStatus.success,
              ),
            );
          } else {
            emit(
              state.copyWith(
                formStatus: FormzStatus.pure,
                screenStatus: ScreenStatus.infoUpdated,
                updateStatus: UpdateStatus.success,
              ),
            );
          }
        },
      );
    }
  }

  void getLocation() async {
    final result = await getUserLocationUseCase(NoParams());
    result.fold(
      (error) {
        _locationStateEmit(error.message);
      },
      (position) {
        emit(
          state.copyWith(
            locationStatus: LocationStatus.success,
            marker: Marker(
              markerId: const MarkerId('address'),
              infoWindow: const InfoWindow(title: 'My Address'),
              position: LatLng(position.longitude, position.latitude),
            ),
          ),
        );
      },
    );
  }

  void _locationStateEmit(String error) {
    switch (error) {
      case 'Location service is disabled':
        emit(
          state.copyWith(
            locationStatus: LocationStatus.serviceDisabled,
            errorMessage: error,
          ),
        );
        break;
      case 'Location permission denied':
        emit(
          state.copyWith(
            locationStatus: LocationStatus.permissionDenied,
            errorMessage: error,
          ),
        );
        break;
      case 'Permission definition not found':
        emit(
          state.copyWith(
            locationStatus: LocationStatus.permissionDefinitionNotFound,
            errorMessage: error,
          ),
        );
        break;
      case 'Handling another permission, please wait':
        emit(
          state.copyWith(
            locationStatus: LocationStatus.handlingAnotherPermissionError,
            errorMessage: error,
          ),
        );
        break;
      case 'Connection timeout':
        emit(
          state.copyWith(
            locationStatus: LocationStatus.connectionTimeout,
            errorMessage: error,
          ),
        );
        break;
      case 'Unknown error occurred':
        emit(
          state.copyWith(
            locationStatus: LocationStatus.unknownError,
            errorMessage: error,
          ),
        );
        break;
    }
  }

  void addMarker(LatLng loc) {
    emit(
      state.copyWith(
        marker: Marker(
          markerId: const MarkerId('address'),
          infoWindow: const InfoWindow(title: 'My Address'),
          position: loc,
        ),
      ),
    );
  }

  void getAddressDetails() async {
    final result = await getUserAddressUseCase(
      GetUserAddressUseCaseInput(
        state.marker!.position.longitude,
        state.marker!.position.latitude,
      ),
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            addressStatus: AddressStatus.error,
            errorMessage: error.message,
          ),
        );
      },
      (address) {
        emit(
          state.copyWith(
            addressStatus: AddressStatus.success,
            placeMark: Placemark(
              administrativeArea: address.administrativeArea ?? '',
              name: address.name ?? '',
              street: address.street ?? '',
              postalCode: address.postalCode ?? '',
            ),
          ),
        );
      },
    );
  }
}
