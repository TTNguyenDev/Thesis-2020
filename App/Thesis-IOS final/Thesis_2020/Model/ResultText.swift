//
//  ResultText.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

struct ResultText : Identifiable {
    public var id: Int
    public var text: String
    public var px: Float
    public var py: Float
    public var width: Float
    public var height: Float
}

struct ResultModel : Codable{
    public var type: String
    public var value: [JokesData]
   
}

struct JokesData: Identifiable, Codable {
    public var id: Int
    public var joke: String
    public var categories: [String]
}
