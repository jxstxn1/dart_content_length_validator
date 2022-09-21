# Dart Content Length Validator

Ensures that your application is not vulnerable to large payload attacks.
Inspired by <https://github.com/ericmdantas/express-content-length-validator>

## Installing

```sh
dart pub add content_length_validator
```

## Usage

### As shelf middleware

```dart
import 'package:content_length_validator/content_length_validator.dart';

  var handler = const Pipeline()
      .addMiddleware(
        maxContentLengthValidator(
          maxContentLength: YOUR_CONTENT_LENGTH,
        ),
      )
      .addMiddleware(logRequests())
      .addHandler(_echoRequest);
```

### As dart_frog middleware

```dart
import 'package:content_length_validator/content_length_validator.dart';

Handler maxContentLengthValidator(Handler handler) {
    return handler.use(fromShelfMiddleware(maxContentLengthValidator(maxContentLength: YOUR_CONTENT_LENGTH,)));
}
```

### Defining custom error response

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
