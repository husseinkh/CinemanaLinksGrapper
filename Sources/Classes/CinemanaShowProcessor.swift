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

    // init(showID : Int,  downloadingHandler : @escaping DownloadingHandler) {

    // }
    init(showID : Int , resolution : VideoInfoElement.Resolution = .hd , renameFile : Bool , folderURL : URL = FileManager.default.homeDirectoryForCurrentUser , downloadingHandler : @escaping DownloadingHandler) {
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
                        renameFileName(cinemanaTVShows: cinemanaTVShows , seasonNo: 0, resolution: resolution)
                    }
                } // end show kind is film
                else {
                    for (seasonNo ,cinemanaTVShows) in cinemanaShowDetail.cinemanaShowTVBySeasons {
                        let jsonFileNamesCoding = jsonFileNameCoding(cinemanaTVShows: cinemanaTVShows , resolution: resolution)
                        let fileURLs = filesURL(cinemanaTVShows: cinemanaTVShows , resolution: resolution)
                        
                        do {
                            
                            let seasonfolderURL = folderURL.appendingPathComponent("\(seasonNo)", isDirectory: true)
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
                            renameFileName(cinemanaTVShows: cinemanaTVShows , seasonNo: seasonNo , resolution: resolution)
                        }
                        
                    }
                }
                
                message = "finihsed loading all"
                
        } // end switch
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
    
    
    func filesURL(cinemanaTVShows : CinemanaTVShow , bySeason : Bool) -> [Int : String] {
        var urlsStr = ""
        var filesURLBySeason : [Int : String] = [:]
        for cinemanaTVShow in cinemanaTVShows {
            urlsStr = filesURLBySeason[cinemanaTVShow.seasonNo] ?? ""
            if  let highestResolution = cinemanaTVShow.highestResolutionVideo {
                urlsStr.append(highestResolution.videoURL)
                urlsStr.append("\n")
            }
            if let translationFile = cinemanaTVShow.subtitle?.arTranslationFilePath {
                urlsStr.append(translationFile)
                urlsStr.append("\n")
            }
            filesURLBySeason[cinemanaTVShow.seasonNo] = urlsStr
        }
        
        return filesURLBySeason
    }
    func jsonFileNameCoding(cinemanaTVShows : CinemanaTVShow, resolution : VideoInfoElement.Resolution = .fullHD) -> String {
        
        let episodesInfo  = cinemanaTVShows.toEpisodesInfo(resolution: resolution)
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
    
    
    func renameFileName(cinemanaTVShows : CinemanaTVShow , seasonNo : Int = 0 , resolution : VideoInfoElement.Resolution = .fullHD) {
        
        
        let showTitle = cinemanaTVShows[0].enTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var subFolderPath = "Videos/\(showTitle)"
        if (seasonNo > 0) {
            subFolderPath += "/\(seasonNo)"
        }
        let folderURL = self.folderURL.appendingPathComponent(subFolderPath, isDirectory: true)
        
        
        if let dirEnum = FileManager.default.enumerator(atPath: folderURL.path) {
            
            while let fileName = dirEnum.nextObject() as? String {
                var cinemanaShow : EpisodeInfo? = nil
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
