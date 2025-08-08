//
//  MovieInfoScreenModel.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation

extension CreditsResponse.Cast {
    var profilePathImage: String? {
        get {
            guard let profilePath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + profilePath
        }
    }
}

extension ReviewsResponse.Result.AuthorDetails {
    var avatarPathImage: String? {
        get {
            guard let avatarPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + avatarPath
        }
    }
}
