import 'dart:convert';

import 'package:clickup/data/models/clickup_list.dart';
import 'package:clickup/data/models/folder.dart';
import 'package:clickup/data/models/space.dart';
import 'package:clickup/data/providers/api.dart';
import 'package:clickup/data/providers/db.dart';
import 'package:flutter/foundation.dart';

import '../../locator.dart';
import 'package:connectivity/connectivity.dart';

class SpacesRepository {
  ClickUpApi get _clickUpApi => locator.get();
  DBProvider get _db => locator.get();

  Future<List<Space>> getTeamSpaces(String teamID) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      List<Space> spaces = [];
      if (connectivityResult != ConnectivityResult.none) {
        List<dynamic> result = await _clickUpApi.getTeamSpaces(teamID);
        List<Map<String, dynamic>> spaceMaps = List.castFrom(result);
        spaceMaps.forEach((spaceMap) {
          spaces.add(Space.fromJson(spaceMap));
        });
        for (Space space in spaces) {
          space.folders = await _getSpaceFolders(space.id);
        }
        _cacheSpaces(spaces);
      } else {
        spaces = await _cachedSpaces(teamID);
      }

      return spaces;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Folder>> _getSpaceFolders(String spaceID) async {
    try {
      List<Folder> folders = [];
      List<dynamic> result = await _clickUpApi.getSpaceFolders(spaceID);

      List<Map<String, dynamic>> folderMaps = List.castFrom(result);

      folderMaps.forEach((folderMap) {
        Folder folder = Folder.fromJson(folderMap);
        folder.spaceId = spaceID;
        folders.add(folder);
      });

      return folders;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Space>> _cachedSpaces(String teamID) async {
    List<Map> spacesMap = await _db.getSpaces();
    List<Space> spaces = [];

    for (Map spaceMap in spacesMap) {
      Space space = Space.fromMap(spaceMap);
      List<Folder> folders = [];
      List<Map> foldersMap = await _db.getSpaceFolders(space.id);
      for (Map folderMap in foldersMap) {
        Folder folder = Folder.fromMap(folderMap);
        List<ClickupList> lists = [];
        List<Map> listsMap = await _db.getFolderLists(folder.id);
        for (Map listMap in listsMap) {
          lists.add(ClickupList.fromJson(listMap));
        }
        folder.lists = lists;
        folders.add(folder);
      }
      space.folders = folders;
      spaces.add(space);
    }
    return spaces;
  }

  _cacheSpaces(List<Space> spaces) {
    List<Map<String, dynamic>> spacesMapList = [];
    List<Map<String, dynamic>> foldersMapList = [];
    List<Map<String, dynamic>> listsMapList = [];
    spaces.forEach((space) {
      space.folders.forEach((folder) {
        folder.lists.forEach((list) {
          listsMapList.add(list.toMap());
        });
        foldersMapList.add(folder.toMap());
      });
      spacesMapList.add(space.toMap());
    });
    _db.insertLists(listsMapList);
    _db.insertFolders(foldersMapList);
    _db.insertSpaces(spacesMapList);
  }
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}
