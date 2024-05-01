import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

enum MenuItemType { single, multi }

class MenuItemContent {
  final String key;
  final String title;
  final Widget? subtitle;
  final MenuItemType type;
  final List<MenuOptionContent> options;
  final List<String> selectedKeys;

  MenuItemContent({
    required this.key,
    required this.title,
    required this.type,
    required this.options,
    this.subtitle,
    this.selectedKeys = const [],
  });
}

class MenuOptionContent {
  final String key;
  final String title;
  final IconData? icon;

  MenuOptionContent({
    required this.key,
    required this.title,
    this.icon,
  });
}

class IconMenuContent extends StatelessWidget {
  final IconData icon;
  final List<MenuItemContent> items;
  final void Function(String, List<String>)? onChange;

  const IconMenuContent({
    super.key,
    this.icon = Icons.more_vert,
    this.items = const [],
    this.onChange,
  });

  void onChangeOption(String key, String value, List<String> selectedKeys, MenuItemType type) {
    if (type == MenuItemType.single) {
      if (selectedKeys.isNotEmpty && selectedKeys[0] == value) {
        return;
      }
      onChange?.call(key, [value]);
    } else {
      List<String> newData = [...selectedKeys];
      if (newData.contains(value)) {
        newData.remove(value);
      } else {
        newData.add(value);
      }
      onChange?.call(key, newData);
    }
  }

  Widget buildOptions(MenuItemContent item) {
    MenuItemType type = item.type;
    List<MenuOptionContent> options = item.options;
    List<String> selectedKeys =
        type == MenuItemType.single && item.selectedKeys.length > 1 ? [item.selectedKeys[1]] : item.selectedKeys;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        options.length,
        (index) => buildItemOption(key: item.key, option: options[index], selectedKeys: selectedKeys, type: type),
      ),
    );
  }

  Widget buildItemOption({
    required String key,
    required MenuOptionContent option,
    required MenuItemType type,
    List<String> selectedKeys = const [],
  }) {
    bool selected = selectedKeys.contains(option.key);
    return CirillaTile(
      leading:
          type == MenuItemType.multi ? CirillaRadio.iconCheck(isSelect: selected) : CirillaRadio(isSelect: selected),
      title: Text(option.title),
      trailing: option.icon != null ? Icon(option.icon!, size: 20) : null,
      pad: 12,
      isChevron: false,
      isDivider: false,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: () => onChangeOption(key, option.key, selectedKeys, type),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return MenuAnchor(
      builder: (_, MenuController controller, __) {
        return IconButton(
          icon: Icon(icon, size: 20),
          onPressed: () {
            if (items.isNotEmpty) {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            }
          },
          splashRadius: 25,
        );
      },
      menuChildren: items.isNotEmpty
          ? List.generate(items.length, (index) {
              MenuItemContent item = items[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Flexible(child: Text(item.title, style: theme.textTheme.titleSmall)),
                        if (item.subtitle != null) ...[const SizedBox(width: 8), item.subtitle!],
                      ],
                    ),
                  ),
                  if (item.options.isNotEmpty) buildOptions(item),
                ],
              );
            })
          : [],
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(theme.cardColor),
        padding: MaterialStateProperty.all(const EdgeInsets.only(bottom: 30)),
      ),
    );
  }
}
