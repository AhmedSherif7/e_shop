part of 'user_info_cubit.dart';

enum ScreenStatus {
  viewing,
  editing,
  loading,
  infoUpdated,
}

enum ImageStatus {
  initial,
  success,
  error,
}

enum UpdateStatus {
  success,
  error,
}

enum LocationStatus {
  loading,
  serviceDisabled,
  permissionDenied,
  permissionDefinitionNotFound,
  handlingAnotherPermissionError,
  connectionTimeout,
  unknownError,
  success,
}

enum AddressStatus {
  success,
  error,
}

@immutable
class UserInfoState extends Equatable {
  final ScreenStatus screenStatus;
  final UpdateStatus? updateStatus;
  final ImageStatus imageStatus;
  final FirstNameInput firstName;
  final LastNameInput lastName;
  final EmailInput email;
  final PhoneInput phone;
  final GovernorateInput governorate;
  final CityInput city;
  final StreetInput street;
  final PostalCodeInput postalCode;
  final FormzStatus formStatus;
  final String? errorMessage;
  final String? newImagePath;

  final Marker? marker;
  final LocationStatus locationStatus;
  final AddressStatus? addressStatus;
  final Placemark? placeMark;

  const UserInfoState({
    this.screenStatus = ScreenStatus.viewing,
    this.updateStatus,
    this.imageStatus = ImageStatus.initial,
    this.addressStatus,
    this.firstName = const FirstNameInput.pure(),
    this.lastName = const LastNameInput.pure(),
    this.email = const EmailInput.pure(),
    this.phone = const PhoneInput.pure(),
    this.governorate = const GovernorateInput.pure(),
    this.city = const CityInput.pure(),
    this.street = const StreetInput.pure(),
    this.postalCode = const PostalCodeInput.pure(),
    this.formStatus = FormzStatus.pure,
    this.newImagePath,
    this.errorMessage,
    this.marker,
    this.locationStatus = LocationStatus.loading,
    this.placeMark,
  });

  @override
  List<Object?> get props => [
        screenStatus,
        updateStatus,
        imageStatus,
        addressStatus,
        firstName,
        lastName,
        email,
        phone,
        governorate,
        city,
        street,
        postalCode,
        formStatus,
        newImagePath,
        locationStatus,
        marker,
        placeMark,
      ];

  UserInfoState copyWith({
    UpdateStatus? updateStatus,
    ImageStatus? imageStatus,
    AddressStatus? addressStatus,
    FirstNameInput? firstName,
    LastNameInput? lastName,
    EmailInput? email,
    PhoneInput? phone,
    GovernorateInput? governorate,
    CityInput? city,
    StreetInput? street,
    PostalCodeInput? postalCode,
    String? errorMessage,
    String? newImagePath,
    FormzStatus? formStatus,
    ScreenStatus? screenStatus,
    double? longitude,
    double? latitude,
    Marker? marker,
    LocationStatus? locationStatus,
    Placemark? placeMark,
  }) {
    return UserInfoState(
      screenStatus: screenStatus ?? this.screenStatus,
      updateStatus: updateStatus,
      imageStatus: imageStatus ?? this.imageStatus,
      addressStatus: addressStatus,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      newImagePath: newImagePath ?? this.newImagePath,
      marker: marker ?? this.marker,
      locationStatus: locationStatus ?? this.locationStatus,
      placeMark: placeMark ?? this.placeMark,
    );
  }
}
