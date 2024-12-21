//
//  NewsViewController.swift
//  dizemlianukhinHW5
//
//  Created by Denis Zemlyanukhin on 20.12.2024.
//

import UIKit

class NewsViewController: UIViewController {
    
    // MARK: - Variables
    private var tableView: UITableView!
    private var articles: [ArticleModel] = []
    private var articleManager: ArticleManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        configureArticleManager()
    }

    // MARK: - Private methods
    private func configureTable() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureArticleManager() {
        articleManager = ArticleManager()
        articleManager.delegate = self
        articles = articleManager.getArticles()
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title
        return cell
    }
    
    
}
