//
//  NewsModel.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/17/23.
//

//NewsModel.swift

struct Article: Codable {
    let webUrl: String
    let snippet: String
    let leadParagraph: String
    
    //to match JSON key
    enum CodingKeys: String, CodingKey {
        case webUrl = "web_url"
        case snippet
        case leadParagraph = "lead_paragraph"
    }
}

struct ArticleResponse: Codable {
    let response: Response

    struct Response: Codable {
        let docs: [Article]
    }
}
