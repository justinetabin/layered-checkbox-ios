//
//  DependencyWorker.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol ViewControllerFactory {
    func makeListSections() -> ListSectionsViewController
}

protocol WorkerFactory {
    func makeSectionsWorker() -> SectionsWorker
}

class DependencyWorker {
    let sectionStore: SectionsStore
    
    init(sectionStore: SectionsStore) {
        self.sectionStore = sectionStore
    }
}

extension DependencyWorker: ViewControllerFactory {
    func makeListSections() -> ListSectionsViewController {
        let vc = ListSectionsViewController()
        vc.viewModel = ListSectionsViewModel(factory: self)
        return vc
    }
}

extension DependencyWorker: WorkerFactory {
    func makeSectionsWorker() -> SectionsWorker {
        return SectionsWorker(sectionStore: sectionStore)
    }
}
