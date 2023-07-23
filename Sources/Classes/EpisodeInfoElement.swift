//
//  EpisodeInfo.swift
//  EpisodeInfo
//
//  Created by Hussein Abdulwahid on 19/08/2021.
//
import Foundation

/// It is used to save episodes data into JSON file

public struct EpisodeInfoElement : Codable  {
    //let showName : String
    let episodeNo : Int
   // let seasonNo : Int
    let transcoddedFileName : String?
    let arTranslationFile : String?
    let skippingDurations : SkippingDurations?
}

//  extension EpisodeInfoElement : Codable {
    
// }
//public typealias EpisodesInfo = [EpisodeInfoElement]

public struct SeasonInfo : Codable  {
    let showName : String
    let seasonNo : Int
    let episode :[EpisodeInfoElement]
}