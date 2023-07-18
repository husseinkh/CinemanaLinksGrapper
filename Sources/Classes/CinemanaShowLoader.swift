import Foundation
import FoundationNetworking
public protocol CinemanaShowDelagate
{
    func finishedLoading(result : Result<CinemanaShowDetail , Error>)
}
public class CinemanaShowLoader {
    
    let cinemanaShowURL : ShowURLBuilder
    
    public var delegate : CinemanaShowDelagate?
    private let showID : Int
    
    let dispatchQueue = DispatchQueue(label: "com.sindibad.Cinemana", qos: .userInitiated, attributes: .concurrent)
    let dispatchGroup = DispatchGroup()
    let dispatchSemaphore = DispatchSemaphore(value: 5)
    
    public init(showID : Int) {
        self.showID = showID
        cinemanaShowURL = ShowURLBuilder(id: showID)
    }
    
    public func fetchTVShowDetail() {
        
        
        var dict : [Int : CinemanaShow] = [:]
        
        fetchCinemanaShow(id: showID) { [weak self] result in
            
            switch(result) {
                case .failure(let error):
                    print("Some error has happened here \(error.localizedDescription)")
                    self?.delegate?.finishedLoading(result: Result.failure(error))
                    return
                case .success(let cinemanaDetail) :
                    
                    
                    
                    let thedict = cinemanaDetail.cinemanaShowTVBySeasons.map({ (key: Int, value: CinemanaTVShow) in
                        
                        value.toDict()
                    })
                    
                    dict = thedict.reduce(into: [:], { result, element in
                        result.merge(element) { _,  showItem in
                            showItem
                        }
                        
                    })
                    
                    var detail = cinemanaDetail
                    
                    for (season , cinemanaTVShow) in cinemanaDetail.cinemanaShowTVBySeasons {
                        for  (index ,info) in cinemanaTVShow.enumerated() {
                            
                            self?.dispatchGroup.enter()
                            self?.dispatchQueue.async { [self] in
                                self?.dispatchSemaphore.wait()
                                
                                self?.getVideoInfo(id: info.id) { videoInforesult in
                                    switch(videoInforesult) {
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        case .success(let (videoInfo , id)) :
                                            dict[id]?.videoInfo = videoInfo
                                            detail.cinemanaShowTVBySeasons[season]?[index].videoInfo = videoInfo
                                    }
                                    self?.dispatchGroup.leave()
                                    self?.dispatchSemaphore.signal()
                                    
                                }
                            }
                            
                            
                            self?.dispatchGroup.enter()
                            self?.dispatchQueue.async { [self] in
                                self?.dispatchSemaphore.wait()
                                
                                self?.getTranslationInfo(id: info.id)   { subtitleResult in
                                    switch(subtitleResult) {
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        case .success(let (subtitle , id)) :
                                            dict[id]?.subtitle = subtitle
                                            detail.cinemanaShowTVBySeasons[season]?[index].subtitle = subtitle
                                    }
                                    
                                    self?.dispatchGroup.leave()
                                    self?.dispatchSemaphore.signal()
                                    
                                }
                            }
                            
                            
                            
                            self?.dispatchGroup.enter()
                            self?.dispatchQueue.async { [self] in
                                self?.dispatchSemaphore.wait()
                                
                                self?.getSkippingDurations(id: info.id ) { skipdurationResult in
                                    
                                    switch(skipdurationResult) {
                                        case .failure(let error) :
                                            print(error.localizedDescription)
                                        case .success(let (skippingDurations, id)) :
                                            dict[id]?.skippingDurations = skippingDurations
                                            detail.cinemanaShowTVBySeasons[season]?[index].skippingDurations = skippingDurations
                                    }
                                    
                                    self?.dispatchGroup.leave()
                                    self?.dispatchSemaphore.signal()
                                    
                                }
                            }
                            
                        } //end for in showinfo
                    }
                    
                    
                    
                    self?.dispatchGroup.notify(queue: DispatchQueue.main) {
                        
                        self?.delegate?.finishedLoading(result: Result.success(detail))
                        
                        
                    }
                    
            } // end main Switch
        } // end fetch detail
    }
    
    func fetchCinemanaShow(id : Int , completionHandler : @escaping (Result<CinemanaShowDetail , Error> ) -> Void ) {
        getInfo(id: id, urlType: .allVideoInfo) { (result : Result<(CinemanaShow , Int) , Error> ) in
            switch (result) {
                    
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    
                case .success((let showInfo, _)) :
                    
                    if (showInfo.kind != .tvShow  ){
                        let showDetail = CinemanaShowDetail(showKind: showInfo.kind, cinemanaShowTVBySeasons: [0 : [showInfo]], showTitle: showInfo.enTitle.trimmingCharacters(in: .whitespacesAndNewlines), seasons: 0, episodes: 0)
                        completionHandler(Result.success(showDetail))
                        
                    }
                    
                    else {
                        
                        self.fetchTVShowEpisodes(id: id) { result in
                            
                            switch (result) {
                                case .failure(let error):
                                    completionHandler(Result.failure(error))
                                    
                                case .success(let cinemanaTVShow) :
                                    var seasons : Set<Int> = []
                                    var episodes : Int  = 0
                                    var cinemanaShowBySeason : [Int : CinemanaTVShow] = [:]
                                    for cinemanaShow in cinemanaTVShow {
                                        seasons.insert(cinemanaShow.seasonNo)
                                        episodes += 1
                                        
                                        if (cinemanaShowBySeason[cinemanaShow.seasonNo] == nil) {
                                            cinemanaShowBySeason[cinemanaShow.seasonNo] = []
                                        }
                                        cinemanaShowBySeason[cinemanaShow.seasonNo]?.append(cinemanaShow)
                                    }
                                    let showDetail = CinemanaShowDetail(showKind: showInfo.kind, cinemanaShowTVBySeasons: cinemanaShowBySeason, showTitle: showInfo.enTitle, seasons: seasons.count, episodes: episodes)
                                    completionHandler(Result.success(showDetail))
                                    
                            }
                            
                        }
                        
                    }
            }
        }
    }
    
    func fetchTVShowEpisodes(id : Int , completionHandler : @escaping (Result<CinemanaTVShow , Error> ) -> Void ) {
        getInfo(id: id, urlType: .tvShow) { (result : Result<(CinemanaTVShow , Int) , Error> ) in
            switch (result) {
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    
                case .success((let showInfo, _)) :
                    
                    completionHandler(Result.success(showInfo))
                    
            }
        }
    }
    
    func fetchShowInfo(id : Int , completionHandler : @escaping (Result<CinemanaShow , Error> ) -> Void ) {
        getInfo(id: id, urlType: .allVideoInfo) { (result : Result<(CinemanaShow , Int) , Error> ) in
            switch (result) {
                case .failure(let error):
                    completionHandler(Result.failure(error))
                    
                case .success((let showInfo, _)) :
                    completionHandler(Result.success(showInfo))
                    
            }
        }
    }
    
    
    func getVideoInfo(id : Int ,  completionHanlder : @escaping (Result<(VideoInfo , Int), Error>) -> Void ) {
        
        getInfo(id: id, urlType: .videoTranscoddedFiles) { (result : Result<(VideoInfo , Int) , Error> ) in
            completionHanlder(result)
        }
    }
    
    func getSkippingDurations(id : Int, completionHanlder : @escaping (Result<(SkippingDurations, Int), Error>) -> Void ) {
        
        getInfo(id: id, urlType: .skippingDurations) { (result : Result<(SkippingDurations, Int), Error>) in
            completionHanlder(result)
        }
    }
    
    //to get translation info and filenames
    func getTranslationInfo(id : Int ,  completionHanlder : @escaping (Result<(Subtitle , Int), Error>) -> Void ){
        getInfo(id : id , urlType: .translationFiles) { ( result : Result<(Subtitle , Int), Error>) in
            completionHanlder(result)
        }
    }
    
    //to get translation info and filenames
    func getSeasons(id : Int ,  completionHanlder : @escaping (Result<(Seasons , Int), Error>) -> Void ){
        getInfo(id : id , urlType: .seasons) { ( result : Result<(Seasons , Int), Error>) in
            completionHanlder(result)
        }
    }
    
    //Generic func to get json file and decode it
    func getInfo<T:Decodable>(id : Int , urlType : URLType ,  completionHanlder : @escaping (Result<(T , Int), Error>) -> Void ) {
        
        let showURL = ShowURLBuilder(id: id).getURL(urlType: urlType)
        var request = URLRequest(url:showURL,timeoutInterval: Double.infinity)
        // request.addValue("ci_session=%2BUCuHyd%2FO6NV00KCHbLRoyxIagvi52WxNDtDMLsoeTx1mLLyPeIEmZIOLJYakeVX4G8QrvLwwj3ixNGd0iFah3%2BuM9DjOerNafMCGk5bv0unhqmU2DjGu5alETNpyKQEqLNGBzMkCq7MfgA2r7aob6nnfHyhJEVJq34x%2B%2BXNV3lSA1GMo4D74XEhio5ZYkbRCrVTLwpUswI4tOe5LqFpGqZyvYKbDKgOfYMYeBvewj0qTfIz7Z6uYnlkTf39cmeDd44PiMKkf9mGzAxT4YowCvS5c6EbxS30u2W7T4rofoc1li9g5vvAnFWWT%2BeLxKbAekQj8GtEPToK2SAUmQhM60bYfgLGzYpm4piJqmZGnmEq6BmeWN1Gnz%2Bx8BE9K8G%2F3e7Pt0i7H4WvTxKPG6jU5v2y9rIwmgVeGIrpJbBhbmpxEZrTboPY1KqZNH%2FD866tvW4%2FNilCH%2Bug3zFxv%2BQvCQ%3D%3D", forHTTPHeaderField: "Cookie")
        
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        request.httpMethod = "GET"
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { infoData, response, error in
            guard error == nil else
                {
                completionHanlder(Result.failure(error!))
                
                return
                }
            
            if let httpRes = response as? HTTPURLResponse {
                let cookies:[HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: httpRes.allHeaderFields as! [String : String], for: httpRes.url!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response?.url!, mainDocumentURL: nil)
                
            }
            if let infoData = infoData {
                
                do {
                    let json = JSONDecoder()
                    
                    let info = try json.decode(T.self, from: infoData)
                    
                    completionHanlder(Result.success((info , id)))
                }
                
                
                catch let DecodingError.dataCorrupted(context) {
                    completionHanlder(Result.failure(context.underlyingError!))
                    
                }
                catch let error {
                    completionHanlder(Result.failure(error))
                    
                }
                  
            }
            
        }
        dataTask.resume()
    }
}


public extension CinemanaShowLoader {
    
    func asyncLoad( code : @escaping () -> Void) {
        
        dispatchGroup.enter()
        dispatchQueue.async { [self] in
            dispatchSemaphore.wait()
            code()
            dispatchGroup.leave()
            dispatchSemaphore.signal()
        }
    }
}
