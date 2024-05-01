import 'package:ajax_search/model/search_response.dart';
import 'package:ajax_search/search_ajax_delegate.dart';
import 'package:ajax_search/widget/recent_search_ajax.dart';
import 'package:flutter/material.dart';

class SearchAjax extends StatefulWidget {
  final String? search;
  final ValueChanged<String>? onChange;
  final Function(CancelAjaxRequest action)? cancelRequestListener;
  final Future<List<dynamic>> Function(String endPoint, Map<String, dynamic> query) getSearchResult;
  final Function(String message)? onSearchError;
  final int? searchComponentId;
  final Widget Function(Widget Function(List<String> searchStored) child)? recentSearchObservable;
  final Function(String? value)? removeRecentSearch;
  final Function(String? postTitle, int? postId) onTapResult;
  final String Function(String text)? unescapeText;

  const SearchAjax(
      {Key? key,
      this.search,
      this.onChange,
      required this.cancelRequestListener,
      required this.getSearchResult,
      required this.onSearchError,
      required this.searchComponentId,
      required this.recentSearchObservable,
      required this.removeRecentSearch,
      required this.onTapResult,
      required this.unescapeText})
      : super(key: key);

  @override
  State<SearchAjax> createState() => _SearchAjaxState();
}

class _SearchAjaxState extends State<SearchAjax> {
  List<SearchAjaxResponse> _data = [];

  @override
  void dispose() {
    if (widget.cancelRequestListener != null) {
      // widget.cancelRequestListener!(CancelAjaxRequest.cancel);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> search() async {
    try {
      List<SearchAjaxResponse> searchData = [];
      var response = await widget.getSearchResult(ajaxSearchPluginEndPoint, {
        's': widget.search,
        'id': widget.searchComponentId,
      });
      for (var item in response) {
        searchData.add(SearchAjaxResponse.fromJson(item));
      }
      setState(() {
        _data = searchData;
      });
    } catch (e) {
      if (widget.onSearchError != null) {
        widget.onSearchError!("Cancel fetch");
      }
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.cancelRequestListener != null) {
      // CancelToken.cancel().
      widget.cancelRequestListener!(CancelAjaxRequest.cancel);
      // Create new CancelToken.
      widget.cancelRequestListener!(CancelAjaxRequest.create);
      search();
    } else {
      search();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.search == '') {
      return (widget.recentSearchObservable != null)
          ? RecentSearchAjax(
              search: widget.search,
              recentSearchObservable: widget.recentSearchObservable!,
              removeRecentSearch: widget.removeRecentSearch,
              onChange: widget.onChange,
              unescape: unescape,
            )
          : const SizedBox.shrink();
    }
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          widget.onTapResult(_data[index].postTitle!, _data[index].id);
        },
        leading: const Icon(Icons.search, size: 22),
        horizontalTitleGap: 0,
        title: Text(unescape(_data[index].postTitle!), style: Theme.of(context).textTheme.titleSmall),
      ),
      itemCount: _data.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  String unescape(String text) {
    if (widget.unescapeText != null) {
      return widget.unescapeText!(text);
    }
    return text;
  }
}
