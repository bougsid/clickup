part of 'tasks_bloc.dart';

@immutable
abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;
  TasksLoaded({@required this.tasks});

  TasksLoaded copyWith({List<Task> tasks}) {
    return TasksLoaded(
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  String toString() => 'TasksLoaded with tasks= ${tasks.length}';
}
