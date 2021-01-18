part of 'tasks_bloc.dart';

@immutable
abstract class TasksEvent extends Equatable {}

class FetchTasks extends TasksEvent {
  final String listId;

  FetchTasks({@required this.listId});

  @override
  List<Object> get props => [listId];
}

class AddTask extends TasksEvent {
  final String listId;
  final String name;

  AddTask({@required this.listId, @required this.name});

  @override
  List<Object> get props => [name];
}

class UpdateTask extends TasksEvent {
  final Task task;

  UpdateTask({@required this.task});

  @override
  List<Object> get props => [task.id];
}

class DeleteTask extends TasksEvent {
  final Task task;
  DeleteTask({@required this.task});

  @override
  List<Object> get props => [task];
}

// class DismissNewTask extends TasksEvent {
//   @override
//   List<Object> get props => [];
// }
