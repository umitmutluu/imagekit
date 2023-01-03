import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imagekit/imagekit.dart';
import 'package:imagekit/src/model/auth_reponse.dart';

class RestClient {
  static const uploadBaseUrl = 'https://upload.imagekit.io/api/v1/files/upload';

  static HttpClient _getHttpClient() {
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    return httpClient;
  }

  ImageKit imageKit;
  // Request request;
  // MultipartBuilder multipartBuilder;

  RestClient(this.imageKit);
  // this.multipartBuilder = new MultipartBuilder();

  Future<ImageKitResponse> upload(
    File file, {
    required AuthEndpointRespose auth,
    List<String> tags = const [],
    Map<String, dynamic> customMetadata = const {},
    Map<String, String> headers = const {},
  }) async {
    final config = imageKit.config;
    if (config == null) {
      throw "SDK Initilization failed, Please setup Config!";
    }
    final response = await _getHttpResepose(
      file,
      auth,
      customMetadata,
      tags,
      config,
    );
    final statusCode = response.statusCode;
    final data = await _readResponseAsString(response);
    if (statusCode ~/ 100 != 2) {
      throw Exception(data);
    } else {
      final json = jsonDecode(data);
      return ImageKitResponse.fromJson(json);
    }
  }

  Future<HttpClientResponse> _getHttpResepose(
    File file,
    AuthEndpointRespose authResponse,
    Map<String, dynamic> customMetadata,
    List<String> tags,
    Configuration config,
  ) async {
    final httpClient = _getHttpClient();

    String fileName = file.path.split('/').last;
    final request = await httpClient.postUrl(Uri.parse(uploadBaseUrl));

    // Prepare Multipart
    final requestMultipart =
        http.MultipartRequest("Post", Uri.parse(uploadBaseUrl));
    final multipart = await http.MultipartFile.fromPath("file", file.path);
    requestMultipart.files.add(multipart);
    requestMultipart.fields["fileName"] = fileName;
    if (tags.isNotEmpty) {
      requestMultipart.fields["tags"] = tags.join(',');
    }
    if (customMetadata.isNotEmpty) {
      requestMultipart.fields["customMetadata"] = jsonEncode(customMetadata);
    }
    requestMultipart.fields["token"] = authResponse.token;
    requestMultipart.fields["expire"] = authResponse.expire.toString();
    requestMultipart.fields["signature"] = authResponse.signature;
    requestMultipart.fields["publicKey"] = config.publicKey;

    // Finalize multipart
    final msStream = requestMultipart.finalize();
    final totalByteLength = requestMultipart.contentLength;
    request.contentLength = totalByteLength;
    request.headers.set(
      HttpHeaders.contentTypeHeader,
      requestMultipart.headers[HttpHeaders.contentTypeHeader]!,
    );
    Stream<List<int>> stream = msStream.transform(
      StreamTransformer.fromHandlers(),
    );
    await request.addStream(stream);
    final httpResponse = await request.close();
    return httpResponse;
  }

  Future<String> _readResponseAsString(
    HttpClientResponse response,
  ) {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen(
          (String data) => contents.write(data),
          onDone: () => completer.complete(contents.toString()),
          onError: (e) => throw e,
        );
    return completer.future;
  }

  Future<AuthEndpointRespose> fetchAuthToken(
    String endpoint, {
    Map<String, String> headers = const {},
  }) async {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw "Authentication Failed";
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    final keys = body.keys;
    final expectedKey = ['expire', 'signature', 'token'];
    final hasTopLevel = expectedKey.every((element) => body[element] != null);
    if (hasTopLevel) return AuthEndpointRespose.fromMap(body);
    final key = keys.firstWhere(
      (key) {
        final data = body[key];
        if (data is Map) expectedKey.every((element) => data[element] != null);
        return false;
      },
      orElse: () => '',
    );
    if (key.isEmpty) {
      throw "Invalid response from authenticationEndpoint. The SDK expects a JSON response with three fields i.e. signature, token and expire.";
    }
    final result = AuthEndpointRespose.fromMap(body[key]);
    return result;
  }
}
