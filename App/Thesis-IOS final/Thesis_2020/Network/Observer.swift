//
//  Observer.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import Foundation
import Alamofire

class Observer : ObservableObject{
    @Published var jokes = [JokesData]()
    
    init() {
        getJokes()
    }
    
    func getJokes(count: Int = 5)
    {
        AF.request("http://api.icndb.com/jokes/random/\(count)").responseData { (response) in
            switch response.result {
            case .success(let value):
                print(String(data: value, encoding: .utf8)!)
                
                let decoder = JSONDecoder()
                let result = try! decoder.decode(ResultModel.self, from: value)
                self.jokes.append(contentsOf: result.value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
