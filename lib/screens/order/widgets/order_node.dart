import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/order_note/order_node.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/services.dart';

class OrderNoteWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final int orderId;
  final Color? color;

  const OrderNoteWidget({
    Key? key,
    this.padding,
    required this.orderId,
    this.color,
  }) : super(key: key);

  @override
  State<OrderNoteWidget> createState() => _OrderNoteWidgetState();
}

class _OrderNoteWidgetState extends State<OrderNoteWidget> with LoadingMixin, SnackMixin {
  late RequestHelper _requestHelper;
  bool _loading = true;
  List<OrderNode> _data = [];
  List<String> dataCopy = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _requestHelper = Provider.of<RequestHelper>(context);
    getOrderNodes();
  }

  Future<void> getOrderNodes() async {
    try {
      List<OrderNode>? data =
          await _requestHelper.getOrderNodes(queryParameters: {"type": "customer"}, orderId: widget.orderId);
      setState(() {
        _loading = false;
        _data = data ?? [];
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  void onCopy(BuildContext context, {int? index}) {
    if (index == null) {
      String text = dataCopy.join();
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        showSuccess(context, 'Copied "$text"');
      });
    } else {
      String text = dataCopy[index];
      Clipboard.setData(ClipboardData(text: text)).then((_) {
        showSuccess(context, 'Copied "$text"');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('order_notes'),
                style: theme.textTheme.titleMedium,
              ),
              Visibility(
                visible: !_loading && _data.isNotEmpty,
                child: btnCopy(theme: theme),
              ),
            ],
          ),
          if (_loading)
            Padding(
              padding: const EdgeInsets.only(top: itemPaddingLarge),
              child: entryLoading(context),
            )
          else if (_data.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: itemPaddingLarge),
              child: Column(
                children: List.generate(_data.length, (index) {
                  double padBottom = index < _data.length - 1 ? itemPaddingMedium : 0;
                  OrderNode item = _data[index];

                  String date = '${index + 1} . ${formatDate(date: item.dateCreated!)}';
                  String noteContent = CirillaHtml(html: item.note ?? '').html;
                  dataCopy.add('$date \n $noteContent\n');

                  return Padding(
                    padding: EdgeInsets.only(bottom: padBottom),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: theme.colorScheme.surface,
                      ),
                      child: OrderReturnItem(
                        name: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(date, style: theme.textTheme.bodySmall),
                            btnCopy(theme: theme, index: index),
                          ],
                        ),
                        dateTime: CirillaHtml(html: item.note ?? ''),
                        onClick: () => onCopy(context, index: index),
                      ),
                    ),
                  );
                }),
              ),
            )
        ],
      ),
    );
  }

  Widget btnCopy({required ThemeData theme, int? index}) {
    return TextButton(
      onPressed: () => onCopy(context, index: index),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        textStyle: theme.textTheme.bodyMedium,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Icon(FeatherIcons.copy, size: 16),
    );
  }
}
