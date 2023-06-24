enum DomainError {
  unexpected,
  accessDenied,
}

extension DomainErrorMessage on DomainError {
  String get message {
    switch (this) {
      case DomainError.accessDenied:
        return "You don't have access to this resource. Please get in touch with the app's provider";
      case DomainError.unexpected:
      default:
        return 'An error happened while processing your request';
    }
  }
}
