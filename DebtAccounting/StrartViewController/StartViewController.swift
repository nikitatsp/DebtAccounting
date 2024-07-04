import UIKit
import ProgressHUD

final class StartViewController: UIViewController {
    let exchangeRateService = ExchangeRateService.shared
    let conversionRateService = ConversionRateService.shared
    
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
                    self.conversionRateService.conversionRate = conversionRate
                    print(conversionRate)
                    ProgressHUD.dismiss()
                    self.switchToTabBar()
                case .failure(let error):
                    ProgressHUD.dismiss()
                    let alertVC = UIAlertController(title: "Не удалось загрузить курс валют", message: "Вы продолжите с последним сохраненным курсом: \(self.conversionRateService.conversionRate)", preferredStyle: .alert)
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
        
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        let activeViewController = DebtActiveTableViewController()
        let historyViewController = DebtHistoryTableViewController()
        
        mainViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.circle.fill"), selectedImage: nil)
        activeViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle.fill"), selectedImage: nil)
        historyViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "clock.fill"), selectedImage: nil)
        
        tabBarController.viewControllers = [mainViewController, UINavigationController(rootViewController: activeViewController), UINavigationController(rootViewController: historyViewController)]
        
        window.rootViewController = tabBarController
    }
}
