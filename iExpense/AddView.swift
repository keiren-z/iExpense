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
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
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
                    self.validate()
                    if let actualAmount = Int(self.amount) {
                        let item = ExpenseItem(name: self.name, type: self.type,
                                amount: actualAmount)
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            )
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func validate() {
        
        let varName = name
        let varAmount = amount.trimmingCharacters(in: .whitespacesAndNewlines)
       
        guard !varName.isEmpty  else {
            wordError(title: "Warning", message: "Name is empty")
            return
        }
        
        guard !varAmount.isEmpty  else {
            wordError(title: "Warning", message: "Amount is empty")
            return
        }
        
        guard isValidNumber(text: varAmount) else {
            wordError(title: "Warning", message: "Invalid amount")
            return
        }
    }
    
    func isValidNumber(text: String) -> Bool{
        let regex = "^[0-9]*$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: text)
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct  AddView_Previews: PreviewProvider {
    static var previews: some View {
         AddView(expenses: Expenses())
    }
}
