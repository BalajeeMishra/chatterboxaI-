
import 'package:provider/provider.dart';

import '../ViewModel/AllGameVm.dart';
import '../ViewModel/JabberHomeAIvm.dart';
import '../ViewModel/PlayTabooScreenVM.dart';
import '../ViewModel/TabooGameChatPageVM.dart';



final appProvider = [
  /// Declare Here All The View Model For DI And Provide Object When it's need.
  ChangeNotifierProvider<JabberHomeAIvm>(create: (context) => JabberHomeAIvm(context)),
  ChangeNotifierProvider<AllGameVm>(create: (context) => AllGameVm(context)),
  ChangeNotifierProvider<TabooGameChatPageVM>(create: (context) => TabooGameChatPageVM(context)),
  ChangeNotifierProvider<PlayTabooScreenVM>(create: (context) => PlayTabooScreenVM(context)),
];
