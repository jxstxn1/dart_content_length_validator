import 'package:shelf/shelf.dart';

/// Copied from the Shelf package.
/// https://github.com/dart-lang/shelf/blob/master/pkgs/shelf/test/test_util.dart

/// A simple, synchronous handler for [Request].
///
/// By default, replies with a status code 200, empty headers, and
/// `Hello from ${request.url.path}`.
Response syncHandler(
  Request request, {
  int? statusCode,
  Map<String, String>? headers,
}) {
  return Response(
    statusCode ?? 200,
    headers: headers,
    body: 'Hello from ${request.requestedUri.path}',
  );
}

Future<Response> makePostRequest(
  Handler handler, {
  Map<String, Object>? headers,
  Object? body,
}) {
  return Future.sync(
    () {
      return handler(
        Request(
          'POST',
          localhostUri,
          headers: headers,
          body: body,
        ),
      );
    },
  );
}

final localhostUri = Uri.parse('http://localhost/');
