import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personal_info;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @batch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get batch;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @owner_name.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get owner_name;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @office_chat.
  ///
  /// In en, this message translates to:
  /// **'Office Chat'**
  String get office_chat;

  /// No description provided for @support_chat.
  ///
  /// In en, this message translates to:
  /// **'Support Chat'**
  String get support_chat;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message;

  /// No description provided for @confirm_logout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirm_logout;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @full_list.
  ///
  /// In en, this message translates to:
  /// **'Full List'**
  String get full_list;

  /// No description provided for @pending_records.
  ///
  /// In en, this message translates to:
  /// **'Pending Records'**
  String get pending_records;

  /// No description provided for @sync_all.
  ///
  /// In en, this message translates to:
  /// **'Sync All'**
  String get sync_all;

  /// No description provided for @no_farm_found.
  ///
  /// In en, this message translates to:
  /// **'No farm found'**
  String get no_farm_found;

  /// No description provided for @no_tasks_today.
  ///
  /// In en, this message translates to:
  /// **'No tasks scheduled for today'**
  String get no_tasks_today;

  /// No description provided for @field_officer.
  ///
  /// In en, this message translates to:
  /// **'Field Officer'**
  String get field_officer;

  /// No description provided for @no_batch_found.
  ///
  /// In en, this message translates to:
  /// **'No batch found'**
  String get no_batch_found;

  /// No description provided for @batch_code.
  ///
  /// In en, this message translates to:
  /// **'Batch Code'**
  String get batch_code;

  /// No description provided for @breed_label.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed_label;

  /// No description provided for @finding_location.
  ///
  /// In en, this message translates to:
  /// **'Finding precise location...'**
  String get finding_location;

  /// No description provided for @bird_info.
  ///
  /// In en, this message translates to:
  /// **'Bird Info'**
  String get bird_info;

  /// No description provided for @food_and_water.
  ///
  /// In en, this message translates to:
  /// **'Food and Water'**
  String get food_and_water;

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @growth.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growth;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @daily_info_entry.
  ///
  /// In en, this message translates to:
  /// **'Daily Info Entry'**
  String get daily_info_entry;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @bird_count_label.
  ///
  /// In en, this message translates to:
  /// **'Chicken Count'**
  String get bird_count_label;

  /// No description provided for @mortality_label.
  ///
  /// In en, this message translates to:
  /// **'Mortality'**
  String get mortality_label;

  /// No description provided for @culling_label.
  ///
  /// In en, this message translates to:
  /// **'Culling'**
  String get culling_label;

  /// No description provided for @feed_consumption_label.
  ///
  /// In en, this message translates to:
  /// **'Feed Consumption (kg)'**
  String get feed_consumption_label;

  /// No description provided for @water_consumption_label.
  ///
  /// In en, this message translates to:
  /// **'Water Consumption (ltr)'**
  String get water_consumption_label;

  /// No description provided for @temperature_label.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C)'**
  String get temperature_label;

  /// No description provided for @humidity_label.
  ///
  /// In en, this message translates to:
  /// **'Humidity (%)'**
  String get humidity_label;

  /// No description provided for @light_hours_label.
  ///
  /// In en, this message translates to:
  /// **'Light Hours (hrs)'**
  String get light_hours_label;

  /// No description provided for @avg_weight_label.
  ///
  /// In en, this message translates to:
  /// **'Avg. Weight (gm)'**
  String get avg_weight_label;

  /// No description provided for @medicine_used_label.
  ///
  /// In en, this message translates to:
  /// **'Medicine Used'**
  String get medicine_used_label;

  /// No description provided for @vaccine_label.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get vaccine_label;

  /// No description provided for @enter_remarks_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter remarks...'**
  String get enter_remarks_hint;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'grams'**
  String get grams;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'liters'**
  String get liters;

  /// No description provided for @captured_images.
  ///
  /// In en, this message translates to:
  /// **'Captured Images'**
  String get captured_images;

  /// No description provided for @take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get take_photo;

  /// No description provided for @camera_instruction.
  ///
  /// In en, this message translates to:
  /// **'Photos of shed, feed, water & environment'**
  String get camera_instruction;

  /// No description provided for @auto_upload_msg.
  ///
  /// In en, this message translates to:
  /// **'Will upload automatically when network is available'**
  String get auto_upload_msg;

  /// No description provided for @confirmation_page.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Page'**
  String get confirmation_page;

  /// No description provided for @info_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Information Confirmation'**
  String get info_confirmation;

  /// No description provided for @total_mortality.
  ///
  /// In en, this message translates to:
  /// **'Total Mortality'**
  String get total_mortality;

  /// No description provided for @average_weight.
  ///
  /// In en, this message translates to:
  /// **'Average Weight'**
  String get average_weight;

  /// No description provided for @total_feed.
  ///
  /// In en, this message translates to:
  /// **'Total Feed'**
  String get total_feed;

  /// No description provided for @confirmation_agreement.
  ///
  /// In en, this message translates to:
  /// **'I confirm that the above information is correct'**
  String get confirmation_agreement;

  /// No description provided for @confirm_button.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm_button;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @fetch_batch_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch batch details'**
  String get fetch_batch_error;

  /// No description provided for @checkin_success.
  ///
  /// In en, this message translates to:
  /// **'Check-in successful'**
  String get checkin_success;

  /// No description provided for @please_confirm_info.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the information'**
  String get please_confirm_info;

  /// No description provided for @data_saved_success.
  ///
  /// In en, this message translates to:
  /// **'Data saved successfully'**
  String get data_saved_success;

  /// No description provided for @failed_to_send_data.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data to server'**
  String get failed_to_send_data;

  /// No description provided for @location_services_disabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get location_services_disabled;

  /// No description provided for @location_permissions_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get location_permissions_denied;

  /// No description provided for @location_permissions_permanently_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied.'**
  String get location_permissions_permanently_denied;

  /// No description provided for @failed_to_get_location.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location'**
  String get failed_to_get_location;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get session_expired;

  /// No description provided for @please_login_again.
  ///
  /// In en, this message translates to:
  /// **'Please login again to continue'**
  String get please_login_again;

  /// No description provided for @checkin_failed.
  ///
  /// In en, this message translates to:
  /// **'Check-in Failed'**
  String get checkin_failed;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @weather_forecast.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weather_forecast;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @data_not_found.
  ///
  /// In en, this message translates to:
  /// **'Data not found'**
  String get data_not_found;

  /// No description provided for @forecast_5_days.
  ///
  /// In en, this message translates to:
  /// **'Forecast for next 5 days'**
  String get forecast_5_days;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get login_failed;

  /// No description provided for @failed_load_batches.
  ///
  /// In en, this message translates to:
  /// **'Failed to load batches'**
  String get failed_load_batches;

  /// No description provided for @daily_entry_missing.
  ///
  /// In en, this message translates to:
  /// **'Daily entry data missing'**
  String get daily_entry_missing;

  /// No description provided for @location_not_available.
  ///
  /// In en, this message translates to:
  /// **'Location not available. Please wait.'**
  String get location_not_available;

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get network_error;

  /// No description provided for @upload_success.
  ///
  /// In en, this message translates to:
  /// **'Upload successful'**
  String get upload_success;

  /// No description provided for @upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get upload_failed;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @added_to_queue.
  ///
  /// In en, this message translates to:
  /// **'Image added to upload queue'**
  String get added_to_queue;

  /// No description provided for @your_location.
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get your_location;
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
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
