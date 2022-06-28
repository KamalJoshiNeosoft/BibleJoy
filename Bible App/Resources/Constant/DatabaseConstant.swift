//
//  DatabaseConstant.swift
//  Bible App
//
//  Created by webwerks on 20/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

struct DatabaseConstant {
   
    //Prayer
    static let prayerId = "PrayerId"
    static let topic = "Topic"
    static let prayer = "Prayer"
    static let favorite = "Favorite"
    static let prayreadStatus = "ReadStatus"
    
    // Inspiration
    static let inspirationId = "InspirationId"
    static let inspiration = "Inspiration"
    static let inspirationFavorite = "Favorite"
    
    //Verses
    static let verseId = "VerseId"
    static let verse = "Verse"
    static let passage = "Passage"
    static let commentary = "Commentary"
    
    //Article
    static let articleNumber = "ArticlesNumber"
    static let button = "Button"
    static let title = "Title"
    static let titleDescription = "Title Description"
    static let itemOne = "Item 1"
    static let itemDescriptionOne = "Item 1 Description"
    static let itemTwo = "Item 2"
    static let itemDescriptionTwo = "Item 2 Description"
    static let itemThree = "Item 3"
    static let itemDescriptionThree = "Item 3 Description"
    static let itemFour = "Item 4"
    static let itemDescriptionFour = "Item 4 Description"
    static let itemFive = "Item 5"
    static let itemDescriptionFive = "Item 5 Description"
    static let itemSix = "Item 6"
    static let itemDescriptionSix = "Item 6 Description"
    static let itemSeven = "Item 7"
    static let itemDescriptionSeven = "Item 7 Description"
    static let itemEight = "Item 8"
    static let itemDescriptionEight = "Item 8 Description"
    static let itemNine = "Item 9"
    static let itemDescriptionNine = "Item 9 Description"
    static let itemTen = "Item 10"
    static let itemDescriptionTen = "Item 10 Description"
    static let itemEleven = "Item 11"
    static let itemDescriptionEleven = "Item 11 Description"
    
    static let item = "Item"
    static let itemDescription = "Item Description"
    static let readStatus = "ReadStatus"
     static let markAsReadStatus = "MarkAsReadStatus"
    //Trivia
    static let triviaId = "TriviaId"
    static let question = "Question"
    static let optionA = "Option_a"
    static let optionB = "Option_b"
    static let optionC = "Option_c"
    static let optionD = "Option_d"
    static let answer = "Answer"
    static let explanation = "Explanation"
    
    //MorningNotifications
    static let morningNotificationsId = "Id"
    static let morningNotificationsDate = "NotificationDate"
    static let morningNotificationsTime = "Time"
    static let morningNotificationsMessage = "Message"
    
    //TriviaNotifications
    static let triviaNotificationsId = "Id"
    static let triviaNotificationsHeadline = "Headline"
    static let triviaNotificationsDescription = "Description"
    static let triviaNotificationsButton = "Button"
    static let triviaNotificationsTenjinEventOnOpen = "TenjinEventOnOpen"
    
    //ArticleNotifications
    static let articleNotificationsNumber = "ArticlesNumber"
    static let articleNotificationsName = "ArticleName"
    static let articleNotificationsPushTitle = "PushTitle"
    static let articleNotificationsPushMessage = "PushMessage"
    static let articleNotificationsPushButton = "PushButton"
    static let articleNotificationsTenjinEventOnOpen = "TenjinEventOnOpen"
    
    //BookList
    static let bookId = "BookId"
    static let bookName = "BookName"
    static let oldNew = "OldNew"
    static let chapterCount = "ChapterCount"
    static let currentReadStatus = "ReadStatus"

    
    //ChapterList
    static var verseNumber = "VerseNumber"
    static let chapterNumber = "ChapterNumber"
    
    //LockedBookList
    static let lockBookId = "id"
    static let lockBookIdentifier = "eBookIdentifier"
    static let lockUnlockStatus = "lockUnlockStatus"
    static let lockBookName = "eBookName"
    static let lockBookimageName = "imageName"
    
    //AddNotes
    static let notes = "Notes"
    static let notesId = "id"
    static let notesText = "NotesText"
    static let verseName = "VerseName"
    static let verseText = "VerseText"
    static let notesAdded = "NotesAdded"
    
    //Bookmark
    static let bookmark = "Bookmarks"

}

struct IndexConstant {
    
    static let prayersIndex = "PrayersIndex"
    static let inspirationIndex = "inspirationIndex"
    static let versesIndex = "VersesIndex"
    static let triviaIndex = "TriviaIndex"
    static let triviaNotificationIndex = "TriviaNotificationIndex"
    static let triviaSubIndex = "TriviaSubIndex"
    static let articleIndex = "ArticleIndex"
    static let articleNotificationIndex = "ArticleNotificationIndex"
    static let devotionArticleIndex = "DevotionArticleIndex"
    static let favVerseIndex = "FavVerseIndex"
    static let favPrayerIndex = "FavPrayerIndex"
    static let welcomeIndex = "WelcomeIndex"
    static let markAsReadCountInDevotion = "markAsReadCountInDevotion"
    static let markAsReadCountInArticle = "markAsReadCountInArticle"
    static let banerImageIndex = "banerImageIndex"

}

struct TableName {
    static let prayer = "Prayer"
    static let inspiration = "Inspirations"
    static let verse = "Verses"
    static let trivia = "Trivia"
    static let article = "Article"
//    static let articleNotification = "ArticleNotification"
    static let favVerseList = "FavVerseList"
    static let favPrayerList = "FavPrayerList"
    static let articleDesc = "ArticleDesc"
    static let bookList = "BookList"
    static let oldTestamentBookChapter = "OldTestament"
    static let newTestamentBookChapter = "NewTestament"
}

struct AppStatusConst {
    
    static let isFirstAppLaunched = "IsFirstAppLaunched"
    static let devotionScreenFloatingViewTap = "devotionScreenFloatingViewTap"
    static let bNMediaAdsCrossButtonTap = "bNMediaAdsCrossButtonTap"
    static let appVersion = "appVersion"
    static let needMigration = "needMigration"
    static let isTimeSlotChange = "IsTimeSlotChange"
    static let isNewArticle = "IsNewArticle"
    static let isNewTrivia = "IsNewTrivia"
    static let isNewDevotion = "IsNewDevotion"
    static let appLastOpenDate = "AppLastOpenDate"
    static let markAsReadClickedDate = "markAsReadClickedDate"
    static let appLastCloseDate = "AppLastClosenDate"
    static let previousTimeSlot = "PreviousTimeSlot"
    static let levelOpenDate = "LevelOpenDate"
    static let appCloseCount = "AppCloseCount"
    static let appOpenCount = "AppOpenCount"
    static let appInstallDate = "AppInstallDate"
    static let homeScreenButtonCount = "HomeScreenButtonCount"
    static let homeScreenInterAdLoadCount = "HomeScreenInterAdLoadCount"
    static let homeScreenDayFourLogged = "HomeScreenDayFourLogged"
    static let campaignId = "CampaignId"
    static let prayerMaxFavLimit = "PrayerMaxFavLimit"
    static let inspirationMaxFavLimit = "InspirationMaxFavLimit"
    static let versesMaxFavLimit = "VersesMaxFavLimit"
    static let bibleVersesMaxFavLimit = "BibleVersesMaxFavLimit"

    static let unlockUrlIndex = "UnlockUrlIndex"
    static let appInstallDaysCount = 2
    static let articleNotificationsAppCloseCount = 2
    static let lastMarkAsReadPrayer = "LastMarkAsReadPrayer"
    static let appName = "Bible Joy"
    static let showSeeMoreVerses = "ShowSeeMoreVerses"
    static let prayerPoints = "PrayerPoints"
    static let usedPromoCodes = "usedPromoCodes"
    static let loadPrayerPointInfo = "loadPrayerPointInfo"
    static let lastOpenedBook = "lastOpenedBook"
    static let lastOpenedBookStatus = "lastOpenedBookStatus"
    static let unlimitedSubscriptionPurchased = "unlimitedSubscriptionPurchased"
    static let markAsCompleteClickedDate = "markAsCompleteClickedDate"
    static let viewRotateCount = "viewRotateCount"
    static let bibleVersesMaxNotesLimit = "bibleVersesMaxNotesLimit"
    static let isCrossMaxLimit = "isCrossMaxLimit"
    static let storeDate = "storeDate"
    static let rotationDay = "rotationDay"
    static let oneTimePassword = "oneTimePassword"
    static let oneTimeBonusCount = "oneTimeBonusCount"
    static let markAsReadTip = "markAsReadTip"
    static let lastTipReadDate = "lastTipReadDate"
    static let buttonType = "buttonType"
    static let buttonClickNumber = "buttonClickNumber"
    static let dynamicTextOpenCount = "dynamicTextOpenCount"
    static let readAllTips = "readAllTips"
    static let tipsReadCount = "tipsReadCount"
    static let isShowDevotionTips = "isShowDevotionTips"
    static let userISFromControlTutorial = "UserISFromControlTutorial"
    static let userISFromAllPageTutorial = "UserISFromAllPageTutorial"
}
 
struct TriviaStateConst {
    
    static let isAnswerView = "IsAnswerView"
    static let answerTag = "AnswerTag"
    static let numberOfCorrectAnswer = "NumberOfCorrectAnswer"
    static let numberOfLevel = "NumberOfLevel"
    static let completeTodaysLevels = "completeTodaysLevels"
}

enum SelectedButton {
    case devotion
    case trivia
    case noSelection
}

enum TutorialType: String {
    case single_page
    case multi_page
    case all_page_tutorial
    case user_page_control_tutorial
    case no_tutorial
}

enum DynamicButtonBadge: String {
    case New
    case Free
    case None
}

enum DynamicButtonType: String {
    case NU
    case BF
    case CMP
}

enum DynamicButtonUserType: String {
    case new_user
    case backfill
    case campaign
}
