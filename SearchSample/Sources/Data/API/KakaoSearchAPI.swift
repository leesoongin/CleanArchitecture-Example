//
//  KakaoSearchAPI.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation
import Moya

enum KakaoSearchAPI {
    case fetchImages(request: SearchRequestDTO)
    case fetchVideos(request: SearchRequestDTO)
}

extension KakaoSearchAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://dapi.kakao.com/v2/search")!
    }
    
    var path: String {
        switch self {
        case .fetchImages:
            return "/image"
        case .fetchVideos:
            return "/vclip"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchImages:
            return .get
        case .fetchVideos:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchImages(let request):
            let parameters = try? request.asDictionary()
            
            return .requestParameters(
                parameters: parameters ?? [:],
                encoding: URLEncoding.default
            )
        case .fetchVideos(let request):
            let parameters = try? request.asDictionary()
            
            return .requestParameters(
                parameters: parameters ?? [:],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        ["Authorization": "KakaoAK 98634f607f168cd84f9a5450e200f876"]
    }
}
