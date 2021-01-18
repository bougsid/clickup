import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ClickUpApi {
  ClickUpApi(this._apiToken) {
    dio = Dio();
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
  }

  String _apiToken;
  Dio dio;
  static const String _clickUpUrl = "https://api.clickup.com/api/v2";

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> task) async {
    try {
      String listId = task['list_id'];
      Response response = await dio.post("$_clickUpUrl/list/$listId/task",
          data: task,
          options: Options(
            headers: {
              'Authorization': _apiToken,
              'Content-Type': 'application/json',
            },
          ));

      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      Response response = await dio.delete("$_clickUpUrl/task/$id",
          options: Options(
            headers: {
              'Authorization': _apiToken,
              'Content-Type': 'application/json',
            },
          ));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Future<Map<String, dynamic>> createList(
  //     Map<String, dynamic> list, String folderID) async {
  //   try {
  //     Response response = await dio.post("$_clickUpUrl/list/$folderID/task",
  //         data: list,
  //         options: Options(
  //           headers: {
  //             'Authorization': _apiToken,
  //             'Content-Type': 'application/json',
  //           },
  //         ));

  //     return response.data;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<List<Map<String, dynamic>>> getTeams() async {
    try {
      Response response = await dio.get("$_clickUpUrl/team",
          options: Options(
            headers: {
              'Authorization': _apiToken,
              'Content-Type': 'application/json',
            },
          ));
      return response.data['teams'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<dynamic>> getTeamSpaces(String teamID) async {
    try {
      Response response = await dio.get("$_clickUpUrl/team/$teamID/space",
          options: Options(
            headers: {
              'Authorization': _apiToken,
              'Content-Type': 'application/json',
            },
          ));
      return response.data['spaces'];
    } catch (e) {
      throw e;
    }
  }

  Future<List<dynamic>> getListTasks(String listID) async {
    try {
      Response response = await dio.get("$_clickUpUrl/list/$listID/task",
          options: Options(
            headers: {
              'Authorization': _apiToken,
              'Content-Type': 'application/json',
            },
          ));
      return response.data['tasks'];
    } catch (e) {
      throw e;
    }
  }

  Future<List<dynamic>> getSpaceFolders(String spaceID) async {
    try {
      Response response = await dio.get("$_clickUpUrl/space/$spaceID/folder",
          options: Options(
            headers: {
              'Authorization': _apiToken,
              'Content-Type': 'application/json',
            },
          ));

      return response.data['folders'];
    } catch (e) {
      throw e;
    }
  }

  Future<List<Map<dynamic, dynamic>>> getFolderLists(String folderID) async {
    try {
      Response response = await dio.get("$_clickUpUrl/folder/$folderID/list",
          options: Options(
            headers: {
              'Authorization': _apiToken,
              'Content-Type': 'application/json',
            },
          ));

      return response.data['lists'];
    } catch (e) {
      throw e;
    }
  }
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}
