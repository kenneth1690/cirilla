const List initProfileBlocks = [
  {
    "template": "default",
    "active": true,
    "data": {
      "name": "Information - Login",
      "title": {
        "text": "Information",
      },
      "items": [
        {
          "active": false,
          "value": {
            "title": {
              "text": "My account",
            },
            "icon": {
              "name": "user",
              "type": "feather",
            },
            "enableChevron": true,
            "action": {
              "type": "screen",
              "route": "/profile/account",
              "args": {"name": "Account"}
            },
          },
        },
        {
          "active": false,
          "value": {
            "title": {
              "text": "Order & return",
            },
            "icon": {
              "name": "package",
              "type": "feather",
            },
            "enableChevron": true,
            "action": {
              "type": "screen",
              "route": "/order_list",
              "args": {"name": "Order list"}
            },
          },
        },
        {
          "active": false,
          'value': {
            "title": {
              "text": "Downloads",
            },
            "icon": {
              "name": "download",
              "type": "feather",
            },
            "enableChevron": true,
            "action": {
              "type": "screen",
              "route": "/profile/download",
              "args": {"name": "Download"}
            },
          },
        },
      ],
      "conditional": {
        "when_conditionals": "show_if",
        "conditionals": [
          [
            {"value1": "{isLogin}", "operator": "is_equal_to", "value2": "true"}
          ]
        ]
      }
    }
  },
  {
    "template": "default",
    "active": true,
    "data": {
      "name": "Settings",
      "title": {
        "text": "Settings",
      },
      "items": [
        {
          "active": false,
          "value": {
            "title": {
              "text": "App Settings",
            },
            "icon": {
              "name": "settings",
              "type": "feather",
            },
            "enableChevron": true,
            "action": {
              "type": "screen",
              "route": "/profile/setting",
              "args": {"name": "Settings"}
            },
          },
        },
        {
          "active": false,
          "value": {
            "title": {
              "text": "Help & Info",
            },
            "icon": {
              "name": "info",
              "type": "feather",
            },
            "enableChevron": true,
            "action": {
              "type": "screen",
              "route": "/profile/help_info",
              "args": {"name": "Hele & info"}
            },
          },
        },
        {
          "active": false,
          "value": {
            "title": {
              "text": "Hotline",
            },
            "subTitle": {"text": "0123456789"},
            "icon": {
              "name": "phone-forwarded",
              "type": "feather",
            },
            "enableChevron": true,
            "action": {
              "type": "launcher",
              "route": "/launcher",
              "args": {"url": "tel://0123456789", "name": "tel://0123456789"}
            },
          },
        },
        {
          "active": false,
          "value": {
            "title": {
              "text": "Sign out",
            },
            "icon": {
              "name": "log-out",
              "type": "feather",
            },
            "enableChevron": false,
            "action": {
              "type": "logout",
              "route": "/logout",
              "args": {"name": "Logout"}
            },
            "conditional": {
              "when_conditionals": "show_if",
              "conditionals": [
                [
                  {"value1": "{isLogin}", "operator": "is_equal_to", "value2": "true"}
                ]
              ]
            }
          },
        }
      ],
    },
  },
];
