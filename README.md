This is Imagekit SDK for Dart that allows you to upload images to the Imagekit server using the Imagekit SDK. It simplifies the process of using the Imagekit in flutter by handling all the necessary tasks.

## Features

- Upload Image
- Add Tags
- Add Custom Meta Data

## Getting started

You will need three data to use this SDK

- public key
- url endpoint
- auth endpoint

## Usage

To setup the imagekit you will need to call setConfig with these config data.

```dart

  final imagekit = ImageKit.getInstance();
  const config = Configuration(
    publicKey: 'your-public-key',
    urlEndpoint: 'https://ik.imagekit.io/your-endpoint',
    authenticationEndpoint: 'http://your-server.tld/imagekit/auth',
  );
  imagekit.setConfig(config);

```

To upload image anywhere in your code just call this

```dart

    final data = await imagekit.upload(selectedImageFile);

```

## Additional information

This is un-official package which is built using offical sdk of imagekit.
