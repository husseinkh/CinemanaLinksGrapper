// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let the35818Trans = try? newJSONDecoder().decode(The35818Trans.self, from: jsonData)
/*
 {
   "arTranslationFile": "450E1595-44EC-CEEC-0387-B21B07A99FC4_ar_transfile.srt",
   "enTranslationFile": "",
   "spTranslationFile": "",
   "arTranslationFilePath": "https://cnth2.shabakaty.com/translation-files/450E1595-44EC-CEEC-0387-B21B07A99FC4_ar_transfile.srt?response-cache-control=max-age%3D86400&AWSAccessKeyId=RNA4592845GSJIHHTO9T&Expires=1630238180&Signature=nR1G75fzrLE%2BBI9qs0lSoqis%2BuE%3D",
   "enTranslationFilePath": "defaultImages/loading.gif",
   "translations": [
     {
       "id": 1,
       "name": "arabic",
       "type": "ar",
       "extention": "srt",
       "file": "https://cnth2.shabakaty.com/translation-files/450E1595-44EC-CEEC-0387-B21B07A99FC4_ar_transfile.srt?response-cache-control=max-age%3D86400&AWSAccessKeyId=RNA4592845GSJIHHTO9T&Expires=1630238180&Signature=nR1G75fzrLE%2BBI9qs0lSoqis%2BuE%3D"
     },
     {
       "id": 2,
       "name": "arabic",
       "type": "ar",
       "extention": "vtt",
       "file": "https://cnth2.shabakaty.com/translation-files/450E1595-44EC-CEEC-0387-B21B07A99FC4_ar_transfile.vtt?response-cache-control=max-age%3D86400&AWSAccessKeyId=RNA4592845GSJIHHTO9T&Expires=1630238180&Signature=5n7T6QZZ0i69Wt2Gd54%2BRKgUu0k%3D"
     }
   ]
 }
 */

import Foundation

// MARK: - TranslationInfo
///Structure holds main translation files in srt format and Translation Detail collection for more translation format
public struct Subtitle: Codable {
    public let arTranslationFile: String
    public let enTranslationFile: String
    public let spTranslationFile: String
    public let arTranslationFilePath: String
    public let enTranslationFilePath: String
    public let translations: [Translation]

}


// MARK: - TranslationDetail
/* example {
  "id": 1,
  "name": "arabic",
  "type": "ar",
  "extention": "srt",
  "file": "https://cnth2.shabakaty.com/translation-files/450E1595-44EC-CEEC-0387-B21B07A99FC4_ar_transfile.srt?response-cache-control=max-age%3D86400&AWSAccessKeyId=RNA4592845GSJIHHTO9T&Expires=1630238180&Signature=nR1G75fzrLE%2BBI9qs0lSoqis%2BuE%3D"
}
 */
/// Holds  translation file URL, language and file format
public struct Translation: Codable {
    public let id: Int
    public let name: String
    public let type: String
    public let extention: String
    public let file: String

    public init(id: Int, name: String, type: String, extention: String, file: String) {
        self.id = id
        self.name = name
        self.type = type
        self.extention = extention
        self.file = file
    }
    
}
