// ignore_for_file: avoid_print

class SerializerHelper {
  static ObjectType mapToObject<MapType, ObjectType>(
      Map<String, MapType> dataMap, ObjectType obj) {
    dataMap.forEach((key, value) {
      (obj as dynamic);
    });
    return obj;
  }
}
