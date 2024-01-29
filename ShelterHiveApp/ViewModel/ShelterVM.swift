//
//  ShelterVM.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/21/23.
//
// Description:
// The ShelterVM (ViewModel) is responsible for handling the Yelp Fusion API call to get shelter data
//Contains published properties for the ShelterModel and the first five businesses retrieved from the Yelp API.

import Foundation

class ShelterVM: ObservableObject {
    
    //publihsed vars for for the shelter Model and the first five Shelters
    @Published var shelterModel: ShelterModel?
    @Published var firstFiveBusinesses: [Business] = []

    //apiKey provided Yelp Developer
    let apiKey = "16mXpSIdoy3LqaRvCeXTln5LoeOCzZLb12yqqumJBoxrydPC8NQWuoC5vOleCV52jFqXvCLMvife0zNFPzqNYrsQ9RT6QHVcCgc7XOgjTRRNGOp1hI2cj9Sn6MkUZXYx"
    
    let baseUrl = "https://api.yelp.com/v3/businesses/search"
    
    //func to search for the businesses(shelters), uses queryParams from the SearchShelter View
    func searchShelters(latitude: Double, longitude: Double, term: String, completion: @escaping (Result<ShelterModel, Error>) -> Void) {
        
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        //query paramters for the API request to add to baseUrl to narrow search
        let queryParams = [
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "term": term,
            "sort_by": "best_match",
            "limit": "20"
        ]
        
        //conjugates params with baseUrl
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let request = NSMutableURLRequest(url: urlComponents.url!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        //creates URL session
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                    do {
                        //debug print statement
                        if let jsonString = String(data: data!, encoding: .utf8) {
                            let truncatedString = String(jsonString.prefix(3000))
                                print("JSON: \(truncatedString)")
                        }
                        //decodes JSON data for ShelterModel
                        let shelterModel = try JSONDecoder().decode(ShelterModel.self, from: data!)
                        completion(.success(shelterModel))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: nil)))
                }
            }
        }
        
        dataTask.resume()
    }
}
