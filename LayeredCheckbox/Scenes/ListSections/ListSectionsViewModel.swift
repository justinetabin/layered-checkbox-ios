//
//  ListSectionsViewModel.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ListSectionsViewModel: ViewModelType {
    
    var input = Input(
        viewDidLoad: PublishRelay(),
        didTapCheckAll: PublishRelay(),
        didTapExpandSection: PublishRelay(),
        didTapSectionCheck: PublishRelay(),
        didTapItem: PublishRelay()
    )
    
    var output = Output(
        displayableTableSections: BehaviorRelay(value: []),
        checkAll: BehaviorRelay(value: false),
        checkAllState: .none,
        sectionCheck: PublishRelay(),
        sectionExpand: PublishRelay(),
        itemCheck: PublishRelay()
    )
    
    var disposeBag = DisposeBag()
    
    private var sections = [DisplayableTableSection]()
    
    init(factory: WorkerFactory) {
        let worker = factory.makeSectionsWorker()
        
        input.viewDidLoad.bind { [weak self] (_) in
            guard let self = self else { return }
            worker.list { (sections) in
                self.sections = sections.map { section in
                    let items = section.items.map { DisplayableTableRow(title: $0.title,
                                                                        subtitle: $0.subtitle) }
                    return DisplayableTableSection(title: section.title,
                                                   items: items)
                }
                self.output.displayableTableSections.accept(self.sections)
            }
            
        }.disposed(by: disposeBag)
        
        input.didTapCheckAll.bind { [weak self] (isChecked) in
            guard let self = self else { return }
            self.sections.enumerated().forEach { (sectionIndex, section) in
                section.isChecked = isChecked
                section.state = isChecked ? .checked : .none
                self.output.sectionCheck.accept((sectionIndex, section))
                section.state = isChecked ? .checked : .none
                section.items.enumerated().forEach { (itemIndex, item) in
                    item.isChecked = isChecked
                    self.output.itemCheck.accept((sectionIndex, itemIndex, section, item))
                }
            }
            self.output.checkAllState = isChecked ? .checked : .none
            self.output.checkAll.accept(isChecked)
        }.disposed(by: disposeBag)
        
        input.didTapExpandSection.bind { [weak self] (sectionIndex) in
            guard let self = self else { return }
            let section = self.sections[sectionIndex]
            let isExpanded = !section.isExpanded
            section.isExpanded = isExpanded
            self.output.sectionExpand.accept(sectionIndex)
        }.disposed(by: disposeBag)
        
        input.didTapSectionCheck.bind { [weak self]  (sectionIndex) in
            guard let self = self else { return }
            let section = self.sections[sectionIndex]
            let isChecked = !section.isChecked
            section.isChecked = isChecked
            section.state = isChecked ? .checked : .none
            
            section.items.enumerated().forEach { (itemIndex, item) in
                item.isChecked = isChecked
                self.output.itemCheck.accept((sectionIndex, itemIndex, section, item))
            }
            
            self.output.sectionCheck.accept((sectionIndex, section))
            self.handleSelectAll()
        }.disposed(by: disposeBag)
        
        input.didTapItem.bind { [weak self] (sectionIndex, itemIndex) in
            guard let self = self else { return }
            let section = self.sections[sectionIndex]
            let item = section.items[itemIndex]
            let isChecked = !item.isChecked
            item.isChecked = isChecked
            
            let bools = section.items.map { $0.isChecked }
            let filtered = bools.filter { $0 }
            var state: CheckBoxState = .none
            var checked = false
            if filtered.count == bools.count {
                state = .checked
                checked = true
            } else if filtered.count > 0 {
                state = .indeterminate
                checked = false
            }
            section.state = state
            section.isChecked = checked
            
            self.output.itemCheck.accept((sectionIndex, itemIndex, section, item))
            self.output.sectionCheck.accept((sectionIndex, section))
            self.handleSelectAll()
        }.disposed(by: disposeBag)
    }
    
    func handleSelectAll() {
        let bools = self.sections.map { $0.isChecked }
        let filtered = bools.filter { $0 }
        if filtered.count == bools.count {
            self.output.checkAllState = .checked
            self.output.checkAll.accept(true)
        } else if filtered.count > 0 {
            self.output.checkAllState = .indeterminate
            self.output.checkAll.accept(false)
        } else {
            self.output.checkAllState = .none
            self.output.checkAll.accept(false)
        }
    }
}

extension ListSectionsViewModel {
    
    struct Input {
        var viewDidLoad: PublishRelay<()>
        var didTapCheckAll: PublishRelay<Bool>
        var didTapExpandSection: PublishRelay<Int>
        var didTapSectionCheck: PublishRelay<Int>
        var didTapItem: PublishRelay<(Int, Int)>
    }
    
    struct Output {
        var displayableTableSections: BehaviorRelay<[DisplayableTableSection]>
        var checkAll: BehaviorRelay<Bool>
        var checkAllState: CheckBoxState
        var sectionCheck: PublishRelay<(Int, DisplayableTableSection)>
        var sectionExpand: PublishRelay<Int>
        var itemCheck: PublishRelay<(Int, Int, DisplayableTableSection, DisplayableTableRow)>
    }
    
    class DisplayableTableSection {
        var title: String
        var state: CheckBoxState
        var isChecked: Bool
        var isExpanded: Bool
        var items: [DisplayableTableRow]
        
        init(title: String, items: [DisplayableTableRow]) {
            self.title = title
            self.state = .none
            self.isChecked = false
            self.isExpanded = false
            self.items = items
        }
    }
    
    class DisplayableTableRow {
        var title: String
        var subtitle: String
        var isChecked: Bool
        
        init(title: String, subtitle: String) {
            self.title = title
            self.subtitle = subtitle
            self.isChecked = false
        }
    }
    
}
