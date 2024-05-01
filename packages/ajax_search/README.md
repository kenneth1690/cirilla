## Features

 - Package for Ajax search pro plugin Wordpress

## Getting started


## Usage
 Follow docs & example:

 ```
 class SearchProductWidget extends StatefulWidget {
   const SearchProductWidget({Key? key}) : super(key: key);

   @override
   State<SearchProductWidget> createState() => _SearchProductWidgetState();
 }

 class _SearchProductWidgetState extends State<SearchProductWidget> {
   late SearchStore searchStore;
   List<String> _recentSearchStored = [];

   @override
   void didChangeDependencies() {
     SettingStore settingStore = Provider.of<SettingStore>(context);
     searchStore = SearchStore(settingStore.persistHelper);
     _recentSearchStored = searchStore.data;
     super.didChangeDependencies();
   }

   @override
   Widget build(BuildContext context) {
     ThemeData theme = Theme.of(context);
     TranslateType translate = AppLocalizations.of(context)!.translate;
     return Search(
       icon: const Icon(FeatherIcons.search, size: 16),
       label: Text(translate('product_category_search'), style: theme.textTheme.bodyText2),
       shape: RoundedRectangleBorder(
         borderRadius: borderRadius,
         side: BorderSide(width: 1, color: theme.dividerColor),
       ),
       color: theme.colorScheme.surface,
       onTap: () async {
         // Create cancelToken.
         CancelToken? cancelToken = CancelToken();
         await showSearch<String?>(
           context: context,
           delegate: SearchAjaxDelegate(context, "Ajax search",
               // Call API search.
               getSearchResult: (endPoint, query) async {
                 return await Provider.of<RequestHelper>(context).searchWithPlugin(
                   endPoint: endPoint,
                   queryParameters: query,
                   cancelToken: cancelToken,
                 );
               },
               // Handle onTap result.
               onTapResult: (title, productId) {
                 if (title != null) {
                   searchStore.addSearch(title);
                 }
                 Navigator.pushNamed(context, '${ProductScreen.routeName}/$productId');
               },
               // Observer recent search result.
               recentSearchObservable: (child) {
                 return Observer(
                   builder: (_) {
                     _recentSearchStored = searchStore.data;
                     return child(_recentSearchStored);
                   },
                 );
               },
               // Handle cancel request
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
               onSearchError: (message) {
                 debugPrint(message);
               },
               searchComponentId: 1,
               removeRecentSearch: (value) {
                 if (value != null) {
                   searchStore.removeSearch(value);
                 } else {
                   searchStore.removeAllSearch();
                 }
               }),
         );
       },
     );
   }
 }

 ```

