//
//  AddSheet.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 21/07/24.
//

import SwiftUI

struct AddSheet: View {
    @ObservedObject private var vm = AddSheetViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            TextField("Amount", text: $vm.amount)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            TextField("Remarks", text: $vm.remarks)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Picker("Transaction Type", selection: $vm.transactionType) {
                Text("Income").tag("income")
                Text("Expense").tag("expense")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if let errorMessage = vm.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let successMessage = vm.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            Button(action: {
                vm.addTransaction()
            }) {
                Text("Add Transaction")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .onReceive(vm.$isTransactionAdded) { isTransactionAdded in
            if isTransactionAdded {
                dismiss()
            }
        }
    }
}

#Preview {
    AddSheet()
}
