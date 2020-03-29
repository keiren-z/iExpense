//
//  ContentView.swift
//  iExpense
//
//  Created by Keiren on 3/25/20.
//  Copyright © 2020 keiren. All rights reserved.
//

import SwiftUI

/*
 Identifiable Protocol
 it has only one requirement, which is that there must be a property called id that contains a unique identifier.
 */
struct ExpenseItem: Identifiable, Codable {
    
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
    
}

/**This needs to conform to the ObservableObject protocol, and we’re also going to use @Published to make sure change announcements get sent whenever the items array gets modified*/
class Expenses: ObservableObject {
    
    @Published var items = [ExpenseItem]() {
    
    /*Create an instance of JSONEncoder that will do the work of converting our data to JSON, we ask that to try encoding our items array, and then we can write that to UserDefaults using the key “Items” */
        
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try?
                encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        /* - Create an instance of JSONDecoder, which is the counterpart of JSONEncoder that lets us go from JSON data to Swift objects.
          -  Ask the decoder to convert the data we received from      UserDefaults into an array of ExpenseItem objects.
          -  If that worked, assign the resulting array to items and exit.
          -  Otherwise, set items to be an empty array */
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            
            if let decoded = try?
                decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        
        self.items = []
    }
}

struct ContentView: View {
    /*
     using @ObservedObject here asks SwiftUI to watch the object for any change announcements, so any time one of our @Published properties changes the view will refresh its body
     */
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text("$\(item.amount)")
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(trailing:
               Button(action: {
                 self.showingAddExpense = true
               }) {
                   Image(systemName: "plus")
               }
            )
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: self.expenses)
            }
        }
        
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
