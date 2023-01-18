import 'dart:io';
import 'package:imagekit/src/model/auth_reponse.dart';
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

  /// using [upload] you can upload image to the server without thinking of the authentication
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
    Map<String, String> headers = const {},
    String? bearerToken,
    AuthEndpointRespose? auth,
  }) async {
    final auth = await getToken(
      bearerToken: bearerToken,
      headers: headers,
    );
    return uploadOnly(
      file,
      tags: tags,
      auth: auth,
      customMetadata: customMetadata,
    );
  }

  /// using [uploadOnly] you can upload image to the server and
  /// handle the imagekit authentication on your side
  Future<ImageKitResponse> uploadOnly(
    File file, {
    required AuthEndpointRespose auth,
    List<String> tags = const [],
    Map<String, dynamic> customMetadata = const {},
  }) async {
    final config = this.config;
    if (config == null) {
      throw "SDK Initilization failed, Public key is required to upload!";
    }
    _restClient ??= RestClient(this);
    return _restClient!.upload(
      file,
      auth: auth,
      tags: tags,
      customMetadata: customMetadata,
    );
  }

  /// If you want to get the token separately and re-use it in future you may use this method and store the token
  Future<AuthEndpointRespose> getToken({
    String? bearerToken,
    Map<String, String> headers = const {},
  }) async {
    final config = this.config;
    if (config == null) {
      throw "SDK Initilization failed, Auth Endpoint is missing";
    }
    final authEndpoint = config.authenticationEndpoint;
    _restClient ??= RestClient(this);
    return _restClient!.fetchAuthToken(
      authEndpoint,
      headers: {
        ...headers,
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      },
    );
  }
}
