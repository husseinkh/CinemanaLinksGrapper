// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let videoInfo = try? newJSONDecoder().decode(VideoInfo.self, from: jsonData)
/*
 
 {
     "name": "mp4-1080",
     "resolution": "1080p",
     "container": "mp4",
     "transcoddedFileName": "D1B6D565-8DEF-C976-DA75-C836DF0E2EA6_video.mp4",
     "videoUrl": "https://cdn.shabakaty.com/m1080/D1B6D565-8DEF-C976-DA75-C836DF0E2EA6_video.mp4?response-content-disposition=attachment%3B%20filename%3D%22video.mp4%22&AWSAccessKeyId=RNA4592845GSJIHHTO9T&Expires=1628197255&Signature=WvvfOd%2BgyuxVwYLqAFWezoaBxW4%3D"
   }
 */
import Foundation

// MARK: - VideoInfoElement
///A structure that holds information for Cinemana Show video , like resolution, transcoddedfilename and video url
public struct VideoInfoElement: Codable {
    
    /// Video Resoultion
    public enum Resolution : String , Codable , CaseIterable {
        case veryLow = "240p"
        case low = "360p"
        case medium = "480p"
        case hd = "720p"
        case fullHD = "1080p"
        
        public var index : Int {
            return Resolution.allCases.firstIndex(of: self) ?? 0
        }
    }
    public let name: String
    public let resolution: Resolution
    public let container: String
    public let transcoddedFileName: String
    public let videoURL: String
    public var id : Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case resolution = "resolution"
        case container = "container"
        case transcoddedFileName = "transcoddedFileName"
        case videoURL = "videoUrl"
    }
    
   
}

extension VideoInfoElement : Comparable {
    public static func < (lhs: VideoInfoElement, rhs: VideoInfoElement) -> Bool {
        
        return lhs.resolution.index < rhs.resolution.index
    }
    
    public static func == (lhs : VideoInfoElement , rhs : VideoInfoElement) -> Bool {
        return lhs.resolution.index == rhs.resolution.index

    }
}

/// A collection of VideoInfoElements
public typealias VideoInfo = [VideoInfoElement]


//MARK:- Show Kind
/// Show type : Film , TVShow ..
public enum ShowKind : Int {
    case film = 1
    case tvShow = 2
    case unknown = 0
}

extension ShowKind : Codable {
    
    /// Convert it from String to Int and back
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let strValue = try container.decode(String.self)
            if let intValue = Int(strValue) {
                self = .init(rawValue: intValue) ?? .unknown
            }
            else {
                self = .unknown
            }
        }
        catch  DecodingError.typeMismatch {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("\(rawValue)")
    }
}

