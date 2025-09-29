import '../entities/welcome_message.dart';

class GetWelcomeMessage {
  const GetWelcomeMessage();

  WelcomeMessage call() {
    return const WelcomeMessage('Welcome to the Checkers app starter kit.');
  }
}
