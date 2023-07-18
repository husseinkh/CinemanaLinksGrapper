import Foundation
//video info , main film or show video info
//https://cinemana.shabakaty.com/api/android/allVideoInfo/id/35811
// show info with how many episodes and seasons
//https://cinemana.shabakaty.com/api/android/videoSeason/id/35811

//video file info
//https://cinemana.shabakaty.com/api/android/transcoddedFiles/id/35818

//translation
//https://cinemana.shabakaty.com/api/android/translationFiles/id/35818

//skipdurations
//https://cinemana.shabakaty.com/api/android/skippingDurations/id/35811


// season number
//https://cinemana.shabakaty.com/api/android/videoSeasonNumber/id/21948

///Hold the the url part that refer to the type of data like  Video, translation ...
public enum URLType : String {

    case allVideoInfo
    case tvShow = "videoSeason"
    case videoTranscoddedFiles = "transcoddedFiles"
    case translationFiles
    case skippingDurations
    case seasons = "videoSeasonNumber"
}


///It is used to construct the url for the required data or file : video url, translation and so.
/**
Providing it with show id.
*/
public struct ShowURLBuilder {
    
    private let baseURL = URL(string:"https://cinemana.shabakaty.com/api/android")!
    

    let id : Int

    public init(id : Int) {
        self.id = id
    }
    var allVideoInfoURL : URL {
        return self.getURL(urlType: .allVideoInfo)
    }
    var tvShowURL : URL {
        return self.getURL(urlType: .tvShow)
    }
    var videoTranscoddedFilesURL : URL {
        return self.getURL(urlType: .videoTranscoddedFiles)
    }
    var translationFilesURL : URL {
        return self.getURL(urlType: .translationFiles)
    }
    var skippingDurationsURL : URL {
        return self.getURL(urlType: .skippingDurations)
    }
    var seasonsURL :  URL {
        return self.getURL(urlType: .seasons)
    }
  public  func getURL( urlType : URLType ) -> URL {
        return baseURL.appendingPathComponent("\(urlType.rawValue)/id/\(id)")
    }
}
