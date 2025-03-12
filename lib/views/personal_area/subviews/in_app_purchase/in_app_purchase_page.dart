// ignore_for_file: unused_element

import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import 'package:omnyqr/commons/widgets/common_shop_dialog.dart';
import 'package:omnyqr/models/user.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/main_container/bloc/container_state.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

String _enterprise = Platform.isIOS ? 'level_enterprise' : 'level_enterprise';
String _pro = Platform.isIOS ? 'level_pro' : 'livello_pro';

List<String> _kProductIds = <String>[
  _pro, _enterprise,

//_gold
];

class InAppPurchasePage extends StatefulWidget {
  const InAppPurchasePage({super.key});

  @override
  State<InAppPurchasePage> createState() => _MyAppState();
}

class _MyAppState extends State<InAppPurchasePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];

  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];

        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());

    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];

        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];

        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;

      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ContainerState? contState =
        context.select((ContainerBloc bloc) => bloc.state);
    User? user = contState?.user;

    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: <Widget>[
            // _buildConnectionCheckTile(),
            _buildProductList(user?.premiumStatus),
            // _buildConsumableBox(),
            // _buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        const Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: 25.w,
          ),
          InkWell(
              enableFeedback: false,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                AppImages.backIcon,
              )),
          SizedBox(
            width: 5.w,
          ),
          const Spacer(
            flex: 2,
          ),
          Center(
              child: Text(tr('appbar_title'),
                  style: AppTypografy.mainContainerAppBarTitle)),
          const Spacer(
            flex: 3,
          ),
          SizedBox(
            width: 30.w,
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Stack(
          children: stack,
        ),
      ),
    );
  }

  Card _buildProductList(String? premiumStatus) {
    if (_loading) {
      return Card(
        child: ListTile(
          leading: const CircularProgressIndicator(
            color: AppColors.mainBlue,
          ),
          title: Text(
            tr('shop_loading'),
          ),
        ),
      );
    }
    if (!_isAvailable) {
      return const Card();
    }
    ListTile productHeader = ListTile(title: Text(tr('product_for_sale')));
    final List<ListTile> productList = <ListTile>[];

    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    _products.sort((a, b) => a.price.compareTo(b.price));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: showButton(productDetails, purchases, premiumStatus));
      },
    ));

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

  Widget showButton(productDetails, purchases, premiumStatus) {
    String getAccountType(String value) {
      switch (value) {
        case 'free':
          return 'free';
        case 'pro':
          return Platform.isIOS ? 'level_pro' : 'livello_pro';
        case 'business':
          return Platform.isIOS ? 'level_enterprise' : 'level_enterprise';

        default:
          return 'free';
      }
    }

    String getPremiumType(String value) {
      switch (value) {
        case 'free':
          return 'free';
        case 'level_pro':
          return 'pro';
        case 'livello_pro':
          return 'pro';
        case 'level_enterprise':
          return 'business';
        default:
          return 'free';
      }
    }

    if (getAccountType(premiumStatus ?? 'free') != productDetails.id) {
      return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.mainBlue,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return CommonDialogShop(
                  isBtn1Enabled: true,
                  body: productDetails.id == _pro
                      ? """Con il livello pro puoi creare fino a 4 QR e assegnare ad ognuno di essi 8 referenti ed inoltre sbloccherai le video chiamate."""
                      : """Con il livello Buisness puoi creare fino a 20 QR e assegnare ad ognuno di essi 40 referenti ed inoltre sbloccherai le video chiamate.""",
                  btn2Label: 'Acquista',
                  btn1Label: 'Chiudi',
                  title: productDetails.id == _pro
                      ? 'Account livello pro a \n ${productDetails.price} annui\n\nDurata 1 anno'
                      : 'Account livello Business a \n ${productDetails.price} annui\n\nDurata 1 anno',
                  onTap2: () {
                    if (premiumStatus == "free" || premiumStatus == "pro") {
                      late PurchaseParam purchaseParam;

                      if (Platform.isAndroid) {
                        final GooglePlayPurchaseDetails? oldSubscription =
                            _getOldSubscription(productDetails, purchases);
                        purchaseParam = GooglePlayPurchaseParam(
                            productDetails: productDetails,
                            changeSubscriptionParam: (oldSubscription != null)
                                ? ChangeSubscriptionParam(
                                    oldPurchaseDetails: oldSubscription,
                                    prorationMode: ProrationMode
                                        .immediateWithTimeProration,
                                  )
                                : null);
                      } else {
                        purchaseParam = PurchaseParam(
                          productDetails: productDetails,
                        );
                      }

                      _inAppPurchase.buyNonConsumable(
                          purchaseParam: purchaseParam);
                    }
                    Navigator.pop(context);
                  },
                  onTap1: () {
                    Navigator.pop(context);
                  },
                );
              });
          /**
           *      
           */
        },
        child: Text(productDetails.price),
      );
    } else {
      return Icon(
        Icons.check,
        color: AppColors.commonGreen,
        size: 40.h,
      );
    }
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.

    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          context.read<ContainerBloc>().add(SetAccountLevelEvent(
              value: purchaseDetails.productID,
              token: purchaseDetails.verificationData.serverVerificationData,
              productID: purchaseDetails.productID));
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          setState(() {
            _purchasePending = false;
          });
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    // Price changes for Android are not handled by the application, but are
    // instead handled by the Play Store. See
    // https://developer.android.com/google/play/billing/price-changes for more
    // information on price changes on Android.
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == _enterprise && purchases[''] != null) {
      oldSubscription = purchases['']! as GooglePlayPurchaseDetails;
    } else if (productDetails.id == '' && purchases[_enterprise] != null) {
      oldSubscription = purchases[_enterprise]! as GooglePlayPurchaseDetails;
    }

    return oldSubscription;
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
