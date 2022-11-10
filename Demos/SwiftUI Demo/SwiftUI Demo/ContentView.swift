//
//  ContentView.swift
//  SwiftUI Demo
//
//  Created by Darren Ford on 23/7/21.
//

import SwiftUI
import DSFQuickActionBar

struct ContentView: View {

	@State var searchTerm = ""
	@State var visible = false
	@State var showKeyboardShortcuts = false
	@State var selectedFilter: Filter?
	@State var location: QuickActionBarLocation = .screen
	@State var showAllIfNoSearchTerm = true

	@State var singleClickToActivate = false

	var body: some View {
		//Self._printChanges()
		_ = showAllIfNoSearchTerm
		return VStack(spacing: 12) {
			VStack(spacing: 12) {
				Text("SwiftUI Demo for DSFQuickActionBar").font(.title2)

				HStack {
					Button("Show for window") {
						visible = true
						location = .window
					}
					Button("Show for screen") {
						visible = true
						location = .screen
					}
				}

				VStack(alignment: .leading) {
					Toggle(isOn: $showAllIfNoSearchTerm, label: {
						Text("Show all items if search term is empty")
					})
					Toggle(isOn: $showKeyboardShortcuts, label: {
						Text("Show keyboard shortcuts")
					})
					Toggle(isOn: $singleClickToActivate, label: {
						Text("Single click to activate item")
					})
				}

				HStack {
					Text("Current search term:")
					TextField("The search term", text: $searchTerm)
				}
			}
			Divider()
			VStack(spacing: 8) {
				Text("User selected: '\(selectedFilter?.userPresenting ?? "<none>")'")
					.font(.title2)
				Text(selectedFilter?.description ?? "")
			}
			QuickActionBar<Filter, FilterViewCell>(
				location: location,
				visible: $visible,
				showKeyboardShortcuts: showKeyboardShortcuts,
				requiredClickCount: singleClickToActivate ? .single : .double,
				searchTerm: $searchTerm,
				selectedItem: $selectedFilter,
				placeholderText: "Type something (eg. blur)",
				itemsForSearchTerm: { searchTerm, resultsCallback in
					resultsCallback(filters__.search(searchTerm))
				},
				viewForItem: { filter, searchTerm in
					FilterViewCell(filter: filter)
				}
			)
			Spacer()
			.onChange(of: showAllIfNoSearchTerm, perform: { newValue in
				filters__.showAllIfEmpty = newValue
			})
			.onChange(of: selectedFilter) { newValue in
				Swift.print("Selected filter \(newValue?.description ?? "")")
			}
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
