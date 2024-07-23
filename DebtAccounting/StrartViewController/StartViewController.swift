import UIKit
import ProgressHUD
import CoreData

final class StartViewController: UIViewController {
    let exchangeRateService = ExchangeRateService.shared
    let conversionRateService = ConversionRateService.shared
    let context = CoreDataService.shared.getContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchConversionRate()
    }
    
    private func fetchConversionRate() {
        ProgressHUD.animate()
        exchangeRateService.fetchExchangeRate { [weak self] result in
            guard let self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let conversionRate):
                    self.conversionRateService.conversionRate?.rate = conversionRate
                    
                    do {
                        try self.context.save()
                        print(conversionRate)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    ProgressHUD.dismiss()
                    self.switchToTabBar()
                case .failure(_):
                    ProgressHUD.dismiss()
                    guard let rate = self.conversionRateService.conversionRate?.rate else {return}
                    let cource = Int(1 / rate)
                    let alertVC = UIAlertController(title: "Не удалось загрузить актуальный курс валют", message: "Вы продолжите с последним сохраненным курсом: 1 $ = \(cource) руб", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ок", style: .default) { _ in
                        self.switchToTabBar()
                    }
                    alertVC.addAction(alertAction)
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
    
    private func switchToTabBar() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor(named: "YP Black")
        
        let tabBarAppearenceForScroll = UITabBarAppearance()
        tabBarAppearenceForScroll.configureWithDefaultBackground()
        tabBarAppearenceForScroll.backgroundColor = .white
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearenceForScroll
        
        
        let mainScreenViewController = MainScreenViewController()
        MainScreenConfigurator.shared.configure(withView: mainScreenViewController)
        
        let activeViewController = DebtListViewController()
        DebtListConfiguarator.shared.configure(withView: activeViewController, isActive: true)
        
        let historyViewController = DebtListViewController()
        DebtListConfiguarator.shared.configure(withView: historyViewController, isActive: false)
        _ = historyViewController.view
        
        mainScreenViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.circle.fill"), selectedImage: nil)
        activeViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle.fill"), selectedImage: nil)
        historyViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "clock.fill"), selectedImage: nil)
        
        tabBarController.viewControllers = [UINavigationController(rootViewController: mainScreenViewController), UINavigationController(rootViewController: activeViewController), UINavigationController(rootViewController: historyViewController)]
        
        window.rootViewController = tabBarController
    }
}
