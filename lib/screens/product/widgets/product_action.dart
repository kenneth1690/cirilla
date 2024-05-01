import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/product/product_action_share.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';

class ProductAction extends StatefulWidget {
  final Product? product;
  final String? align;
  final Map<String, dynamic>? fields;

  const ProductAction({Key? key, this.product, this.align = 'left', this.fields}) : super(key: key);

  @override
  State<ProductAction> createState() => _ProductActionState();
}

class _ProductActionState extends State<ProductAction> with NavigationMixin, WishListMixin {
  @override
  Widget build(BuildContext context) {
    WrapAlignment wrapAlignment = widget.align == 'right'
        ? WrapAlignment.end
        : widget.align == 'center'
            ? WrapAlignment.center
            : WrapAlignment.start;
    return Wrap(
      spacing: 24,
      alignment: wrapAlignment,
      children: [
        InkWell(
          onTap: () => productActionShare(
            permalink: widget.product!.permalink!,
            name: widget.product!.name,
            context: context,
            fields: widget.fields,
          ),
          child: const Icon(FeatherIcons.share2, size: 20),
        ),
        InkWell(
          onTap: () {
            addWishList(productId: widget.product!.id);
          },
          child: Icon(
            existWishList(productId: widget.product!.id) ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
            size: 20,
          ),
        ),
      ],
    );
  }
}
