import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'onlineImageFetchForBackground/onlineImageFetchForBackground.dart';

class constant{

  static const List<String> Fonts = [
    "Roboto",
    "GreatVibes",
    "Baskerville",
    "GoodDog",
    "Quicksand",
    "Bodoni",
    "Didot",
    "Pacifico",
    "Frutiger",
    "Garamond",
    "Georgia",
    "Montserrat",
    "Avenir",
    "NewYorkTimes",
    "TimesNewRoman"
  ];

  static const List<String> bulletListImage = [
    "assets/bulletList/List-01.png",
    "assets/bulletList/List-02.png",
    "assets/bulletList/List-03.png",
    "assets/bulletList/List-04.png",
    "assets/bulletList/List-05.png",
    "assets/bulletList/List-06.png",
    "assets/bulletList/List-07.png",
    "assets/bulletList/List-08.png",
    "assets/bulletList/List-09.png",
  ];

  static const List<String> bulletListIcon = [
    "assets/bulletList/sun (1).png",
    "assets/bulletList/flower.png",
    "assets/bulletList/rainbow.png",
    "assets/bulletList/orange.png",
    "assets/bulletList/basketball-ball.png",
    "assets/bulletList/light-bulb.png",
    "assets/bulletList/plant.png",
    "assets/bulletList/heart.png",
    "assets/bulletList/round.png",
  ];

  static const List<String> Fontfomily = [
    "Roboto",
    "GreatVibes",
    "Baskerville",
    "GoodDog",
    "Quicksand",
    "Bodoni",
    "Didot",
    "Pacifico",
    "Frutiger",
    "Garamond",
    "Georgia",
    "Montserrat",
    "Avenir",
    "Thenewyorktimes",
    "Timesnewroman"
  ];

  static const List<String> QuestionAndAnswertitleText = [
    "How do I start my own diary if I don't know what to write about?",
    "How to create tags and search tags?",
    "How to set diary lock to protect my secret?",
    "I changed to a new phone or I deleted the app once, how do I get my data back?",
    "I can't backup my data successfully, any idea what happened?",
    "I have backed up successfully, how can I find my entries in Google Drive?",
  ];

  static const List<String> QuestionAndAnswerInfoFirst = [
    "Diary can help you to record your unique experiences and stories, you can write about your plans, places you want to go, movies you have seen or express secret feelings. yours.",
    "Besides words, you can attach photos and recordings, decorate with stickers and emojis, change the color and font of words, and change the theme to make your diary more beautiful.",
    "If you still have no idea, touch the user icon on the home screen, you will see the message \"don't know what to write press start and choose a template to record your day.",
  ];

  static const List<String> QuestionAndAnswerInfoSecond = [
    "To create a tag. please check the toolbar at the edit page and create the tag you want",
    "To search for tags, please go to Menu → Tag Management and see all the tags you have created.",
  ];

  static const List<String> QuestionAndAnswerInfoThird = [
    "You can make sure that other people won't see your entries without your permission.",
    "To set the lock, please go to Menu → Log Lock,then enable password unlock or fingerprint lock (only if your phone has a fingerprint scanner).",
    "To change the key formats, please go to the password setting at the bottom of the page.",
    "Go to the forgot password section in the unlock section to change the password.",
  ];

  static const List<String> QuestionAndAnswerInfoFourth = [
    "Only if you have backed up your data before, the data will be saved in your drive and can be retrieved, please login your account again in Menu → Backup",
  ];

  static const List<String> QuestionAndAnswerInfoFifth = [
    "Check internet connection, as logs can have large files including photos and audio recordings, logs will need high quality network to upload to Google Drive.",
    "Check if your Google Drive is signed in with the correct account.",
    "Check that you have granted Google Drive access to this application.",
    "Check if there is enough space in Drive and in your phone.",
    "If that still doesn't work, please use the report on the Backup - Failure page to send us detailed error reports, which we will resolve as soon as possible.",
  ];

  static const List<String> QuestionAndAnswerInfosix = [
    "To protect your privacy, entries are not saved as actual documents. Instead, they are saved as application data and can only be accessed by your application, so you won't see them in your folders.",
    "The data goes with your Google Drive account, you can log into this app on any other device and get your data back, so take care of your account information seriously.",
    "If you want documents, please export them to pdf format and save them to your device.",
  ];

  static const List<String> tiktokemoji = [
    "assets/emojis/tiktokemoji/tiktoksmile.png",
    "assets/emojis/tiktokemoji/tiktokshy.png",
    "assets/emojis/tiktokemoji/tiktokcool.png",
    "assets/emojis/tiktokemoji/tiktokmoody.png",
    "assets/emojis/tiktokemoji/tiktokangry.png",
    "assets/emojis/tiktokemoji/tiktoksad.png",
    "assets/emojis/tiktokemoji/tiktokcry.png",
    "assets/emojis/tiktokemoji/tiktokshock.png",
  ];

  static const List<String> emojiTextWhichSelected = [
    "Default Emoji",
    "Sticker Emoji",
    "Unicorn Emoji",
    "Pikachu Emoji",
    "Cat Emoji"
  ];

  static const  List<String> editorIcons = [
    "assets/images/BackgroundIcon.png",
    "assets/images/GalleryIcon.png",
    "assets/images/TextIcon.png",
    "assets/images/ListIcon.png",
    "assets/images/TagIcon.png",
   "assets/images/MicIcon.png",
    "assets/images/paintBrushIcon.png"
  ];

  static const List<String> loosetiktokemoji = [
    "assets/emojis/loosetittokemoji/good.png",
    "assets/emojis/loosetittokemoji/happy.png",
    "assets/emojis/loosetittokemoji/cool.png",
    "assets/emojis/loosetittokemoji/love.png",
    "assets/emojis/loosetittokemoji/angry.png",
    "assets/emojis/loosetittokemoji/sad.png",
    "assets/emojis/loosetittokemoji/cry.png",
    "assets/emojis/loosetittokemoji/surprised.png",
  ];

  static const List<String> CatEmoji = [
    "assets/emojis/CatEmoji/Good.png",
    "assets/emojis/CatEmoji/Smile.png",
    "assets/emojis/CatEmoji/Cool.png",
    "assets/emojis/CatEmoji/Love.png",
    "assets/emojis/CatEmoji/Angry.png",
    "assets/emojis/CatEmoji/Sad.png",
    "assets/emojis/CatEmoji/Cry.png",
    "assets/emojis/CatEmoji/Surprised.png",
  ];

  static const List<String> UnicornEmoji = [
    "assets/emojis/UnicornEmoji/Angry.png",
    "assets/emojis/UnicornEmoji/Smile.png",
    "assets/emojis/UnicornEmoji/Cool.png",
    "assets/emojis/UnicornEmoji/Love.png",
    "assets/emojis/UnicornEmoji/Angry.png",
    "assets/emojis/UnicornEmoji/Sad.png",
    "assets/emojis/UnicornEmoji/Cry.png",
    "assets/emojis/UnicornEmoji/Surprised.png",
  ];

  static const List<String> PikachuEmoji = [
    "assets/emojis/pikachuemoji/Good.png",
    "assets/emojis/pikachuemoji/Smile.png",
    "assets/emojis/pikachuemoji/Cool.png",
    "assets/emojis/pikachuemoji/Love.png",
    "assets/emojis/pikachuemoji/Angry.png",
    "assets/emojis/pikachuemoji/Sad.png",
    "assets/emojis/pikachuemoji/Cry.png",
    "assets/emojis/pikachuemoji/Surpirsed.png",
  ];

  static const List<String> StickerEmoji = [
    "assets/emojis/StickerEmoji/Good.png",
    "assets/emojis/StickerEmoji/Smile.png",
    "assets/emojis/StickerEmoji/Cool.png",
    "assets/emojis/StickerEmoji/Love.png",
    "assets/emojis/StickerEmoji/Angry.png",
    "assets/emojis/StickerEmoji/Sad.png",
    "assets/emojis/StickerEmoji/Irritate.png",
    "assets/emojis/StickerEmoji/Surprised.png",
  ];

  static const List<String> themeImages = [
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-01.jpg",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-02.jpg",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-03.jpg",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-04.jpg",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-05.jpg",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-06.jpg",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-07.jpg",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-08.png",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-09.png",
    "assets/ThemeImage/ThemeBackgroundDemo/Daily diary Theme-10.png",
  ];

  static const List<String> mainScreenThemeImages = [
    "assets/ThemeImage/Daily diary Theme-01.jpg",
    "assets/ThemeImage/Daily diary Theme-02.jpg",
    "assets/ThemeImage/Daily diary Theme-03.jpg",
    "assets/ThemeImage/Daily diary Theme-04.jpg",
    "assets/ThemeImage/Daily diary Theme-05.jpg",
    "assets/ThemeImage/Daily diary Theme-06.jpg",
    "assets/ThemeImage/Daily diary Theme-07.jpg",
    "assets/ThemeImage/Daily diary Theme-08.jpg",
    "assets/ThemeImage/Daily diary Theme-09.jpg",
    "assets/ThemeImage/Daily diary Theme-10.jpg",
  ];

  static const List<String> templateImage = [
    "assets/images/TemplateImages/Quick Guide.png",
    "assets/images/TemplateImages/Gratitude Diary.png",
    "assets/images/TemplateImages/Self_love.png",
    "assets/images/TemplateImages/Learning diary.png",
    "assets/images/TemplateImages/Travaling Diary.png",
    "assets/images/TemplateImages/Food diary.png",
  ];

  static const List<String> achievementImage = [
    "assets/images/AchievementImages/apprentice.png",
    "assets/images/AchievementImages/asethetic.png",
    "assets/images/AchievementImages/decrate.png",
    "assets/images/AchievementImages/growing.png",
    "assets/images/AchievementImages/guardian.png",
    "assets/images/AchievementImages/hero.png",
    "assets/images/AchievementImages/telent.png",
    "assets/images/AchievementImages/will.png",
  ];

  static const List<String> settingCustomTitle = [
    "Mood Style",
    "Tags",
    "Notify",
    "Diary Lock",
    "First day of week",
    "Date format log",
    "Time format",
  ];

  static const List<String> settingIntroduceTitle = [
    "Feedback",
    "Privacy Policy",
    "Language",
  ];

  static const List<Icon> settingCustomIcon = [
    Icon(Icons.insert_emoticon_outlined),
    Icon(Icons.sell_outlined),
    Icon(Icons.notifications_rounded),
    Icon(Icons.key),
    Icon(Icons.calendar_today_outlined),
    Icon(Icons.calendar_month),
    Icon(Icons.watch_later_outlined),
  ];

  static const List<Icon> settingIntroduceIcon = [
    Icon(Icons.feedback),
    Icon(Icons.local_police_rounded),
    Icon(Icons.language),
  ];

  static const List<String> rateText = [
    "Oh,no!",
    "Oh,no!",
    "Oh,no!",
    "So Amazing!",
    "We like you too",
  ];

  List<List<String>> tabViewImagesString = [
    onlineImageFetchForBackground().ColorsImage,
    onlineImageFetchForBackground().PopularImages,
    onlineImageFetchForBackground().ArtsyImage,
    onlineImageFetchForBackground().CuteImage,
    onlineImageFetchForBackground().LifestyleImage,
  ];

  static const List<String> reviewText = [
    "We're sorry you had a bad experience.Please leave us some feedback.",
    "We understand you are not happy with the service you received.Please leave us some feedback.",
    "We would lick the opportunity to investigate your feedback further.",
    "Thank you so much for the wonderful review.",
    "Thank you so much for taking the time to leave us your review."
  ];

  static List<Color> emojiMoodColors = [
    Colors.pinkAccent.shade200,
    Colors.yellowAccent.shade200,
    Colors.greenAccent.shade200,
    Colors.blueAccent.shade200,
    Colors.deepPurpleAccent.shade200,
    Colors.redAccent.shade200,
    Colors.orangeAccent.shade200,
    Colors.brown.shade200,
  ];

  static const List<String> weekDayName = [
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT",
    "SUN"
  ];

  static List listOfFileCount = [
    0,
    1,
    2,
    3,
    4,
    0,
    0,
  ];

  static const List<String> emojiMoodTexts = [
    "Happy",
    "Shy",
    "Very Happy",
    "Clam",
    "Angry",
    "Unhappy",
    "Sad",
    "Shocked",
  ];

  static const String questionMark = "assets/images/circle.png";

  static int year = DateTime.now().year;
  static DateTime now = DateTime.now();
  static int hour = DateTime.now().hour;
  static final minute = DateFormat('m', 'en_US').format(now);
  static String day = DateFormat.E('en_US').format(now);


  static const String angry = "assets/tiktokemoji/tiktokangry.png";
  static const String cool = "assets/tiktokemoji/tiktokcool.png";
  static const String cry = "assets/tiktokemoji/tiktokcry.png";
  static const String moody = "assets/tiktokemoji/tiktokmoody.png";
  static const String sad = "assets/tiktokemoji/tiktoksad.png";
  static const String shock = "assets/tiktokemoji/tiktokshock.png";
  static const String shy = "assets/tiktokemoji/tiktokshy.png";
  static const String smile = "assets/tiktokemoji/tiktoksmile.png";

}