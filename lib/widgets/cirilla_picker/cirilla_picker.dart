import 'dart:io';

import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CirillaPicker extends StatefulWidget {
  final MultipartFile? value;
  final ValueChanged<MultipartFile?>? onChange;

  const CirillaPicker({
    super.key,
    this.value,
    this.onChange,
  });

  @override
  State<CirillaPicker> createState() => _CirillaPickerState();
}

class _CirillaPickerState extends State<CirillaPicker> {
  final ImagePicker _picker = ImagePicker();

  void _onChange(String file) async {
    if (file != '') {
      MultipartFile filePicker = await MultipartFile.fromFile(
        file,
        filename: file.split('/').last,
      );
      widget.onChange?.call(filePicker);
    }
  }

  void _pickImageAndFile(BuildContext context, TranslateType translate) async {
    final action = CupertinoActionSheet(
      actions: [
        // Take Photo
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () async {
            try {
              XFile? file = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 600);
              _onChange(file?.path ?? '');
            } catch (e) {
              avoidPrint(e);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(translate("picker_take_photo")),
        ),
        // Photo library
        CupertinoActionSheetAction(
          onPressed: () async {
            try {
              XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 600);
              _onChange(file?.path ?? '');
            } catch (e) {
              avoidPrint(e);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(translate("picker_photo_library")),
        ),
        // Select file
        CupertinoActionSheetAction(
          onPressed: () async {
            try {
              FilePickerResult? file = await FilePicker.platform.pickFiles();
              String path = file?.files.single.path ?? '';
              _onChange(File(path).path);
            } catch (e) {
              avoidPrint(e);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(translate("picker_file_library")),
        ),
        if (widget.value != null)
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: Text(translate("picker_remove_file")),
            onPressed: () {
              widget.onChange?.call(null);
              Navigator.pop(context);
            },
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(translate("picker_cancel")),
        onPressed: () => Navigator.pop(context),
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Row(
      children: [
        Expanded(
          child: widget.value is MultipartFile
              ? Text(
                  widget.value!.filename ?? "",
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleSmall?.color),
                )
              : Text(
                  translate("picker_no_file"),
                  style: theme.textTheme.bodyMedium,
                ),
        ),
        const SizedBox(width: itemPaddingMedium),
        ElevatedButton(
          onPressed: () => _pickImageAndFile(context, translate),
          child: Text(
            widget.value is MultipartFile ? translate("picker_change_file") : translate("picker_select_file"),
          ),
        ),
      ],
    );
  }
}
