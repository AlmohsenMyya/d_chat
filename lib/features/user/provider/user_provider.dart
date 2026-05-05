import 'dart:async';
import 'package:flutter/material.dart';
import '../data/user_model.dart';
import '../data/user_service.dart';
import '../../../core/utils/navigation_service.dart';
import '../../../core/utils/app_routes.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;
  final NavigationService _navigationService;
  final String _currentUserId;

  StreamSubscription? _userSubscription;
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;
  String _searchQuery = "";

  List<UserModel> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  UserProvider(this._userService, this._navigationService, this._currentUserId) {
    _initUsersStream();
  }

  void _initUsersStream() {
    _userSubscription = _userService.getUsersStream(_currentUserId).listen((users) {
      _allUsers = users;
      _filterUsers();
      _isLoading = false;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterUsers();
    notifyListeners();
  }

  void _filterUsers() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = _allUsers;
    } else {
      _filteredUsers = _allUsers
          .where((user) =>
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void selectUser(UserModel user) {
    _navigationService.navigateTo(AppRoutes.chat, arguments: user);
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
