//
//  MyTableViewController.swift
//  CoreData_modul_20
//
//  Created by Admin on 21.09.2024.
//

import UIKit
import CoreData

class MyTableViewController: UITableViewController {

    struct Constants {
        static let entity = "Person"
        static let sortName = "name"
        static let cellName = "Cell"
        static let identifier = "tableInCV"
    }
    
    
    var fetchResultController: NSFetchedResultsController<Person>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Добавляем кнопку слева с системным изображением "compose"
            let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeButtonTapped))
        
        // Устанавливаем кнопку в левую часть навигационного бара
           navigationItem.leftBarButtonItem = composeButton
        
        
        // Добавляем кнопку справа с системным изображением "add"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // Устанавливаем кнопку в левую часть навигационного бара
           navigationItem.rightBarButtonItem = addButton
        
        
        // Добавляем наблюдателя на изменение сортировки
        NotificationCenter.default.addObserver(self, selector: #selector(sortOrderChanged(_:)), name: NSNotification.Name("sortOrderChanged"), object: nil)
        
        // Первоначальная загрузка данных
        loadData()
        
        fetchResultController.delegate = self
        
        // Удаляем кэш перед выполнением запроса данных
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)

        
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
        
        // Удаляем разлиновку пустых ячеек
        tableView.tableFooterView = UIView()
        
        
    }
    
    // Обработчик нажатия на кнопку
    @objc func composeButtonTapped() {
        
        let alertController = UIAlertController(title: "Действие", message: "Выберите действие", preferredStyle: .actionSheet)
            
        // Добавляем действия в UIAlertController
        let action1 = UIAlertAction(title: "ascending", style: .default) { _ in
        // Сохраняем сортировку по возрастанию
        UserDefaults.standard.set(UserDefaultsViewController.SortOrder.ascending.rawValue, forKey: UserDefaultsViewController.Constants.sortOrderKey)
        self.loadData()  // Загружаем данные с новой сортировкой
            }
        let action2 = UIAlertAction(title: "descending", style: .default) { _ in
                // Сохраняем сортировку по убыванию
                UserDefaults.standard.set(UserDefaultsViewController.SortOrder.descending.rawValue, forKey: UserDefaultsViewController.Constants.sortOrderKey)
                self.loadData()  // Загружаем данные с новой сортировкой
            }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alertController.addAction(action1)
            alertController.addAction(action2)
            alertController.addAction(cancelAction)
            
            // Показываем UIAlertController
            present(alertController, animated: true, completion: nil)
    }
    
    
    // Обработчик нажатия на кнопку
    @objc func addButtonTapped() {
        // Создаем экземпляр MyViewController
            let myViewController = MyViewController()
            
            // Устанавливаем стиль модального перехода (по умолчанию .automatic или .fullScreen)
        myViewController.modalPresentationStyle = .pageSheet  // Можно использовать .automatic, если хотите
            myViewController.modalTransitionStyle = .coverVertical // Это стандартная анимация
            
            // Открываем MyViewController как модальное окно
            present(myViewController, animated: true, completion: nil)
    }
    
    // Загрузка данных с учетом текущей сортировки
        private func loadData() {
            // Получаем текущий порядок сортировки из UserDefaults
            let sortOrder = UserDefaults.standard.string(forKey: UserDefaultsViewController.Constants.sortOrderKey) ?? UserDefaultsViewController.SortOrder.ascending.rawValue
            
            let sortDescriptor: NSSortDescriptor
            if sortOrder == UserDefaultsViewController.SortOrder.ascending.rawValue {
                sortDescriptor = NSSortDescriptor(key: Constants.sortName, ascending: true)
            } else {
                sortDescriptor = NSSortDescriptor(key: Constants.sortName, ascending: false)
            }

            let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
            fetchRequest.sortDescriptors = [sortDescriptor]

            // Инициализируем NSFetchedResultsController с обновленным fetch-запросом
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)

            fetchResultController.delegate = self

            do {
                try fetchResultController.performFetch()
                tableView.reloadData()
            } catch {
                print("Ошибка загрузки данных: \(error)")
            }
        }

        @objc func sortOrderChanged(_ notification: Notification) {
            // Обновляем данные при изменении сортировки
            loadData()
        }

        deinit {
            // Удаляем наблюдателя при деинициализации
            NotificationCenter.default.removeObserver(self)
        }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath)

        let person = fetchResultController.object(at: indexPath) as! Person
        cell.textLabel?.text = person.surName
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        cell.detailTextLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        cell.detailTextLabel?.text = person.name

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let person = fetchResultController.object(at: indexPath) as? Person else {
                print("Ошибка: Person не найден")
                return
            }

            print("Выбранный объект Person: \(person.name ?? "Имя не найдено")")
            
            // Проверяем, не отображается ли уже другой контроллер
            if let presentedVC = self.presentedViewController {
                // Если модальный контроллер уже отображается, закрываем его
                print("Закрываем уже отображающийся контроллер")
                presentedVC.dismiss(animated: true) {
                    // Открываем новый MyViewController с объектом Person
                    self.presentMyViewController(with: person)
                }
            } else {
                // Открываем новый MyViewController с объектом Person
                presentMyViewController(with: person)
            }
    }
    
    // Программное создание и показ MyViewController
    private func presentMyViewController(with person: Person) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let myViewController = storyboard.instantiateViewController(withIdentifier: "MyViewController") as? MyViewController {
            myViewController.person = person
            myViewController.modalPresentationStyle = .pageSheet  // Или другой стиль, если нужно
            present(myViewController, animated: true, completion: nil)
            print("Передан объект Person: \(person.name ?? "Имя не найдено")")
        } else {
            print("Ошибка: Не удалось создать экземпляр MyViewController")
        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let person = fetchResultController.object(at: indexPath) as! Person
            CoreDataManager.instance.context.delete(person)
            CoreDataManager.instance.saveContext()
        }
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Constants.identifier {
//            let controller = segue.destination as! MyViewController
//            controller.person = sender as? Person
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.identifier {
            if let controller = segue.destination as? MyViewController,
               let person = sender as? Person {
                controller.person = person
                print("Передан объект Person: \(person.name ?? "Имя не найдено")")
            } else {
                print("Ошибка: Не удалось передать объект Person")
            }
        } else {
            print("Ошибка: Идентификатор сегвея не совпадает")
        }
        
    }
    

}


extension MyTableViewController: NSFetchedResultsControllerDelegate {
    
    // Информирует о начале изменения данных
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let person = fetchResultController.object(at: indexPath) as! Person
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = person.name
                cell?.detailTextLabel?.text = person.surName
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = indexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}










