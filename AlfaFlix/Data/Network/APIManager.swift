//
//  APIManager.swift
//  AlfaFlix
//
//  Created by Yoga on 08/08/25.
//

import Foundation
import Alamofire
import RxSwift

final class APIManager {
    static let shared = APIManager()
    private let apiReadAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzZmY5NzkxOTYzNGNhYjkyMmMyOTVmMmQ5YjVmZjY0YSIsInN1YiI6IjY0MDk4NTVjZjlhM2ZiMDA3YWZhOTJmYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yzIluEWS7mkD_UtYhRvhd6ZSGYAz-eKa8hAQrxTavPk"
    
    func executeQuery<T> (url: URL, method: HTTPMethod, params: Parameters? = nil) -> Observable<T> where T: Decodable {
        return Observable<T>.create { observer in
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(self.apiReadAccessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
            AF.request(url, method: method, parameters: params, headers: headers).validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
