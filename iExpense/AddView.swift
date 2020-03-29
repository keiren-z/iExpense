//
//  AddView.swift
//  iExpense
//
//  Created by Keiren on 3/28/20.
//  Copyright © 2020 keiren. All rights reserved.
//

import SwiftUI

struct AddView: View {
    
    @ObservedObject var expenses: Expenses
    //property called presentationMode attached to the presentation mode variable stored in the app’s environment
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""

    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(AddView.self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            // Button that, when tapped, creates an ExpenseItem out of our properties and adds it to the expenses items.
            .navigationBarItems(trailing:
                Button("Save") {
                    if let actualAmount = Int(self.amount) {
                        let item = ExpenseItem(name: self.name, type: self.type,
                                amount: actualAmount)
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}

struct  AddView_Previews: PreviewProvider {
    static var previews: some View {
         AddView(expenses: Expenses())
    }
}
