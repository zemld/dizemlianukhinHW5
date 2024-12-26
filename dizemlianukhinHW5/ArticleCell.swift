//
//  ArticleCell.swift
//  dizemlianukhinHW5
//
//  Created by Denis Zemlyanukhin on 21.12.2024.
//

import UIKit

final class ArticleCell: UITableViewCell {
    private let articleImage = UIImageView()
    private let articleTitle = UILabel()
    private let articleDescription = UILabel()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func configure(article: ArticleModel) {
        articleTitle.text = article.title
        articleDescription.text = article.announce

        if let imageURL = article.img?.url {
            loadImage(from: imageURL)
        } else {
            articleImage.image = nil
        }
    }

    // MARK: - Private methods
    private func configureUI() {
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        articleDescription.translatesAutoresizingMaskIntoConstraints = false

        articleTitle.font = .boldSystemFont(ofSize: 16)
        articleTitle.numberOfLines = 0
        articleDescription.font = .systemFont(ofSize: 14)
        articleDescription.numberOfLines = 0
        articleImage.contentMode = .scaleAspectFill
        articleImage.clipsToBounds = true

        contentView.addSubview(articleImage)
        contentView.addSubview(articleTitle)
        contentView.addSubview(articleDescription)

        NSLayoutConstraint.activate([
            articleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            articleImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            articleImage.widthAnchor.constraint(equalToConstant: 60),
            articleImage.heightAnchor.constraint(equalToConstant: 60),

            articleTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            articleTitle.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: 8),
            articleTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            articleDescription.topAnchor.constraint(equalTo: articleTitle.bottomAnchor, constant: 4),
            articleDescription.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: 8),
            articleDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            articleDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self?.articleImage.image = image
            }
        }
    }
}
