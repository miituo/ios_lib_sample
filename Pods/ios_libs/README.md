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

  pod 'ios_libs', '~> 0.1.2'

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
click_Button_Action_Function() {
    let bundle = Bundle(for: PolizasViewController.self)
    let storyboard = UIStoryboard(name: "Polizas", bundle: bundle)

    let myAlert = storyboard.instantiateViewController(withIdentifier: "navpolizas") as! UINavigationController
    myAlert.modalPresentationStyle = .fullScreen
    let vc = myAlert.viewControllers[0] as! PolizasViewController

    if celField.text != ""{
        //phoneDataFromView es la variable key para buscar pólizas
        vc.phoneDataFromView = celField.text
        //dev es la bandera para especificar ambiente
        vc.dev = true
        present(myAlert, animated: true, completion: nil)
    }
}
```  

Donde:
**celField** puede ser un textField para agregar el número de teléfono con el cual la librería buscará las pólizas.
**dev** es la bandera para especificar ambiente. **true** es para desarrollo, **false** es para producción.
  
  
La librería se encarga de:
Reporte de odómetro
Toma de fotografías 
Ver póliza 
  
## Preview:
  
## Autor: 
  
**Pay as you drive technologies**
