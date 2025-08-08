//
//  MainScreenModel.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation

extension TMDBResponse.Results {
    var posterPathImage: String? {
        get {
            guard let posterPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + posterPath
        }
    }
}
