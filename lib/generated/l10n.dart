// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign In`
  String get signin_btn_text {
    return Intl.message(
      'Sign In',
      name: 'signin_btn_text',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password_text {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password_text',
      desc: '',
      args: [],
    );
  }

  /// `Click Here`
  String get click_here_text {
    return Intl.message(
      'Click Here',
      name: 'click_here_text',
      desc: '',
      args: [],
    );
  }

  /// `Enter the Code sent to`
  String get enter_code_text {
    return Intl.message(
      'Enter the Code sent to',
      name: 'enter_code_text',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify_btn_text {
    return Intl.message(
      'Verify',
      name: 'verify_btn_text',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit_btn_text {
    return Intl.message(
      'Edit',
      name: 'edit_btn_text',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_btn_text {
    return Intl.message(
      'Delete',
      name: 'delete_btn_text',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get dont_receive_text {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'dont_receive_text',
      desc: '',
      args: [],
    );
  }

  /// `RESEND`
  String get resend_text {
    return Intl.message(
      'RESEND',
      name: 'resend_text',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total_text {
    return Intl.message(
      'Total',
      name: 'total_text',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin_text {
    return Intl.message(
      'Admin',
      name: 'admin_text',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard_text {
    return Intl.message(
      'Dashboard',
      name: 'dashboard_text',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages_text {
    return Intl.message(
      'Languages',
      name: 'languages_text',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout_text {
    return Intl.message(
      'Logout',
      name: 'logout_text',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get r_u_sure_text {
    return Intl.message(
      'Are you sure?',
      name: 'r_u_sure_text',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit?`
  String get do_u_want_to_exit_text {
    return Intl.message(
      'Do you want to exit?',
      name: 'do_u_want_to_exit_text',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes_btn_text {
    return Intl.message(
      'Yes',
      name: 'yes_btn_text',
      desc: '',
      args: [],
    );
  }

  /// `no`
  String get no_btn_text {
    return Intl.message(
      'no',
      name: 'no_btn_text',
      desc: '',
      args: [],
    );
  }

  /// `Admin Dashboard`
  String get admin_dashboard_text {
    return Intl.message(
      'Admin Dashboard',
      name: 'admin_dashboard_text',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to logout?`
  String get want_to_logout {
    return Intl.message(
      'Do you want to logout?',
      name: 'want_to_logout',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete?`
  String get want_to_delete {
    return Intl.message(
      'Do you want to delete?',
      name: 'want_to_delete',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name_text {
    return Intl.message(
      'First Name',
      name: 'first_name_text',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get last_name_text {
    return Intl.message(
      'Last Name',
      name: 'last_name_text',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get mobile_num_text {
    return Intl.message(
      'Mobile Number',
      name: 'mobile_num_text',
      desc: '',
      args: [],
    );
  }

  /// `This number does not exist`
  String get number_not_exist {
    return Intl.message(
      'This number does not exist',
      name: 'number_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `You've reached maximum login attempts!`
  String get too_many_attempts {
    return Intl.message(
      'You\'ve reached maximum login attempts!',
      name: 'too_many_attempts',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number or invalid country code`
  String get invalid_phone {
    return Intl.message(
      'Please enter a valid phone number or invalid country code',
      name: 'invalid_phone',
      desc: '',
      args: [],
    );
  }

  /// `There is an error`
  String get error {
    return Intl.message(
      'There is an error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Valid OTP`
  String get valid_otp {
    return Intl.message(
      'Please Enter Valid OTP',
      name: 'valid_otp',
      desc: '',
      args: [],
    );
  }

  /// `Updated successfully!`
  String get update_success {
    return Intl.message(
      'Updated successfully!',
      name: 'update_success',
      desc: '',
      args: [],
    );
  }

  /// `Deleted successfully!`
  String get delete_success {
    return Intl.message(
      'Deleted successfully!',
      name: 'delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Added successfully!`
  String get add_success {
    return Intl.message(
      'Added successfully!',
      name: 'add_success',
      desc: '',
      args: [],
    );
  }

  /// `Registered successfully!`
  String get register_success {
    return Intl.message(
      'Registered successfully!',
      name: 'register_success',
      desc: '',
      args: [],
    );
  }

  /// `Already exist!`
  String get already_exist {
    return Intl.message(
      'Already exist!',
      name: 'already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Notification sent!`
  String get notification_sent {
    return Intl.message(
      'Notification sent!',
      name: 'notification_sent',
      desc: '',
      args: [],
    );
  }

  /// `Employees`
  String get employees_text {
    return Intl.message(
      'Employees',
      name: 'employees_text',
      desc: '',
      args: [],
    );
  }

  /// `Add New Employee`
  String get add_new_employee_text {
    return Intl.message(
      'Add New Employee',
      name: 'add_new_employee_text',
      desc: '',
      args: [],
    );
  }

  /// `New Employee`
  String get new_employee_text {
    return Intl.message(
      'New Employee',
      name: 'new_employee_text',
      desc: '',
      args: [],
    );
  }

  /// `Add Employee`
  String get add_employee_text {
    return Intl.message(
      'Add Employee',
      name: 'add_employee_text',
      desc: '',
      args: [],
    );
  }

  /// `Update Employee`
  String get Update_employee_text {
    return Intl.message(
      'Update Employee',
      name: 'Update_employee_text',
      desc: '',
      args: [],
    );
  }

  /// `Edit Employee`
  String get edit_employee_text {
    return Intl.message(
      'Edit Employee',
      name: 'edit_employee_text',
      desc: '',
      args: [],
    );
  }

  /// `Employee List`
  String get employee_list_text {
    return Intl.message(
      'Employee List',
      name: 'employee_list_text',
      desc: '',
      args: [],
    );
  }

  /// `Employee Number`
  String get employee_num_text {
    return Intl.message(
      'Employee Number',
      name: 'employee_num_text',
      desc: '',
      args: [],
    );
  }

  /// `No Employee  Found`
  String get no_employee_found_text {
    return Intl.message(
      'No Employee  Found',
      name: 'no_employee_found_text',
      desc: '',
      args: [],
    );
  }

  /// `Employee Update Successfully`
  String get employee_updated_text {
    return Intl.message(
      'Employee Update Successfully',
      name: 'employee_updated_text',
      desc: '',
      args: [],
    );
  }

  /// `Employee Dashboard`
  String get employee_dashboard_text {
    return Intl.message(
      'Employee Dashboard',
      name: 'employee_dashboard_text',
      desc: '',
      args: [],
    );
  }

  /// `Employee Added Successfully`
  String get employee_added_text {
    return Intl.message(
      'Employee Added Successfully',
      name: 'employee_added_text',
      desc: '',
      args: [],
    );
  }

  /// `Employee Deleted Successfully`
  String get employee_deleted_text {
    return Intl.message(
      'Employee Deleted Successfully',
      name: 'employee_deleted_text',
      desc: '',
      args: [],
    );
  }

  /// `Managers`
  String get managers_text {
    return Intl.message(
      'Managers',
      name: 'managers_text',
      desc: '',
      args: [],
    );
  }

  /// `Manager`
  String get manager_text {
    return Intl.message(
      'Manager',
      name: 'manager_text',
      desc: '',
      args: [],
    );
  }

  /// `Add New Manager`
  String get add_new_manager_text {
    return Intl.message(
      'Add New Manager',
      name: 'add_new_manager_text',
      desc: '',
      args: [],
    );
  }

  /// `New Manager`
  String get new_manager_text {
    return Intl.message(
      'New Manager',
      name: 'new_manager_text',
      desc: '',
      args: [],
    );
  }

  /// `Add Manager`
  String get add_manager_text {
    return Intl.message(
      'Add Manager',
      name: 'add_manager_text',
      desc: '',
      args: [],
    );
  }

  /// `Update Manager`
  String get Update_manager_text {
    return Intl.message(
      'Update Manager',
      name: 'Update_manager_text',
      desc: '',
      args: [],
    );
  }

  /// `Edit Manager`
  String get edit_manager_text {
    return Intl.message(
      'Edit Manager',
      name: 'edit_manager_text',
      desc: '',
      args: [],
    );
  }

  /// `Manager Dashboard`
  String get manager_dashboard_text {
    return Intl.message(
      'Manager Dashboard',
      name: 'manager_dashboard_text',
      desc: '',
      args: [],
    );
  }

  /// `Manager List`
  String get manager_list_text {
    return Intl.message(
      'Manager List',
      name: 'manager_list_text',
      desc: '',
      args: [],
    );
  }

  /// `Manager Number`
  String get manager_num_text {
    return Intl.message(
      'Manager Number',
      name: 'manager_num_text',
      desc: '',
      args: [],
    );
  }

  /// `No Manager  Found`
  String get no_manager_found_text {
    return Intl.message(
      'No Manager  Found',
      name: 'no_manager_found_text',
      desc: '',
      args: [],
    );
  }

  /// `Manager Update Successfully`
  String get manager_updated_text {
    return Intl.message(
      'Manager Update Successfully',
      name: 'manager_updated_text',
      desc: '',
      args: [],
    );
  }

  /// `Manager Added Successfully`
  String get manager_added_text {
    return Intl.message(
      'Manager Added Successfully',
      name: 'manager_added_text',
      desc: '',
      args: [],
    );
  }

  /// `Manager Deleted Successfully`
  String get manager_deleted_text {
    return Intl.message(
      'Manager Deleted Successfully',
      name: 'manager_deleted_text',
      desc: '',
      args: [],
    );
  }

  /// `Add City`
  String get add_city_text {
    return Intl.message(
      'Add City',
      name: 'add_city_text',
      desc: '',
      args: [],
    );
  }

  /// `Enter City`
  String get enter_city {
    return Intl.message(
      'Enter City',
      name: 'enter_city',
      desc: '',
      args: [],
    );
  }

  /// `Update City`
  String get edit_city_text {
    return Intl.message(
      'Update City',
      name: 'edit_city_text',
      desc: '',
      args: [],
    );
  }

  /// `Select City`
  String get select_city_text {
    return Intl.message(
      'Select City',
      name: 'select_city_text',
      desc: '',
      args: [],
    );
  }

  /// `City Update Successfully`
  String get city_updated_text {
    return Intl.message(
      'City Update Successfully',
      name: 'city_updated_text',
      desc: '',
      args: [],
    );
  }

  /// `City Added Successfully`
  String get city_added_text {
    return Intl.message(
      'City Added Successfully',
      name: 'city_added_text',
      desc: '',
      args: [],
    );
  }

  /// `City Deleted Successfully`
  String get city_deleted_text {
    return Intl.message(
      'City Deleted Successfully',
      name: 'city_deleted_text',
      desc: '',
      args: [],
    );
  }

  /// `City Already Exist`
  String get city_already_text {
    return Intl.message(
      'City Already Exist',
      name: 'city_already_text',
      desc: '',
      args: [],
    );
  }

  /// `City List`
  String get city_list_text {
    return Intl.message(
      'City List',
      name: 'city_list_text',
      desc: '',
      args: [],
    );
  }

  /// `Branches`
  String get branches_text {
    return Intl.message(
      'Branches',
      name: 'branches_text',
      desc: '',
      args: [],
    );
  }

  /// `Branch City`
  String get branch_city {
    return Intl.message(
      'Branch City',
      name: 'branch_city',
      desc: '',
      args: [],
    );
  }

  /// `Add New Branch`
  String get add_new_branch_text {
    return Intl.message(
      'Add New Branch',
      name: 'add_new_branch_text',
      desc: '',
      args: [],
    );
  }

  /// `Add Branch`
  String get add_branch_text {
    return Intl.message(
      'Add Branch',
      name: 'add_branch_text',
      desc: '',
      args: [],
    );
  }

  /// `Update Branch`
  String get update_branch_text {
    return Intl.message(
      'Update Branch',
      name: 'update_branch_text',
      desc: '',
      args: [],
    );
  }

  /// `Edit Branch`
  String get edit_branch_text {
    return Intl.message(
      'Edit Branch',
      name: 'edit_branch_text',
      desc: '',
      args: [],
    );
  }

  /// `Branch List`
  String get branch_list_text {
    return Intl.message(
      'Branch List',
      name: 'branch_list_text',
      desc: '',
      args: [],
    );
  }

  /// `Select Branch`
  String get select_branch_text {
    return Intl.message(
      'Select Branch',
      name: 'select_branch_text',
      desc: '',
      args: [],
    );
  }

  /// `Branch Update Successfully`
  String get branch_updated_text {
    return Intl.message(
      'Branch Update Successfully',
      name: 'branch_updated_text',
      desc: '',
      args: [],
    );
  }

  /// `Branch Added Successfully`
  String get branch_added_text {
    return Intl.message(
      'Branch Added Successfully',
      name: 'branch_added_text',
      desc: '',
      args: [],
    );
  }

  /// `Branch Deleted Successfully`
  String get branch_deleted_text {
    return Intl.message(
      'Branch Deleted Successfully',
      name: 'branch_deleted_text',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications_text {
    return Intl.message(
      'Notifications',
      name: 'notifications_text',
      desc: '',
      args: [],
    );
  }

  /// `Notification Name`
  String get notifications_name_text {
    return Intl.message(
      'Notification Name',
      name: 'notifications_name_text',
      desc: '',
      args: [],
    );
  }

  /// `Create New Notification`
  String get create_new_notification_text {
    return Intl.message(
      'Create New Notification',
      name: 'create_new_notification_text',
      desc: '',
      args: [],
    );
  }

  /// `New Notification`
  String get new_notification_text {
    return Intl.message(
      'New Notification',
      name: 'new_notification_text',
      desc: '',
      args: [],
    );
  }

  /// `Edit Notification`
  String get edit_notification_text {
    return Intl.message(
      'Edit Notification',
      name: 'edit_notification_text',
      desc: '',
      args: [],
    );
  }

  /// `Add Notification`
  String get add_notification_text {
    return Intl.message(
      'Add Notification',
      name: 'add_notification_text',
      desc: '',
      args: [],
    );
  }

  /// `update Notification`
  String get update_notification_text {
    return Intl.message(
      'update Notification',
      name: 'update_notification_text',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification_list_text {
    return Intl.message(
      'Notification',
      name: 'notification_list_text',
      desc: '',
      args: [],
    );
  }

  /// `Notification Update Successfully`
  String get notification_updated_text {
    return Intl.message(
      'Notification Update Successfully',
      name: 'notification_updated_text',
      desc: '',
      args: [],
    );
  }

  /// `Notification Added Successfully`
  String get notification_added_text {
    return Intl.message(
      'Notification Added Successfully',
      name: 'notification_added_text',
      desc: '',
      args: [],
    );
  }

  /// `Notification Deleted Successfully`
  String get notification_deleted_text {
    return Intl.message(
      'Notification Deleted Successfully',
      name: 'notification_deleted_text',
      desc: '',
      args: [],
    );
  }

  /// `Notification not sent`
  String get notification_not_sent_text {
    return Intl.message(
      'Notification not sent',
      name: 'notification_not_sent_text',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get list {
    return Intl.message(
      'List',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Chat with`
  String get chat_with {
    return Intl.message(
      'Chat with',
      name: 'chat_with',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get something_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'something_wrong',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar', countryCode: 'AE'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}