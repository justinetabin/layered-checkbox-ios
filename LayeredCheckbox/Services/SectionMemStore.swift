//
//  SectionMemStore.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class SectionMemStore: SectionsStore {
    var sections = [Section]()
    
    func list(completion: ([Section]) -> Void) {
        completion(sections)
    }
    
    func create(section: Section, completion: (Section) -> Void)  {
        sections.append(section)
        completion(section)
    }
}
