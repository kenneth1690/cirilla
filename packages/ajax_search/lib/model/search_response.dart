class SearchAjaxResponse {
  int? id;
  String? postAuthor;
  String? postDate;
  String? postDateGmt;
  String? postContent;
  String? postTitle;
  String? postExcerpt;
  String? postStatus;
  String? commentStatus;
  String? pingStatus;
  String? postPassword;
  String? postName;
  String? toPing;
  String? pinged;
  String? postModified;
  String? postModifiedGmt;
  String? postContentFiltered;
  int? postParent;
  String? guid;
  int? menuOrder;
  String? postType;
  String? postMimeType;
  String? commentCount;
  String? filter;
  String? aspGuid;
  String? aspId;
  String? blogId;
  AspData? aspData;

  SearchAjaxResponse(
      {this.id,
        this.postAuthor,
        this.postDate,
        this.postDateGmt,
        this.postContent,
        this.postTitle,
        this.postExcerpt,
        this.postStatus,
        this.commentStatus,
        this.pingStatus,
        this.postPassword,
        this.postName,
        this.toPing,
        this.pinged,
        this.postModified,
        this.postModifiedGmt,
        this.postContentFiltered,
        this.postParent,
        this.guid,
        this.menuOrder,
        this.postType,
        this.postMimeType,
        this.commentCount,
        this.filter,
        this.aspGuid,
        this.aspId,
        this.blogId,
        this.aspData});

  SearchAjaxResponse.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    postAuthor = json['post_author'];
    postDate = json['post_date'];
    postDateGmt = json['post_date_gmt'];
    postContent = json['post_content'];
    postTitle = json['post_title'];
    postExcerpt = json['post_excerpt'];
    postStatus = json['post_status'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    postPassword = json['post_password'];
    postName = json['post_name'];
    toPing = json['to_ping'];
    pinged = json['pinged'];
    postModified = json['post_modified'];
    postModifiedGmt = json['post_modified_gmt'];
    postContentFiltered = json['post_content_filtered'];
    postParent = json['post_parent'];
    guid = json['guid'];
    menuOrder = json['menu_order'];
    postType = json['post_type'];
    postMimeType = json['post_mime_type'];
    commentCount = json['comment_count'];
    filter = json['filter'];
    aspGuid = json['asp_guid'];
    aspId = json['asp_id'];
    blogId = json['blogid'];
    aspData = json['asp_data'] != null
        ? AspData.fromJson(json['asp_data'])
        : null;
  }
}

class AspData {
  String? title;
  String? postTitle;
  String? id;
  String? blogid;
  String? date;
  String? postDate;
  String? content;
  String? excerpt;
  String? postType;
  String? contentType;
  String? gContentType;
  String? author;
  String? postAuthor;
  String? priority;
  String? pTypePriority;
  String? groupPriority;
  int? relevance;
  String? customfp;
  String? customfs;
  String? image;
  String? link;
  int? primaryOrder;
  String? aspGuid;

  AspData(
      {this.title,
        this.postTitle,
        this.id,
        this.blogid,
        this.date,
        this.postDate,
        this.content,
        this.excerpt,
        this.postType,
        this.contentType,
        this.gContentType,
        this.author,
        this.postAuthor,
        this.priority,
        this.pTypePriority,
        this.groupPriority,
        this.relevance,
        this.customfp,
        this.customfs,
        this.image,
        this.link,
        this.primaryOrder,
        this.aspGuid});

  AspData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    postTitle = json['post_title'];
    id = json['id'];
    blogid = json['blogid'];
    date = json['date'];
    postDate = json['post_date'];
    content = json['content'];
    excerpt = json['excerpt'];
    postType = json['post_type'];
    contentType = json['content_type'];
    gContentType = json['g_content_type'];
    author = json['author'];
    postAuthor = json['post_author'];
    priority = json['priority'];
    pTypePriority = json['p_type_priority'];
    groupPriority = json['group_priority'];
    relevance = json['relevance'];
    customfp = json['customfp'];
    customfs = json['customfs'];
    image = json['image'];
    link = json['link'];
    primaryOrder = json['primary_order'];
    aspGuid = json['asp_guid'];
  }
}
