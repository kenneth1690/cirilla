import 'package:ajax_search/search_ajax_delegate.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/search/search_post_store.dart';
import 'package:cirilla/store/search/search_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'product_search.dart';

class SearchFeature extends StatefulWidget {
  final String? searchLabel;
  final Widget? child;
  final bool? enableSearchPost;
  final BorderRadius? borderRadius;

  const SearchFeature({
    this.searchLabel,
    this.child,
    this.enableSearchPost,
    this.borderRadius,
    Key? key,
  }) : super(key: key);
  @override
  State<SearchFeature> createState() => SearchFeatureState();
}

class SearchFeatureState extends State<SearchFeature> {
  RequestHelper? _requestHelper;
  SearchStore? searchStore;
  SearchPostStore? searchPostStore;
  CancelToken? cancelToken;
  late SettingStore settingStore;
  late bool enableSearchPost;

  @override
  void initState() {
    enableSearchPost = widget.enableSearchPost == true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _requestHelper = Provider.of<RequestHelper>(context);
    settingStore = Provider.of<SettingStore>(context);
    searchStore = SearchStore(settingStore.persistHelper);
    searchPostStore = SearchPostStore(settingStore.persistHelper);

    super.didChangeDependencies();
  }

  Future<List<dynamic>> search(String endPoint, Map<String, dynamic> query) async {
    if (query['s'] != '') {
      try {
        dynamic data = await _requestHelper?.searchWithPlugin(
          endPoint: endPoint,
          queryParameters: query,
          cancelToken: cancelToken,
        );
        if (enableSearchPost) {
          searchPostStore!.addSearch(query['s']);
        } else {
          searchStore!.addSearch(query['s']);
        }

        return data;
      } catch (e) {
        avoidPrint('Cancel fetch');
      }
    }
    return [];
  }

  /// Search Ajax Delegate
  SearchDelegate<String?> searchAjaxDelegate({
    String? searchLable,
    int? postSearchId,
    int? productSearchId,
  }) {
    bool enablePost = enableSearchPost && postSearchId != -1;
    return SearchAjaxDelegate(
      context,
      searchLable ?? '',
      searchComponentId: enablePost ? postSearchId : productSearchId,
      getSearchResult: (String endPoint, Map<String, dynamic> query) {
        return search(endPoint, query);
      },
      onTapResult: (String? title, int? id) {
        if (enablePost) {
          // Result Post search
          searchPostStore!.addSearch(title!);
          Navigator.pushNamed(context, '${PostScreen.routeName}/$id');
        } else {
          // Result Product search
          searchStore!.addSearch(title!);
          Navigator.pushNamed(context, '${ProductScreen.routeName}/$id');
        }
      },
      recentSearchObservable: (Widget Function(List<String>) child) {
        return Observer(builder: (_) {
          List<String> dataRecentProduct = searchStore?.data.toList() ?? [];
          List<String> dataRecentPost = searchPostStore?.data.toList() ?? [];
          // List recent search
          return child(enablePost ? dataRecentPost : dataRecentProduct);
        });
      },
      removeRecentSearch: (value) {
        // Remove recent Post search
        if (enablePost) {
          if (value != null) {
            searchPostStore!.removeSearch(value);
          } else {
            searchPostStore!.removeAllSearch();
          }
        } else {
          // Remove recent Product search
          if (value != null) {
            searchStore!.removeSearch(value);
          } else {
            searchStore!.removeAllSearch();
          }
        }
      },
      cancelRequestListener: (action) {
        if (action == CancelAjaxRequest.cancel) {
          if (cancelToken != null) {
            cancelToken!.cancel();
            cancelToken = null;
          }
        } else {
          cancelToken = CancelToken();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    SearchDelegate<String?> delegate =
        enableSearchPost ? PostSearchDelegate(context, translate) : ProductSearchDelegate(context, translate);

    // Default Post search and Product search by plugin "ajax search pro"
    if (postSearchId == -1 && productSearchId != -1) {
      delegate = enableSearchPost
          ? PostSearchDelegate(context, translate)
          : searchAjaxDelegate(
              searchLable: translate('product_category_search'),
              postSearchId: postSearchId,
              productSearchId: productSearchId,
            );
    }

    // Post search by plugin "ajax search pro" and Default Product search
    if (productSearchId == -1 && postSearchId != -1) {
      delegate = enableSearchPost
          ? searchAjaxDelegate(
              searchLable: translate('post_category_search'),
              postSearchId: postSearchId,
              productSearchId: productSearchId,
            )
          : ProductSearchDelegate(context, translate);
    }

    // Default search
    if (productSearchId == -1 && postSearchId == -1) {
      delegate;
    }

    // Search by plugin "ajax search pro"
    if (productSearchId != -1 && postSearchId != -1) {
      delegate = searchAjaxDelegate(
        searchLable: enableSearchPost ? translate('post_category_search') : translate('product_category_search'),
        postSearchId: postSearchId,
        productSearchId: productSearchId,
      );
    }
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: widget.borderRadius,
      onTap: () async {
        await showSearch<String?>(context: context, delegate: delegate);
      },
      child: widget.child,
    );
  }
}
