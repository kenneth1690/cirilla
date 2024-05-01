const initLayouts = [
  {
    "template": "default",
    "active": false,
    "data": {
      "icon": {
        "name": "square",
        "type": "feather",
      },
      "template": {
        "template": "default",
        "data": {
          "size": {"width": 335, "height": 260},
          "imageSize": 'cover',
          "enableImage": true,
          "enableCategory": true,
          "enableDate": true,
          "enableAuthor": true,
          "enableComments": true,
          "nameFieldTopLeftImage": '',
          "nameFieldTopRightImage": '',
          "nameFieldAboveName": '',
          "nameFieldBottomLeft": '',
          "nameFieldBottomRight": '',
        },
      }
    },
  },
  {
    "template": "default",
    "active": true,
    "data": {
      "icon": {
        "name": "list",
        "type": "feather",
      },
      "template": {
        "template": "horizontal",
        "data": {
          "size": {"width": 120, "height": 120},
          "imageSize": 'cover',
          "enableImage": true,
          "enableCategory": true,
          "enableDate": true,
          "enableAuthor": true,
          "enableComments": true,
          "alignment": 'left',
          "nameFieldAbove": '',
          "nameFieldBelow": '',
          "nameFieldBelowName": '',
        },
      }
    },
  }
];
