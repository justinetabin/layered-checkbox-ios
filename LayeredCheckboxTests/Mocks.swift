//
//  Mocks.swift
//  LayeredCheckboxTests
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
@testable import LayeredCheckbox

class MockSectionStore: SectionsStore {
    var sections: [Section]
    
    init() {
        sections = [
            Section(title: "ABC123", items: [
                Item(title: "ABC123", subtitle: "DEF"),
                Item(title: "ABC123", subtitle: "DEF"),
                Item(title: "ABC123", subtitle: "DEF"),
            ]),
            Section(title: "DSA321", items: [
                Item(title: "DSA321", subtitle: "DEF"),
                Item(title: "DSA321", subtitle: "DEF"),
                Item(title: "DSA321", subtitle: "DEF"),
            ])
        ]
    }
    
    func list(completion: ([Section]) -> Void) {
        completion(sections)
    }
    
    func create(section: Section, completion: (Section) -> Void) {
        sections.append(section)
        completion(section)
    }
    
}
