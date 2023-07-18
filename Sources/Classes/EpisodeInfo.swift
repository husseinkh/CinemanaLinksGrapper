//
//  EpisodeInfo.swift
//  EpisodeInfo
//
//  Created by Hussein Abdulwahid on 19/08/2021.
//
import Foundation

/// It is used to save episodes data into JSON file

struct EpisodeInfoElement  {
    let showName : String
    let episodeNo : String
    let seasonNo : String
    let transcoddedFileName : String?
    let arTranslationFile : String?
    let skippingDurations : SkippingDurations?
}

extension EpisodeInfoElement : Codable {
    
}
typealias EpisodeInfo = [EpisodeInfoElement]
