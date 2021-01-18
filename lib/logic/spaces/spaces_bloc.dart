import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clickup/data/models/space.dart';
import 'package:clickup/data/repositories/spaces_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'spaces_event.dart';
part 'spaces_state.dart';

class SpacesBloc extends Bloc<SpacesEvent, SpacesState> {
  final SpacesRepository repository;

  SpacesBloc({@required this.repository}) : super(SpacesInitial());

  @override
  Stream<SpacesState> mapEventToState(
    SpacesEvent event,
  ) async* {
    if (event is FetchSpaces) {
      yield* _mapFetchSpacesToState(event);
    }
  }

  Stream<SpacesState> _mapFetchSpacesToState(
    FetchSpaces event,
  ) async* {
    yield SpacesLoading();
    List<Space> spaces = await repository.getTeamSpaces("4561548");
    yield SpacesLoaded(spaces: spaces);
  }
}
