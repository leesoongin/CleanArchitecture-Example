//
//  AppDIContainer.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/26/24.
//

import Foundation
import Swinject

final class AppDIContainer {
    static let shared = AppDIContainer()
    private let container = Container()

    private let searchContainer: SearchDIContainer

    private init() {
        searchContainer = SearchDIContainer(
            parentContainer: container
        )
    }

    func resolveSearchModule<Service>(_ serviceType: Service.Type) -> Service {
        return searchContainer.resolve(serviceType)
    }
}
