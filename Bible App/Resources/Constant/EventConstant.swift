//
//  EventConstant.swift
//  Bible App
//
//  Created by applemacos on 26/02/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
import Firebase


struct FacebookEventConstant {
    static let homescreenDay4 = "Homescreen_4th_Day" //    Homescreen_4th_Day - hourDifference(from install time) >= 96
    static let hsDevotionClicked = "hs_devotion_clicked" //hs_devotion_clicked - on click of devotion button
    static let hsSponsorClicked = "hs_sponsor_clicked" //hs_sponsor_clicked - on click of sponsor button
    static let hsTriviaClicked = "hs_trivia_clicked" //hs_trivia_clicked - on click of trivia button
}

struct TenjinEventConstant {
    
    static let homescreenDay4 = "Homescreen_4th_Day" //u    Homescreen_4th_Day - hourDifference(from install time) >= 96
    //    static let hsDevotionClicked = "hs_devotion_clicked" //u hs_devotion_clicked - on click of devotion button
    //    static let hsSponsorClicked = "hs_sponsor_clicked" //u hs_sponsor_clicked - on click of sponsor button
    //    static let hsTriviaClicked = "hs_trivia_clicked" //u hs_trivia_clicked - on click of trivia button
    //    static let hsTriviaLevel1Complete = "trivia_level_1_complete" //u hs_trivia_clicked - on click of trivia level complete
    
    static let hsShown = "hs_loaded" //u
    static let hsShown3 = "hs_loaded_third" //u consider app open count
    static let hsShown4 = "hs_loaded_four" //u
    static let hsShown5 = "hs_loaded_five" //u
    static let hsMorningdevClick = "hs_morning_dev_btn_clicked" //u
    static let hsAfternoondevClick = "hs_afternoon_dev_btn_clicked" //u
    static let hsEveningdevClick = "hs_evening_dev_btn_clicked" //u
    static let hsPlayTriviaClicked = "hs_trivia_btn_clicked" //u
    static let hsSponsoredReachMobiBibleButtonClicked = "hs_reachmobi_btn_clicked" //u
    static let hsSettingsButtonClicked = "hs_settings_btn_clicked" //u
    
    static let devTabClick = "dev_tab_clicked" //u  devotion section - on top menu change
    static let triviaTabClick = "trivia_tab_clicked" //u devotion section - on top menu change
    
    static let devScreenSaveToScreenMorningVerse = "dev_save_morning_verse" //u
    static let devScreenSaveToScreenAfternoonVerse = "dev_save_afternoon_verse" //u
    static let devScreenSaveToScreenEveningVerse = "dev_save_evening_verse" //u
    
    static let devScreenSaveToScreenMorningInspiration = "dev_save_morning_inspiration" //u
    static let devScreenSaveToScreenAfternoonInspiration = "dev_save_afternoon_inspiration" //u
    static let devScreenSaveToScreenEveningInspiration = "dev_save_evening_inspiration" //u
    
    static let devScreenSaveToScreenMorningPrayer = "dev_save_morning_prayer" //u
    static let devScreenSaveToScreenAfternoonPrayer = "dev_save_afternoon_prayer" //u
    static let devScreenSaveToScreenEveningPrayer = "dev_save_evening_prayer" //u
    
    static let devScreenMaxPrayersSavedModalView = "dev_max_prayers_saved_loaded" //u max fav limitation events
    static let devScreenMaxInspirationSavedModalView = "dev_max_inspiration_saved_loaded"
    static let devScreenMaxPrayersSavedUnlockbuttonclick = "dev_max_prayers_saved_unlock_btn_clicked" //u
    static let devScreenMaxPrayersSavedNoThanksclick = "dev_max_prayers_saved_nothanks_btn_clicked" //u
    
    
    static let settingsMenuMyFavoritesClicked = "settings_favorites_btn_clicked" //u side menu click
    static let settingsMenuRateUsClicked = "settings_rateus_btn_clicked"//u
    static let settingsMenuSettingsClicked = "settings_settings_btn_clicked" //u
    static let settingsTermsClicked = "settings_terms_btn_clicked" //u
    static let settingsPrivacyPolicyClick = "settings_privacypolicy_btn_clicked" //u
    
    static let favoritesScreenPrayersTabClicked = "favorites_prayers_btn_clicked" //u fav screen on tab change
    static let favoritesScreenVersesTabClicked = "favorites_verses_btn_clicked" //u
    static let favoritesScreenNextButtonClicked = "favorites_next_btn_clicked" //u
    static let favoritesScreenPreviousButtonClicked = "favorites_previous_btn_clicked" //u
    static let favoritesScreenFavoritesUnclicked = "favorites_btn_unclicked" //u
    
    /*
     static let initialSettingsScreenView = "initial_settings_loaded"
     static let initialSettingsScreenSelectNowclick = "initial_settings_selectnow_clicked"
     static let initialSettingsVerseScreenOldTestamentClicked = "initial_settings_verse_oldtestament_btn_clicked"
     static let initialSettingsVerseScreenNewTestamentClicked = "initial_settings_verse_newtestament_btn_clicked"
     static let initialSettingsVerseScreenTop100BibleVersesClicked = "initial_settings_verse_top100verses_btn_clicked"
     static let initialSettingsVerseScreenWordsofInspirationclicked = "initial_settings_verse_wordsofinspiration_btn_clicked"
     static let initialSettingsVerseScreenVersesforStrengthclicked = "initial_settings_verse_strengthverses_btn_clicked"
     static let initialSettingsVerseScreenVersesforHappinessclicked = "initial_settings_verse_happinessverses_btn_clicked"
     static let initialSettingsVerseScreenAlloftheaboveclicked = "initial_settings_verse_all_btn_clicked"
     static let initialSettingsVerseScreenNextButtonClicked = "initial_settings_verse_next_btn_clicked"
     
     static let initialSettingsEndModalView = "initial_settings_end_modal_loaded"
     static let initialSettingsEndModalCloseScreen = "initial_settings_end_modal_closescreen"
     static let initialSettingsEndModalOKButtonClick = "initial_settings_end_modal_ok_btn_clicked" */
    
    static let adloadedInterstitialForHomescreenClick = "int_homescreen_loaded" //u always on devo and trivia on click
    static let adLoadedHomescreen = "banner_320x100_homescreen" //u  on banner loaded on home screen
    static let adLoadedDevotionScreen = "banner_320x100_devotion" //u banner load on devo
    static let adLoadedTrivia = "banner_320x50_trivia" //u banner load on trvia
    static let adLoadedTriviaUpdated = "banner_320x100_trivia" //u banner load on trvia
    static let adloadedInterstitialForhomescreenEvenClick = "int_homescreen_even_click" //u on devo and trivia on even click
    static let adloadedFavorites = "banner_320x100_favorites" //u banner ad on fav on load
    
    static let alarmPushShown = "push_shown_" //u on local push
    static let alarmPushClicked = "push_clicked_" //u on did recive of 7.35 alarm with id
    static let unlockNextTriviaLevels = "unlock_next_trivia_levels" //u on next button click
    static let adloadInterstitialForOddlevel = "int_end_of_trivia_odd" //u on interstitial ad open
    
    //    static let settingsCallScreenClicked = "settings_call_screen_clicked"
    static let settingsReminderClicked = "settings_reminder_clicked" //u manage from settings screen
    static let settingsReminderSetOff = "settings_reminder_set_off" //u
    static let settingsReminderSetOn = "settings_reminder_set_on" //u
    
    static let rewardedVideo2MoreLevels = "rewarded_video_2more_levels" //u after getting reward to unloack trivia level
    
    static let intTriviaInBetweenOdd = "int_end_of_trivia_odd"
    
    /*  static let bnNewsletter3rdSessionView = "BN_Newsletter_3rdSession_View"
     static let bnNewsletter3rdSessionCloseScreen = "BN_Newsletter_3rdSession_CloseScreen"
     static let bnNewsletter3rdSessionSubmit = "BN_Newsletter_3rdSession_Submit"
     static let bnNewsletter5thSessionView = "BN_Newsletter_5thSession_View"
     static let bnNewsletter5thSessionCloseScreen = "BN_Newsletter_5thSession_CloseScreen"
     static let bnNewsletter5thSessionSubmit = "BN_Newsletter_5thSession_Submit"
     static let bnNewsletter11thSessionView = "BN_Newsletter_11thSession_View"
     static let bnNewsletter11thSessionCloseScreen = "BN_Newsletter_11thSession_CloseScreen"
     static let bnNewsletter11thSessionSubmit = "BN_Newsletter_11thSession_Submit" */
    
    static let Test_Panel3_320100AdLoad = "062419Test_Panel3_320100AdLoad" //u on devo banner ad load
    
    
    static let sliderAdDevoView = "slider_bibleminute_2ndopen_devo_view"
    static let sliderAdDevoClick = "slider_bibleminute_2ndopen_devo_click"
    static let sliderAdHomeView = "slider_bibleminute_4thopen_home_click"
    static let sliderAdHomeClick = "slider_bibleminute_4thopen_home_view"
    
    static let sliderAdDevoClose = "slider_bibleminute_2ndopen_devo_close"
    static let sliderAdHomeClose = "slider_bibleminute_4thopen_home_close"
    
    /* static let bnNewsletter1stSessionUpdateView = "BN_Newsletter_1stSessionUpdate_View"
     static let bnNewsletter1stSessionUpdateCloseScreen = "BN_Newsletter_1stSessionUpdate_CloseScreen"
     static let bnNewsletter1stSessionUpdateSubmit = "BN_Newsletter_1stSessionUpdate_Submit"
     static let bnNewsletter3rdSessionUpdateView = "BN_Newsletter_3rdSessionUpdate_View"
     static let bnNewsletter3rdSessionUpdateCloseScreen = "BN_Newsletter_3rdSessionUpdate_CloseScreen"
     static let bnNewsletter3rdSessionUpdateSubmit = "BN_Newsletter_3rdSessionUpdate_Submit"
     
     static let bnTriviaEndOfLevel2ImpressionView = "BN_trivia_EndOfLevel2_Impression_View"
     static let bNTriviaEndOfLevel2ImpressionSubmit = "BN_trivia_EndOfLevel2_Impression_Submit"
     static let bNTriviaEndOfLevel2ImpressionCloseScreen = "BN_trivia_EndOfLevel2_Impression_CloseScreen"
     static let bNSubmit = "BN_Submit"
     
     static let arcaMaxNewsletterTest07092019View = "ArcaMax_Newsletter_Test07092019_View"
     static let arcaMaxNewsletterTest07092019CloseScreen = "ArcaMax_Newsletter_Test07092019_CloseScreen"
     static let arcaMaxNewsletterTest07092019Submit = "ArcaMax_Newsletter_Test07092019_Submit"
     static let arcaMaxTYPageTest07092019CloseScreen = "ArcaMax_TYPage_Test07092019_CloseScreen"
     static let arcaMaxTYPageTest07092019CloseButton = "ArcaMax_TYPage_Test07092019_CloseButton"
     static let arcaMaxTYPageTest0709201930SecondsExpire = "ArcaMax_TYPage_Test07092019_30SecondsExpire"
     
     static let bonComTest0709019Screen1shown = "BonCom_Test_0709019_Screen1_shown"
     static let bonComTest0709019Screen1YesClick = "BonCom_Test_0709019_Screen1_YesClick"
     static let bonComTest0709019Screen1NoClick = "BonCom_Test_0709019_Screen1_NoClick"
     static let bonComTest0709019Screen1CloseScreen = "BonCom_Test_0709019_Screen1_CloseScreen"
     static let bonComTest0709019Screen2shown = "BonCom_Test_0709019_Screen2_shown"
     static let bonComTest0709019Screen2ContinueButtonClick = "BonCom_Test_0709019_Screen2_ContinueButtonClick"
     static let bonComTest_0709019Screen2ButtonCloserToGod = "BonCom_Test_0709019_Screen2_ButtonCloserToGod"
     static let bonComTest0709019Screen2ButtonImprove = "BonCom_Test_0709019_Screen2_ButtonImprove"
     static let bonComTest0709019Screen2ButtonSeekingAnswers = "BonCom_Test_0709019_Screen2_ButtonSeekingAnswersb"
     static let bonComTest0709019Screen2ButtonLifeEvent = "BonCom_Test_0709019_Screen2_ButtonLifeEvent"
     static let bonComTest0709019Screen2ButtonCurious = "BonCom_Test_0709019_Screen2_ButtonCurious"
     static let bonComTest0709019Screen2ButtonOther = "BonCom_Test_0709019_Screen2_ButtonOther"
     static let bonComTest0709019Screen2CloseScreen = "BonCom_Test_0709019_Screen2_CloseScreen"
     static let bonComTest0709019Screen3shown = "BonCom_Test_0709019_Screen3_shown"
     static let bonComTest0709019Screen3Button2Missionaries = "BonCom_Test_0709019_Screen3_Button2Missionaries"
     static let bonComTest0709019Screen3ButtonOnline = "BonCom_Test_0709019_Screen3_ButtonOnline"
     static let bonCom_Test0709019Screen3CloseScreen = "BonCom_Test_0709019_Screen3_CloseScreen"
     static let bonComTest0709019Screen4shown = "BonCom_Test_0709019_Screen4_shown"
     static let bonComTest_0709019Screen4ButtonWeekday = "BonCom_Test_0709019_Screen4_ButtonWeekday"
     static let bonComTest0709019Screen4ButtonWeekend = "BonCom_Test_0709019_Screen4_ButtonWeekend"
     static let bonComTest0709019Screen4CloseScreen = "BonCom_Test_0709019_Screen4_CloseScreen"
     static let bonComTest0709019Screen5shown = "BonCom_Test_0709019_Screen5_shown"
     static let bonComTest0709019Screen5ButtonMorning = "BonCom_Test_0709019_Screen5_ButtonMorning"
     static let bonComTest0709019Screen5ButtonAfternoon = "BonCom_Test_0709019_Screen5_ButtonAfternoon"
     static let bonComTest0709019Screen5ButtonEvening = "BonCom_Test_0709019_Screen5_ButtonEvening"
     static let bonComTest0709019Screen5CloseScreen = "BonCom_Test_0709019_Screen5_CloseScreen"
     static let bonComTest0709019Screen6shown = "BonCom_Test_0709019_Screen6_shown"
     static let bonComTest0709019Screen6ButtonRequest = "BonCom_Test_0709019_Screen6_ButtonRequest"
     static let bonComTest0709019Screen6CloseScreen = "BonCom_Test_0709019_Screen6_CloseScreen"
     
     static let panel1_08152019StartUp = "Panel1_08152019_StartUp"
     static let panel2_08152019StartUp = "Panel2_08152019_StartUp"
     static let panel2_08152019WelcomeShown = "Panel2_08152019_Welcome_Shown"
     static let panel2_08152019WelcomeNext_Click = "Panel2_08152019_Welcome_Next_Click"
     static let panel2_08152019WelcomeClose = "Panel2_08152019_Welcome_Close"
     static let panel2_08152019ArcamaxClose = "Panel2_08152019_Arcamax_Close"
     static let panel2_08152019ArcamaxSubmit = "Panel2_08152019_Arcamax_Submit"
     static let panel2_08152019ArcamaxConfirm_Email = "Panel2_08152019_Arcamax_Confirm_Email"
     static let panel2_08152019BN_Close = "Panel2_08152019_BN_Close"
     static let panel2_08152019BN_Submit = "Panel2_08152019_BN_Submit"
     static let panel3_08152019StartUp = "Panel3_08152019_StartUp"
     static let panel3_08152019WelcomeShown = "Panel3_08152019_Welcome_Shown"
     static let panel3_08152019WelcomeNextClick = "Panel3_08152019_Welcome_Next_Click"
     static let panel3_08152019WelcomeClose = "Panel3_08152019_Welcome_Close"
     static let panel3_08152019ArcamaxClose = "Panel3_08152019_Arcamax_Close"
     static let panel3_08152019ArcamaxSubmit = "Panel3_08152019_Arcamax_Submit"
     static let panel3_08152019ArcamaxConfirmEmail = "Panel3_08152019_Arcamax_Confirm_Email"
     static let panel3_08152019BNClose = "Panel3_08152019_BN_Close"
     static let panel3_08152019BNSubmit = "Panel3_08152019_BN_Submit"
     static let panel4_08152019StartUp = "Panel4_08152019_StartUp"
     static let panel4_08152019Close = "Panel4_08152019_Close"
     static let panel4_08152019NextClick = "Panel4_08152019_Next_Click" */
    
    static let triviaAlarmPushOpen = "TriviaAlarmPushOpen_" //u on trivia notification open - append id
    static let articleAlarmPushOpenArticle = "ArticleAlarmPushOpen_Article" //u on article notification open - append id
    static let alarmPushOpenArticle = "Alarm_Push_Open_Article" //u on article notification open without id
    static let alarmPushOpenTrivia = "Alarm_Push_Open_Trivia" //u on trivia notification open without id
    static let alarmPushOpenAM = "Alarm_Push_Open_AM" //u on morning notification open
    
    /* static let sliderHealthcareImpressionHs = "slider_Healthcare_Impression_hs"
     static let sliderBibleMinuteImpressionHs = "slider_BibleMinute_Impression_hs"
     static let sliderAmplyImpressionHs = "slider_Amply_Impression_hs"
     static let sliderBNDevoImpressionHs = "slider_BNDevo_Impression_hs"
     static let sliderArcamaxImpressionHs = "slider_Arcamax_Impression_hs"
     static let sliderHealthcareClickedHs = "slider_Healthcare_clicked_hs"
     static let sliderBibleMinuteClickedHs = "slider_BibleMinute_clicked_hs"
     static let sliderAmplyClickedHs = "slider_Amply_clicked_hs"
     static let sliderBNDevoClickedHs = "slider_BNDevo_clicked_hs"
     static let sliderArcamaxClickedHs = "slider_Arcamax_clicked_hs"
     static let sliderBibleMinuteImpressionDevo = "slider_BibleMinute_Impression_devo"
     static let sliderHealthcareImpressionDevo = "slider_Healthcare_Impression_devo"
     static let sliderAmplyImpressionDevo = "slider_Amply_Impression_devo"
     static let sliderBNDevoImpressionDevo = "slider_BNDevo_Impression_devo"
     static let sliderArcamaxImpressionDevo = "slider_Arcamax_Impression_devo"
     static let sliderBibleMinuteClickedDevo = "slider_BibleMinute_clicked_devo"
     static let sliderHealthcareClickedDevo = "slider_Healthcare_clicked_devo"
     static let sliderAmplyClickedDevo = "slider_Amply_clicked_devo"
     static let sliderBNDevoClickedDevo = "slider_BNDevo_clicked_devo"
     static let sliderArcamaxClickedDevo = "slider_Arcamax_clicked_devo" */
    
    
    
    // Custom String events
    /*static let exitScreen  = "Exit_Screen_Shown"
     static let confirmExit  = "Confirm_exit_yes"
     static let confirmExitScreenNativeAd = "Exit_Screen_Native_Ad_Load"
     static let adBannerExit = "Ad_banner_exit_screen" */
    
    static let intArticleLoaded = "int_article_loaded"//u on article intrrstitial on load --- and on next aticle click interstiatial load
    static let testPanelNativeAdShown2 = "test08292019_panel2_native_ad_shown" //u devo screen bottom native ad
    //    static let testPanelNativeAdShown4 = "test08292019_panel4_native_ad_shown"
    static let testPanelNativeAdShown3 = "062419Test_Panel3_NativeAdLoad" //u Devotion - native ad need to use this
    
    //    static let testPanelDevoScreen1 = "test08292019_panel1_devoscreenload"
    static let testPanelDevoScreen2 = "test08292019_panel2_devoscreenload" //u  use this on controller load
    //    static let testPanelDevoScreen3 = "test08292019_panel3_devoscreenload"
    //    static let testPanelDevoScreen4 = "test08292019_panel4_devoscreenload"
    
    static let testPanelDevoScreenShown3 = "062419Test_Panel3_DevoScreenShown" //use this on controller load
    
    /* static let permissionsPromptScreenLoaded = "Permissions_prompt_screen_loaded"
     static let permissionsPromptScreenNextClicked = "Permissions_prompt_screen_next_clicked" */
    
    static let intStartup = "int_startup" //u app open interstitial on load
    //     on
    static let firstOpenAdEmailCapture = "ad_native_image_350_625_first_open"//"dfp_first_open_ad_350X625"
    static let markAsReadForArticle = "ad_banner_300_250_article_markasread"//"dfp_mark_as_read_300X250_show_from_article"
    static let markAsReadForDevotion = "ad_banner_300_250_devo_markasread"//"dfp_mark_as_read_300X250_show_from_devotion"
    static let articleMarkAsReadClicked = "ad_intl_article_markasread_click"//"int_article_mark_as_read_clicked"
    static let devotionMarkAsReadClicked = "ad_intl_devo_markasread_click"//"int_devotion_mark_as_read_clicked"
    
    
    static let nativeTrivia = "ad_native_trivia"
    static let nativeArticleBottom = "ad_native_article_bottom_page"
    //    static let startUpAd = "ad_native_image_350_625_first_open"
    //    static let devoMarkAsReadBanner = "ad_banner_300_250_devo_markasread"
    static let articleBanner = "ad_banner_320_100_article"
    //    static let interDevoMarkAsRead = "ad_intl_devo_markasread_click"
    //    static let interArticleMarkAsRead = "ad_intl_article_markasread_click"
    
    static let articleFirstPageLoad = "ArticleView"
    static let devoLoad = "DevoLoad"
    
    static let articleMarkAsReadBtnClicked = "article_mark_as_read_clicked"
    static let devoMarkAsReadBtnClicked = "devotion_mark_as_read_clicked"
    
    
    
    static let emailCaptureSubmitClicked = "bibleminute_lca_1stopen_submit_clicked"
    static let emailCaptureViewed = "bibleminute_lca_1stopen_submit_clicked_viewed"
    
    static let bnCloseClicked = "bn_newsletter_3rdsession_closescreen"
    static let bnSubmitClicked = "bn_newsletter_3rdsession_submit"
    static let bnViewed = "bn_newsletter_3rdsession_view"
    static let bnSubmitClicked2 = "bn_submit"
    
    
    //new panel events
    static let panel1 = "pushtest_052020_panel1user"
    static let panel2 = "pushtest_052020_panel2user"
    static let panel3 = "pushtest_052020_panel3user"
    
    
    //new Bible book events - tab - 4
    
    static let bibleNavMenuClicked = "bible_nav_menu_clicked"
    
    static let seeMoreOldTestamentClicked = "bible_main_book_see_more_old_testament_clicked"
    static let seeMoreNewTestamentClicked = "bible_main_book_see_more_new_testament_clicked"
    
    //Prayer points
    static let prayerPointClicked = "prayer_points_explainer_clicked"
    static let bonusContentClicked = "prayer_points_explainer_bonus_content_clicked"
    static let prayerPointsNavClicked = "prayer_points_nav_clicked"
    
    //Bonus content
    static let allContentNavClicked = "bonus_content_all_content_nav_clicked"
    static let unlockedContentNavClicked = "bonus_content_unlocked_content_nav_clicked"
    //    static let incrementFavClicked = "bonus_content_increment_favorites_click"
    
    
    static let incrementVersesFavClicked = "bonus_content_increment_favorites_prayer_click"
    static let incrementPrayerFavClicked = "bonus_content_increment_favorites_verse_click"
    static let incrementInspirationFavClicked = "bonus_content_increment_favorites_dailyinspiration_click"
    static let incrementBibleVersesFavClicked = "bonus_content_increment_favorites_bible_verse_click"
    
//    static let button_rotation_internal_name_new_user = "button_rotation_internal_name_new_user"
//    static let button_rotation_internal_name_backfill = "button_rotation_internal_name_backfill"
//    static let button_rotation_internal_name_campaign = "button_rotation_internal_name_campaign"
//
    
    static func buttonRotationWithInternalNameType(internameName: String, userType: DynamicButtonUserType) -> String {
        return "button_rotation_\(internameName)_\(userType)"
    }
    
    //    static let bonusPrayerFavInc = "bonus_content_increment_favorites_prayer_click"
    //    static let bonusVerseFavInc = "bonus_content_increment_favorites_verse_click"
    //    static let bonusInspirationFavInc = "bonus_content_increment_favorites_dailyinspiration_click"
    
    static let favPrayerFavInc = "favorites_increment_favorites_prayer_click"
    static let favVerseFavInc = "favorites_increment_favorites_verse_click"
    static let favInspirationFavInc = "favorites_increment_favorites_dailyinspiration_click"
    static let favBibleVersFavInc = "favorites_increment_favorites_bible_verse_click"
    
    
    
    // reward prayer point
    static let reward_unlock_ebook_yes_click = "reward_unlock_ebook_yes_click"
    static let reward_unlock_ebook_no_click = "reward_unlock_ebook_no_click"
    static let ad_rewarded_unlock_ebook = "ad_rewarded_unlock_ebook"
    static let reward_unlock_ebook_points_awarded = "reward_unlock_ebook_points_awarded"
    static let reward_unlock_favorites_prayer_yes = "reward_unlock_favorites_prayer_yes"
    static let reward_unlock_favorites_prayer_no = "reward_unlock_favorites_prayer_no"
    static let ad_rewarded_unlock_favorites_prayer = "ad_rewarded_unlock_favorites_prayer"
    static let reward_unlock_favorites_prayer_points_awarded = "reward_unlock_favorites_prayer_points_awarded"
    static let reward_unlock_favorites_verse_yes = "reward_unlock_favorites_verse_yes"
    static let reward_unlock_favorites_verse_no = "reward_unlock_favorites_verse_no"
    static let ad_rewarded_unlock_favorites_verse = "ad_rewarded_unlock_favorites_verse"
    static let reward_unlock_favorites_verse_points_awarded = "reward_unlock_favorites_verse_points_awarded"
    static let reward_unlock_favorites_dailyinspiration_yes = "reward_unlock_favorites_dailyinspiration_yes"
    static let reward_unlock_favorites_dailyinspiration_no = "reward_unlock_favorites_dailyinspiration_no"
    static let ad_rewarded_unlock_favorites_dailyinspiration = "ad_rewarded_unlock_favorites_dailyinspiration"
    static let reward_unlock_favorites_dailyinspiration_points_awarded = "reward_unlock_favorites_dailyinspiration_points_awarded"
    
    static let reward_unlock_favorites_bibleverses_no = "reward_unlock_favorites_bible_verse_no"
    static let reward_unlock_favorites_bibleverses_yes = "reward_unlock_favorites_bible_verse_yes"
    static let reward_unlock_favorites_bibleverses_points_awarded = "reward_unlock_favorites_bible_verse_points_awarded"
    static let ad_rewarded_unlock_favorites_bibleverses = "ad_rewarded_unlock_favorites_bible_verse"
    static let reward_video_watched = "reward_video_watched"
    static let bible_book_chapter_verse_loaded = "bible_book_chapter_verse_loaded"
    
    //    bible_book_favorites_bible_verse_added_clicked_[x]_ch_[y]_ve_[z]    verse added to favorites    x = book name, y = chapter number, z = verse number
    //    bible_book_favorites_bible_verse_removed_clicked_[x]_ch_[y]_ve_[z]    verse removed from favorites    x = book name, y = chapter number, z = verse number
    //    favorites_increment_favorites_bible_verse_click    *see row 24 for pattern*
    //    reward_unlock_favorites_bible_verse_yes    *see pattern from row 30 to 45*
    //    reward_unlock_favorites_bible_verse_no
    //    ad_rewarded_unlock_favorites_bible_verse
    //    reward_unlock_favorites_bible_verse_points_awarded
    
    
    //MARK:- Quick Tour Tutorial
    static let quick_tour_homescreen_clicked = "quick_tour_homescreen_clicked"
    static let quick_tour_slider_menu_clicked = "quick_tour_slider_menu_clicked"
    static let quick_tour_homescreen_clicked_no_tutorial = "quick_tour_homescreen_clicked_no_tutorial"
    static let quick_tour_homescreen_clicked_single_page_tutorial = "quick_tour_homescreen_clicked_single_page_tutorial"
    static let quick_tour_homescreen_clicked_multi_page_tutorial = "quick_tour_homescreen_clicked_multi_page_tutorial"
    static let quick_tour_slider_menu_clicked_no_tutorial = "quick_tour_slider_menu_clicked_no_tutorial"
    static let quick_tour_slider_menu_clicked_single_page_tutoial = "quick_tour_slider_menu_clicked_single_page_tutoial"
    static let quick_tour_slider_menu_clicked_multi_page_tutorial = "quick_tour_slider_menu_clicked_multi_page_tutorial"
    static let quick_tour_no_tutorial_loaded = "quick_tour_no_tutorial_loaded"
    static let quick_tour_single_page_tutorial_loaded = "quick_tour_single_page_tutorial_loaded"
    static let quick_tour_multipage_tutorial_loaded = "quick_tour_multipage_tutorial_loaded"
    
    
    // MARK:- In app purchase - Subscription
    
    static let homescreen_free_trial_clicked = "homescreen_free_trial_clicked"
    static let offers_explainer_page_proceed_free_trial_clicked = "offers_explainer_page_proceed_free_trial_clicked"
    static let offerpage_75_prayer_points_offer_clicked = "offerpage_75_prayer_points_offer_clicked"
    static let offerpage_subscription_offer_clicked = "offerpage_subscription_offer_clicked"
    static let devotion_bottom_free_trial_clicked = "devotion_bottom_free_trial_clicked"
    static let settings_free_trial_clickeed = "settings_free_trial_clickeed"
    static let homescreen_devotion_button_clicked_freetrial_loaded = "homescreen_devotion_button_clicked_freetrial_loaded"
    static let homescreen_devotion_button_clicked_freetrial_clicked = "homescreen_devotion_button_clicked_freetrial_clicked"
    static let bonus_content_book_rebuttal_free_trial_clicked = "bonus_content_book_rebuttal_free_trial_clicked"
    static let bonus_content_top_free_trial_clicked = "bonus_content_top_free_trial_clicked"
    
    // MARK: - Bonus content
    static let homescreen_bonus_button_clicked = "homescreen_bonus_button_clicked"
    static let homescreen_bonus_clicked = "homescreen_bonus_clicked"
    static let bonus_content_ebook_preview_clicked = "bonus_content_ebook_preview_clicked"
    static let bible_notes_increment_note_click = "bible_notes_increment_note_click"
    static let bible_notes_delete_note_click = "bible_notes_delete_note_click"

    // MARK: - Play Trivia
    static let trivia_option1_mark_complete_get_10_prayer_points_clicked = "trivia_option1_mark_complete_get_10_prayer_points_clicked"
    static let trivia_option2_unlock_all_rounds_with_a_free_trial_clicked = "trivia_option2_unlock_all_rounds_with_a_free_trial_clicked"
    static let devotion_section1_click_here_clicked = "devotion_section1_click_here_clicked"
    static let devotion_section2_play_bible_trivia_clicked = "devotion_section2_play_bible_trivia_clicked"
    static let devotion_section3_unlock_content_clicked = "devotion_section3_unlock_content_clicked"
    
    
    //MARK:- Bible Notes
    static let bible_book_notes_verse_saved = "bible_book_notes_verse_saved"
    static func bibleBookNotesVerseSaved(bookName: String, chapterNumber: String, verseNumber:String) -> String {
        return "bible_book_notes_verse_saved_"+"\(bookName)"+"_ch_"+"\(chapterNumber)"+"_ve_" + "\(verseNumber)"
    }
    
    //MARK:- Bible Bookmarks
    static let bible_book_bookmarked_verse = "bible_book_bookmarked_verse"
    static func bibleBookBookmarkedVerse(bookName: String, chapterNumber: String, verseNumber:String) -> String {
        return "bible_book_bookmarked_verse_"+"\(bookName)"+"_ch_"+"\(chapterNumber)"+"_ve_" + "\(verseNumber)"
    }
    
    //MARK:- Bible Favorites
    static func addToFavBibleVerse(bookName : String, chapter:String, verseNumber:String) -> String{
        return  "bible_book_favorites_bible_verse_added_clicked_"+"\(bookName)"+"_ch_"+"\(chapter)"+"_ve_" + "\(verseNumber)"
    }
    
    static func removeFromFavBibleVerse(bookName : String, chapter:String, verseNumber:String) -> String{ //u  2 banner ads use position starts from 1
        return  "bible_book_favorites_bible_verse_removed_clicked_"+"\(bookName)"+"_ch_"+"\(chapter)"+"_ve_" + "\(verseNumber)"
    }
    
    
    static func promoCodeRedeem(promoCode : String) -> String{ //u  2 banner ads use position starts from 1
        return "promo_codes_redeem_" + "\(promoCode)"
    }
    
    static func bookUnlockedClicked(bookId : Int) -> String{ //u  2 banner ads use position starts from 1
        return "bonus_content_book_unlocked_clicked_" + "\(bookId)"
    }
    
    static func bookReadClicked(bookId : Int) -> String{ //u  2 banner ads use position starts from 1
        return "bonus_content_book_read_clicked_" + "\(bookId)"
    }
    
    static func bibleMainBookClicked(bookName : String) -> String{ //u  2 banner ads use position starts from 1
        return "bible_main_book_clicked_" + "\(bookName)"
    }
    
    static func bibleBookChapterClicked(bookName : String, chapterNumber : Int) -> String{ //u  2 banner ads use position starts from 1
        return "bible_book_chapter_clicked_" + "\(bookName)" + "_ch_" + "\(chapterNumber)"
    }
    
    static func bibleBookSeeMoreClicked(bookName : String, chapterNumber : Int) -> String{ //u  2 banner ads use position starts from 1
        return "bible_book_see_more_clicked_" + "\(bookName)" + "_ch_" + "\(chapterNumber)"
    }
    
    static func bibleBookPreviousChapterClicked(bookName : String, chapterNumber : Int) -> String{ //u  2 banner ads use position starts from 1
        return "bible_book_previous_chapter_clicked_" + "\(bookName)" + "_ch_" + "\(chapterNumber)"
    }
    
    static func bibleBookNextChapterClicked(bookName : String, chapterNumber : Int) -> String{ //u  2 banner ads use position starts from 1
        return "bible_book_next_chapter_clicked_" + "\(bookName)" + "_ch_" + "\(chapterNumber)"
    }
    
    
    
    
    // on article vc for each page load
    static func articleScreenLoaded(counter:Int, position : Int) -> String{ //u counter - article number, position - page number
        return "article_" + "\(counter)" + "_screen_" + "\(position)" + "_loaded"
    }
    
    static func bannerArticle1(position : Int) -> String{ //u  2 banner ads use position starts from 1
        return "banner_300x250_article_" + "\(position)"
    }
    
    static func articleScreenPage(counter:Int, page : Int) -> String{ //u on next buttone click
        return "article_" + "\(counter)" + "_screen_" + "\(page)" + "next"
    }
    
    /*  static func articleTestPanel1(position : Int) -> String {
     return "test08292019_panel1_article" + "\(position)" + "_shown"
     } */
    
    static func articleTestPanel2(position : Int) -> String { //u use only this - on devotion screen for loaded articles // need to cross check with sandeep - need to change
        return "test08292019_panel2_article" + "\(position)" + "_shown"
    }
    
    //    static func articleTestPanel3(position : Int) -> String{
    //        return "test08292019_panel3_article" + "\(position)" + "_shown"
    //    }
    
    //    static func articleTestPanel4(position : Int) -> String{
    //        return "test08292019_panel4_article" + "\(position)" + "_shown"
    //    }
    //need to check with sandeep
    static func articleRowShown(row : Int) -> String{ //u on click of article button - on interstitial ad shown with article id
        return  "hs_article_" + "\(row)" + "_shown"
    }
    
    //    static func devoClickedPanel1(row : Int) -> String{
    //        return  "test08292019_panel1_article" + "\(row)" + "_clicked"
    //    }
    
    static func devoRowClickedPanel2(row : Int) -> String{ //u article id devo screen article click
        return  "test08292019_panel2_article" + "\(row)" + "_clicked"
    }
    
    //    static func devoRowClickedPanel3(row : Int) -> String{
    //        return  "test08292019_panel3_article" + "\(row)" + "_clicked"
    //    }
    //
    //    static func devoRowClickedPanel4(row : Int) -> String{
    //        return  "test08292019_panel4_article" + "\(row)" + "_clicked"
    //    }
    
    static func articleCounterShown(counter : Int) -> String{ //u article inter ad open  - counter - article number
        return  "hs_article_" + "\(counter)" + "_shown"
    }
    static func articleCounterClicked(counter : Int) -> String{ //u on article button click with article number
        return  "hs_article_" + "\(counter)" + "_clicked"
    }
    
    static func triviaAnsSelection(questionId : String, selectedAns : Int, isCorrect : Bool) -> String { //u on answer selection
        if let queId = Int(questionId) {
            return  "trivia_q" + "\(queId)" + "_\(selectedAns)_" + (isCorrect ? "correct" : "incorrect")
        } else {
            return  "trivia_q" + "\(questionId)" + "_\(selectedAns)_" + (isCorrect ? "correct" : "incorrect")
        }
    }
    
    static func triviaLevelComplete(levelId : Int) -> String { //u on answer selection
        return  "trivia_level_" + "\(levelId)" + "_complete"
    }
    
    static func triviaLevelOfferShown(levelId : Int) -> String { //u on answer selection
        return  "trivia_level_" + "\(levelId)" + "_offer_shown"
    }
    
    
    
    
    //    DFP first open - dfp_first_open_ad_350x625
    //    300x250 On Read Screen for Article -  dfp_mark_as_read_300X250_shown_from_article
    //    300x250 On Read Screen for Devotion - dfp_mark_as_read_300X250_shown_from_devotion
    //    Interstitial To Show After A User Clicks “Mark As Read” button for Article - int_article_mark_as_read_clicked
    //    Interstitial To Show After A User Clicks “
    
    
    
    
    //    trivia,trivia_level_x_offer_shown
    //    trivia,trivia_qx_x_incorrect,,missing event,
    //    trivia,trivia_qx_x_correct,,missing event,
}

struct FirebaseEventConstant {
    static let homescreenDay4 = "Homescreen_4th_Day" //    Homescreen_4th_Day - hourDifference(from install time) >= 96
    static let hsDevotionClicked = "hs_devotion_clicked" //hs_devotion_clicked - on click of devotion button
    static let hsSponsorClicked = "hs_sponsor_clicked" //hs_sponsor_clicked - on click of sponsor button
    static let hsTriviaClicked = "hs_trivia_clicked" //hs_trivia_clicked - on click of trivia button
    static let hsTriviaLevel1Complete = "trivia_level_1_complete" //hs_trivia_clicked - on click of trivia button
}

class TenjinAnalyticsHelper {
    class func logEvent(name: String) {
        DispatchQueue.global(qos: .utility).async {
            //TODO: uncomment below line while uploading to app store appstore
            //TODO:  APPSTORE 
            //            #if !DEBUG
      // TenjinSDK.sendEvent(withName: name)
            //            #endif
        }
    }
}

class FirebaseAnalyticsHelper {
    class func logEvent(name: String) {
        DispatchQueue.global(qos: .background).async {
            Analytics.logEvent(name, parameters: ["Name" : name])
        }
    }
}

struct TenjinValues {
    static let sourceCampaignId1 = "fb9RWn2ktX3KBCVLd27cVA"
    static let sourceCampaignId2 = "a5577755-64f9-412c-9605-5c86970f876c"
    
    static func isCampaignUser() -> Bool {
        let campId = DataManager.shared.getStringValueForKey(key: AppStatusConst.campaignId)
        if campId == TenjinValues.sourceCampaignId1 || campId == TenjinValues.sourceCampaignId2 {
            return true
        }
        return false
    }
}
