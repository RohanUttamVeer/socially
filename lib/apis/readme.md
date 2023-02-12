// provides services {create account etc.} -> Account
// fetch user details -> model.Account

public variable :
final Account account;
  AuthAPI({required this.account});

private variable :
final Account _account;
  AuthAPI({required Account account}) : _account = account;

Provider in riverpod lets us provide a single instance which is immutable 
{read-only value}
types of Provider in riverpod :
Provider
Future Provider
Stream Provider
State Provider
State Notifies Provider
    Notifier and async Notifier

ref.watch(appwriteClientProvider) : listens to the appwriteClientProvider every time it changes

ref.read(appwriteClientProvider) : listens to the appwriteClientProvider only once

if it's a dependency you have to create a provider