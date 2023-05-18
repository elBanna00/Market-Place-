part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class UnLoggedState extends LoginState {}
class LoggedState extends LoginState {}

