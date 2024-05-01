/// @link https://contactform7.com/tag-syntax/#form_tag

const List<String> supportFullCloseTag = ['textarea'];
const List<String> ignoreName = ['submit'];

// Get default value in \" and \"
const String regValue = r'\"([^\"]+)\"';
final RegExp regValueExp = RegExp(regValue);
final RegExp regNameExp = RegExp(r'(^[\w-_]+)');

String _preHtml(html) {
  // Pre Submit [submit] => [submit "Send"]
  String newHtml = html.replaceAllMapped(RegExp(r'\[submit\]'), (match) {
    return '[submit "Send"]';
  });

  // Parse Checkbox
  String newHtml2 = _parseCheckbox(newHtml);

  // Parse Select
  String newHtml3 = _parseSelect(newHtml2);

  // Parse acceptance
  String newHtml4 = _parseAcceptance(newHtml3);

  // Parse quiz
  String newHtml5 = _parseQuiz(newHtml4);

  return newHtml5;
}

String _parseCheckbox(html) {
  const String regExpString = r'\[(checkbox|radio)(\*?)\s+([^\]]+)?\]';
  final RegExp regExp = RegExp(regExpString);
  return html.replaceAllMapped(regExp, (match) {
    String result = "";
    String name = "";
    String id = "";
    String required = "";
    String labelFirst = "";
    String exclusive = "";
    List<String>? images;
    List<String> cls = [match[1]];

    // required
    if (match[2]?.isNotEmpty == true && match[2] == '*') {
      required = ' data-required';
    }

    if (match[3]?.isNotEmpty == true) {
      String attrsMatch = match[3]!;

      name = regNameExp.firstMatch(attrsMatch)?.group(1) ?? '';
      List<String?> values = regValueExp.allMatches(attrsMatch).map((e) => e.group(1)).toList();
      List<String> attrs = attrsMatch.split(' ');

      List<String> defaultValues = [];

      // label first
      if (attrs.contains("label_first")) {
        labelFirst = ' data-labelfirst';
      }
      // exclusive
      if (attrs.contains("exclusive")) {
        exclusive = ' data-exclusive';
      }

      for (String attr in attrs) {
        List<String> attrSplit = attr.split(':');
        if (attrSplit.length == 2) {
          if (attrSplit[0] == 'default') {
            defaultValues = attrSplit[1].split('_');
          }

          if (attrSplit[0] == 'id') {
            id = ' id="${attrSplit[1]}"';
          }

          if (attrSplit[0] == 'class') {
            cls = [...cls, attrSplit[1]];
          }
        }
        if (attrSplit.length > 2) {
          // images
          if (attrSplit[0] == "images") {
            List<String> attrImages = [...attrSplit];
            attrImages.removeAt(0);
            images = attrImages.join(":").split("|");
          }
        }
      }
      
      
      int step = 1;
      for (String? value in values) {
        if (value == null) continue;
        String image = "";
        String id = '${name}-${value}'.toLowerCase();
        String checked = defaultValues.contains(step.toString()) ? ' checked' : '';
        if (images != null) {
          image = ' src="${images.length > 1 ? images.elementAtOrNull(step - 1) ?? "" : images.elementAtOrNull(0) ?? ""}"';
        }
        result += '<input type="${match[1]}" id="${id}" name="$name" value="${value}"${image}${checked}/><label for="${id}">${value}</label>';
        step++;
      }
    }

    String classString = cls.length > 0 ? ' class="${cls.join(' ')}"' : '';

    return "<div data-name=\"${name}\"${id}${classString}${required}${labelFirst}${exclusive}>${result}</div>";
  });
}

String _parseSelect(html) {
  const String regExpString = r'\[(select)(\*?)\s+([^\]]+)?\]';
  final RegExp regExp = RegExp(regExpString);
  return html.replaceAllMapped(regExp, (match) {
    String result = "";
    String name = "";
    String id = "";
    String required = "";
    String multiple = "";
    String includeBlank = "";
    List<String> cls = [];

    // required
    if (match[2]?.isNotEmpty == true && match[2] == '*') {
      required = ' required';
    }

    if (match[3]?.isNotEmpty == true) {
      String attrsMatch = match[3]!;

      name = regNameExp.firstMatch(attrsMatch)?.group(1) ?? '';
      List<String?> values = regValueExp.allMatches(attrsMatch).map((e) => e.group(1)).toList();
      List<String> attrs = attrsMatch.split(' ');

      List<String> defaultValues = [];

      // multi value
      if (attrs.contains("multiple")) {
        multiple = ' multiple';
      }
      // include blank
      if (attrs.contains("include_blank")) {
        includeBlank = ' data-includeblank';
      }

      for (String attr in attrs) {
        List<String> attrSplit = attr.split(':');
        if (attrSplit.length == 2) {
          if (attrSplit[0] == 'default') {
            defaultValues = attrSplit[1].split('_');
          }

          if (attrSplit[0] == 'id') {
            id = ' id="${attrSplit[1]}"';
          }

          if (attrSplit[0] == 'class') {
            cls = [...cls, attrSplit[1]];
          }
        }
      }

      int step = 1;
      for (String? value in values) {
        if (value == null) continue;
        String selected = defaultValues.contains(step.toString()) ? ' selected' : '';
        result += '<option value="${value}"${selected}>${value}</option>';
        step++;
      }
    }

    String classString = cls.length > 0 ? ' class="${cls.join(' ')}"' : '';

    return "<select name=\"${name}\"${id}${classString}${required}${multiple}${includeBlank}>${result}</select>";
  });
}

String _parseAcceptance(html) {
  const String regExpString = r'\[(acceptance)(\*?)\s+([^\]]+)?\]([^\[]+)?(\[\/[a-z]+])?';
  final RegExp regExp = RegExp(regExpString);
  return html.replaceAllMapped(regExp, (match) {
    String name = "";
    String id = "";
    String requiredData = "";
    String defaultValue = "";
    String condition = "";
    String invert = "";
    List<String> cls = [match[1]];

    // required
    if (match[2]?.isNotEmpty == true && match[2] == '*') {
      requiredData = ' data-required';
    }

    if (match[3]?.isNotEmpty == true) {
      String attrsMatch = match[3]!;

      name = regNameExp.firstMatch(attrsMatch)?.group(1) ?? '';
      List<String> attrs = attrsMatch.split(' ');

      for (String attr in attrs) {
        if (attr == 'invert') {
          invert = ' data-invert';
          continue;
        }

        List<String> attrSplit = attr.split(':');

        if (attrSplit.length == 2) {
          if (attrSplit[0] == 'default' && attrSplit[1] == "on") {
            defaultValue = ' data-active';
          }

          if (attrSplit[0] == 'id') {
            id = ' id="${attrSplit[1]}"';
          }

          if (attrSplit[0] == 'class') {
            cls = [...cls, attrSplit[1]];
          }
        }
      }
    }

    if (match[4]?.isNotEmpty == true) {
      condition = " data-condition=\"${match[4]}\"";
    }

    String classString = cls.length > 0 ? ' class="${cls.join(' ')}"' : '';
    return "<div data-name=\"${name}\"${id}${classString}${requiredData}${defaultValue}${condition}${invert}></div>";
  });
}

String _parseQuiz(html) {
  const String regExpString = r'\[(quiz)(\*?)\s+([^\]]+)?\]';
  final RegExp regExp = RegExp(regExpString);
  return html.replaceAllMapped(regExp, (match) {
    String result = "";
    String requiredData = "";
    String name = "";
    String id = "";
    String minLength = "";
    String maxLength = "";
    String size = "";
    List<String> cls = [match[1]];

    // required
    if (match[2]?.isNotEmpty == true && match[2] == '*') {
      requiredData = ' data-required';
    }

    if (match[3]?.isNotEmpty == true) {
      String attrsMatch = match[3]!;

      name = regNameExp.firstMatch(attrsMatch)?.group(1) ?? '';
      List<String?> values = regValueExp.allMatches(attrsMatch).map((e) => e.group(1)).toList();
      List<String> attrs = attrsMatch.split(' ');

      for (String attr in attrs) {
        List<String> attrSplit = attr.split(':');
        if (attrSplit.length == 2) {

          if (attrSplit[0] == 'id') {
            id = ' id="${attrSplit[1]}"';
          }

          if (attrSplit[0] == 'class') {
            cls = [...cls, attrSplit[1]];
          }

          if (attrSplit[0] == 'minlength') {
            minLength = ' data-minlength="${attrSplit[1]}"';
          }

          if (attrSplit[0] == 'maxlength') {
            maxLength = ' data-maxlength="${attrSplit[1]}"';
          }

          if (attrSplit[0] == 'size') {
            size = ' data-size="${attrSplit[1]}"';
          }
        }
      }

      for (String? value in values) {
        if (value == null) continue;
        result += '<span data-name="${name}">${value}</span>';
      }
    }

    String classString = cls.length > 0 ? ' class="${cls.join(' ')}"' : '';

    return "<div data-name=\"${name}\"${id}${classString}${requiredData}${minLength}${maxLength}${size}>${result}</div>";
  });
}

String fromContactFrom7(String html) {
  const String regExpString =
      r'\[(text|email|url|tel|number|range|date|textarea|submit)(\*?)\s+([^\]]+)?\]([^\[]+\[\/[a-z]+])?';
  final RegExp regExp = RegExp(regExpString);
  return _preHtml(html).replaceAllMapped(regExp, (match) {
    String input = supportFullCloseTag.contains(match[1]) ? '<${match[1]}' : '<input';

    // required
    if (match[2]?.isNotEmpty == true && match[2] == '*') {
      input = input + ' required';
    }

    // type
    if (match[1]?.isNotEmpty == true && !supportFullCloseTag.contains(match[1])) {
      input = input + ' type="${match[1]}"';
    }

    // Default value
    String defaultValue = '';

    // Attributes
    if (match[3]?.isNotEmpty == true) {
      String attrsMatch = match[3]!;
      String value = regValueExp.firstMatch(attrsMatch)?.group(1) ?? '';

      List<String> attrs = attrsMatch.replaceAll(RegExp(r'\s+(placeholder\s+)?"([^"]+)"'), '').split(' ');
      for (String attr in attrs) {
        List<String> attrSplit = attr.split(':');
        if (attrSplit.length == 2) {
          if (attrSplit[0] == 'default') {
            defaultValue = '{{${attrSplit[1]}}}';
          } else {
            input = input + ' ${attrSplit[0]}="${attrSplit[1]}"';
          }
        } else if (!ignoreName.contains(match[1])) {
          input = input + ' name="${attrSplit[0]}"';
        }
      }

      // Has placeholder and value
      if (attrsMatch.contains(RegExp(r'\s+(placeholder\s+)"([^"]+)"'))) {
        input = input + ' placeholder="$value"';
      } else if (defaultValue.isEmpty) {
        defaultValue = value;
      }

      // Has default value
      if (defaultValue.isNotEmpty && !supportFullCloseTag.contains(match[1])) {
        input = input + ' value="$defaultValue"';
      }
    }

    if (supportFullCloseTag.contains(match[1])) {
      if (match[4]?.isNotEmpty == true) {
        input += '>' + match[4]!.replaceAll(RegExp(r'\[/[a-z]+\]'), '</${match[1]}>');
      } else {
        input += '>${defaultValue}</${match[1]}>';
      }
    } else {
      input = input + ' />';
    }

    return input;
  });
}
