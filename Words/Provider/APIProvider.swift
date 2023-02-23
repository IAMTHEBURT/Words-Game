//
//  APIProvider.swift
//  Words
//
//  Created by Иван Львов on 11.12.2022.
//

import Foundation
import SwiftUI



struct ServerGameSessionModel: Codable{
    let type: String
    let word: String
    let UID: String
    let result: Int
    let filled_lines: Int
    let duration: Int
}

struct SaveCommentModel: Codable{
    let word: String
    let text: String
    let UID: String
}

struct TopElement: Codable{
    let nickname: String
    let points: Int
    let isPlayer: Bool
    let position: Int
}

struct CommentsRequestModel: Codable{
    let word: String
    let UID: String
}


struct WordstatModel: Codable{
    let word: String
    let won: Int
    let lost: Int
    let averageDuration: Double
    let averageLines: Double
    
    var wonPercent: Int {
        if won == 0 { return 0 }
        return (won + lost) / won * 100
    }
    
    var lostPercent: Int {
        if won == 0 { return 0 }
        return (won + lost) / won * 100
    }
    
}

class APIProvider: ObservableObject{
    // MARK: - PROPERTIES
    static let shared = APIProvider()
    
    @AppStorage("UID") private var UID: String = ""
    
    //let server = "http://localhost"
    let server = "http://193.187.96.70"
    @Published var message: String = ""
    @Published var showDownloading: Bool = false
    @Published var wordOfTheDay: String = ""
    @Published var wordOfTheDayResponse: WordOfTheDayResponse? = nil
        
    @Published var topList: [TopElement] = []
    @Published var points: Int = 0
    @Published var comments: [Comment] = []
    
    @Published var savedComment: Comment?
    @Published var updatedComment: Comment?
    
    @Published var isCommentSaved: Bool? = nil
    @Published var messageToDevelopersHasBeenSent: Bool = false
    @Published var wordstat: WordstatModel? = nil
    
    init(){
        if UID == "" { UID = UUID().uuidString }
    }
    
    // MARK: - FUNCTIONS
    
    
    // MARK: - GET STATISTICS ABOT THIS WORD
    func getWordstat(word: String){
        wordstat = nil
        
        guard let encoded = try? JSONEncoder().encode([ "word": word, "UID": UID ]) else {
            print("Failed to encode order")
            //interactionController.showDownloading = false
            return
        }
        
        print(String(data: encoded, encoding: .utf8)!)
        
        let urlString = "\(server)/api/wordstat/"
        
        print(word)
        print(urlString)
        guard let url = URL(string: urlString) else {
            //fatalError("Missing URL")
            //self.message = "Отсутствует подключение"
            print("Отсутствует подключение")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("GET RESPONSE ERROR")
                return
            }
            
            if response.statusCode == 200 || response.statusCode == 201{
                DispatchQueue.main.async {
                    guard let data = data else {
                        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    
                    do {
                        print("Статистика получена")
                        let decodedResult = try JSONDecoder().decode(WordstatModel.self, from: data)
                        self.wordstat = decodedResult
                    } catch let error {
                        print("Error: ", error)
                    }
                }
            }
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
        
           
    }
    
    // MARK: - SEND MESSAGE TO DEVELOPERS
    func sendMessage(message: String) {
        //interactionController.showDownloading = true
        
        guard let encoded = try? JSONEncoder().encode(["message": "\(UID) \(message)"]) else {
            print("Failed to encode order")
            //interactionController.showDownloading = false
            return
        }
        
        print(String(data: encoded, encoding: .utf8)!)
        
        guard let url = URL(string: "https://vin.monster/minute/message/") else {
            print("Отсутствует подключение")
            //interactionController.showDownloading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        print(encoded)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            if let error = error {
                print("Request error: ", error)
                //self.interactionController.showDownloading = false
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("GET RESPONSE ERROR")
                //self.interactionController.showDownloading = false
                return
            }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedResult = try JSONDecoder().decode(Bool.self, from: data)
                        print(decodedResult)
                        
                        //self.interactionController.showDownloading = false
                        
                        withAnimation(.easeInOut(duration: 1)){
                            self.messageToDevelopersHasBeenSent = true
                        }
                        
                    } catch let error {
                        //self.interactionController.showDownloading = false
                        print("Error decoding: ", error)
                    }
                }
            }
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
    
    func addReaction(type: ReactionType, comment_id: Int){
        updatedComment = nil
        let reaction = Reaction(type: type, UID: UID, comment_id: comment_id)
        
        let urlString = "\(server)/api/reactions/"
        
        guard let url = URL(string: urlString) else {
            //fatalError("Missing URL")
            //self.message = "Отсутствует подключение"
            print("Отсутствует подключение")
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(reaction) else {
            print("Failed to encode order")
            return
        }
        
        print(String(data: encoded, encoding: .utf8)!)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("GET RESPONSE ERROR")
                return
            }
            
            if response.statusCode == 200 || response.statusCode == 201{
                DispatchQueue.main.async {
                    guard let data = data else {
                        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    
                    do {
                        print("Комментарий сохранен")
                        let decodedResult = try JSONDecoder().decode(Comment.self, from: data)
                        self.updatedComment = decodedResult
                        print(decodedResult)
                        
                    } catch let error {
                        print("Error: ", error)
                    }
                }
            }
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
    
    
    func getComments(word: String){
        
        let urlString = "\(server)/api/getcomments/"
        
        guard let url = URL(string: urlString) else {
            //fatalError("Missing URL")
            //self.message = "Отсутствует подключение"
            print("Отсутствует подключение")
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(CommentsRequestModel(word: word, UID: self.UID)) else {
            print("Failed to encode order")
            return
        }
        
        print(String(data: encoded, encoding: .utf8)!)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("GET RESPONSE ERROR")
                return
            }
            
            if response.statusCode == 200 || response.statusCode == 201{
                DispatchQueue.main.async {
                    guard let data = data else {
                        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    
                    do {
                        print("Комментарии получены")
                        let decodedResult = try JSONDecoder().decode([Comment].self, from: data)
                        withAnimation {
                            self.comments = decodedResult
                        }
                        
                        print(decodedResult)
                        
                    } catch let error {
                        print("Error: ", error)
                    }
                }
            }
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
        
    }
    
    func saveComment(word: String, text: String){
        isCommentSaved = nil
        
        
        let comment = SaveCommentModel(word: word, text: text, UID: UID)
        
        let urlString = "\(server)/api/comments/"
        guard let url = URL(string: urlString) else {
            //fatalError("Missing URL")
            //self.message = "Отсутствует подключение"
            print("Отсутствует подключение")
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(comment) else {
            print("Failed to encode order")
            return
        }
        
        print(String(data: encoded, encoding: .utf8)!)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("GET RESPONSE ERROR")
                return
            }
            
            if response.statusCode == 200 || response.statusCode == 201{
                DispatchQueue.main.async {
                    guard let data = data else {
                        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    do {
                        print("Комментарий сохранен")
                        let decodedResult = try JSONDecoder().decode(Comment.self, from: data)
                        self.savedComment = decodedResult
                        print(decodedResult)
                        self.getComments(word: word)
                        self.isCommentSaved = true
                        
                    } catch let error {
                        print("Error: ", error)
                    }
                }
            }
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
    
    func getPoints(){
        let urlString = "\(server)/api/getPoints/\(UID)"
        
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
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
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
                        let decodedResult = try JSONDecoder().decode(Int.self, from: data)
                        self.points = decodedResult
                        print("Points \(decodedResult)")
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
            
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
    
    func getTopList(){
        let urlString = "\(server)/api/top/\(UID)"
        
        guard let url = URL(string: urlString) else {
            //fatalError("Missing URL")
            //self.message = "Отсутствует подключение"
            print("Отсутствует подключение")
            //self.showDownloadProgressView = false
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
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
                        let decodedResult = try JSONDecoder().decode( [TopElement].self , from: data)
                        self.topList = decodedResult
                        
                        print("ТОП ЛИСТ")
                        print(decodedResult)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
            
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
    
    func saveTheGame(game: GameHistoryModel){
        let serverGameSessionModel = ServerGameSessionModel(type: game.gameType.name, word: game.word, UID: UID, result: game.result.rawValue, filled_lines: game.tries, duration: game.duration)
        
        let urlString = "\(server)/api/games/"
        guard let url = URL(string: urlString) else {
            //fatalError("Missing URL")
            //self.message = "Отсутствует подключение"
            print("Отсутствует подключение")
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(serverGameSessionModel) else {
            print("Failed to encode order")
            return
        }
        
        print(String(data: encoded, encoding: .utf8)!)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // handle the result here.
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("GET RESPONSE ERROR")
                return
            }
            
            if response.statusCode == 200 || response.statusCode == 201{
                DispatchQueue.main.async {
                    do {
                        print("Игровая сессия. Успешно сохранена")
                    } catch let error {
                        print("Error: ", error)
                    }
                }
            }
            print(url)
            print("STATUS CODE \(response.statusCode)")
        }.resume()
    }
    
    
    
    func getWordOfTheDay(){
        
        let urlString = "\(server)/api/dailyword"
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
                //self.showDownloading = false
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                //self.showDownloading = false
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
                        let decodedResult = try JSONDecoder().decode(WordOfTheDayResponse.self, from: data)
                        self.wordOfTheDayResponse = decodedResult
                        print("Слово дня")
                        print(decodedResult)
                        
                        //Записываем в базу
                        let dailyWord = DailyWordDBM(context: CoreDataProvider.shared.viewContext)
                        dailyWord.word = decodedResult.word
                        dailyWord.active_at = Int64(decodedResult.active_at)
                        dailyWord.next_at = Int64(decodedResult.next_at)
                        dailyWord.save()
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
