part of 'constants.dart';

class AppConstants {
  AppConstants._();

  static const String yandexApiKey = '502b52f5-5030-41a7-b590-3ee852303446';
  static const String geocoderApiKey = 'eee41c72-9cac-4104-ad42-126d8b939c78';
}

class ImagesConstants {
  ImagesConstants._();

  static const String noWifi = 'assets/svg/no-wifi.svg';
}

class Validations {
  Validations._();

  static const emailEmpty = 'Email cannot be empty';
  static const notEmail = 'This is not email';
  static const passwordEmpty = 'Password cannot be empty';
  static const passwordShort = 'Password too short';
  static const passwordLong = 'Password too long';
  static const firstnameEmpty = 'Firstname cannot be empty';
  static const firstnameShort = 'Firstname too short';
  static const firstnameLong = 'Firstname too long';
  static const lastnameEmpty = 'Last name cannot be empty';
  static const lastnameShort = 'Lastname too short';
  static const lastnameLong = 'Lastname too long';
  static const passwordNotMatch = 'Passwords do not match';
  static const internetFailure = 'No Internet';
  static const somethingWentWrong = 'Something went wrong!';
}
