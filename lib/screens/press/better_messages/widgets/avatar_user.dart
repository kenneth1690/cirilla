import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class AvatarUserWidget extends StatelessWidget {
  final List<BMUser>? users;
  final double width;

  const AvatarUserWidget({super.key, this.users, this.width = 60});

  Widget buildImage(BMUser user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CirillaCacheImage(
        user.avatar,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (users != null && users!.length > 2) {
      double pad = 3;
      double widthItem = (width - pad) / 2;

      return SizedBox(
        width: width,
        child: Wrap(
          spacing: pad,
          runSpacing: pad,
          children: List.generate(4, (index) {
            late Widget child;
            if (users!.length > 4 && index == 3) {
              child = Stack(
                children: [
                  buildImage(users![index]),
                  Positioned.fill(child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("+ ${users!.length - 4}", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),),
                  ),
                  ),
                ],
              );
            } else if (index < users!.length) {
              child = buildImage(users![index]);
            } else {
              child = Container();
            }

            return SizedBox(
              width: widthItem,
              child: AspectRatio(
                aspectRatio: 1,
                child: child,
              ),
            );
          }),
        ),
      );
    }

    AuthStore authStore = Provider.of<AuthStore>(context);
    BMUser? user = users?.firstWhere((user) => user.userId?.toString() != authStore.user?.id, orElse: () => BMUser());
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CirillaCacheImage(
        user?.avatar,
        width: width,
        height: width,
      ),
    );
  }
}
