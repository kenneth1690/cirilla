library ajax_search;

import 'package:ajax_search/widget/result_ajax.dart';
import 'package:ajax_search/widget/search_ajax.dart';
import 'package:flutter/material.dart';

const String ajaxSearchPluginEndPoint = "/ajax-search-pro/v0/woo_search";

enum CancelAjaxRequest { cancel, create }

class SearchAjaxDelegate extends SearchDelegate<String?> {
  SearchAjaxDelegate(
    BuildContext context,
    String searchLabel, {
    required this.getSearchResult,
    this.cancelRequestListener,
    this.onSearchError,
    this.searchComponentId,
    required this.onTapResult,
    required this.recentSearchObservable,
    this.removeRecentSearch,
    this.unescapeText,
  }) : super(searchFieldLabel: searchLabel);

  /// Get search result function.
  ///
  /// The first argument is end point of api.
  ///
  /// The second argument is query parameter
  final Future<List<dynamic>> Function(String endPoint, Map<String, dynamic> query) getSearchResult;

  /// Listen cancel-request action changes.
  ///
  /// Use it in conjunction with CancelToken to cancel search request
  ///
  /// and search performance will be improved.
  ///
  /// Example:
  /// ```dart
  /// cancelRequestListener: (action) {
  ///    if (action == CancelAjaxRequest.cancel) {
  ///       if (cancelToken != null) {
  ///          cancelToken!.cancel();
  ///          cancelToken = null;
  ///       }
  ///    } else {
  ///       cancelToken = CancelToken();
  ///    }
  /// },
  /// ```
  final Function(CancelAjaxRequest action)? cancelRequestListener;

  /// Called when error or cancel request is thrown.
  final Function(String message)? onSearchError;

  /// Create recent search widget.
  ///
  /// Note: Wrap it by observable widget to rebuild when data is changed.
  ///
  /// The argument is a function to create child widget, this function
  ///
  /// need list of recent search result which you stored before.
  ///
  /// Example:
  ///
  /// ```dart
  /// recentSearchObservable: (child) {
  ///     return Observer(
  ///        builder: (_){
  ///           _recentSearchStored = searchStore.data;
  ///           return child(_recentSearchStored);
  ///        },
  ///    );
  /// },
  /// ```
  final Widget Function(Widget Function(List<String> searchStored) child)? recentSearchObservable;

  /// Remove recent search from store.
  ///
  /// Example
  ///
  /// ```dart
  ///  removeRecentSearch: (value){
  ///      if(value != null){
  ///         searchStore.removeSearch(value);
  ///      }else{
  ///         searchStore.removeAllSearch();
  ///      }
  ///  }
  /// ```
  final Function(String? value)? removeRecentSearch;

  /// Called when tap search result.
  ///
  /// If you want store search result, handle it here.
  final Function(String? postTitle, int? postId) onTapResult;

  /// Unescape text function.
  final String Function(String text)? unescapeText;

  /// Id of search component.
  ///
  /// Find it in Search Ajax Pro plugin > Search instances
  final int? searchComponentId;

  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme.bodyMedium,
        border: InputBorder.none,
      ),
      textTheme: query != '' ? textTheme.copyWith(titleLarge: textTheme.titleSmall!) : null,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchAjax(
      search: query,
      onChange: (String? title) {
        query = title ?? '';
      },
      removeRecentSearch: removeRecentSearch,
      recentSearchObservable: recentSearchObservable,
      cancelRequestListener: cancelRequestListener,
      getSearchResult: getSearchResult,
      onSearchError: onSearchError,
      onTapResult: onTapResult,
      searchComponentId: searchComponentId,
      unescapeText: unescapeText,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ResultAjax(
      search: query,
      cancelRequestListener: cancelRequestListener,
      getSearchResult: getSearchResult,
      onSearchError: onSearchError,
      onTapResult: onTapResult,
      searchComponentId: searchComponentId,
      unescapeText: unescapeText,
      clearText: () {
        query = '';
        showSuggestions(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => Navigator.pop(context),
        )
      else
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear, size: 22),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

}
