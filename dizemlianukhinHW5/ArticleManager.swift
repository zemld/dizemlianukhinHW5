//
//  ArticleManager.swift
//  dizemlianukhinHW5
//
//  Created by Denis Zemlyanukhin on 20.12.2024.
//

import Foundation
import UIKit

// MARK: - ArticleModel
struct ArticleModel: Decodable {
    var newsId: Int?
    var title: String?
    var announce: String?
    var img: ImageContainer?
    var requestId: String?
    var articleUrl: URL? {
        let requestId = requestId ?? ""
        let newsId = newsId ?? 0
        return URL(string: "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(requestId)")
    }
}

// MARK: - ImageContainer
struct ImageContainer: Decodable {
    var url: URL?
}

// MARK: - NewsPage
struct NewsPage: Decodable {
    // MARK: - Variables
    var news: [ArticleModel]?
    var requestId: String?
    
    // MARK: - Lifecycle
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        requestId = try container.decodeIfPresent(String.self, forKey: .requestId)
        
        news = try container.decodeIfPresent([ArticleModel].self, forKey: .news)
        
        if let requestId = requestId {
            news = news?.map { article in
                var updatedArticle = article
                updatedArticle.requestId = requestId
                return updatedArticle
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case news, requestId
    }
}

protocol ArticleManagerDelegate: AnyObject {
    func didUpdateArticles(_ articles: [ArticleModel])
}

class ArticleManager {
    weak var delegate: ArticleManagerDelegate?

    private var articles: [ArticleModel] = []

    func getArticles() -> [ArticleModel] {
        return articles
    }

    func addArticle(_ article: ArticleModel) {
        articles.append(article)
        delegate?.didUpdateArticles(articles)
    }
}

extension NewsViewController : ArticleManagerDelegate {
    func didUpdateArticles(_ articles: [ArticleModel]) {
        
    }
}
