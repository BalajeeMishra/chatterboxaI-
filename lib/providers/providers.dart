
import 'package:provider/provider.dart';

import '../ViewModel/AllGameVm.dart';
import '../ViewModel/JabberHomeAIvm.dart';



final appProvider = [
  /// Declare Here All The View Model For DI And Provide Object When it's need.
  ChangeNotifierProvider<JabberHomeAIvm>(create: (context) => JabberHomeAIvm(context)),
  ChangeNotifierProvider<AllGameVm>(create: (context) => AllGameVm(context)),
];
