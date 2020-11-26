//
//  ApiClient.swift
//  miituoLib
//
//  Created by MACBOOK on 10/11/20.
//

import Foundation
import UIKit

var ipdev = "https://apidev2019.miituo.com/api/" //DEV
var urlCotizaStringdev = "https://websitedev2019.miituo.com/Cotizar"
var pathPhotosdev = "https://filesdev.miituo.com/"

var ipProd = "https://api.miituo.com/api/"   //PROD
var urlCotizaStringProd = "https://www.miituo.com/Cotizar"
var pathPhotosProd = "https://files.miituo.com/"

var ip = ""   //PROD
var urlCotizaString = ""
var pathPhotos = ""

var ipana = "http://apiana.netdev.miituo.com/api/"
//let ips : [String] = ["http://apiatlas.netdev.miituo.com/api/", "http://apiana.netdev.miituo.com/api/"]
let ips : [String] = ["https://miituo.com/api/api/", "https://miituo.com/api/api/"]

var banderaPushPago = false

var idticket = 0
var telefono = ""
var jsoncorrecto = "1"

var fotos = 0
var fotoscantidad = 0
var totalfotos = 0
var banderafotos = false
//var json:AnyObject?
var sinpolizas = 0
var cuponInfo = ""

var CodigoCupon = ""
var kmscuponcodigo = ""

var dictionaryApis: [String:String] = ["ANA seguros":ipana,"Seguros Atlas":ip]
var dictionaryTelefonos: [String:String] = ["ANA seguros":"","Seguros Atlas":"8008493917"]

var valordevuelto = ""
var odometerflag = 0

var speed = ""

var amount = 0.0
var dias_reporte = 0

var enterosFoto : [Int]?
var flagScan = false

//MARK: - Polizas data
var valueToPass = ""
var arreglo = [[String:String]]()
var arregloPolizas = [[String:String]]()
var arreglocarro = [[String:String]]()
var celular = ""

var flagcontrol = "0"

var valornum:Double = 0.0
var latitude = 0.0
var longitude = 0.0
var locationZipCodeToCamera = ""

var nombrecliente = ""
var flagDatosLoc = true

var actualizar = "0"

var volteado = "0"
var message = 0
var solofotos = 0

var leftflag = 0
var rigthflag = 0
var frontflag = 0
var backflag = 0
var pushflag = false
var numPush = 0
var badneraprocsando = 1
var fotosfaltantes : [Bool] = [false,false,false,false,false]
var fotosarriba:Int = 0

var banderaCancelacion = 0

var kmsCuponReferido = ""
var descriptipnCuponReferido = ""

//MARK: - More details
var polizaparasms:String? = ""
var tokentemp:String? = ""

var tienepolizas = ""

var conexion = ""
var flagmensaje = 0

//MARK: - AppDelegate
var token = ""

var ventana = ""

var tipoodometro = ""
var nueva_tarifa = ""
var fecha_vigencia = ""
var rco = ""
var plantipo = ""

var orientationLock = UIInterfaceOrientationMask.all
var flagpush = 0
var mensajepush = ""
var tarifa = ""
var splash = 0

var flagServicio = 0

var cotizando = 0
var crashedLastTime = true

var lastvalordev = ""

var polizaPadreId = 0
var odometro = ""
var flag = false

//MARK: - Odometer
var odometrouno = ""
var backPolizas = false

//MARK: - Polizas
let reloadData = Notification.Name("reloadData")
var tipopdf = ""

//MARK: - ODOMETER
var odometroanteriorlast = ""
var odometroaactuallast = ""
var kilometrosrecorridoslast = ""
var tarifaporkmlast = ""
var primalast = ""
var basemeslast = ""
var promolast = ""
var totalapagarlast = ""
var derechopolizad = ""
var esperando = ""
var banderacuponesrefe = false
var banderacuponesvaca = false
var kmscupon = 0
var kmscuponlimite = 0
var valorcuponrefe = 0.0
var tarifaneeeta = ""
var parametro_tope_kms = 0.0

var fiva = ""
var ivait = ""
var ivaderecho = ""

var banderapago = 0
