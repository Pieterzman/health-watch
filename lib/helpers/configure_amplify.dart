import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

import '../amplifyconfiguration.dart';
import '../models/ModelProvider.dart';

Future<void> configureAmplify() async {
  // AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
  AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
  AmplifyAPI apiPlugin = AmplifyAPI();
  AmplifyDataStore datastorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);

  await Amplify.addPlugins([authPlugin, datastorePlugin, apiPlugin]);

  try {
    ///Wait for plugins to add before configure is called
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    print(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
  }
}
