import 'package:flutter/material.dart';

class NewTaskWidget extends StatefulWidget {
  final ValueSetter<String> onSubmitted;
  const NewTaskWidget({Key key, this.onSubmitted}) : super(key: key);

  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<NewTaskWidget> {
  FocusNode _focusNode;

  String taskName;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode = FocusNode(debugLabel: 'TextField');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      elevation: 10,
      child: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0),
            )),
        padding: new EdgeInsets.all(10.0),
        child: Column(
          children: [_buildTaskNameInput(), _buildOptionsRow()],
        ),
      ),
    );
  }

  TextField _buildTaskNameInput() {
    return new TextField(
      focusNode: _focusNode,
      autofocus: true,
      onSubmitted: widget.onSubmitted,
      onChanged: (text) {
        taskName = text;
      },
      decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        // suffixIcon: IconButton(
        //   icon: Icon(Icons.send),
        //   onPressed: () => widget.onSubmitted(taskName),
        // ),
        hintText: 'Task name',
      ),
    );
  }

  Row _buildOptionsRow() {
    return Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.camera_alt,
              color: Colors.grey,
            )),
        Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.attach_file,
              color: Colors.grey,
            )),
        Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.flag_outlined,
              color: Colors.grey,
            )),
        Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        Expanded(
          child: Container(),
        ),
        _buildAddButton(),
      ],
    );
  }

  Container _buildAddButton() {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: new BorderRadius.all(Radius.circular(30.0))),
        child: SizedBox(
          height: 30.0,
          width: 30.0,
          child: IconButton(
            padding: new EdgeInsets.all(0.0),
            iconSize: 20,
            onPressed: () => widget.onSubmitted(taskName),
            icon: Icon(
              Icons.arrow_upward,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ));
  }
}
