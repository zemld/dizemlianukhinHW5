//
//  ArticleManager.swift
//  dizemlianukhinHW5
//
//  Created by Denis Zemlyanukhin on 20.12.2024.
//

import UIKit

// MARK: - ArticleModel
struct ArticleModel {
    let title: String
    let content: String
    let date: Date
}

// MARK: - ArticleManagerDelegate
protocol ArticleManagerDelegate: AnyObject {
    func didUpdateArticles(_ articles: [ArticleModel])
}

// MARK: - ArticleManager
class ArticleManager {
    // MARK: - Variables
    weak var delegate: ArticleManagerDelegate?

    private var articles: [ArticleModel] = []

    // MARK: - Methods
    func getArticles() -> [ArticleModel] {
        return articles
    }

    func addArticle(_ article: ArticleModel) {
        articles.append(article)
        delegate?.didUpdateArticles(articles)
    }
}

// MARK: - ArticleManagerDelegate
extension NewsViewController: ArticleManagerDelegate {
    func didUpdateArticles(_ articles: [ArticleModel]) {
        
    }
}
