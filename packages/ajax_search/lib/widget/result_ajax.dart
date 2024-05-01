import 'package:ajax_search/model/search_response.dart';
import 'package:ajax_search/search_ajax_delegate.dart';
import 'package:ajax_search/widget/empty_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultAjax extends StatefulWidget {
  final String? search;
  final Function(CancelAjaxRequest action)? cancelRequestListener;
  final Future<List<dynamic>> Function(String endPoint, Map<String, dynamic> query) getSearchResult;
  final Function(String message)? onSearchError;
  final int? searchComponentId;
  final Function(String? postTitle, int? postId) onTapResult;
  final String Function(String text)? unescapeText;
  final Function()? clearText;

  const ResultAjax({
    Key? key,
    this.search,
    required this.cancelRequestListener,
    required this.getSearchResult,
    required this.onSearchError,
    required this.searchComponentId,
    required this.onTapResult,
    required this.unescapeText,
    required this.clearText,
  }) : super(key: key);

  @override
  State<ResultAjax> createState() => _ResultAjaxState();
}

class _ResultAjaxState extends State<ResultAjax> {
  List<SearchAjaxResponse> _data = [];
  bool _loading = true;

  @override
  void dispose() {
    if (widget.cancelRequestListener != null) {
      widget.cancelRequestListener!(CancelAjaxRequest.cancel);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    search();
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
        _loading = false;
      });
    } catch (e) {
      if (widget.onSearchError != null) {
        widget.onSearchError!("Cancel fetch");
      }
    }
  }

  // @override
  // void didUpdateWidget(oldWidget) {
  //   search();
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    if (_data.isNotEmpty) {
      return ListView.separated(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            widget.onTapResult(_data[index].postTitle!, _data[index].id);
          },
          horizontalTitleGap: 0,
          title: Text(unescape(_data[index].postTitle!), style: Theme.of(context).textTheme.titleSmall),
        ),
        itemCount: _data.length,
        separatorBuilder: (context, index) => const Divider(),
      );
    }
    if (_data.isEmpty && _loading && widget.search != '') {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return EmptyResultAjaxScreen(
      title: Text("Search result", style: Theme.of(context).textTheme.titleLarge),
      content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "No products were found matching \nyour selection.",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          )),
      iconData: Icons.search,
      textButton: Text(
        "Clear text",
        style: TextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
      ),
      styleBtn: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 61),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        widget.clearText?.call();
      },
    );
  }

  String unescape(String text) {
    if (widget.unescapeText != null) {
      return widget.unescapeText!(text);
    }
    return text;
  }
}
