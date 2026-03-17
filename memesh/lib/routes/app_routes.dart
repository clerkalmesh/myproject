import 'routes.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:flutter/material.dart';

import 'package:memesh/views/splash_views.dart';
//import 'package:memesh/views/home_views.dart';
import 'package:memesh/views/main_views.dart';

import 'package:memesh/views/login_views.dart';
//import 'package:memesh/views/register_views.dart';

class AppRoutes {
    
    static const initial = Routes.splash;
    
    static final routes = [
        GetPage(name: Routes.splash, page: () => const SplashView()),
        GetPage(name: Routes.login, page: () => const LoginView()),
        
        GetPage(
            name: Routes.main, 
            page: () => const MainView(),
           // binding: BindingsBuilder(() {
            //    Get.put(MainController())
           // }),
        ),
        
        /*
        GetPage(
            name: Routes.home, 
            page: () => const HomeView(),
            binding: BindingsBuilder(() {
                Get.put(HomeController())
            }),
        ),
        GetPage(
            name: Routes.chat, 
            page: () => const ChatView(),
            binding: BindingsBuilder(() {
                Get.put(ChatController())
            }),
        ),
        GetPage(
            name: Routes.userList, 
            page: () => const UserListView(),
            binding: BindingsBuilder(() {
                Get.put(UserListController())
            }),
        ),
        
        GetPage(
            name: Routes.profile, 
            page: () => const ProfileView(),
            binding: BindingsBuilder(() {
                Get.put(ProfileController())
            }),
        ),
       
        GetPage(
            name: Routes.friends, 
            page: () => const FriendsView(),
            binding: BindingsBuilder(() {
                Get.put(FriendsController())
            }),
        ),
        GetPage(
            name: Routes.friendsRequest, 
            page: () => const FriendsRequestView(),
            binding: BindingsBuilder(() {
                Get.put(FriendsRequestController())
            }),
        ),
        GetPage(
            name: Routes.notifications, 
            page: () => const NotificationsView(),
            binding: BindingsBuilder(() {
                Get.put(NotificationsController())
            }),
        ),*/
        
    ];
    
}