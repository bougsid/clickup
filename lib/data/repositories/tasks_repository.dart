import 'dart:convert';

import 'package:clickup/data/models/task.dart';
import 'package:clickup/data/providers/api.dart';
import 'package:clickup/data/providers/db.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity/connectivity.dart';

import '../../locator.dart';

class TasksRepository {
  ClickUpApi get _clickUpApi => locator.get();
  DBProvider get _db => locator.get();

  Future<Task> createTask(Task task) async {
    try {
      Map<String, dynamic> result = await _clickUpApi.createTask(task.toJson());
      return Task.fromJson(result);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> deleteTask(String taskID) async {
    try {
      bool result = await _clickUpApi.deleteTask(taskID);
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<List<Task>> getListTasks(String listID) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      List<Task> tasks = [];
      List<Map<String, dynamic>> taskMaps;
      if (connectivityResult != ConnectivityResult.none) {
        taskMaps = List.castFrom(await _clickUpApi.getListTasks(listID));
        taskMaps.forEach((taskMap) {
          tasks.add(Task.fromJson(taskMap));
        });
        _cacheTasks(tasks);
      } else {
        tasks = await _cachedTasks(listID);
      }

      return tasks;
    } catch (e) {
      throw e;
    }
  }

  _cacheTasks(List<Task> tasks) {
    List<Map<String, dynamic>> tasksMapList = [];
    tasks.forEach((task) {
      tasksMapList.add(task.toMap());
    });
    _db.insertTasks(tasksMapList);
  }

  _cachedTasks(String listId) async {
    List<Map> tasksMap = await _db.getListTasks(listId);
    List<Task> tasks = [];
    for (Map taskMap in tasksMap) {
      tasks.add(Task.fromMap(taskMap));
    }
    return tasks;
  }
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}
