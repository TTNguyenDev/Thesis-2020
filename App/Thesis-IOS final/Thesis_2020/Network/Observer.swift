//
//  Observer.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

import Foundation
import Alamofire
import SwiftUI

class Observer : ObservableObject{
    @Published var jokes = [JokesData]()
    @Published var dlResults = [DLResult]()
    
    init() {
        getJokes()
//        getTextWithImage(image: image)
    }
    
    func getJokes(count: Int = 5) {
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
    func getTextWithImage(image: UIImage) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image.jpegData(compressionQuality: 0.1)!, withName: "file" , fileName: "file.jpeg", mimeType: "image/jpeg")
            },
            to: GET_TEXT_URL, method: .post , headers: headers)
            .response { resp in
                switch resp.result {
                case .success(let value):
                    print(String(data: value!, encoding: .utf8)!)
                    
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode([DLResult].self, from: value!)
                    result.forEach { (element) in
                        self.dlResults.append(element)
                    }
                    
                case .failure(let error):
                    print(error)
                    
                    
                }
            }
    }
    
}
