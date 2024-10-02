//
//  UserDefaultsViewController.swift
//  CoreData_modul_20
//
//  Created by Admin on 25.09.2024.
//

import UIKit
import SnapKit

class UserDefaultsViewController: UIViewController {

    // Создаем сегментированный контрол для сортировки
    private let sortOrderSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Ascending", "Descending"])
        return control
    }()

    struct Constants {
        static let sortOrderKey = "sortOrder"
    }

    enum SortOrder: String {
        case ascending = "ascending"
        case descending = "descending"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Добавляем сегментированный контрол на экран
        view.addSubview(sortOrderSegmentControl)
        
        // Устанавливаем SnapKit разметку
        sortOrderSegmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview() // Центрируем контрол на экране
            make.width.equalTo(200) // Устанавливаем ширину
        }
        
        // Загружаем сохранённое состояние сортировки (используем строковое значение)
        let savedSortOrder = UserDefaults.standard.string(forKey: Constants.sortOrderKey) ?? SortOrder.ascending.rawValue
        sortOrderSegmentControl.selectedSegmentIndex = savedSortOrder == SortOrder.ascending.rawValue ? 0 : 1
        
        // Добавляем таргет для изменения сортировки
        sortOrderSegmentControl.addTarget(self, action: #selector(sortOrderChanged(_:)), for: .valueChanged)
        
        setupUI()
    }

    @objc func sortOrderChanged(_ sender: UISegmentedControl) {
        // Преобразуем в строку для сохранения в UserDefaults
        let sortOrder: SortOrder = sender.selectedSegmentIndex == 0 ? .ascending : .descending

        // Сохраняем строковое значение в UserDefaults
        UserDefaults.standard.set(sortOrder.rawValue, forKey: Constants.sortOrderKey)

        // Оповещаем об изменении сортировки через NotificationCenter
        NotificationCenter.default.post(name: NSNotification.Name("sortOrderChanged"), object: sortOrder.rawValue) // Передаем строку
        
        // Закрываем контроллер
        navigationController?.popViewController(animated: true)
    }
    
    lazy var titleText: UILabel = {
        let label = UILabel()
        label.text = "Задать и изменить сортировку "
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        //label.numberOfLines = 2
        return label
    }()
    
    // Создаем кнопку
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Действие для кнопки
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            //make.center.equalToSuperview()
            //make.width.equalTo(250)
            //make.height.equalTo(80)
        }
        
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(220)
            make.centerX.equalToSuperview()
            //make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
}


