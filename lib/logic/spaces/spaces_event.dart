part of 'spaces_bloc.dart';

@immutable
abstract class SpacesEvent extends Equatable {}

class FetchSpaces extends SpacesEvent {
  @override
  List<Object> get props => [];
}
