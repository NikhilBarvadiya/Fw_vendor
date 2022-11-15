Map<String, dynamic> environment = {
  "serverConfig": {
    'apiUrl': 'https://fastwhistle.com/v3/',
    'baseUrl': 'https://fastwhistle.com',
    // 'apiUrl': 'http://192.168.29.91:3500/v3/',
    // 'baseUrl': 'http://192.168.29.91.8:3500',
    'apiVersion': 'v1',
    'accessToken': '292105248cc4118ee8f2ccb0a97cd54d',
    'playStoreURL': 'https://play.google.com/store/apps/details?id=com.appName',
    'appStoreURL': 'https://apps.apple.com/us/app/itunes-connect/id8978990',
    'appDownloadURL': 'https://staging.carerockets.com/redirect/app-download',
  },
  "advanceConfig": {
    "defaultLanguage": "en",
    "defaultCurrency": {
      "symbol": "₹",
      "decimalDigits": 0,
      "symbolBeforeTheNumber": true,
      "currency": "INR",
      "currencyCode": "INR",
    },
    "isMultiLanguages": false,
  },
  "loginSetting": {
    "IsRequiredLogin": false,
    "showAppleLogin": false, // Nitin
    "showFacebook": false, // Nitin
    "showSMSLogin": false, // Nitin
    "showGoogleLogin": false, // Nitin
    "showPhoneNumberWhenRegister": true,
    "requirePhoneNumberWhenRegister": true,

    /// For Facebook login.
    "facebookAppId": "430258564493822",
    "facebookLoginProtocolScheme": "fb430258564493822",
  },
  "imagesbaseUrl": "https://fastwhistle.s3.amazonaws.com/"
};
