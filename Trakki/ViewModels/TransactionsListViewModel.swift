//
//  TransactionsListViewModel.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import Foundation
import Combine

class TransactionsListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var totalIncome: Int = 0
    @Published var totalExpense: Int = 0
    @Published var expenseComparisonPercentage: Double = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    private var token: String?
    
    init() {
        self.token = UserDefaults.standard.string(forKey: "accessToken")
        fetchTransactions()
    }
    
    func fetchTransactions() {
        guard let token = token else {
            self.errorMessage = "Missing access token"
            return
        }
        
        guard let url = URL(string: "http://localhost:8000/api/transactions/") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: TransactionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.transactions = response.data
                self.calculateTotals()
                self.calculateExpenseComparison()
            }
            .store(in: &cancellables)
    }
    
    private func calculateTotals() {
        var income = 0
        var expense = 0
        
        for transaction in transactions {
            if transaction.transaction_type.lowercased() == "income" {
                income += transaction.amount
            } else if transaction.transaction_type.lowercased() == "expense" {
                expense += transaction.amount
            }
        }
        
        self.totalIncome = income
        self.totalExpense = expense
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        guard let token = token else {
            self.errorMessage = "Missing access token"
            return
        }
        
        guard let url = URL(string: "http://localhost:8000/api/transactions/\(transaction.id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.transactions.removeAll { $0.id == transaction.id }
                self.calculateTotals()
            }
            .store(in: &cancellables)
    }
    
    func deleteTransactions(at offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            deleteTransaction(transaction)
        }
    }
    
    func calculateExpenseComparison() {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let lastMonthStart = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        let lastMonthEnd = calendar.date(byAdding: .day, value: -1, to: DateUtils.startOfMonth(for: currentDate))!
        let thisMonthStart = DateUtils.startOfMonth(for: currentDate)
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let lastMonthExpenses = transactions.filter { transaction in
            if let date = dateFormatter.date(from: transaction.updatedAt),
               transaction.transaction_type.lowercased() == "expense" {
                return date >= lastMonthStart && date <= lastMonthEnd
            }
            return false
        }.reduce(0) { $0 + $1.amount }
        
        let thisMonthExpenses = transactions.filter { transaction in
            if let date = dateFormatter.date(from: transaction.updatedAt),
               transaction.transaction_type.lowercased() == "expense" {
                return date >= thisMonthStart && date <= currentDate
            }
            return false
        }.reduce(0) { $0 + $1.amount }
        
        if lastMonthExpenses > 0 {
            let difference = Double(lastMonthExpenses - thisMonthExpenses)
            expenseComparisonPercentage = (difference / Double(lastMonthExpenses)) * 100
        } else {
            expenseComparisonPercentage = thisMonthExpenses > 0 ? 100 : 0
        }
    }
}
