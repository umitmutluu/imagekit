import 'dart:io';
import 'package:imagekit/src/model/configuration.dart';
import 'package:imagekit/src/model/imagekit_response.dart';
import 'package:imagekit/src/tasks/rest_client.dart';

class ImageKit {
  /// RestClient calls the imagekit using REST API and
  /// perform the requested operation
  RestClient? _restClient;

  /// Contains the config of required for image upload
  Configuration? _config;

  /// You may see the active config using this config
  Configuration? get config => _config;

  ImageKit._();

  static ImageKit? _imageKit;
  static final ImageKit _instance = ImageKit._();

  /// Get the instance of Imagekit
  ///
  ///
  /// If you have called [setConfig] then the instace will have that config
  static ImageKit getInstance() => _imageKit ??= _instance;

  /// Set the Config required for image Upload
  ///
  ///
  /// You may find this config on imagekit dashboard
  /// i.e. publicKey, urlEndpoint, authenticationEndpoint
  void setConfig(Configuration config) => _config = config;

  /// using [upload] you can upload image to the server
  ///
  ///
  ///
  /// [tags] : If you would like to attach tag for the image
  ///
  /// [customMetadata] : If you would like to add any custom data
  /// To add customMetadata you need to do some setup in imagekit dashboard first
  Future<ImageKitResponse> upload(
    File file, {
    List<String> tags = const [],
    Map<String, dynamic> customMetadata = const {},
  }) async {
    if (config == null) throw "Please setConfig before uploading";
    _restClient ??= RestClient(this);
    return _restClient!.upload(
      file,
      tags: tags,
      customMetadata: customMetadata,
    );
  }
}
