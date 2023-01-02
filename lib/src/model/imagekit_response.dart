class ImageKitResponse {
  ImageKitResponse({
    required this.fileId,
    required this.name,
    required this.size,
    required this.versionInfo,
    required this.filePath,
    required this.url,
    required this.fileType,
    required this.height,
    required this.width,
    required this.thumbnailUrl,
    required this.aiTags,
  });

  final String fileId;
  final String name;
  final int size;
  final VersionInfo versionInfo;
  final String filePath;
  final String url;
  final String fileType;
  final int height;
  final int width;
  final String thumbnailUrl;
  final dynamic aiTags;

  factory ImageKitResponse.fromJson(Map<String, dynamic> json) {
    return ImageKitResponse(
      fileId: json["fileId"],
      name: json["name"],
      size: json["size"],
      versionInfo: VersionInfo.fromJson(json["versionInfo"]),
      filePath: json["filePath"],
      url: json["url"],
      fileType: json["fileType"],
      height: json["height"],
      width: json["width"],
      thumbnailUrl: json["thumbnailUrl"],
      aiTags: json["AITags"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fileId": fileId,
      "name": name,
      "size": size,
      "versionInfo": versionInfo.toJson(),
      "filePath": filePath,
      "url": url,
      "fileType": fileType,
      "height": height,
      "width": width,
      "thumbnailUrl": thumbnailUrl,
      "AITags": aiTags,
    };
  }
}

class VersionInfo {
  VersionInfo({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}
