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
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isHidden = true
        
        view.addSubview(webView)
        webView.pinHorizontal(to: view)
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    private func handleMarkAsFavourite() {
        print("Marked as favourite")
    }

    private func handleMarkAsUnread() {
        print("Marked as unread")
    }

    private func handleMoveToTrash() {
        print("Moved to trash")
    }

    private func handleMoveToArchive() {
        print("Moved to archive")
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
                                            self?.handleMarkAsFavourite()
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archive = UIContextualAction(style: .normal,
                                         title: "Archive") { [weak self] (action, view, completionHandler) in
                                            self?.handleMoveToArchive()
                                            completionHandler(true)
        }
        archive.backgroundColor = .systemGreen

        let trash = UIContextualAction(style: .destructive,
                                       title: "Trash") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToTrash()
                                        completionHandler(true)
        }
        trash.backgroundColor = .systemRed

        let unread = UIContextualAction(style: .normal,
                                       title: "Mark as Unread") { [weak self] (action, view, completionHandler) in
                                        self?.handleMarkAsUnread()
                                        completionHandler(true)
        }
        unread.backgroundColor = .systemOrange

        let configuration = UISwipeActionsConfiguration(actions: [trash, archive, unread])

        return configuration
    }
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleManager.getArticles().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = articleManager.getArticles()[indexPath.row]
        print(article)
        cell.configure(article: article)
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
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
