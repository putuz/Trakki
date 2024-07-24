//
//  Account.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 23/07/24.
//

import Foundation

struct AccountResponse: Codable {
    let status: String
    let data: AccountData
    let transactions: [Transaction]
}

struct AccountData: Codable {
    let _id: String
    let name: String
    let email: String
    let balance: Int
    let createdAt: String
    let updatedAt: String
}
