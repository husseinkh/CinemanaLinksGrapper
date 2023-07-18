//
//  CinemanaShowProcessor.swift
//  CinemanaShowProcessor
//
//  Created by Hussein Abdulwahid on 20/08/2021.
//

import Foundation
class CinemanaShowProcessor : CinemanaShowDelagate {
    
    typealias DownloadingHandler = (String) -> Void
    let cinemanaShowLoader : CinemanaShowLoader
    var folderURL : URL
    var showInfo : CinemanaTVShow?
    let renameFileReady : Bool
    let downloadingHandler : DownloadingHandler
    let resolution : VideoInfoElement.Resolution
    init(showID : Int ,resolution : VideoInfoElement.Resolution = .hd , renameFile : Bool , folderURL : URL = FileManager.default.homeDirectoryForCurrentUser , downloadingHandler : @escaping DownloadingHandler) {
        self.renameFileReady = renameFile
        cinemanaShowLoader = CinemanaShowLoader(showID: showID )
        self.folderURL = folderURL
        self.resolution = resolution
        self.downloadingHandler = downloadingHandler
    }
    
    func startProcess() {
        cinemanaShowLoader.delegate = self
        cinemanaShowLoader.fetchTVShowDetail()
    }
    
    func finishedLoading(result: Result<CinemanaShowDetail, Error>) {
        var message : String = ""
        defer {
            self.downloadingHandler(message)
        }
        switch (result) {
            case .failure(let error) :
                debugPrint(error)
                message = error.localizedDescription
            case .success(let cinemanaShowDetail) :
                
                let showTitle = cinemanaShowDetail.showTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                
                
                let folderURL = self.folderURL.appendingPathComponent("Videos/\(showTitle)", isDirectory: true)
                if !FileManager.default.fileExists(atPath: folderURL.path) {
                    print("Creating Folder for the Show")
                    try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                }
                
                do {
                    
                    
                    let showInfo = """
        {"\(self.cinemanaShowLoader.cinemanaShowURL.id)" : "\(showTitle)"}
        """
                    
                    try showInfo.write(to: folderURL.appendingPathComponent(showTitle).appendingPathExtension("json"), atomically: true, encoding: .utf8)
                }
                catch   {
                    print(error.localizedDescription)
                    message = error.localizedDescription
                }
                
                if cinemanaShowDetail.showKind == .film {
                    let cinemanaTVShows = cinemanaShowDetail.cinemanaShowTVBySeasons[0]!
                    let jsonFileNamesCoding = jsonFileNameCoding(cinemanaTVShows: cinemanaTVShows , resolution: resolution)
                    let fileURLs = filesURL(cinemanaTVShows: cinemanaTVShows, resolution: resolution)
                    
                    do {
                        
                        
                        try jsonFileNamesCoding.write(to: folderURL.appendingPathComponent("fileNameEncoding").appendingPathExtension("json"), atomically: true, encoding: .utf8)
                        
                        
                        
                        try fileURLs.write(to: folderURL.appendingPathComponent("filesURL").appendingPathExtension("txt"), atomically: true, encoding: .utf8)
                        
                    }
                    catch {
                        print(error.localizedDescription)
                        message = error.localizedDescription
                    }
                    
                    if renameFileReady {
                        renameFileName(cinemanaTVShows: cinemanaTVShows , season: 0, resolution: resolution)
                    }
                }
                else {
                    for (season ,cinemanaTVShows) in cinemanaShowDetail.cinemanaShowTVBySeasons {
                        let jsonFileNamesCoding = jsonFileNameCoding(cinemanaTVShows: cinemanaTVShows , resolution: resolution)
                        let fileURLs = filesURL(cinemanaTVShows: cinemanaTVShows , resolution: resolution)
                        
                        do {
                            
                            let seasonfolderURL = folderURL.appendingPathComponent("\(season)", isDirectory: true)
                            if !FileManager.default.fileExists(atPath: seasonfolderURL.path) {
                                print("Creating Folder for the Show")
                                try? FileManager.default.createDirectory(at: seasonfolderURL, withIntermediateDirectories: true, attributes: nil)
                            }
                            
                            try fileURLs.write(to: seasonfolderURL.appendingPathComponent("filesURL").appendingPathExtension("txt"), atomically: true, encoding: .utf8)
                            try jsonFileNamesCoding.write(to: seasonfolderURL.appendingPathComponent("fileNameEncoding").appendingPathExtension("json"), atomically: true, encoding: .utf8)
                            
                        }
                        catch {
                            print(error.localizedDescription)
                            message = error.localizedDescription
                        }
                        
                        if renameFileReady {
                            renameFileName(cinemanaTVShows: cinemanaTVShows , season: season , resolution: resolution)
                        }
                        
                    }
                }
                
                message = "finihsed loading all"
                
        } // end switch
    }
    
    
    func htmlFormat(cinemanaTVShow : CinemanaTVShow) -> String {
        var htmlStr = """
    <!DOCTYPE html>
    <html>
    <head>
    <title> \(cinemanaTVShow[0].enTitle) </title>
    </head>
    <body>
    <h1> \(cinemanaTVShow[0].enTitle)</h1>
    """
        for info in cinemanaTVShow {
            if  let highestResolution = info.highestResolutionVideo {
                
                htmlStr.append("""
                <p><a href="\(highestResolution.videoURL)">Season \(info.seasonNo) Episode \(info.episodeNo) Video</a></p>
                """)
                // print(highestResolution.videoURL)
                if let translationFile = info.subtitle?.arTranslationFilePath {
                    htmlStr.append("""
                   <p><a href="\(translationFile)">Season\(info.seasonNo) Episode \(info.episodeNo) Arabic Subtitle</a></p>
               """)
                }
            }
            
        }
        
        htmlStr.append("""
            </body>
            </html>
            """)
        
        return htmlStr
    }
    
    
    func saveFileURLS(to : URL, cinemanaTVShow : CinemanaTVShow , resolution : VideoInfoElement.Resolution) {
        
        var urlsStr = ""
        for cinemanaShow in cinemanaTVShow {
            
            if let hd = cinemanaShow.videoInfo?.first(where: { videoInfoElement in
                videoInfoElement.resolution == resolution
            })
            {
            urlsStr.append(hd.videoURL)
            urlsStr.append("\n")
            }
            else {
                if  let highestResolution = cinemanaShow.highestResolutionVideo {
                    urlsStr.append(highestResolution.videoURL)
                    urlsStr.append("\n")
                }
            }
            
            
            if let translationFile = cinemanaShow.subtitle?.arTranslationFilePath {
                urlsStr.append(translationFile)
                urlsStr.append("\n")
            }
        }
        
        do {
            try urlsStr.write(to: to, atomically: true, encoding: .utf8)
        }
        catch {
            
        }
    }
    func filesURL(cinemanaTVShows : CinemanaTVShow, resolution : VideoInfoElement.Resolution = .fullHD) -> String {
        var urlsStr = ""
        for cinemanaTVShow in cinemanaTVShows {
            
            if let hd = cinemanaTVShow.videoInfo?.first(where: { videoInfoElement in
                videoInfoElement.resolution == resolution
            })
            {
            urlsStr.append(hd.videoURL)
            urlsStr.append("\n")
            }
            else {
                if  let highestResolution = cinemanaTVShow.highestResolutionVideo {
                    urlsStr.append(highestResolution.videoURL)
                    urlsStr.append("\n")
                }
            }
            
            
            if let translationFile = cinemanaTVShow.subtitle?.arTranslationFilePath {
                urlsStr.append(translationFile)
                urlsStr.append("\n")
            }
        }
        
        return urlsStr
    }
    
    
    func filesURL(cinemanaTVShows : CinemanaTVShow , bySeason : Bool) -> [String : String] {
        var urlsStr = ""
        var filesURLBySeason : [String : String] = [:]
        for cinemanaTVShow in cinemanaTVShows {
            urlsStr = filesURLBySeason[cinemanaTVShow.season] ?? ""
            if  let highestResolution = cinemanaTVShow.highestResolutionVideo {
                urlsStr.append(highestResolution.videoURL)
                urlsStr.append("\n")
            }
            if let translationFile = cinemanaTVShow.subtitle?.arTranslationFilePath {
                urlsStr.append(translationFile)
                urlsStr.append("\n")
            }
            filesURLBySeason[cinemanaTVShow.season] = urlsStr
        }
        
        return filesURLBySeason
    }
    func jsonFileNameCoding(cinemanaTVShows : CinemanaTVShow, resolution : VideoInfoElement.Resolution = .fullHD) -> String {
        
        let episodesInfo : EpisodeInfo = cinemanaTVShows.map {
            var transcoddeFileName : String? = $0.highestResolutionVideo?.transcoddedFileName
            if let hd = $0.videoInfo?.first(where: { videoInfoElement in
                videoInfoElement.resolution == resolution
            })
            {
            transcoddeFileName = hd.transcoddedFileName
            }
            
            
            let epispdeInfoElement = EpisodeInfoElement(showName: $0.enTitle.trimmingCharacters(in: .whitespacesAndNewlines), episodeNo: $0.episodeNumber, seasonNo: $0.season, transcoddedFileName: transcoddeFileName, arTranslationFile: $0.subtitle?.arTranslationFile , skippingDurations: $0.skippingDurations)
            return epispdeInfoElement
        }
        do {
            let jsonData = try JSONEncoder().encode(episodesInfo)
            guard let jsonStr = String(data: jsonData, encoding: .utf8) else { return "" }
            return jsonStr
            
        }
        catch {
            print(error.localizedDescription)
            return ""
        }
        
    }
    
    
    func renameFileName(cinemanaTVShows : CinemanaTVShow , season : Int = 0 , resolution : VideoInfoElement.Resolution = .fullHD) {
        
        
        let showTitle = cinemanaTVShows[0].enTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var subFolderPath = "Videos/\(showTitle)"
        if (season > 0) {
            subFolderPath += "/\(season)"
        }
        let folderURL = self.folderURL.appendingPathComponent(subFolderPath, isDirectory: true)
        
        
        if let dirEnum = FileManager.default.enumerator(atPath: folderURL.path) {
            
            while let fileName = dirEnum.nextObject() as? String {
                var cinemanaShow : CinemanaShow? = nil
                let fullPath = folderURL.appendingPathComponent(fileName, isDirectory: false)
                
                var encodedFileName = fullPath.lastPathComponent
                
                if (encodedFileName.contains("?") ){
                    encodedFileName = String(encodedFileName.split(separator: "?")[0])
                }
                
                
                cinemanaShow = cinemanaTVShows.first(where: { cShow in
                    
                    var transcoddeFileName : String = cShow.highestResolutionVideo?.transcoddedFileName ?? ""
                    if let hd = cShow.videoInfo?.first(where: { videoInfoElement in
                        videoInfoElement.resolution == resolution
                    })
                    {
                    transcoddeFileName = hd.transcoddedFileName
                    }
                    return  transcoddeFileName == encodedFileName || cShow.subtitle?.arTranslationFile == encodedFileName
                    
                })
                if let cinemanaShow = cinemanaShow {
                    
                    if let newFileName = cinemanaShow.findAndFormatFileURL(fileName: encodedFileName) {
                        
                        let originalFileNameURL = folderURL.appendingPathComponent(fileName)
                        let newFileNameURL = folderURL.appendingPathComponent(newFileName)
                        
                        try? FileManager.default.moveItem(at: originalFileNameURL, to: newFileNameURL)
                    }
                    
                }
            }
        }
    }
}


extension CinemanaShow {
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

