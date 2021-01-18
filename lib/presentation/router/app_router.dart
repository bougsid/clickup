import 'package:clickup/data/repositories/spaces_repository.dart';
import 'package:clickup/data/repositories/tasks_repository.dart';
import 'package:clickup/logic/spaces/spaces_bloc.dart';
import 'package:clickup/logic/tasks/tasks_bloc.dart';
import 'package:clickup/presentation/screens/spaces_screen.dart';
import 'package:clickup/presentation/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  SpacesBloc _spacesBloc;
  TasksBloc _tasksBloc;
  SpacesRepository _spacesRepository;
  TasksRepository _tasksRepository;

  AppRouter() {
    _spacesRepository = SpacesRepository();
    _tasksRepository = TasksRepository();
    _spacesBloc = SpacesBloc(repository: _spacesRepository);
    _tasksBloc = TasksBloc(repository: _tasksRepository);
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
                value: _spacesRepository,
                child: BlocProvider.value(
                  value: _spacesBloc,
                  child: SpacesScreen(),
                )));
        break;
      case '/tasks':
        return MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
                value: _tasksRepository,
                child: BlocProvider.value(
                  value: _tasksBloc,
                  child: TasksScreen(list: settings.arguments),
                )));
        break;
      default:
        return null;
    }
  }

  void dispose() {
    _spacesBloc.close();
    _tasksBloc.close();
  }
}
