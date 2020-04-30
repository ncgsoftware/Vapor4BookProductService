//
//  File.swift
//  
//
//  Created by Jeremy Nelson on 4/29/20.
//

import Vapor

struct ProductResponse: Content {
    let id: Int
    let name: String
    let description: String
    let price: Int
}
