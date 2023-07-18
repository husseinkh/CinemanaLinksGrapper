// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cinemanaVideo = try? newJSONDecoder().decode(CinemanaVideo.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.cinemanaShowTask(with: url) { cinemanaShow, response, error in
//     if let cinemanaShow = cinemanaShow {
//       ...
//     }
//   }
//   task.resume()

import Foundation
import FoundationNetworking

// MARK: - CinemanaVideo
public struct CinemanaShow: Codable {
    public let nb: String
    public let enTitle: String
    //public let arTitle: String
    public let kind: ShowKind
    public let season: String
    public let episodeNumber: String
    
    public var videoInfo : VideoInfo?
    public var skippingDurations: SkippingDurations?
    public var subtitle: Subtitle?
    
    public enum CodingKeys: String, CodingKey {
        case nb
        //case arTitle = "ar_title"
        case enTitle = "en_title"
        case kind = "kind"
        case season
        case episodeNumber = "episodeNummer"
    }
    
    
    
}


extension CinemanaShow : Comparable {
    public var episodeNo : Int {
        if let value = Int(self.episodeNumber) {
            return value
        }
        return 0
    }
    
    public var seasonNo : Int {
        if let value = Int(self.season) {
            return value
        }
        return 0
    }
    public var id : Int {
        if let value = Int(self.nb) {
            return value
        }
        return 0
    }
    public static func < (lhs: CinemanaShow, rhs: CinemanaShow) -> Bool {
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
    
    
    public static func == (lhs : CinemanaShow , rhs : CinemanaShow) -> Bool {
        return ( lhs.seasonNo == rhs.seasonNo) && (lhs.episodeNo == rhs.episodeNo)
    }
    
    
    public var highestResolutionVideo : VideoInfoElement? {
        let highestRes = self.videoInfo?.max(by: <)
        return highestRes
    }
    
    
}



// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date"))
    })
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    encoder.dateEncodingStrategy = .formatted(formatter)
    return encoder
}

// MARK: - URLSession response handlers

public extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func cinemanaShowTask(with url: URL, completionHandler: @escaping (CinemanaShow?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


public typealias CinemanaTVShow = [CinemanaShow]


extension CinemanaTVShow {
    
    public func toDict() -> [Int : CinemanaShow] {
       
        return self.reduce(into: [:]) { result, cinemanaShow in
            result[cinemanaShow.id] = cinemanaShow
        }
        
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
