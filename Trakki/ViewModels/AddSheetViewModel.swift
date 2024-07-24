//
//  AddSheetViewModel.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import Foundation
import Combine

class AddSheetViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var remarks: String = ""
    @Published var transactionType: String = "expense"
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isTransactionAdded: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func addTransaction() {
        guard let amountInt = Int(amount) else {
            errorMessage = "Amount must be a valid number."
            return
        }
        
        if amountInt < 0 {
            errorMessage = "Amount must not be negative."
            return
        }
        
        if remarks.count < 5 {
            errorMessage = "Remarks must be at least 5 characters long."
            return
        }
        
        let transaction = Add(amount: amountInt, remarks: remarks, transactionType: transactionType)
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            errorMessage = "User not logged in."
            return
        }
        
        let urlString: String
        if transactionType == "expense" {
            urlString = "http://localhost:8000/api/transactions/addExpense"
        } else {
            urlString = "http://localhost:8000/api/transactions/addIncome"
        }
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(transaction)
        } catch {
            errorMessage = "Failed to encode transaction."
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    let response = result.response as? HTTPURLResponse
                    throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: "Failed with status code: \(response?.statusCode ?? -1)"])
                }
                return result.data
            }
            .decode(type: [String: String].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to add transaction: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.successMessage = response["message"]
                self.amount = ""
                self.remarks = ""
                self.isTransactionAdded = true
            })
            .store(in: &cancellables)
    }
}
