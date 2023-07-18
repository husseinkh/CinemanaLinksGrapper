//
//  CinemanaShowInfo.swift
//  CinemanaShow
//
//  Created by Hussein Abdulwahid on 29/09/2021.
//

import Foundation


public struct CinemanaShowDetail {
    let showKind : ShowKind
    var cinemanaShowTVBySeasons : [Int : CinemanaTVShow]
    let showTitle : String
    let seasons : Int
    let episodes :Int
    
    
    init(showKind : ShowKind , cinemanaShowTVBySeasons : [Int : CinemanaTVShow] , showTitle : String, seasons : Int, episodes : Int) {
        self.showKind = showKind
        self.cinemanaShowTVBySeasons = cinemanaShowTVBySeasons
        self.showTitle = showTitle
        self.seasons = seasons
        self.episodes = episodes
    }
    
    var filmShow : CinemanaShow? {
        if (showKind == .film) {
            return cinemanaShowTVBySeasons[0]?.first
        }
        else {
            return nil
        }
    }
    
    
    
    
}
