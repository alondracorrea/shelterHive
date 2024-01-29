//
//  NewsVM.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/17/23.
//
// Description:
// The NewsVM (ViewModel) manages Article data and makes call to New York Times API for article data.

import Foundation

class NewsVM: ObservableObject {
    //published var for array of Articles for articles retrieved
    @Published var articles: [Article] = []
    //api key
    let apiKey = "BdFhNpWvsD7YAmumZ4TgsbGXWrM5GXHB"
    
    //function to search for news articles using the New York Times API
    func searchArticles(query: String) {
        guard let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=\(query)&sort=newest&api-key=\(apiKey)")
        else {
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                   
                    //before decode
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON: \(jsonString.prefix(1000))")
                    }
                    //decodes JSON data
                    let result = try JSONDecoder().decode(ArticleResponse.self, from: data)
                    
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    //debug statement
                    if let jsonData = try? encoder.encode(result) {
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            print(jsonString.prefix(1000)) // limited for rn so I can read what im getting from json
                        }
                    }
                    
                    //updates ViewModel Articles
                    DispatchQueue.main.async {
                        self.articles = result.response.docs
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

