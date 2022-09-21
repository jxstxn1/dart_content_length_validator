// ignore_for_file: avoid_print

import 'package:content_length_validator/content_length_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  final handler = const Pipeline()
      .addMiddleware(
        maxContentLengthValidator(
          maxContentLength: 999,
          errorResponse: Response(400, body: 'Only send payloads < 1000 bytes'),
        ),
      )
      .addMiddleware(logRequests())
      .addHandler(_echoRequest);

  final server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

Response _echoRequest(Request request) => Response.ok('Request for "${request.url}"');
