//
//  ViewController.swift
//  CoreData_modul_20
//
//  Created by Admin on 21.09.2024.
//

import UIKit
import SnapKit
import CoreData

class MyViewController: UIViewController {

    var person: Person?
    
    // Создаем кнопку
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Действие для кнопки
    @objc func addButtonTapped() {
        //print("Кнопка была нажата")
        
        if savePerson() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
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
    
    
    lazy var titleText: UILabel = {
        let label = UILabel()
        label.text = "Экран редактирования"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        //label.numberOfLines = 2
        return label
    }()
    
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.text = "Фамилия"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var surName: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    lazy var birthDay: UILabel = {
        let label = UILabel()
        label.text = "Дата рождения"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    lazy var country: UILabel = {
        let label = UILabel()
        label.text = "Страна"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        // Настройка границ
        textField.layer.borderColor = UIColor.gray.cgColor // Цвет границы
        textField.layer.borderWidth = 1.0 // Ширина границы
        textField.layer.cornerRadius = 4.0 // Скругление углов
        return textField
    }()
    
    
    lazy var surNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Фамилия"
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        // Настройка границ
        textField.layer.borderColor = UIColor.gray.cgColor // Цвет границы
        textField.layer.borderWidth = 1.0 // Ширина границы
        textField.layer.cornerRadius = 4.0 // Скругление углов
        return textField
    }()
    
    
//    lazy var birthDayTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Дата рождения"
//        textField.font = .systemFont(ofSize: 20, weight: .semibold)
//        // Настройка границ
//        textField.layer.borderColor = UIColor.gray.cgColor // Цвет границы
//        textField.layer.borderWidth = 1.0 // Ширина границы
//        textField.layer.cornerRadius = 4.0 // Скругление углов
//        return textField
//    }()
    
    lazy var birthDayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Дата рождения"
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        
        // Настройка границ
        textField.layer.borderColor = UIColor.gray.cgColor // Цвет границы
        textField.layer.borderWidth = 1.0 // Ширина границы
        textField.layer.cornerRadius = 4.0 // Скругление углов
        
        // Настройка даты
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels // Стиль выбора даты
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Используем datePicker в качестве inputView для textField
        textField.inputView = datePicker
        
        return textField
    }()

    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru_RU") // Локализация для формата даты на русском
        birthDayTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    lazy var countryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Страна"
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        // Настройка границ
        textField.layer.borderColor = UIColor.gray.cgColor // Цвет границы
        textField.layer.borderWidth = 1.0 // Ширина границы
        textField.layer.cornerRadius = 4.0 // Скругление углов
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Чтение объекта
        if let person = person {
            nameTextField.text = person.name
            surNameTextField.text = person.surName
            birthDayTextField.text = person.birthDay
            countryTextField.text = person.country
        }

        

        
        setupUI()
    }


    func savePerson() -> Bool {
        if nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка ввода", message: "Вы не запнили поле ИМЯ - сохранение не возможно" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        if surNameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Ошибка ввода", message: "Вы не запнили поле ФАМИЛИЯ - сохранение не возможно" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        
        
        
        // Создаем объект
        if person == nil {
            person = Person()
        }
        
    
        // Сохранить объект
        if let person = person {
            person.name = nameTextField.text
            person.surName = surNameTextField.text
            person.birthDay = birthDayTextField.text
            person.country = countryTextField.text
            
            CoreDataManager.instance.saveContext()
        }
        
        
        
        return true
    }
    
    
    func setupUI() {
        
        // Добавляем кнопку в иерархию представлений
        view.addSubview(titleText)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(surName)
        surName.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(birthDay)
        birthDay.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(country)
        country.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(surNameTextField)
        surNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(birthDayTextField)
        birthDayTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(countryTextField)
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Устанавливаем ограничения через SnapKit
        titleText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalTo(55)
            //make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(80)
        }
        
        
        // Устанавливаем ограничения через SnapKit
        name.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalTo(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        // Устанавливаем ограничения через SnapKit
        surNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalTo(surName.snp_rightMargin).offset(30)
            make.width.equalTo(155)
            make.height.equalTo(35)
        }
        
        // Устанавливаем ограничения через SnapKit
        surName.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        // Устанавливаем ограничения через SnapKit
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(surNameTextField.snp.bottom).offset(30)
            make.left.equalTo(name.snp_rightMargin).offset(30)
            make.width.equalTo(155)
            make.height.equalTo(35)
        }
        
        // Устанавливаем ограничения через SnapKit
        birthDay.snp.makeConstraints { make in
            make.top.equalTo(surName.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        // Устанавливаем ограничения через SnapKit
        birthDayTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.left.equalTo(birthDay.snp_rightMargin).offset(30)
            make.width.equalTo(155)
            make.height.equalTo(35)
        }
        
        // Устанавливаем ограничения через SnapKit
        country.snp.makeConstraints { make in
            make.top.equalTo(birthDay.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        // Устанавливаем ограничения через SnapKit
        countryTextField.snp.makeConstraints { make in
            make.top.equalTo(birthDayTextField.snp.bottom).offset(30)
            make.left.equalTo(country.snp_rightMargin).offset(30)
            make.width.equalTo(155)
            make.height.equalTo(35)
        }
        
        // Устанавливаем ограничения через SnapKit
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(350)
            make.right.equalTo(-20)
            make.width.equalTo(80)    // ширина кнопки
            make.height.equalTo(35)    // высота кнопки
        }
        
        // Устанавливаем ограничения через SnapKit
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(350)
            make.left.equalTo(20)
            make.width.equalTo(80)    // ширина кнопки
            make.height.equalTo(35)    // высота кнопки
        }
        
        
        
    }

}

