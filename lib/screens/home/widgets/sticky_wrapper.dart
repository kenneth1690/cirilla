import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickable_screen_flutter/stickable_screen_flutter.dart';

class StickyWrapper extends StatefulWidget {
  const StickyWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  State<StickyWrapper> createState() => _StickyWrapperState();
}

class _StickyWrapperState extends State<StickyWrapper> with NavigationMixin {
  late SettingStore settingStore;

  @override
  void didChangeDependencies() {
    settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? data = settingStore.data?.settings!['general']!.widgets!['general']!.fields;
    bool enableStickyBanner = get(data, ['enableStickyBanner'], false);
    List itemStickyBanner = get(data, ['itemStickyBanner'], []);
    if (!enableStickyBanner || itemStickyBanner.isEmpty) {
      return widget.child;
    }
    return StickableScreen(
      sticker: List.generate(itemStickyBanner.length, (index) {
        final Map<String, dynamic> stickyBanner = itemStickyBanner[index];
        final Map<String, dynamic> data = get(stickyBanner, ['data']);
        final Map<String, dynamic> position = get(data, ['position']);

        String imageSrc = get(data, ['image', settingStore.imageKey], '');
        Size imageSize = ConvertData.toSizeValue(data['imageSize'], const Size(32, 32));
        double? height = ConvertData.stringToDoubleCanBeNull(position['height']);
        double? width = ConvertData.stringToDoubleCanBeNull(position['width']);
        double? left = ConvertData.stringToDoubleCanBeNull(position['left']);
        double? right = ConvertData.stringToDoubleCanBeNull(position['right']);
        double? top = ConvertData.stringToDoubleCanBeNull(position['top']);
        double? bottom = ConvertData.stringToDoubleCanBeNull(position['bottom']);
        double? elevation = ConvertData.stringToDoubleCanBeNull(data['elevation']);
        double? radius = ConvertData.stringToDoubleCanBeNull(data['radius']);
        BoxFit boxFit = ConvertData.toBoxFit(get(data, ['fit'], 'cover'));
        Color shadowColor = ConvertData.fromRGBA(get(data, ['shadowColor'], {}), Colors.black);
        Map<String, dynamic> action = get(data, ['action'], {});
        int? delay = ConvertData.stringToIntCanBeNull(get(data, ['delay']));
        bool enableDraggable = get(data, ['enableDragable'], false);
        return StickableSticker(
          height: height,
          width: width,
          position: StickablePosition(
            left: left,
            right: right,
            top: top,
            bottom: bottom,
          ),
          delayShowing: delay,
          draggable: enableDraggable,
          closeWidget: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.6),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.black,
              size: 15,
            ),
          ),
          child: imageSrc.isNotEmpty == true
              ? GestureDetector(
                  onTap: () => navigate(context, action),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius ?? 0),
                    ),
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    shadowColor: shadowColor,
                    elevation: elevation,
                    child: Image.network(
                      imageSrc,
                      width: imageSize.width,
                      height: imageSize.height,
                      fit: boxFit,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      }).toList(),
      child: widget.child,
    );
  }
}
