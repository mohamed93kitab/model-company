import 'package:model_company/data_model/business_setting_response.dart';
import 'package:model_company/helpers/shared_value_helper.dart';
import 'package:model_company/repositories/business_setting_repository.dart';
import 'package:model_company/providers/locale_provider.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';

class BusinessSettingHelper {
  setBusinessSettingData() async {
    List<BusinessSettingListResponse> businessLists =
        await BusinessSettingRepository().getBusinessSettingList();


    businessLists.forEach((element) {
      switch (element.type) {
        case 'facebook_login':
          {
            if (element.value.toString() == "1") {
              allow_facebook_login.$ = true;
            } else {
              allow_facebook_login.$ = false;
            }
          }
          break;
        case 'google_login':
          {
            if (element.value.toString() == "1") {
              allow_google_login.$ = true;
            } else {
              allow_google_login.$ = false;
            }
          }
          break;
        case 'twitter_login':
          {
            if (element.value.toString() == "1") {
              allow_twitter_login.$ = true;
            } else {
              allow_twitter_login.$ = false;
            }
          }
          break;
        case 'pickup_point':
          {
            if (element.value.toString() == "1") {
              pick_up_status.$ = true;
            } else {
              pick_up_status.$ = false;
            }
          }
          break;
        case 'wallet_system':
          {
            if (element.value.toString() == "1") {
              wallet_system_status.$ = true;
            } else {
              wallet_system_status.$ = false;
            }
          }
          break;
        case 'email_verification':
          {
            if (element.value.toString() == "1") {
              mail_verification_status.$ = true;
            } else {
              mail_verification_status.$ = false;
            }
          }
          break;
        case 'conversation_system':
          {
            if (element.value.toString() == "1") {
              conversation_system_status.$ = true;
            } else {
              conversation_system_status.$ = false;
            }
          }
          break;
        case 'shipping_type':
          {
            print(element.value.toString());
            if (element.value.toString() == "carrier_wise_shipping") {
              carrier_base_shipping.$ = true;
            } else {
              carrier_base_shipping.$ = false;
            }
          }
          break;

        default:
          {}
          break;
      }
    });
  }
}
