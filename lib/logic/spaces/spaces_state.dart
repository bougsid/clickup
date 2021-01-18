part of 'spaces_bloc.dart';

@immutable
abstract class SpacesState {}

class SpacesInitial extends SpacesState {}

class SpacesLoading extends SpacesState {}

class SpacesLoaded extends SpacesState {
  final List<Space> spaces;
  SpacesLoaded({@required this.spaces});

  SpacesLoaded copyWith({List<Space> spaces}) {
    return SpacesLoaded(
      spaces: spaces ?? this.spaces,
    );
  }

  @override
  String toString() => 'SpacesLoaded with spaces= ${spaces.length}';
}
