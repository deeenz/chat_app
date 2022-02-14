import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

const USER_COLLECTION = "users";
const CHATS_COLLECTION = "chats";
const MESSAGES_COLLECTION = "messages";

final allProviders = <SingleChildWidget>[
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => ChatProvider()),
];
