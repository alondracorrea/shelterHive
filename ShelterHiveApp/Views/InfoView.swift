//
//  InfoView.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/17/23.
//
// Description: New York Times API: User picks a topic and api returns the 5 most recent news articles on the chosen topic.
//limit of 500 calls

import SwiftUI

struct InfoView: View {
    //manages news data
    @ObservedObject var newsViewModel = NewsVM()
    
    //default state variable for news topic
    @State var newsQuery: String = "Domestic Abuse"
    
    //news topic choices
    var newsOptions: [String] = ["Homelessness","Domestic Abuse","Veterans","Refugees","Animal Cruelty"]
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Latest News")
                    .fontWeight(.bold)
                    .font(.system(size: 50))
                Text("Stay up to date.")
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                //picker tool for news topic
                Picker("Topics", selection: $newsQuery) {
                    ForEach(newsOptions, id: \.self) { newsQuery in
                        Text("\(newsQuery)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                //Button calls news VM function to search articles
                Button("Search") {
                    print("searching")
                    newsViewModel.searchArticles(query: newsQuery)
                }
                .padding()
                .frame(width: 100)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yellow)
                )
                .foregroundColor(.black)
                //displays news articles
                List(newsViewModel.articles.prefix(6), id: \.webUrl) { article in
                    VStack(alignment: .leading) {
                        Text("Snippet: \(article.snippet)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("URL: \(article.webUrl)")
                            .font(.subheadline)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .padding()
            .background(Color.gray.ignoresSafeArea())
        }
    }
}

#Preview {
    InfoView()
}
