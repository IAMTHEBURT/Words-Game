//
//  APIProvider.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation

class APIProvider: ObservableObject{
    // MARK: - PROPERTIES
    static let shared = APIProvider()
    
    let server = "https://vin.monster/wordl"
    @Published var message: String = ""
    @Published var showDownloading: Bool = false
    @Published var wordOfTheDay: String = ""
    @Published var wordOfTheDayResponse: WordOfTheDayAPIResponse? = nil
    
    // MARK: - FUNCTIONS
    func getWordOfTheDay(){
        
        let urlString = "\(server)/getWordOfTheDay/"
        guard let url = URL(string: urlString) else {
            //fatalError("Missing URL")
            self.message = "Отсутствует подключение"
            //self.showDownloadProgressView = false
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                self.showDownloading = false
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.showDownloading = false
                print("GET RESPONSE ERROR")
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let decodedResult = try JSONDecoder().decode(WordOfTheDayAPIResponse.self, from: data)
                        self.wordOfTheDayResponse = decodedResult
                        
                        self.showDownloading = false
                    } catch let error {
                        print("Error decoding: ", error)
                        self.showDownloading = false
                    }
                }
            }
            
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
}

