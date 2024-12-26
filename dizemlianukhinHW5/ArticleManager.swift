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
    
    mutating func passTheRequestId() {
        for i in 0..<(news?.count ?? 0) {
            news?[i].requestId = requestId
        }
    }
}

// MARK: - ArticleManagerDelegate
protocol ArticleManagerDelegate: AnyObject {
    func didUpdateArticles(_ articles: [ArticleModel])
}

// MARK: - ArticleManager
final class ArticleManager {
    // MARK: - Variables
    weak var delegate: ArticleManagerDelegate?

    private var articles: [ArticleModel] = []
    private let decoder: JSONDecoder = JSONDecoder()
    private var newsPage: NewsPage = NewsPage()

    // MARK: - Lifecycle
    init() {
        fetchNews(completion: updateArticles)
    }
    
    // MARK: - Methods
    func getArticles() -> [ArticleModel] {
        return articles
    }

    func addArticle(_ article: ArticleModel) {
        articles.append(article)
        delegate?.didUpdateArticles(articles)
    }
    
    func updateArticles(_ articles: [ArticleModel]) {
        self.articles = articles
        delegate?.didUpdateArticles(articles)
    }
    
    private func getURL(_ rubric: Int, _ pageIndex: Int) -> URL? {
        let url = "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)"
        return URL(string: url)
    }
    
    // MARK: - Fetch news
    private func fetchNews(completion: @escaping ([ArticleModel]) -> Void) {
        guard let url = getURL(4, 1) else {
            completion([])
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print(error)
                completion([])
                return
            }
            if
                let self = self,
                let data = data,
                var newsPage = try? decoder.decode(NewsPage.self, from: data)
            {
                DispatchQueue.main.async {
                    newsPage.passTheRequestId()
                    self.newsPage = newsPage
                    completion(newsPage.news ?? [])
                }
            }
        }.resume()
    }
}
