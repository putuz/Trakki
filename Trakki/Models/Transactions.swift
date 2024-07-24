//
//  Transactions.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import Foundation

struct TransactionsResponse: Codable {
    let status: String
    let data: [Transaction]
}

struct Transaction: Codable, Identifiable {
    var id: String
    var user_id: String
    var amount: Int
    var transaction_type: String
    var remarks: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user_id
        case amount
        case transaction_type
        case remarks
        case createdAt
        case updatedAt
    }
}
