//
//  NewsViewController.swift
//  dizemlianukhinHW5
//
//  Created by Denis Zemlyanukhin on 20.12.2024.
//

import UIKit
import WebKit

final class NewsViewController: UIViewController {
    // MARK: - Variables
    private var tableView: UITableView!
    private var articleManager: ArticleManager!
    private var webView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }

    // MARK: - Private methods
    private func configureUI() {
        configureArticleManager()
        configureTable()
        configureWebView()
        // webView.load(URLRequest(url: articleManager.getArticles())
    }
    
    private func configureTable() {
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
         
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func configureArticleManager() {
        articleManager = ArticleManager()
        articleManager.delegate = self
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        webView.pinHorizontal(to: view)
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleManager.getArticles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        guard cell is ArticleCell else { return cell }
        let article = articleManager.getArticles()[indexPath.row]
        cell.textLabel?.text = article.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleUrl = articleManager.getArticles()[indexPath.row].articleUrl else { return }
        let request = URLRequest(url: articleUrl)
        webView.load(request)
        webView.isHidden = false
    }
}

// MARK: - ArticleManagerDelegate
extension NewsViewController : ArticleManagerDelegate {
    func didUpdateArticles(_ articles: [ArticleModel]) {
        DispatchQueue.main.async {
            self.articleManager.updateArticles(articles)
        }
    }
}
