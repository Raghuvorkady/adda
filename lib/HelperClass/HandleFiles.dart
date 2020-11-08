import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class HandleFilesClass{
  createDir() async {
    //Directory baseDir = await getExternalStorageDirectory(); //only for Android
    Directory baseDir = await getApplicationDocumentsDirectory(); //works for both iOS and Android
    String dirToBeCreated = "<your_dir_name>";
    String finalDir = join(baseDir.path, dirToBeCreated);
    var dir = Directory(finalDir);
    bool dirExists = await dir.exists();
    if(!dirExists){
      dir.create(/*recursive=true*/); //pass recursive as true if directory is recursive
    }
    //Now you can use this directory for saving file, etc.
    //In case you are using external storage, make sure you have storage permissions.
    return dir.path;
  }

}