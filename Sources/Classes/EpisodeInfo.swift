// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cinemanaVideo = try? newJSONDecoder().decode(CinemanaVideo.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.EpisodeInfoTask(with: url) { EpisodeInfo, response, error in
//     if let EpisodeInfo = EpisodeInfo {
//       ...
//     }
//   }
//   task.resume()

/*
 {
    "nb": "863872",
    "ar_title": "The Witcher: Blood Origin",
    "en_title": "The Witcher: Blood Origin",
    "ar_content": "\u0628\u0639\u062f \u0623\u0646 \u0646\u0628\u0630\u062a\u0647\u0645 \u0639\u0634\u0627\u0626\u0631\u0647\u0645\u060c \u064a\u062a\u0651\u062d\u062f \u0645\u062d\u0627\u0631\u0628\u0648\u0646 \u062e\u0635\u0648\u0645 \u0644\u0623\u062f\u0627\u0621 \u0645\u0647\u0645\u0651\u0629 \u0627\u0646\u062a\u0642\u0627\u0645\u064a\u0629 \u0636\u062f\u0651 \u0625\u0645\u0628\u0631\u0627\u0637\u0648\u0631\u064a\u0629 \u0643\u0627\u0645\u0644\u0629 \u0641\u064a \u0647\u0630\u0627 \u0627\u0644\u0645\u0633\u0644\u0633\u0644 \u0627\u0644\u062a\u0645\u0647\u064a\u062f\u064a \u0627\u0644\u0645\u0643\u0648\u0651\u0646 \u0645\u0646 \u0623\u0631\u0628\u0639\u0629 \u0623\u062c\u0632\u0627\u0621 \u0645\u0646 \u062b\u0645\u0627\u0631 \u0639\u0642\u0648\u0644 \u0645\u0628\u062f\u0639\u064a The Witcher.",
    "en_content": "More than a thousand years before the events of \"The Witcher,\" seven outcasts in an Elven world join forces in a quest against an all-powerful empire.",
    "publishDate": "2022-12-25 13:49:50",
    "videoUploadDate": "2022-12-25 12:51:18",
    "duration": "3816.96",
    "fileSizeServer": "2558240634",
    "imdbUrlRef": "https://www.imdb.com/title/tt12785720/",
    "rootSeries": "0",
    "stars": "4.7",
    "year": "2022",
    "kind": "2",
    "season": "1",
    "img": "37DFC379-ED94-2F4C-F1F1-7896E39BA063_poster.jpg",
    "imgThumb": "617918D5-EE55-EA5A-7D46-D53C3F0B19FB_poster_thumb.jpg",
    "imgMediumThumb": "AF83B08E-FC84-598C-5708-5DA745E31941_poster_medium_thumb.jpg",
    "imgObjUrl": "https://cnth2.shabakaty.com/poster-images/37DFC379-ED94-2F4C-F1F1-7896E39BA063_poster.jpg",
    "imgThumbObjUrl": "https://cnth2.shabakaty.com/poster-images/617918D5-EE55-EA5A-7D46-D53C3F0B19FB_poster_thumb.jpg",
    "imgMediumThumbObjUrl": "https://cnth2.shabakaty.com/poster-images/AF83B08E-FC84-598C-5708-5DA745E31941_poster_medium_thumb.jpg",
    "objectUrlExpiration": "2023-07-23",
    "orderNmmer": "1",
    "filmRating": "1",
    "seriesRating": "6",
    "episodeNummer": "1",
    "rate": "253952",
    "isSpecial": "1",
    "useParentImg": "0",
    "episode_flag": "0000",
    "parent_skipping": "1",
    "mDate": "2022-12-25"
  }
*/


import Foundation
import FoundationNetworking

// MARK: - EpisodeInfo
public struct EpisodeInfo: Codable {
  //  public let nb: String
    public let id : Int
    public let enTitle: String
    //public let arTitle: String
    public let kind: ShowKind
    public let seasonNo: Int
    public let episodeNo: Int

    public var videoInfo : VideoInfo?
    public var skippingDurations: SkippingDurations?
    public var subtitle: Subtitle?
    

  
 


    public enum CodingKeys: String, CodingKey {
        case id = "nb" 
        //case arTitle = "ar_title"
        case enTitle = "en_title"
        case kind = "kind"
        case seasonNo = "season" 
        case episodeNo = "episodeNummer" 
    }
    
    
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = (try container.decode(String.self, forKey: .id)).integerValue

            enTitle = try container.decode(String.self, forKey: .enTitle)
            kind = try container.decode(ShowKind.self, forKey: .kind)
             
            seasonNo = (try container.decode(String.self, forKey: .seasonNo)).integerValue
            episodeNo = (try container.decode(String.self, forKey:.episodeNo)).integerValue
            
        }

        public func encode(to encoder: Encoder) throws {
            var container =  encoder.container(keyedBy: CodingKeys.self)
           
            try container.encode("\(id)", forKey: .id)
            try container.encode(enTitle, forKey: .enTitle)
            try container.encode(kind, forKey: .kind)
            try container.encode("\(seasonNo)", forKey: .seasonNo)
            try container.encode("\(episodeNo)", forKey: .episodeNo)
        }
}


extension EpisodeInfo : Comparable {

    public static func < (lhs: EpisodeInfo, rhs: EpisodeInfo) -> Bool {
        if (lhs.seasonNo < rhs.seasonNo) {
            return true
        }
        else if (lhs.seasonNo == rhs.seasonNo && lhs.episodeNo < rhs.episodeNo)
        {
            return true
        }
        else {
            return false
        }
    }
    
    
    public static func == (lhs : EpisodeInfo , rhs : EpisodeInfo) -> Bool {
        return ( lhs.seasonNo == rhs.seasonNo) && (lhs.episodeNo == rhs.episodeNo)
    }
    
    
    public var highestResolutionVideo : VideoInfoElement? {
        let highestRes = self.videoInfo?.max(by: <)
        return highestRes
    }
    
    





//MARK:- EpisodeInfo Extension


// extension EpisodeInfo {
    public func findAndFormatFileURL(fileName : String) -> String? {
        let file = fileName as NSString
        //let onlyfileName = file.deletingPathExtension
        let fileExtension = file.pathExtension
        let showName = enTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let seasonStr : String = {
            if seasonNo < 10 {
                return "S0\(seasonNo)"
            }
            else {
                return "S\(seasonNo)"
            }
        }()
        
        let episodeStr : String = {
            if episodeNo < 10 {
                return "E0\(episodeNo)"
            }
            else {
                return "E\(episodeNo)"
            }
        }()
        
        // if highestResolutionVideo?.transcoddedFileName == fileName || subtitle?.arTranslationFile == fileName {
        
        // for films
        if (episodeNo == 0 && seasonNo == 0) {
            return "\(showName).\(fileExtension)"
        }
        else {
            return "\(showName).\(seasonStr)\(episodeStr).\(fileExtension)"
        }
        
    }
}



//MARK:- CinemanaTVShow
/// Array Collection that holds EpisodeInfo
public typealias CinemanaTVShow = [EpisodeInfo]


extension CinemanaTVShow {
    
    public func toDict() -> [Int : EpisodeInfo] {
       
        return self.reduce(into: [:]) { result, EpisodeInfo in
            result[EpisodeInfo.id] = EpisodeInfo
        }
        
    }

public func toEpisodesInfo(resolution : VideoInfoElement.Resolution = .fullHD) -> [EpisodeInfoElement] {
  let episodesInfo : [EpisodeInfoElement] = self.map {
            var transcoddeFileName : String? = $0.highestResolutionVideo?.transcoddedFileName
            if let hd = $0.videoInfo?.first(where: { videoInfoElement in
                videoInfoElement.resolution == resolution
            })
            {
            transcoddeFileName = hd.transcoddedFileName
            }
            
            let epispdeInfoElement = EpisodeInfoElement( episodeNo: $0.episodeNo,  transcoddedFileName: transcoddeFileName, arTranslationFile: $0.subtitle?.arTranslationFile , skippingDurations: $0.skippingDurations)
                      // let epispdeInfoElement = EpisodeInfoElement(showName: $0.enTitle.trimmingCharacters(in: .whitespacesAndNewlines), episodeNo: $0.episodeNo, seasonNo: $0.seasonNo, transcoddedFileName: transcoddeFileName, arTranslationFile: $0.subtitle?.arTranslationFile , skippingDurations: $0.skippingDurations)

            return epispdeInfoElement
        }
return episodesInfo

}
}


extension String {

    public var integerValue : Int {
        return Int(self) ?? 0
    }
}


public struct Season : Codable {
    let season : Int
    
    enum CodingKeys : String , CodingKey {
        case season
    }
    public init ( season : Int) {
        self.season = season
    }
    public init(from decoder: Decoder) throws {
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let strValue = try container.decode(String.self , forKey: .season)
            if let intValue = Int(strValue) {
                season = intValue
            }
            else {
                season = 0
            }
        }
        catch  DecodingError.typeMismatch {
            
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(self.season)", forKey: .season)
    }
}

typealias Seasons = [Season]
