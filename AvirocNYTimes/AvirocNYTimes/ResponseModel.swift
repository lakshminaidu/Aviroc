//
//  ResponseModel.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 8/4/2022.
//

import Foundation

// MARK: - Welcome
struct ResponseModel: Codable {
    var status, copyright: String?
    var numResults: Int?
    var results: [News]?

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}


// MARK: - Result
struct News: Codable {
    var url: String?
    var source: String?
    var title: String?
    var abstract: String?
    var media: [Media]?
    var publishedDate: String?
    var byline: String?
    enum CodingKeys: String, CodingKey {
        case url
        case source
        case publishedDate = "published_date"
        case title, abstract
        case media
        case byline
    }
    
    var thumbnailUrl: String? {
        return media?.first?.mediaMetadata?.first?.url
    }
    var largeUrl: String? {
        return media?.first?.mediaMetadata?.last?.url
    }
}

// MARK: - Media
struct Media: Codable {
    var type: MediaType?
    var subtype: Subtype?
    var caption, copyright: String?
    var approvedForSyndication: Int?
    var mediaMetadata: [MediaMetadatum]?

    enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}

// MARK: - MediaMetadatum
struct MediaMetadatum: Codable {
    var url: String?
    var format: Format?
    var height, width: Int?
}

enum Format: String, Codable {
    case mediumThreeByTwo210 = "mediumThreeByTwo210"
    case mediumThreeByTwo440 = "mediumThreeByTwo440"
    case standardThumbnail = "Standard Thumbnail"
}

enum Subtype: String, Codable {
    case photo = "photo"
}

enum MediaType: String, Codable {
    case image = "image"
}
