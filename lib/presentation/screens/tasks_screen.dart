import 'package:clickup/data/models/clickup_list.dart';
import 'package:clickup/data/models/task.dart';
import 'package:clickup/logic/tasks/tasks_bloc.dart';
import 'package:clickup/presentation/widgets/task_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_task_screen.dart';

class TasksScreen extends StatefulWidget {
  final ClickupList list;

  const TasksScreen({Key key, @required this.list}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchTasks();
  }

  _fetchTasks() {
    BlocProvider.of<TasksBloc>(context).add(FetchTasks(listId: widget.list.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.list.name} Tasks'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(NewTaskOverlay(onSubmited: (taskName) {
                BlocProvider.of<TasksBloc>(context)
                    .add(AddTask(listId: widget.list.id, name: taskName));
              }));
            },
            child: Icon(Icons.add),
          ),
          body: _body(state),
        );
      },
    );
  }

  _body(state) {
    if (state is TasksLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is TasksLoaded) {
      return _buildTasksList(state.tasks);
    }
    return Text("default");
  }

  _buildTasksList(List<Task> tasks) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchTasks();
      },
      child: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 0,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          Task task = tasks[index];
          return TaskItemWidget(
            task: task,
            onDelete: () {
              BlocProvider.of<TasksBloc>(context).add(DeleteTask(task: task));
            },
            statuses: widget.list.statuses,
            onStatusSelected: (newStatus) {
              BlocProvider.of<TasksBloc>(context)
                  .add(UpdateTask(task: task.copyWith(status: newStatus)));
            },
          );
        },
      ),
    );
  }
}
