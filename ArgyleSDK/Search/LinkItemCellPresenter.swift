//
//  LinkItemCellPresenter.swift
//  ArgyleSDK
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import UIKit

final class LinkItemCellPresenter {
    let networkService: NetworkService
    let item: LinkItem

    var requestUUID: UUID?

    init(networkService: NetworkService = RealNetworkService(), item: LinkItem) {
        self.networkService = networkService
        self.item = item
    }

    func image(completion: @escaping (UIImage?) -> Void) {
        guard let logoURL = item.logoURL else {
            completion(nil)
            return
        }

        requestUUID = networkService.request(ImageRequest(baseURL: logoURL)) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }

    func cancelImageRequest() {
        if let requestUUID {
            networkService.cancel(requestUUID: requestUUID)
        }
    }
}
