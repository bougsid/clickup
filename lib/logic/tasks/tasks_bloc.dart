import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clickup/data/models/task.dart';
import 'package:clickup/data/repositories/tasks_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository repository;

  TasksBloc({@required this.repository}) : super(TasksInitial());

  @override
  Stream<TasksState> mapEventToState(
    TasksEvent event,
  ) async* {
    if (event is FetchTasks) {
      yield* _mapFetchTasksToState(event);
    } else if (event is AddTask) {
      yield* _mapAddNewTaskToState(event);
    } else if (event is UpdateTask) {
      yield* _mapUpdateTaskToState(event);
    } else if (event is DeleteTask) {
      yield* _mapDeleteTaskToState(event);
    }
  }

  Stream<TasksState> _mapFetchTasksToState(
    FetchTasks event,
  ) async* {
    yield TasksLoading();
    List<Task> tasks = await repository.getListTasks(event.listId);
    yield TasksLoaded(tasks: List.from(tasks.reversed));
  }

  Stream<TasksState> _mapAddNewTaskToState(
    AddTask event,
  ) async* {
    if (state is TasksLoaded) {
      Task task = Task();
      task.name = event.name;
      List<Task> tasks = (state as TasksLoaded).tasks;
      tasks.add(task);
      yield TasksLoaded(tasks: tasks);
      task.listId = event.listId;
      await repository.createTask(task);
      tasks = await repository.getListTasks(event.listId);
      yield TasksLoaded(tasks: List.from(tasks.reversed));
    }
  }

  Stream<TasksState> _mapUpdateTaskToState(
    UpdateTask event,
  ) async* {
    if (state is TasksLoaded) {
      List<Task> tasks = (state as TasksLoaded).tasks;
      tasks[tasks.indexOf(event.task)] = event.task;
      yield TasksLoaded(tasks: tasks);
      // We could make an api call to update it
    }
  }

  Stream<TasksState> _mapDeleteTaskToState(
    DeleteTask event,
  ) async* {
    if (state is TasksLoaded) {
      List<Task> tasks = (state as TasksLoaded).tasks;
      tasks.remove(event.task);
      yield TasksLoaded(tasks: tasks);

      await repository.deleteTask(event.task.id);
      tasks = await repository.getListTasks(event.task.listId);
      yield TasksLoaded(tasks: List.from(tasks.reversed));
    }
  }

  // Stream<TasksState> _mapAddDismissTaskToState(
  //   DismissNewTask event,
  // ) async* {
  //   if (state is TasksLoaded) {
  //     yield null;
  //   }
  // }
}
