//
//  ExploreViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var categories: [ChatBotCategory] = ChatBotCategory.allCases
}
