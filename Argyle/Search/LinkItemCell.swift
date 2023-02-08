//
//  LinkItemCell.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import UIKit

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

final class LinkItemCellViewModel {
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

final class LinkItemCell: UITableViewCell {
    var viewModel: LinkItemCellViewModel?

    private let placeholderImage = UIImage(systemName: "photo")?.resizeImageTo(size: .init(width: 24, height: 24))
    private let logoBackgroundView = UIImageView()
    private lazy var logoImageView = UIImageView(image: placeholderImage)

    private let nameLabel = UILabel()
    private let kindLabel = UILabel()
    private lazy var labelsStack = UIStackView(arrangedSubviews: [nameLabel, kindLabel])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLogoImageView()
        setupLabelsStack()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelImageRequest()
        logoImageView.image = placeholderImage
    }

    private func setupLogoImageView() {
        logoBackgroundView.backgroundColor = .secondarySystemBackground
        logoBackgroundView.clipsToBounds = true
        logoBackgroundView.layer.cornerRadius = 8

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .label

        contentView.addSubview(logoBackgroundView)
        logoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        logoBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        logoBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        logoBackgroundView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        logoBackgroundView.widthAnchor.constraint(equalToConstant: 75).isActive = true

        logoBackgroundView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.centerYAnchor.constraint(equalTo: logoBackgroundView.centerYAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: logoBackgroundView.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(lessThanOrEqualTo: logoBackgroundView.heightAnchor).isActive = true
        logoImageView.widthAnchor.constraint(lessThanOrEqualTo: logoBackgroundView.widthAnchor).isActive = true
    }

    private func setupLabelsStack() {
        labelsStack.axis = .vertical
        labelsStack.spacing = 8

        nameLabel.font = .systemFont(ofSize: 18)
        nameLabel.numberOfLines = 0

        kindLabel.font = .systemFont(ofSize: 14)
        kindLabel.textColor = .secondaryLabel

        contentView.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        labelsStack.leadingAnchor.constraint(equalTo: logoBackgroundView.trailingAnchor, constant: 16).isActive = true
        labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
    }

    func setup(viewModel: LinkItemCellViewModel) {
        self.viewModel = viewModel

        nameLabel.text = viewModel.item.name
        kindLabel.text = viewModel.item.kind

        viewModel.image { [weak self] image in
            if let image {
                DispatchQueue.main.async {
                    self?.logoImageView.image = image
                }
            }
        }
    }
}

