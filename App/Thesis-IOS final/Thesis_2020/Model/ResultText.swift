//
//  ResultText.swift
//  Thesis_2020
//
//  Created by Triet Nguyen on 10/12/20.
//

struct DLResult : Identifiable, Codable {
    public var id: Int
    public var px: Float
    public var py: Float
    public var width: Float
    public var height: Float
    public var accuracy: Float
    public var name: String
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
