//
//  ArticlePresenter.swift
//  Bible App
//
//  Created by webwerks on 14/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

protocol ArticleDelegate: class {
    func didGetArticlesFailed(error: ErrorObject)
    func didGetArticles(articles: [ArticleModel])
    func didGetUpdateArticle(value:Bool)
}

class ArticlePresenter {
    
    private let articleService: ArticleService?
    weak var articleDelegate: ArticleDelegate?
    
    init(articleService: ArticleService) {
        self.articleService = articleService
    }
    
    func showArticles() {
        articleService?.getArticle(callBack: { [weak self] (articleList, error) in
            if let error = error {
                self?.articleDelegate?.didGetArticlesFailed(error: error)
            } else {
                if let articleList = articleList {
//                    let article = articleList.filter({ $0.markAsReadStatus != 1})
//                    if article.count == 0{
//                        articleService?.updateMarkAsReadToZero()
//                        self.articleDelegate?.didGetArticles(articles:articleList)
//                    }else{
                    self?.articleDelegate?.didGetArticles(articles: articleList)
//                    }
                    
                }
            }
        })
    }
    func setUpdateArticle(articleId:Int){
        articleService?.updateMarkAsReadStatus(articleId: articleId, complition: { value in
            if let boolValue = value{
            articleDelegate?.didGetUpdateArticle(value:boolValue)
            }
        })
    }
    func resetArticleTableByMonth(){
        articleService?.resetArticleTableByMonth()
    }
}
