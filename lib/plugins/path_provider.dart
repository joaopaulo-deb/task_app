
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathProvider {
  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  static Future<File> saveData(list) async {
    String data = json.encode(list);

    final file = await getFile();
    return file.writeAsString(data);
  }

  static Future<String> readData() async {
    try {
      final file = await getFile();

      return file.readAsString();
    } catch (e){
      return null;
    }
  }
}