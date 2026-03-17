import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memesh/services/auth_services.dart';
import 'package:memesh/models/user_models.dart';
import 'package:memesh/routes/routes.dart';

class AuthController extends GetxController {
    
    final AuthService _authService = AuthService();
    final Rx<User?> _user = Rx<User?>(null);
    final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
    final RxBool _isLoading = false.obs;
    final RxString _error = ''.obs;
    final RxBool _isInitialized = false.obs;
    
    User? get user => _user.value;
    UserModel? get userModel => _userModel.value;
    bool get isLoading => _isLoading.value;
    String get error => _error.value;
    bool get isInitialized => _isInitialized.value;
    bool get isAuthenticated => _user.value != null;
    
    @override
    void onInit() {
        super.onInit();
        _user.bindStream(_authService.authStateChanges);
        ever(_user, _handleAuthStateChange);
    }
    
    void _handleAuthStateChange(User? user) {
        if (user == null) {
            if (Get.currentRoute != Routes.login) {
                Get.offAllNamed(Routes.login);
            }
        } else {
            // Set userModel jika belum ada
            if (_userModel.value == null) {
                _loadUserProfile(user.uid);
            }
            
            if (Get.currentRoute != Routes.main) {
                Get.offAllNamed(Routes.main);
            }
        }
        
        if (!_isInitialized.value) {
            _isInitialized.value = true;
        }
    }
    
    Future<void> _loadUserProfile(String uid) async {
        _isLoading.value = true;
        try {
            _userModel.value = await _authService.getUserProfile(uid);
        } catch (e) {
            _error.value = 'Failed to load user profile';
        } finally {
            _isLoading.value = false;
        }
    }
    
    void checkInitialAuthState() {
        final currentUser = FirebaseAuth.instance.currentUser;
        
        if (currentUser != null) {
            _user.value = currentUser;
            _loadUserProfile(currentUser.uid);
            Get.offAllNamed(Routes.main);
        } else {
            Get.offAllNamed(Routes.login);
        }
        
        _isInitialized.value = true;
    }
    
    // METHOD LOGIN ANONYMOUS
    Future<void> loginAnonymous() async {
        _isLoading.value = true;
        _error.value = '';
        
        try {
            UserModel? userModel = await _authService.signInAnonymously();
            
            if (userModel != null) {
                _userModel.value = userModel;
                Get.offAllNamed(Routes.main);
            } else {
                _error.value = 'Failed to sign in anonymously';
            }
        } catch (e) {
            _error.value = 'Error: $e';
        } finally {
            _isLoading.value = false;
        }
    }
    
    // METHOD LOGOUT
    Future<void> logout() async {
        _isLoading.value = true;
        try {
            await _authService.signOut();
            _userModel.value = null;
        } catch (e) {
            _error.value = 'Failed to logout';
        } finally {
            _isLoading.value = false;
        }
    }
    
    // METHOD UPDATE PROFILE
    Future<void> updateProfile({String? name, String? avatar}) async {
        _isLoading.value = true;
        try {
            bool success = await _authService.updateUserProfile(
                name: name,
                avatar: avatar,
            );
            
            if (success && _userModel.value != null) {
                // Refresh user model
                _userModel.value = await _authService.getUserProfile(_user.value!.uid);
            }
        } catch (e) {
            _error.value = 'Failed to update profile';
        } finally {
            _isLoading.value = false;
        }
    }
    
    // METHOD DELETE ACCOUNT
    Future<void> deleteAccount() async {
        _isLoading.value = true;
        try {
            bool success = await _authService.deleteAccount();
            if (success) {
                _userModel.value = null;
                Get.offAllNamed(Routes.login);
            }
        } catch (e) {
            _error.value = 'Failed to delete account';
        } finally {
            _isLoading.value = false;
        }
    }
}