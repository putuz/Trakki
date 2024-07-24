//
//  AccountView.swift
//  Trakki
//
//  Created by Putut Yusri Bahtiar on 23/07/24.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var viewModel = AccountViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let account = viewModel.account {
                Text(account.name)
                    .font(.system(size: 24, weight: .bold))
                
                Text(account.email)
                    .font(.system(size: 20, weight: .regular))
                    .padding(.bottom)
                
                
                Text("Rp.\(account.balance)")
                    .foregroundStyle(.bgGreen)
                    .font(.system(size: 18, weight: .bold))
                
                Text("Created At: \(DateUtils.formatDateString(account.createdAt) ?? "\(Date.now)")")
            }
        }
    }
}

#Preview {
    AccountView()
}
