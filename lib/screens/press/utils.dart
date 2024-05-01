import 'buddypress/buddypress.dart';

DateTime? convertToDate(dynamic value) {
  if (value is String) {
    return DateTime.parse(value[value.length-1] == "Z" ? value : "${value}Z").toLocal();
  }
  return null;
}

List<BPMember>? changeMemberFriendSlug(List<BPMember> members, Map<int, String> update, String type) {
  if (members.isEmpty || update.isEmpty) {
    return null;
  }
  List<BPMember> data = [...members];

  bool enableChanged = false;

  for(int id in update.keys) {
    int index = data.indexWhere((element) => element.id == id);
    if (type == "all") {
      if (index > -1 && data[index].friendshipStatusSlug != update[id]) {
        data.setAll(index, [BPMember.fromJson({
          ...data[index].toJson(),
          "friendship_status_slug": update[id],
        })]);
        if (enableChanged == false) enableChanged = true;
      }
    } else {
      if (index > -1 && data[index].friendshipStatusSlug != update[id] && update[id] != type) {
        data.removeAt(index);
        if (enableChanged == false) enableChanged = true;
      }
    }

  }

  return enableChanged ? data : null;
}