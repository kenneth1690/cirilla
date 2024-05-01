const initLayouts = [
  {
    "template": "default",
    "active": true,
    "data": {
      "icon": {
        "name": "grid",
        "type": "feather",
      },
      "layoutItem": "grid",
      "columnItem": 2,
      "pad": 32,
      "runPad": 16,
      "enableDivider": false,
      "template": {
        "template": "contained",
        "data": {
          "size": {"width": 160, "height": 190},
          "imageSize": 'cover',
          "thumbSizes": 'shop_catalog',
          "enableLabelNew": true,
          "enableLabelSale": true,
          "enableRating": true,
          "enableQuantity": false,
          "enableAddCart": true,
        },
      }
    },
  },
  {
    "template": "default",
    "active": false,
    "data": {
      "icon": {
        "name": "square",
        "type": "feather",
      },
      "layoutItem": "list",
      "columnItem": 2,
      "pad": 32,
      "runPad": 16,
      "enableDivider": false,
      "template": {
        "template": "contained",
        "data": {
          "size": {"width": 335, "height": 397},
          "imageSize": 'cover',
          "thumbSizes": 'shop_catalog',
          "enableLabelNew": true,
          "enableLabelSale": true,
          "enableRating": true,
          "enableQuantity": false,
          "enableAddCart": true,
        },
      }
    },
  },
  {
    "template": "default",
    "active": false,
    "data": {
      "icon": {
        "name": "list",
        "type": "feather",
      },
      "layoutItem": "list",
      "columnItem": 2,
      "pad": 48,
      "runPad": 16,
      "enableDivider": true,
      "template": {
        "template": "horizontal",
        "data": {
          "size": {"width": 86, "height": 102},
          "imageSize": 'cover',
          "thumbSizes": 'shop_catalog',
          "enableLabelNew": true,
          "enableLabelSale": true,
          "enableRating": true,
          "enableQuantity": false,
          "enableAddCart": true,
        },
      }
    },
  }
];
