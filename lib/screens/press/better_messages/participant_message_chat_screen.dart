import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:flutter/material.dart';

class BMParticipantMessageChatScreen extends StatelessWidget with AppBarMixin {
  final List<BMUser> participants;

  const BMParticipantMessageChatScreen({
    super.key,
    this.participants = const [],
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate("bm_participants")),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  BMUser user = participants[index];
                  return CirillaTile(
                    title: Text(user.name ?? "", style: theme.textTheme.titleSmall),
                    onTap: () =>
                        Navigator.pushNamed(context, BPMemberDetailScreen.routeName, arguments: {"id": user.userId}),
                  );
                },
                childCount: participants.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
