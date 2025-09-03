class Profile {
  String? name, token;

  Profile({this.name, this.token}) {
    name ??= 'User';
  }
}
