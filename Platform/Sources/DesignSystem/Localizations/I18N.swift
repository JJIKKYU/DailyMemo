import Foundation

public extension String {
    var localized: String {
            return NSLocalizedString(self, tableName: nil, bundle: Bundle.module, value: "", comment: "")
    }
}

public struct MenualString {

    // MENUAL UX Localizations 적용 버전 = 1.02
    public static let localizations_ver = "localizations_ver".localized
    public static let home_title_menual = "home_title_menual".localized
    public static let home_title_moments = "home_title_moments".localized
    public static let home_title_myMenual = "home_title_myMenual".localized
    public static let home_button_writing = "home_button_writing".localized
    public static let moments_title_aboutMe = "moments_title_aboutMe".localized
    public static let moments_title_notice = "moments_title_notice".localized
    public static let moments_title_reminder = "moments_title_reminder".localized
    public static let filter_button_apply = "filter_button_apply".localized
    public static let search_placeholder_search = "search_placeholder_search".localized
    public static let search_title_searchResult = "search_title_searchResult".localized
    public static let search_title_searchHistory = "search_title_searchHistory".localized
    public static let filter_title = "filter_title".localized
    public static let search_title = "search_title".localized
    public static let search_alert_nonexistent = "search_alert_nonexistent".localized
    public static let home_title_temp_moments = "home_title_temp_moments".localized
    public static let home_title_writing = "home_title_writing".localized
    public static let home_title_mymenual_with_count = "home_title_mymenual_with_count".localized
    public static let home_button_filter_reset = "home_button_filter_reset".localized
    public static let filter_button_reset = "filter_button_reset".localized
    public static let filter_button_select = "filter_button_select".localized
    public static let filter_button_watch_with_menaul_count = "filter_button_watch_with_menaul_count".localized
    public static let filter_title_weather = "filter_title_weather".localized
    public static let filter_title_place = "filter_title_place".localized
    public static let filter_button_select_with_count = "filter_button_select_with_count".localized
    public static let filter_title_year_with_year = "filter_title_year_with_year".localized
    public static let filter_title_month_with_month = "filter_title_month_with_month".localized
    public static let filter_title_date = "filter_title_date".localized
    public static let filter_button_nonexistent = "filter_button_nonexistent".localized
    public static let writing_placeholder_title = "writing_placeholder_title".localized
    public static let writing_placeholder_weather = "writing_placeholder_weather".localized
    public static let writing_placeholder_place = "writing_placeholder_place".localized
    public static let writing_placeholder_desc = "writing_placeholder_desc".localized
    public static let writing_desc_menual_desc_with_count = "writing_desc_menual_desc_with_count".localized
    public static let writing_button_add_image = "writing_button_add_image".localized
    public static let writing_alert_title_add_cancel = "writing_alert_title_add_cancel".localized
    public static let writing_alert_title_tempSave = "writing_alert_title_tempSave".localized
    public static let writing_alert_cancel = "writing_alert_cancel".localized
    public static let writing_alert_confirm = "writing_alert_confirm".localized
    public static let tempsave_desc_nonexistent = "tempsave_desc_nonexistent".localized
    public static let tempsave_title = "tempsave_title".localized
    public static let tempsave_desc_writing = "tempsave_desc_writing".localized
    public static let tempsave_button_delete = "tempsave_button_delete".localized
    public static let tempsave_button_delete_with_count = "tempsave_button_delete_with_count".localized
    public static let tempsave_title_cancel = "tempsave_title_cancel".localized
    public static let uploadimage_desc_thumb = "uploadimage_desc_thumb".localized
    public static let uploadimage_title_add = "uploadimage_title_add".localized
    public static let uploadimage_button_edit = "uploadimage_button_edit".localized
    public static let writing_alert_title_edit_cancel = "writing_alert_title_edit_cancel".localized
    public static let writing_title_edit = "writing_title_edit".localized
    public static let detail_title = "detail_title".localized
    public static let detail_desc_lock = "detail_desc_lock".localized
    public static let detail_button_unlock = "detail_button_unlock".localized
    public static let search_desc_find_menual = "search_desc_find_menual".localized
    public static let search_title_search = "search_title_search".localized
    public static let search_title_recent = "search_title_recent".localized
    public static let search_button_delete_all_search_menual = "search_button_delete_all_search_menual".localized
    public static let search_title_result = "search_title_result".localized
    public static let search_desc_inconsistent = "search_desc_inconsistent".localized
    public static let profile_title_myPage = "profile_title_myPage".localized
    public static let profile_title_setting = "profile_title_setting".localized
    public static let profile_title_etc = "profile_title_etc".localized
    public static let profile_button_guide = "profile_button_guide".localized
    public static let profile_button_set_password = "profile_button_set_password".localized
    public static let profile_button_change_password = "profile_button_change_password".localized
    public static let profile_button_bioauth = "profile_button_bioauth".localized
    public static let profile_button_icloud_backup = "profile_button_icloud_backup".localized
    public static let profile_button_backup = "profile_button_backup".localized
    public static let profile_button_restore = "profile_button_restore".localized
    public static let profile_button_mail = "profile_button_mail".localized
    public static let profile_button_openSource = "profile_button_openSource".localized
    public static let password_title_type = "password_title_type".localized
    public static let password_desc_help = "password_desc_help".localized
    public static let password_title_more = "password_title_more".localized
    public static let password_desc_notcorrect = "password_desc_notcorrect".localized
    public static let home_title_total_page_with_count = "home_title_total_page_with_count".localized
    public static let home_title_my_menual = "home_title_my_menual".localized
    public static let home_title_total_page = "home_title_total_page".localized
    public static let uploadimage_button_select = "uploadimage_button_select".localized
    public static let writing_title = "writing_title".localized
    public static let home_desc_nonexistent_fiflter_menual = "home_desc_nonexistent_fiflter_menual".localized
    public static let home_desc_nonexistent_writing_menual = "home_desc_nonexistent_writing_menual".localized
    public static let password_title_change = "password_title_change".localized
    public static let menu_title = "menu_title".localized
    public static let menu_button_lock = "menu_button_lock".localized
    public static let menu_button_edit = "menu_button_edit".localized
    public static let menu_button_delete = "menu_button_delete".localized
    public static let menu_button_unlock = "menu_button_unlock".localized
    public static let reminder_title = "reminder_title".localized
    public static let reminder_desc_setting_title = "reminder_desc_setting_title".localized
    public static let reminder_alert_title_qna = "reminder_alert_title_qna".localized
    public static let reminder_alert_desc_qna = "reminder_alert_desc_qna".localized
    public static let reminder_alert_confirm_qna = "reminder_alert_confirm_qna".localized
    public static let reminder_button_confirm = "reminder_button_confirm".localized
    public static let reminder_alert_title_reminder_auth = "reminder_alert_title_reminder_auth".localized
    public static let reminder_alert_desc_reminder = "reminder_alert_desc_reminder".localized
    public static let reminder_alert_confirm_reminder = "reminder_alert_confirm_reminder".localized
    public static let menu_alert_title_delete = "menu_alert_title_delete".localized
    public static let reminder_alert_title_reminder_clear = "reminder_alert_title_reminder_clear".localized
    public static let menu_alert_title_lock = "menu_alert_title_lock".localized
    public static let menu_alert_title_unlock = "menu_alert_title_unlock".localized
    public static let reminder_alert_cancel = "reminder_alert_cancel".localized
    public static let home_toast_writing = "home_toast_writing".localized
    public static let home_toast_delete = "home_toast_delete".localized
    public static let tempsave_toast_delete = "tempsave_toast_delete".localized
    public static let reminder_toast_edit = "reminder_toast_edit".localized
    public static let reminder_toast_set = "reminder_toast_set".localized
    public static let reply_placeholder = "reply_placeholder".localized
    public static let writing_button_take_picture = "writing_button_take_picture".localized
    public static let writing_button_select_picture = "writing_button_select_picture".localized
    public static let filter_button_all_menual = "filter_button_all_menual".localized
    public static let restore_title = "restore_title".localized
    public static let backup_title = "backup_title".localized
    public static let backup_alert_title_nothing = "backup_alert_title_nothing".localized
    public static let backup_alert_desc_nothing = "backup_alert_desc_nothing".localized
    public static let backup_desc_notice = "backup_desc_notice".localized
    public static let backup_title_order = "backup_title_order".localized
    public static let backup_desc_order = "backup_desc_order".localized
    public static let backup_title_recent = "backup_title_recent".localized
    public static let backup_desc_recent_date = "backup_desc_recent_date".localized
    public static let backup_desc_recent_count = "backup_desc_recent_count".localized
    public static let backup_desc_recent_page = "backup_desc_recent_page".localized
    public static let backup_desc_recent_empty = "backup_desc_recent_empty".localized
    public static let restore_button_select_file = "restore_button_select_file".localized
    public static let restore_desc_notice = "restore_desc_notice".localized
    public static let restore_title_order = "restore_title_order".localized
    public static let restore_desc_order = "restore_desc_order".localized
    public static let restore_alert_confirm_file = "restore_alert_confirm_file".localized
    public static let restore_alert_success = "restore_alert_success".localized
    public static let restore_alert_title_not_menual = "restore_alert_title_not_menual".localized
    public static let restore_alert_desc_not_menual = "restore_alert_desc_not_menual".localized
    public static let restore_alert_title_error = "restore_alert_title_error".localized
    public static let restore_alert_desc_error = "restore_alert_desc_error".localized
    public static let restore_desc_date = "restore_desc_date".localized
    public static let restore_desc_file_name = "restore_desc_file_name".localized
    public static let restore_title_last_confirm = "restore_title_last_confirm".localized
    public static let restore_title_test_title = "restore_title_test_title".localized
    public static let alarm_title_day = "alarm_title_day".localized
    public static let alarm_title_time = "alarm_title_time".localized
    public static let alarm_button_confirm = "alarm_button_confirm".localized
    public static let profile_button_alarm = "profile_button_alarm".localized
    public static let alarm_alert_authorization_title = "alarm_alert_authorization_title".localized
    public static let alarm_alert_authorization_subtitle = "alarm_alert_authorization_subtitle".localized
    public static let alarm_alert_cancel = "alarm_alert_cancel".localized
    public static let alarm_alert_confirm = "alarm_alert_confirm".localized
    public static let profile_button_alarm_subtitle = "profile_button_alarm_subtitle".localized
    public static let profile_button_dev = "profile_button_dev".localized
    public static let profile_button_designsystem = "profile_button_designsystem".localized
    public static let detail_placeholder_reply = "detail_placeholder_reply".localized
    public static let reminder_desc_setting_subtitle = "reminder_desc_setting_subtitle".localized
    public static let reminder_toast_delete = "reminder_toast_delete".localized
    public static let alarm_alert_body1 = "alarm_alert_body1".localized
    public static let alarm_alert_body2 = "alarm_alert_body2".localized
    public static let alarm_alert_body3 = "alarm_alert_body3".localized
    public static let alarm_alert_body4 = "alarm_alert_body4".localized
    public static let alarm_alert_body5 = "alarm_alert_body5".localized
    public static let alarm_alert_body6 = "alarm_alert_body6".localized
    public static let alarm_alert_body7 = "alarm_alert_body7".localized
    public static let alarm_alert_body8 = "alarm_alert_body8".localized
    public static let alarm_alert_body9 = "alarm_alert_body9".localized
    public static let alarm_alert_body10 = "alarm_alert_body10".localized
    public static let alarm_toast_disable = "alarm_toast_disable".localized
}
