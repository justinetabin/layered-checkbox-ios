//
//  SectionsWorker.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class SectionsWorker {
    let sectionStore: SectionsStore
    
    init(sectionStore: SectionsStore) {
        self.sectionStore = sectionStore
    }
    
    func list(completion: ([Section]) -> Void) {
        sectionStore.list(completion: completion)
    }

    func create(section: Section, completion: (Section) -> Void) {
        sectionStore.create(section: section, completion: completion)
    }
}

protocol SectionsStore {
    func list(completion: ([Section]) -> Void)
    func create(section: Section, completion: (Section) -> Void)
}
