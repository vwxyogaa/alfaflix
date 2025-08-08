//
//  BaseViewModel.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import RxSwift

class BaseViewModel {
    // MARK: - Properties
    let isLoading = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String?>()
    
    // MARK: - Methods
    func setLoading(loading: Bool = false) {
        isLoading.onNext(loading)
    }
    
    func setError(message: String?) {
        errorMessage.onNext(message)
    }
}
