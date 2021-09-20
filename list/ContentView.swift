//
//  ContentView.swift
//  list
//
//  Created by April Lee on 2021/9/16.
//

import SwiftUI

struct ItemInfo: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

struct MenuItemInfo: Identifiable {
    let id = UUID()
    let title: String
    let tag: Int
}

struct ContentView: View {
    
    @State private var menuItems = [MenuItemInfo(title: "List", tag: 0),
                                    MenuItemInfo(title: "List without separator", tag: 1),
                                    MenuItemInfo(title: "ScrollView + VStact", tag: 2)]

    @State private var items = [ItemInfo(title: "Blue", color: Color.blue),
                                ItemInfo(title: "Yellow", color: Color.yellow),
                                ItemInfo(title: "Red", color: Color.red),
                                ItemInfo(title: "Gray", color: Color.gray)]
    
    
    @State private var selectedTag = 0


    var body: some View {

        NavigationView {
            VStack {
                MenuView(menuItems: $menuItems, selectedTag: $selectedTag)

                switch selectedTag {
                case 0:
                    ListView(items: $items)
                case 1:
                    ListWithoutSeparatorView(items: $items)
                case 2:
                    ScrollViewVStackView(items: $items)
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Color List")
        }
        

    }
}

struct MenuView: View {
    @Binding var menuItems: [MenuItemInfo]
    @Binding var selectedTag: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(menuItems, id: \.id) { menuItem in
                    MenuItemView(title: menuItem.title, tag: menuItem.tag, selectedTag: $selectedTag)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct ListView: View {
    @Binding var items: [ItemInfo]
    
    var body: some View {
        List(items) { item in
           ItemView(title: item.title, color: item.color)
        }
        .refreshable {
            //action
            items.append(ItemInfo(title: "Puple", color: Color.purple))
        }
    }
}

struct ListWithoutSeparatorView: View {
    @Binding var items: [ItemInfo]
    
    var body: some View {
        List(items) { item in
           ItemView(title: item.title, color: item.color)
                .listRowSeparator(.hidden)
        }
        .refreshable {
            //action
            items.append(ItemInfo(title: "Puple", color: Color.purple))
        }
    }
}

struct ScrollViewVStackView: View {
    @Binding var items: [ItemInfo]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(items, id: \.id) { item in
                    ItemView(title: item.title, color: item.color)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .padding(.horizontal, 10)

                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.7))
                        .frame(height: 0.5)
                        .padding(.leading)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ItemView: View {
    
    var title: String
    var color: Color
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 20, height: 20)
            Text(title)
        }
        
    }
}

struct MenuItemView: View {
    let title: String
    let tag: Int
    
    @Binding var selectedTag: Int
    
    var body: some View {
        Button {
            selectedTag = tag
        } label: {
            Text(title)
                .foregroundColor(tag == selectedTag ? .orange : .gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
        }
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(tag == selectedTag ? Color.orange : Color.gray))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
