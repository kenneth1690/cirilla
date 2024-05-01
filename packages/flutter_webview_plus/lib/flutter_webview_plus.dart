library flutter_webview_plus;

import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
mixin FlutterWebViewPlusMixin {
  List<String>? fileList = [];
  // Convert data
  Future<String> _getData({required String pickedFile}) async {
    final file = File(pickedFile);
    return file.uri.toString();
  }

  // Support upload file on Webview for Android
  Future<List<String>> androidFilePicker(
    BuildContext context, {
    bool barrierDismissible = true,
    bool selectMultiplePhotos = false,
  }) async {
    String fileName = '';
    final ImagePicker picker = ImagePicker();
    fileList = await showCupertinoModalPopup<List<String>>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            // Upload: Take photo
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () async {
                XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  fileName = await _getData(pickedFile: pickedFile.path);
                  fileList!.add(fileName);
                }
                if (context.mounted) Navigator.pop(context, fileList);
              },
              child: const Text("Take Photo"),
            ),
            // Upload: Photo
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  fileName = await _getData(pickedFile: pickedFile.path);
                  fileList!.add(fileName);
                }
                if (context.mounted) Navigator.pop(context, fileList);
              },
              child: const Text("Photo Library"),
            ),
            // Upload: File library
            CupertinoActionSheetAction(
              onPressed: () async {
                FilePickerResult? file = await FilePicker.platform.pickFiles();
                String path = file?.files.single.path ?? '';
                fileName = await _getData(pickedFile: path);
                fileList!.add(fileName);
                if (context.mounted) Navigator.pop(context, fileList);
              },
              child: const Text('File Library'),
            ),
            // Upload: Multiple photos
            Visibility(
              visible: selectMultiplePhotos,
              child: CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () async {
                  List<XFile> pickedFileList = await picker.pickMultiImage(imageQuality: 50, maxWidth: 600);
                  if (pickedFileList.isNotEmpty) {
                    for (var file in pickedFileList) {
                      fileName = await _getData(pickedFile: file.path);
                      fileList!.add(fileName);
                    }
                  }
                  if (context.mounted) Navigator.pop(context, fileList);
                },
                child: const Text("Select Multiple Photos"),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancel"),
            onPressed: () {
              if (context.mounted) Navigator.pop(context, fileList);
            },
          ),
        );
      },
    );
    return fileList ?? [];
  }

  // Support geolocation on Webview for Android
  Future<GeolocationPermissionsResponse> geolocationPermissionsResponse() async {
    await _handlePermission();
    return const GeolocationPermissionsResponse(allow: true, retain: true);
  }
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    await Geolocator.getCurrentPosition();
    return true;
  }
}
