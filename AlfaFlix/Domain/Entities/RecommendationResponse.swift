//
//  RecommendationResponse.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation

struct RecommendationsResponse: Codable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    struct Result: Codable {
        let adult: Bool?
        let backdropPath: String?
        let id: Int?
        let title, originalLanguage, originalTitle, overview: String?
        let posterPath: String?
        let mediaType: MediaType?
        let genreIDS: [Int]?
        let popularity: Double?
        let releaseDate: String?
        let video: Bool?
        let voteAverage: Double?
        let voteCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case id, title
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case posterPath = "poster_path"
            case mediaType = "media_type"
            case genreIDS = "genre_ids"
            case popularity
            case releaseDate = "release_date"
            case video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
        
        enum MediaType: String, Codable {
            case movie = "movie"
        }
    }
}
