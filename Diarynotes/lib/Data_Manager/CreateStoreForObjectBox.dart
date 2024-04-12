import 'dart:io';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../objectbox.g.dart';

class ObjectBox{

  late final Store store;

  ObjectBox.create(this.store);


}

class ObjectBoxDataManage{

  Future<void> closeStore(ObjectBox objectBox) async{
    objectBox.store.close();
  }

  Future<void> boxOpenStore(ObjectBox objectBox) async{
    final directory = await getApplicationDocumentsDirectory();
    Store store = openStore(directory: p.join(directory.path));
    if(objectBox.store.isClosed()){
      ObjectBox.create(store);
    }
  }

  Future<void> deleteFile({required Directory dir}) async{
    dir.deleteSync(recursive: true);
  }
}