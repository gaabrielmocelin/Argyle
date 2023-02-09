//
//  LinkItemCell.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import UIKit

final class LinkItemCell: UITableViewCell {
    var presenter: LinkItemCellPresenter?

    private let placeholderImage = UIImage(systemName: "photo")?.resizeImageTo(size: .init(width: 24, height: 24))
    private let logoBackgroundView = UIView()
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
        presenter?.cancelImageRequest()
        logoImageView.image = placeholderImage
    }

    private func setupLogoImageView() {
        logoBackgroundView.backgroundColor = .secondarySystemBackground
        logoBackgroundView.clipsToBounds = true
        logoBackgroundView.layer.cornerRadius = 8

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .label

        contentView.addSubview(logoBackgroundView) { contentView, logoBackgroundView in
            logoBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            logoBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            logoBackgroundView.heightAnchor.constraint(equalToConstant: 75)
            logoBackgroundView.widthAnchor.constraint(equalToConstant: 75)
        }

        logoBackgroundView.addSubview(logoImageView) { logoBackgroundView, logoImageView in
            logoImageView.centerYAnchor.constraint(equalTo: logoBackgroundView.centerYAnchor)
            logoImageView.centerXAnchor.constraint(equalTo: logoBackgroundView.centerXAnchor)
            logoImageView.heightAnchor.constraint(lessThanOrEqualTo: logoBackgroundView.heightAnchor)
            logoImageView.widthAnchor.constraint(lessThanOrEqualTo: logoBackgroundView.widthAnchor)
        }
    }

    private func setupLabelsStack() {
        labelsStack.axis = .vertical
        labelsStack.spacing = 8

        nameLabel.font = .systemFont(ofSize: 18)
        nameLabel.numberOfLines = 0

        kindLabel.font = .systemFont(ofSize: 14)
        kindLabel.textColor = .secondaryLabel

        contentView.addSubview(labelsStack) { contentView, labelsStack in
            labelsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
            labelsStack.leadingAnchor.constraint(equalTo: logoBackgroundView.trailingAnchor, constant: 16)
            labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            labelsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        }
    }

    func setup(presenter: LinkItemCellPresenter) {
        self.presenter = presenter

        nameLabel.text = presenter.item.name
        kindLabel.text = presenter.item.kind

        presenter.image { [weak self] image in
            if let image {
                DispatchQueue.main.async {
                    self?.logoImageView.image = image
                }
            }
        }
    }
}

