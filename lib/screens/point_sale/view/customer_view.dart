import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/customer_item.dart';
import 'form_customer_view.dart';

class CustomerView extends StatefulWidget {
  final Customer? customer;
  final ValueChanged<Customer?> onChangeCustomer;

  const CustomerView({
    super.key,
    this.customer,
    required this.onChangeCustomer,
  });

  @override
  State<StatefulWidget> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> with SnackMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  final MenuController _menuController = MenuController();
  late SettingStore _settingStore;

  List<Customer> _customers = [];
  bool _loading = false;
  CancelToken? _token;

  @override
  void initState() {
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    _controller.addListener(() {
      String text = _controller.text;
      if (_token != null) {
        _token?.cancel('cancelled');
      }

      setState(() {
        _token = CancelToken();
      });

      if (text.isNotEmpty) {
        onSearch(search: text, token: _token);
        if (!_menuController.isOpen) {
          _menuController.open();
        }
      } else {
        setState(() {
          _customers = [];
          _loading = false;
        });
        if (_menuController.isOpen) {
          _menuController.close();
        }
      }
    });
    _focus.addListener(() {
      if (!_focus.hasPrimaryFocus && !_menuController.isOpen) {
        _controller.clear();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _token?.cancel('cancelled');
    super.dispose();
  }

  void onSearch({String search = "", CancelToken? token}) async {
    try {
      setState(() {
        _loading = true;
      });
      List<Customer> data = await _settingStore.requestHelper.getCustomers(
        queryParameters: {
          "page": 1,
          "per_page": 10,
          "search": search,
        },
        cancelToken: token,
      );
      setState(() {
        _customers = data;
        _loading = false;
      });
    } on DioException catch (_) {
    }
  }
  void onSelectedCustomer(Customer customer) {
    widget.onChangeCustomer(customer);

    if (_menuController.isOpen) {
      _menuController.close();
      _controller.clear();
    }
  }

  void onAddCustomer() {
    String text = _controller.text;

    if (_menuController.isOpen) {
      _menuController.close();
      _controller.clear();
    }
    List<String> listArr = text.split(" ");

    Map<String, dynamic> data = {
      if (listArr.isNotEmpty) "first_name": listArr.elementAt(0),
      if (listArr.length > 1) "last_name": listArr.elementAt(1),
    };
    showFormCustomer(data);
  }

  void showFormCustomer([Map<String, dynamic>? data]) async {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    bool update = widget.customer != null;

    Customer? value = await showModalBottomSheet<Customer?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        MediaQueryData mediaQuery = MediaQuery.of(context);

        return Container(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height - 150),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: Text(update ? translate("point_sale_update_customer") : translate("point_sale_add_customer"), style: theme.textTheme.titleMedium),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                      child: FormCustomerView(
                        data: data,
                        customer: widget.customer,
                        onSuccess: (data) {
                          Navigator.pop(context, data);
                          showSuccess(context, update ? translate("point_sale_update_customer_success") : translate("point_sale_add_customer_success"));
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    FocusManager.instance.primaryFocus?.unfocus();
    if (value != null) {
      widget.onChangeCustomer(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (widget.customer != null) {
      return CirillaTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CirillaCacheImage(
            widget.customer!.avatar,
            width: 30,
            height: 30,
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.customer?.getName() ?? "",
                style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color)),
            Text(widget.customer!.email ?? "", style: theme.textTheme.labelSmall),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => widget.onChangeCustomer(null),
        ),
        height: 47,
        isDivider: false,
        isChevron: false,
        pad: 12,
        padding: const EdgeInsetsDirectional.only(start: 20, end: 4),
        onTap: showFormCustomer,
      );
    }

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double width = constraints.maxWidth;

        List<Customer> emptyCustomers = List.generate(10, (index) => Customer()).toList();
        List<Customer> data = _loading ? emptyCustomers : _customers;

        return MenuAnchor(
          controller: _menuController,
          menuChildren: [
            SizedBox(
              width: width,
              child: Column(
                children: List.generate(
                  data.length,
                      (index) => CustomerItem(
                    customer: data[index],
                    onClick: () => onSelectedCustomer(data[index]),
                  ),
                ),
              ),
            ),
            CirillaTile(
              leading: Container(
                width: 30,
                alignment: Alignment.center,
                child: const Icon(Icons.add),
              ),
              pad: 12,
              title: Text(translate("point_sale_add_new_customer", {"text": _controller.text})),
              height: 48,
              onTap: onAddCustomer,
              isDivider: false,
              isChevron: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
          style: MenuStyle(
            minimumSize: MaterialStateProperty.all(Size(width, 0)),
            maximumSize: MaterialStateProperty.all(Size(width, 300)),
            backgroundColor: MaterialStateProperty.all(theme.cardColor),
          ),
          alignmentOffset: const Offset(0, 1),
          child: TextFormField(
            controller: _controller,
            focusNode: _focus,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.canvasColor,
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(start: 20, end: 12),
                child: Icon(FontAwesomeIcons.addressCard, size: 18, color: theme.iconTheme.color),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  onPressed: () {
                    if (!_focus.hasPrimaryFocus) {
                      _focus.unfocus();
                    }
                    showFormCustomer();
                  },
                  icon: Icon(Icons.add, size: 20, color: theme.iconTheme.color),
                ),
              ),
              hintText: translate("point_sale_search_customer"),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              constraints: const BoxConstraints(maxHeight: 47, minHeight: 47),
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        );
      },
    );
  }
}
