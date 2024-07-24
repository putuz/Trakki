//
//  TransactionsDetailView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import SwiftUI

struct TransactionsDetailView: View {
    @ObservedObject var viewModel: TransactionsDetailViewModel
    
    var body: some View {
        VStack {  // Added spacing between VStack elements
            TextField("Remarks", text: $viewModel.transaction.remarks)
                .padding()
                .frame(height: 60)  // Increased height
                .frame(maxWidth: .infinity)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 18))  // Increased font size
            
            TextField("Amount", value: $viewModel.transaction.amount, formatter: NumberFormatter())
                .padding()
                .frame(height: 60)  // Increased height
                .frame(maxWidth: .infinity)
                .textFieldStyle(.roundedBorder)
                .disabled(true)
                .font(.system(size: 18))  // Increased font size
            
            Button(action: {
                viewModel.updateTransaction()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TransactionsDetailView(viewModel: TransactionsDetailViewModel(transaction: Transaction(id: "example", user_id: "example", amount: 100, transaction_type: "example income", remarks: "example salary", createdAt: "2024-07-21T10:19:55.432Z", updatedAt: "2024-07-21T10:19:55.432Z")))
}
