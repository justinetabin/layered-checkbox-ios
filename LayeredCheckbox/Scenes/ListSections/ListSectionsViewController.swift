//
//  ListSectionsViewController.swift
//  LayeredCheckbox
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ListSectionsViewController: UIViewController {
    
    var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var layerOneTableHeaderView: LayerOneTableHeaderView = {
        let view = LayerOneTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.titleButton.setTitle("Select All", for: .normal)
        view.checkbox.setCheckedBorderColor(state: .none)
        return view
    }()
    
    var viewModel: ListSectionsViewModel!
    
    var disposeBag = DisposeBag()
    
    fileprivate func setupNavBar() {
        title = "Layered Check Box"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    fileprivate func setupSubviews() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func setupTableView() {
        tableView.register(LayerThreeCheckBoxTableViewCell.self, forCellReuseIdentifier: LayerThreeCheckBoxTableViewCell.reuseIdentifier)
        tableView.register(LayerTwoSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: LayerTwoSectionHeaderView.reuseIdentifier)
        tableView.tableHeaderView = layerOneTableHeaderView
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func bind() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDataSource(self)
            .disposed(by: disposeBag)
        
        layerOneTableHeaderView.titleButton.rx
            .controlEvent(.touchUpInside)
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                let isChecked = !self.layerOneTableHeaderView.checkbox.isChecked
                self.layerOneTableHeaderView.checkbox.isChecked = isChecked
                self.layerOneTableHeaderView.checkbox.setCheckedBorderColor(state: isChecked ? .checked : .none)
                return isChecked
            }
            .bind(to: viewModel.input.didTapCheckAll)
            .disposed(by: disposeBag)
        
        layerOneTableHeaderView.checkbox.rx
            .controlEvent(.valueChanged)
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                print(self.layerOneTableHeaderView.checkbox.isChecked)
                return self.layerOneTableHeaderView.checkbox.isChecked
            }
            .bind(to: viewModel.input.didTapCheckAll)
            .disposed(by: disposeBag)
        
        viewModel.output.checkAll
            .skip(1)
            .bind { [weak self] (isChecked) in
                guard let self = self else { return }
                let state = self.viewModel.output.checkAllState
                self.layerOneTableHeaderView.checkbox.isChecked = isChecked
                self.layerOneTableHeaderView.checkbox.setCheckedBorderColor(state: state)
            }.disposed(by: disposeBag)
        
        viewModel.output.displayableTableSections
            .skip(1)
            .bind { [weak self] sections in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.output.sectionCheck
            .bind { [weak self] (sectionIndex, section) in
                if let headerView = self?.tableView.headerView(forSection: sectionIndex) as? LayerTwoSectionHeaderView {
                    headerView.checkbox.isChecked = section.isChecked
                    headerView.checkbox.setCheckedBorderColor(state: section.state)
                }
            }.disposed(by: disposeBag)
        
        viewModel.output.sectionExpand
            .bind { [weak self] (sectionIndex) in
                self?.tableView.reloadSections([sectionIndex], with: .none)
            }.disposed(by: disposeBag)
        
        viewModel.output.itemCheck
            .bind { [weak self] (sectionIndex, itemIndex, section, item) in
                if section.isExpanded {
                    self?.tableView.reloadRows(at: [IndexPath(row: itemIndex, section: sectionIndex)], with: .none)
                }
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupSubviews()
        
        DispatchQueue.main.async {
            self.setupTableView()
            self.bind()
            self.viewModel.input.viewDidLoad.accept(())
        }
    }
    
}

extension ListSectionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.output.displayableTableSections.value[indexPath.section]
        let item = section.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LayerThreeCheckBoxTableViewCell.reuseIdentifier, for: indexPath) as! LayerThreeCheckBoxTableViewCell
        
        let count = indexPath.row + 1
        cell.titleLabel.text = "\(item.title) \(count)"
        cell.subtitleLabel.text = item.subtitle
        cell.countLabel.text = "\(count)"
        cell.selectionStyle = .none
        cell.checkbox.isChecked = item.isChecked
        cell.checkbox.setCheckedBorderColor(state: item.isChecked ? .checked : .none)
        cell.clipsToBounds = true
        
        cell.checkbox.rx
            .controlEvent(.valueChanged)
            .map { (indexPath.section, indexPath.row) }
            .bind(to: viewModel.input.didTapItem)
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.output.displayableTableSections.value[section]
        return section.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.displayableTableSections.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.output.displayableTableSections.value[indexPath.section]
        return section.isExpanded ? 90 : 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.output.displayableTableSections.value[indexPath.section]
        return section.isExpanded ? 90 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: LayerTwoSectionHeaderView.reuseIdentifier) as! LayerTwoSectionHeaderView
        let sectionIndex = section
        let section = viewModel.output.displayableTableSections.value[section]
        
        view.titleButton.setTitle(section.title, for: .normal)
        view.checkbox.isChecked = section.isChecked
        view.checkbox.setCheckedBorderColor(state: section.state)
        view.expandImageView.image = section.isExpanded ? UIImage(named: "expand_less") : UIImage(named: "expand_more")
        
        view.checkbox.rx
            .controlEvent(.valueChanged)
            .map { sectionIndex }
            .bind(to: viewModel.input.didTapSectionCheck)
            .disposed(by: view.disposeBag)
        
        view.titleButton.rx
            .controlEvent(.touchUpInside)
            .map { _ in sectionIndex }
            .bind(to: viewModel.input.didTapExpandSection)
            .disposed(by: view.disposeBag)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapItem.accept((indexPath.section, indexPath.row))
    }
}
