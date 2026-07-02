import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'E-commerce Demo'**
  String get appTitle;

  /// Etiqueta del tab Explorar
  ///
  /// In es, this message translates to:
  /// **'Explorar'**
  String get explore;

  /// Etiqueta del tab Categorías
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// Etiqueta del tab Tiendas
  ///
  /// In es, this message translates to:
  /// **'Tiendas'**
  String get stores;

  /// Etiqueta del tab Perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// Sección de productos recomendados
  ///
  /// In es, this message translates to:
  /// **'Perfecto para ti'**
  String get perfectForYou;

  /// Sección de productos de temporada
  ///
  /// In es, this message translates to:
  /// **'Para este verano'**
  String get forThisSummer;

  /// Botón para ver más productos
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get seeMore;

  /// Título de la pantalla del carrito
  ///
  /// In es, this message translates to:
  /// **'Tu bolsa'**
  String get yourBag;

  /// Botón de checkout
  ///
  /// In es, this message translates to:
  /// **'Ir al pago'**
  String get checkout;

  /// Etiqueta de total en el carrito
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// Botón de agregar al carrito
  ///
  /// In es, this message translates to:
  /// **'Agregar a la bolsa'**
  String get addToBag;

  /// Etiqueta de talla en detalle de producto
  ///
  /// In es, this message translates to:
  /// **'Talla'**
  String get size;

  /// Etiqueta de color en detalle de producto
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get color;

  /// Botón de cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Botón de procesar pago
  ///
  /// In es, this message translates to:
  /// **'Procesar pago'**
  String get processPayment;

  /// Título de sección de pago
  ///
  /// In es, this message translates to:
  /// **'Elige un método de pago'**
  String get choosePaymentMethod;

  /// Opción de pago con tarjeta
  ///
  /// In es, this message translates to:
  /// **'Tarjeta de crédito'**
  String get creditCard;

  /// Opción de pago con Apple Pay
  ///
  /// In es, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// Opción para agregar tarjeta nueva
  ///
  /// In es, this message translates to:
  /// **'+ Agregar nueva tarjeta'**
  String get addNewCard;

  /// Checkbox de dirección de facturación
  ///
  /// In es, this message translates to:
  /// **'Mi dirección de facturación es la misma que la de envío'**
  String get billingAddressSameAsShipping;

  /// Mensaje de estado de carga
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// Mensaje de error genérico
  ///
  /// In es, this message translates to:
  /// **'Error al cargar'**
  String get errorLoading;

  /// Botón de reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// Título de la pantalla de onboarding
  ///
  /// In es, this message translates to:
  /// **'Crea un prototipo en minutos'**
  String get onboardingTitle;

  /// Subtítulo de la pantalla de onboarding
  ///
  /// In es, this message translates to:
  /// **'Disfruta estos componentes listos para usar y preocúpate solo por crear el mejor producto.'**
  String get onboardingSubtitle;

  /// Botón de avanzar en onboarding
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// Título del paso de intereses
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu experiencia'**
  String get personaliseExperience;

  /// Subtítulo del paso de intereses
  ///
  /// In es, this message translates to:
  /// **'Elige tus intereses.'**
  String get chooseInterests;

  /// Etiqueta del selector de idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Opción de idioma español
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// Opción de idioma inglés
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// Paso de envío en checkout
  ///
  /// In es, this message translates to:
  /// **'Envío'**
  String get shipping;

  /// Paso de pago en checkout
  ///
  /// In es, this message translates to:
  /// **'Pago'**
  String get payment;

  /// Paso de bolsa en checkout
  ///
  /// In es, this message translates to:
  /// **'Bolsa'**
  String get bagStep;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
