//
//  TMDBResponse.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation

struct TMDBResponse: Codable {
    let dates: Dates?
    let results: [Results]?
    let totalPages, totalResults, page: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case page
    }
    
    struct Dates: Codable {
        let maximum, minimum: String?
    }
    
    struct Results: Codable {
        let genreIDS: [Int]?
        let adult: Bool?
        let backdropPath: String?
        let id: Int?
        let originalTitle: String?
        let voteAverage, popularity: Double?
        let posterPath, overview, title: String?
        let originalLanguage: String?
        let voteCount: Int?
        let releaseDate: String?
        let video: Bool?
        
        enum CodingKeys: String, CodingKey {
            case genreIDS = "genre_ids"
            case adult
            case backdropPath = "backdrop_path"
            case id
            case originalTitle = "original_title"
            case voteAverage = "vote_average"
            case popularity
            case posterPath = "poster_path"
            case overview, title
            case originalLanguage = "original_language"
            case voteCount = "vote_count"
            case releaseDate = "release_date"
            case video
        }
    }
}
