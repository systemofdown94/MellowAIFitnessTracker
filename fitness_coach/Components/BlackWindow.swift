import WebKit
import SwiftUI

struct BlackWindow: UIViewRepresentable {
    
    let url: URL
    
    @Binding var isHidden: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(container: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = buildWebView(context: context)
        webView.load(URLRequest(url: url))
        context.coordinator.rootWebView = webView
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
}

private extension BlackWindow {
    
    func buildWebView(context: Context) -> WKWebView {
        let view = WKWebView(frame: .zero, configuration: makeConfiguration())
        
        view.navigationDelegate = context.coordinator
        view.uiDelegate = context.coordinator
        view.allowsBackForwardNavigationGestures = true
        
        attachSwipeGestures(to: view)
        
        return view
    }
    
    func makeConfiguration() -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .all
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        return config
    }
    
    func attachSwipeGestures(to webView: WKWebView) {
        let back = UISwipeGestureRecognizer(
            target: webView,
            action: #selector(WKWebView.goBack)
        )
        back.direction = .right
        
        let forward = UISwipeGestureRecognizer(
            target: webView,
            action: #selector(WKWebView.goForward)
        )
        forward.direction = .left
        
        webView.addGestureRecognizer(back)
        webView.addGestureRecognizer(forward)
    }
    
}

extension BlackWindow {
    
    final class Coordinator: NSObject {
        
        weak var rootWebView: WKWebView?
        private weak var popupWebView: WKWebView?
        
        private let container: BlackWindow
        
        init(container: BlackWindow) {
            self.container = container
        }
        
    }
    
}

extension BlackWindow.Coordinator: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard container.isHidden else { return }
        container.isHidden = false
    }
    
}

extension BlackWindow.Coordinator: WKUIDelegate {
    
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        
        guard popupWebView == nil else { return nil }
        
        let popup = WKWebView(frame: .zero, configuration: configuration)
        popup.navigationDelegate = self
        popup.uiDelegate = self
        
        let controller = UIViewController()
        controller.view.backgroundColor = .systemBackground
        controller.view.addSubview(popup)
        
        popup.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popup.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            popup.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            popup.topAnchor.constraint(equalTo: controller.view.topAnchor),
            popup.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        ])
        
        popupWebView = popup
        present(controller)
        
        return popup
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.window?.rootViewController?.dismiss(animated: true)
        popupWebView = nil
    }
    
}

private extension BlackWindow.Coordinator {
    
    func present(_ controller: UIViewController) {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController?
            .present(controller, animated: true)
    }
}
