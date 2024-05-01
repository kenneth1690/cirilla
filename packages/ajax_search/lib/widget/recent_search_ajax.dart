import 'package:flutter/material.dart';

class RecentSearchAjax extends StatefulWidget {
  final String? search;
  final ValueChanged<String>? onChange;
  final Widget Function(Widget Function(List<String> searchStored) build) recentSearchObservable;
  final Function(String? value)? removeRecentSearch;
  final String Function(String text) unescape;
  const RecentSearchAjax({
    Key? key,
    this.search,
    this.onChange,
    required this.recentSearchObservable,
    required this.removeRecentSearch,
    required this.unescape,
  }) : super(key: key);
  @override
  State<RecentSearchAjax> createState() => _RecentSearchAjaxState();
}

class _RecentSearchAjaxState extends State<RecentSearchAjax> {
  @override
  Widget build(BuildContext context) {
    return widget.recentSearchObservable((searchStore) {
      if (searchStore.isEmpty) {
        return Container();
      }

      List<dynamic> dataRecent = searchStore.map((String title) => {'title': title}).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, top: 24, end: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recent", style: Theme.of(context).textTheme.titleLarge),
                  InkWell(
                    onTap: () {
                      if (widget.removeRecentSearch != null) {
                        widget.removeRecentSearch!(null);
                      }
                    },
                    child: Text("Clear all", style: Theme.of(context).textTheme.bodyMedium),
                  )
                ],
              )),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                String title = widget.unescape(dataRecent.elementAt(index)['title']);
                return ListTile(
                  onTap: () {
                    widget.onChange!(title);
                  },
                  title: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      if (widget.removeRecentSearch != null) {
                        widget.removeRecentSearch!(dataRecent.elementAt(index)['title']);
                      }
                    },
                    child: const Icon(Icons.close, size: 16),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: dataRecent.length,
            ),
          ),
        ],
      );
    });
  }
}
