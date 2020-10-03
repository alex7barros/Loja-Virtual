import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screens/base/base.screen.dart';
import 'package:loja_virtual/screens/base/cart/cart_screen.dart';
import 'package:loja_virtual/screens/base/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screens/base/login/login_sreen.dart';
import 'package:loja_virtual/screens/base/product/product_screen.dart';
import 'package:loja_virtual/screens/base/signup/signup_screen.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:loja_virtual/screens/confirmation/confirmation_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:provider/provider.dart';

import 'models/admin_orders_manager.dart';
import 'models/admin_users_manager.dart';
import 'models/cart_manager.dart';
import 'models/home_manager.dart';
import 'models/order.dart';
import 'models/orders_manager.dart';
import 'models/user_manager.dart';
import 'screens/address/address_screen.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
          cartManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
          ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
          adminUsersManager..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) =>
          adminOrdersManager..updateAdmin(
              adminEnabled: userManager.adminEnabled
          ),
        )
      ],
      child: MaterialApp(
          title: 'Loja do Alexandro',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 4, 125, 141),
            scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
            appBarTheme: const AppBarTheme(elevation: 0),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BaseScreen(),
          initialRoute: '/base',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/login':
                return MaterialPageRoute(
                    builder: (_) => LoginSreen()
                );
              case '/product':
                return MaterialPageRoute(
                    builder: (_) => ProductScreen(
                        settings.arguments as Product
                    )
                );
              case '/signup':
                return MaterialPageRoute(
                    builder: (_) => SignUpScreen()
                );
              case '/cart':
                return MaterialPageRoute(
                    builder: (_) => CartScreen(),
                    settings: settings
                );
              case '/address':
                return MaterialPageRoute(
                    builder: (_) => AddressScreen()
                );
              case '/checkout':
                return MaterialPageRoute(
                    builder: (_) => CheckoutScreen()
                );
              case '/edit_product':
                return MaterialPageRoute(
                    builder: (_) => EditProductScreen(
                        settings.arguments as Product
                    )
                );
              case '/select_product':
                return MaterialPageRoute(
                    builder: (_) => SelectProductScreen()
                );
              case '/confirmation':
                return MaterialPageRoute(
                    builder: (_) => ConfirmationScreen(
                        settings.arguments as Order
                    )
                );
              case '/base':
              default:
                return MaterialPageRoute(
                    builder: (_) => BaseScreen(),
                    settings: settings
                );
            }
          },
      ),
    );
  }
}
