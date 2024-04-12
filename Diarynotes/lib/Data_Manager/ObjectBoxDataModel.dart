import 'dart:typed_data';
import 'package:objectbox/objectbox.dart';

@Entity()
class fileCreate {

  @Id(assignable: true)
  int id = 0;

  String dateTime;
  int emoji;
  String title;
  bool isSaveWithDraft;
  String backgroundImage;
  String fontFamily;
  String bulletListImages;
  ToMany<ImagePathString> imagePath = ToMany<ImagePathString>();
  ToMany<AudioPathString> audioPath = ToMany<AudioPathString>();
  ToMany<DrawImagesString> drawImages = ToMany<DrawImagesString>();
  ToMany<DetailsControllerText> detailsController = ToMany<DetailsControllerText>();
  ToMany<TagStringItem> tags = ToMany<TagStringItem>();
  bool isPinned;
  int sortData;

  fileCreate(this.dateTime,this.isPinned,this.sortData, this.emoji, this.title, this.isSaveWithDraft, this.imagePath, this.audioPath, this.tags, this.drawImages, this.detailsController, this.backgroundImage, this.bulletListImages, this.fontFamily,);

  // fileCreate.withId(this.id, this.dateTime,this.isPinned, this.sortData,this.emoji, this.title,
  //     this.audioPath, this.detailsController, this.drawImages, this.imagePath,
  //     this.tags, this.isSaveWithDraft, this.backgroundImage,
  //     this.bulletListImages, this.fontFamily);

}

@Entity()
class FormatOfDate {
  @Id()
  int id = 0;
  String? dateFormat;

  FormatOfDate(this.dateFormat);

  FormatOfDate.withId(this.id, this.dateFormat);
}

@Entity()
class ImageDrawData {
  @Id()
  int id = 0;
  Uint8List Image;

  ImageDrawData(this.Image);

  ImageDrawData.withId(this.id, this.Image);
}

@Entity()
class WriteDiaryDetailsSaveTemporary {
  @Id(assignable: true)
  int id = 0;
  String BackgroundImage;
  String Title;

  WriteDiaryDetailsSaveTemporary(this.BackgroundImage, this.Title,
      /*this.elements*/);

  WriteDiaryDetailsSaveTemporary.withId(this.id, this.BackgroundImage,
      this.Title, /*this.elements*/);
}

@Entity()
class TagStringItem {
  int id;
  int key;
  String value;

  TagStringItem({this.id = 0, required this.value, required this.key});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'value': value,
    };
  }

  factory TagStringItem.fromJson(Map<String, dynamic> json) {
    return TagStringItem(
      key: json['key'] as int,
      value: json['value'] as String,
    );
  }
}

@Entity()
class TagDataEntity {
  int id;
  final strings = ToMany<TagStringItem>();

  TagDataEntity({this.id = 0});
}

@Entity()
class ExportStringItem {
  int id;
  String value;

  ExportStringItem({this.id = 0, required this.value});
}

@Entity()
class ExportDataEntity {
  int id;
  final strings = ToMany<ExportStringItem>();

  ExportDataEntity({this.id = 0});
}

@Entity()
class ImagePathString {
  int id;
  int key;
  String value;
  double height;
  double width;

  ImagePathString(
      {this.id = 0, required this.key, required this.value, required this.height, required this.width});
}

@Entity()
class EmojiIndex{
  int id;
  int? emojiSelectedIndex;

  EmojiIndex({this.id = 0, this.emojiSelectedIndex});
}

@Entity()
class ThemeSet{
  int id;
  int? selectedTheme;

  ThemeSet({this.id = 0, this.selectedTheme});
}

@Entity()
class PasswordManger{
  int id;
  bool? diaryLockSwitchOn;
  bool? fingerPrintSwitchOn;

  PasswordManger({this.id = 0, this.diaryLockSwitchOn, this.fingerPrintSwitchOn});
}

@Entity()
class ImagePathEntity {
  int id;
  final imagePathStrings = ToMany<ImagePathString>();

  ImagePathEntity({this.id = 0});
}


@Entity()
class DetailsControllerText {
  int id;
  int key;
  String value;

  DetailsControllerText({this.id = 0, required this.key, required this.value});
}

@Entity()
class DetailsControllerEntity {
  int id;
  final detailsControllerStrings = ToMany<DetailsControllerText>();

  DetailsControllerEntity({this.id = 0});
}


@Entity()
class AudioPathString {
  int id;
  int key;
  String value;

  AudioPathString({this.id = 0, required this.key, required this.value});

}

@Entity()
class AudioPathEntity {
  int id;
  final audioPathStrings = ToMany<AudioPathString>();

  AudioPathEntity({this.id = 0});
}

@Entity()
class DrawImagesString {
  int id;
  int key;
  Uint8List value;

  DrawImagesString({this.id = 0, required this.key, required this.value});

}

@Entity()
class DrawImagesEntity {
  int id;
  final drawImage = ToMany<DrawImagesString>();

  DrawImagesEntity({this.id = 0});
}


