import 'package:shelf/shelf.dart';

/// Middleware which will block to big requests.
///
/// [maxContentLength] Is the maximum allowed content length in bytes.
///
/// [errorStatus] Is the Http status code which will be returned if content length is too large.
/// The default status code is 400.
/// You can find more here: https://http.cat/400
///
/// [errorMessage] is the message which will be sent to the client if the content is too large.
Middleware maxContentLengthValidator({
  int maxContentLength = 999,
  int errorStatus = 400,
  String errorMessage = 'Invalid payload; too big',
}) {
  return (innerHandler) {
    return (request) {
      final contentLength = request.contentLength ?? 0;
      if (contentLength > maxContentLength) {
        return Response(errorStatus, body: errorMessage);
      }
      return innerHandler(request);
    };
  };
}
