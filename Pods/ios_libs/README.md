# ios_libs
Librería para apps iOS

Descripción...

## Instalación

Cocoapods: 
Primeramente agregar las referencias 
```
  source 'https://github.com/CocoaPods/Specs.git'
  source 'https://github.com/miituo/ios_libs_podspec.git'
  target 'your_project' do

  pod 'ios_libs', '~> 0.1.0'

  end
```
## Uso:

Para usar la librería miituo, primero debe tener los permisos de la cámara en el archivo info.plist
```
<key>NSCameraUsageDescription</key>
<string>Tomar fotografías del automóvil para su registro</string>
```

Hacemos la importacion

```
import ios_libs
```

Ejemplo para presentar la vista miituo
  
```
@IBAction func launchLib(_ sender: Any) {
    let bundle = Bundle(for: PolizasViewController.self)
    let storyboard = UIStoryboard(name: "Polizas", bundle: bundle)

    let myAlert = storyboard.instantiateViewController(withIdentifier: "navpolizas") as! UINavigationController
    myAlert.modalPresentationStyle = .fullScreen
    let vc = myAlert.viewControllers[0] as! PolizasViewController

    if celField.text != ""{
        vc.phoneDataFromView = celField.text
        present(myAlert, animated: true, completion: nil)
    }
}
```  

Donde **celField** puede ser un textField para agregar el número de teléfono con el cual la librería buscará las pólizas miituo.
  
La librería se encarga de:
Reporte de odómetro
Toma de fotografías 
Ver póliza 
  
## Preview:
  
## Autor: 
  
**Pay as you drive technologies**
