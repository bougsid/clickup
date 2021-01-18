import 'package:clickup/data/models/status.dart';
import 'package:clickup/data/models/task.dart';
import 'package:clickup/color_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jiffy/jiffy.dart';

class TaskItemWidget extends StatefulWidget {
  final Task task;
  final List<Status> statuses;
  final VoidCallback onDelete;
  final ValueSetter<Status> onStatusSelected;
  const TaskItemWidget(
      {Key key,
      @required this.task,
      @required this.statuses,
      @required this.onDelete,
      @required this.onStatusSelected})
      : super(key: key);

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: taskItem(widget.task),
    );
  }

  Slidable taskItem(Task task) {
    return Slidable(
      key: Key(task.id),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
            dense: true,
            leading: statusMenu(),
            title: Text(task.name),
            subtitle: Row(
              children: <Widget>[
                task.status != null ? statusItem(task.status) : Container(),
                task.dueDate != null ? taskDate(task) : Container(),
              ],
            )),
      ),
      dismissal: SlidableDismissal(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0
        },
        child: SlidableDrawerDismissal(),
        onDismissed: (_) => widget.onDelete(),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Set Date',
          foregroundColor: Theme.of(context).primaryColor,
          iconWidget: Icon(
            Icons.calendar_today_outlined,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () => {},
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          foregroundColor: Theme.of(context).errorColor,
          iconWidget: Icon(
            Icons.delete_outline,
            size: 20,
            color: Theme.of(context).errorColor,
          ),
          onTap: widget.onDelete,
        ),
      ],
    );
  }

  Widget statusMenu() {
    return PopupMenuButton<Status>(
        elevation: 4,
        initialValue: widget.task.status,
        icon: Icon(
          Icons.check,
          size: 20,
        ),
        onSelected: widget.onStatusSelected,
        itemBuilder: (BuildContext context) =>
            widget.statuses.map<PopupMenuItem<Status>>((Status status) {
              return PopupMenuItem<Status>(
                value: status,
                child: statusItem(status),
              );
            }).toList());
  }

  Widget statusItem(Status status) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.circle,
          size: 10,
          color: status.color != null ? HexColor(status.color) : Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            status.name,
            style: TextStyle(
                color: status.color != null
                    ? HexColor(status.color)
                    : Colors.grey),
          ),
        )
      ],
    );
  }

  Widget taskDate(Task task) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.calendar_today,
          size: 15,
          color: Theme.of(context).primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Jiffy(task.dueDate).format('MMM do yy'),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
