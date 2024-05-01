import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareVideoShop extends StatelessWidget {
  const ShareVideoShop({Key? key, required this.permalink, required this.name}) : super(key: key);
  final String? permalink;
  final String? name;

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      width: 60.0,
      height: 60.0,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _share();
            },
            child: const Icon(Icons.reply, size: 30.0, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              translate("product_share"),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.0),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _share() async {
    Share.share(permalink ?? "", subject: name ?? "");
  }
}
