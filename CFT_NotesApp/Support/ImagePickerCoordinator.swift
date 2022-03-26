import Foundation
import UIKit

// MARK: - ImagePickerCoordinatorDelegate
protocol ImagePickerCoordinatorDelegate: AnyObject {
    func didFinishPicking(coordinator: ImagePickerCoordinator, _ image: UIImage)
}

final class ImagePickerCoordinator: NSObject, Coordinator {
    // MARK: - Properties
    weak var delegate: ImagePickerCoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    var rootNavigationController: UINavigationController
    var parentCoordinator: Coordinator?
    
    // MARK: - Init
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
        childCoordinators = []
    }
    
    // MARK: - Public Methods
    func start() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: Strings.choosePhotoActionTitle,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: Strings.camera,
                                         style: .default) { [weak self] action in
            self?.takePhotoFromCamera(imagePickerController)
        }
        
        let galleryAction = UIAlertAction(title: Strings.photoLibrary,
                                          style: .default) { [weak self] action in
            self?.takePhotoFromGallery(imagePickerController)
        }
        
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        rootNavigationController.present(actionSheet, animated: true)
    }
    
    // MARK: - Private Methods
    private func takePhotoFromGallery(_ picker: UIImagePickerController) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
            rootNavigationController.present(picker, animated: true)
        }
    }
    
    private func takePhotoFromCamera(_ picker: UIImagePickerController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            rootNavigationController.present(picker, animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ImagePickerCoordinator: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            delegate?.didFinishPicking(coordinator: self, image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Strings
private extension Strings {
    static let choosePhotoActionTitle = "Выбрать фото из:"
    static let photoLibrary = "Галерея"
    static let camera = "Камера"
    static let cancel = "Отменить"
}
