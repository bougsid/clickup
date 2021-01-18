import 'package:clickup/data/models/clickup_list.dart';
import 'package:clickup/data/models/folder.dart';
import 'package:clickup/data/models/space.dart';
import 'package:clickup/logic/spaces/spaces_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpacesScreen extends StatefulWidget {
  SpacesScreen({Key key}) : super(key: key);

  @override
  _SpacesScreenState createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<SpacesBloc>(context).add(FetchSpaces());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    return BlocBuilder<SpacesBloc, SpacesState>(
      builder: (context, state) {
        if (state is SpacesLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SpacesLoaded) {
          return SingleChildScrollView(
            child: Container(
              child: _buildSpacesPanel(state.spaces),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildSpacesPanel(List<Space> spaces) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          spaces[index].isExpanded = !isExpanded;
        });
      },
      children: spaces.map<ExpansionPanel>((Space space) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return PanelHeader(
                icon: Icons.laptop, title: space.name, color: Colors.red);
          },
          body: _buildFoldersPanel(space.folders),
          isExpanded: space.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _buildFoldersPanel(List<Folder> folders) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          folders[index].isExpanded = !isExpanded;
        });
      },
      children: folders.map<ExpansionPanel>((Folder folder) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: ListTile(
                leading: Icon(
                  folder.isExpanded ? Icons.folder_open : Icons.folder,
                  color: Colors.indigo,
                ),
                title: Text(
                  folder.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
          body: _buildClickupListsList(folder.lists),
          isExpanded: folder.isExpanded,
        );
      }).toList(),
    );
  }

  ListView _buildClickupListsList(List<ClickupList> lists) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
        thickness: 0.1,
      ),
      shrinkWrap: true,
      itemCount: lists.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(70, 0, 0, 0),
            dense: true,
            leading: Container(
              child: Icon(
                Icons.circle,
                color: Colors.blue,
                size: 10,
              ),
            ),
            title: Text(lists[index].name),
            onTap: () => {
              Navigator.of(context).pushNamed('/tasks', arguments: lists[index])
            },
          ),
        );
      },
    );
  }
}

class PanelHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const PanelHeader({
    Key key,
    this.title,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: color,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
