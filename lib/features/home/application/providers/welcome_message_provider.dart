import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/welcome_message.dart';
import '../../domain/usecases/get_welcome_message.dart';

final getWelcomeMessageProvider = Provider<GetWelcomeMessage>(
  (ref) => const GetWelcomeMessage(),
);

final welcomeMessageProvider = Provider<WelcomeMessage>(
  (ref) => ref.watch(getWelcomeMessageProvider)(),
);
