class AppwriteConstants {
  static const String endPoint = "http://192.168.0.105:80/v1";
  static const String projectId = "63e65f5b38caba16c84d";
  static const String databaseId = "64072575eab38954087f";
  static const String usersCollection = "64072592b9775571c4f9";
  static const String postCollection = "6408a2c67b09b450542b";
  static const String imagesBucketId = "6409fb395b8221c8883b";
  // static const String endPoint = "http://localhost:80/v1";

  static String imageUrl(String imageId) =>
      "$endPoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin";
}
