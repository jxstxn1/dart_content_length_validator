# Example

## Add the Middleware your Shelf API

by simply adding:

 ```dart
 .addMiddleware(
    maxContentLengthValidator(
      maxContentLength: YOUR_CONTENT_LENGTH,
    ),
  ),
 ```

you can define a custom error Response by setting the `errorResponse` parameter:

```dart
.addMiddleware(
    maxContentLengthValidator(
      maxContentLength: YOUR_CONTENT_LENGTH,
      errorResponse: Response(
        413,
        body: 'Your body is too long',
        ),
      ),
    ),
  ),
```

you can also add use the Middleware in DartFrog by doing the following:

```dart
Handler maxContentLengthValidator(Handler handler) {
    return handler.use(fromShelfMiddleware(maxContentLengthValidator()));
}
```

### Full example

```dart
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
```
