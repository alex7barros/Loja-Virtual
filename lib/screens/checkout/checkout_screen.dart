import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:loja_virtual/screens/checkout/components/cpf_field.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:provider/provider.dart';

import 'components/credit_card_widget.dart';

class CheckoutScreen extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
      checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __){
              if(checkoutManager.loading){
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      const SizedBox(height: 16,),
                      const Text(
                        'Processando seu pagamento...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
                );
              }

              return Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    CreditCardWidget(creditCard),
                    CpfField(),
                              PriceCard(
                                buttonText: 'Finalizar Pedido',
                                onPressed: (){
                                  if(formKey.currentState.validate()){
                                    formKey.currentState.save();
                                    checkoutManager.checkout(
                                        creditCard: creditCard,
                                        onStockFail: (e){
                                          Navigator.of(context).popUntil(
                                                  (route) => route.settings.name == '/cart');
                                        },
                                        onPayFail: (e){
                                          scaffoldKey.currentState.showSnackBar(
                                              SnackBar(
                                                content: Text('$e'),
                                                backgroundColor: Colors.red,
                                              )
                                          );
                                        },
                                        onSuccess: (order){
                                          Navigator.of(context).popUntil(
                                                  (route) => route.settings.name == '/');
                                          Navigator.of(context).pushNamed(
                                              '/confirmation',
                                              arguments: order
                                          );
                                        }
                                    );
                                  }
                                },
                              )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
