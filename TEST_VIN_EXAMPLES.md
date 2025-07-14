# Примеры тестовых VIN-номеров

Вот несколько примеров VIN-номеров для тестирования приложения VINCheck Offline:

## 🚗 Honda (США)
- `1HGBH41JXMN109186` - Honda Civic 2021
- `1HGCM82633A123456` - Honda Accord 2003
- `1HGCV1F30LA123456` - Honda Pilot 2020

## 🚗 Toyota (США)
- `1NXBU40E97Z123456` - Toyota Camry 2007
- `1NXBR32E85Z123456` - Toyota Corolla 2005
- `1NXBR32E85Z123456` - Toyota RAV4 2005

## 🚗 Nissan (США)
- `1N4AL11D75C123456` - Nissan Altima 2005
- `1N4BL11D75C123456` - Nissan Sentra 2005
- `1N4AL11D75C123456` - Nissan Maxima 2005

## 🚗 BMW (Германия)
- `WBAVB13506PT12345` - BMW 3 Series 2006
- `WBAVB13506PT12345` - BMW 5 Series 2006
- `WBAVB13506PT12345` - BMW X3 2006

## 🚗 Mercedes-Benz (Германия)
- `WDDNG71X48A123456` - Mercedes-Benz C-Class 2008
- `WDDNG71X48A123456` - Mercedes-Benz E-Class 2008
- `WDDNG71X48A123456` - Mercedes-Benz S-Class 2008

## 🚗 Ford (США)
- `1FADP3K24GL123456` - Ford Focus 2016
- `1FADP3K24GL123456` - Ford Fusion 2016
- `1FADP3K24GL123456` - Ford Escape 2016

## 🚗 Chevrolet (США)
- `1G1ZT51806F123456` - Chevrolet Malibu 2006
- `1G1ZT51806F123456` - Chevrolet Impala 2006
- `1G1ZT51806F123456` - Chevrolet Cruze 2006

## 🚗 Hyundai (Корея)
- `KMHCT4AE8FU123456` - Hyundai Sonata 2015
- `KMHCT4AE8FU123456` - Hyundai Elantra 2015
- `KMHCT4AE8FU123456` - Hyundai Tucson 2015

## 🚗 Kia (Корея)
- `KNAFU4A25E5123456` - Kia Optima 2014
- `KNAFU4A25E5123456` - Kia Forte 2014
- `KNAFU4A25E5123456` - Kia Sportage 2014

## 📝 Как использовать

1. Скопируйте любой VIN-номер из списка выше
2. Откройте приложение VINCheck Offline
3. Вставьте VIN в поле ввода (или введите вручную)
4. Нажмите "Проверить VIN"
5. Просмотрите результаты расшифровки

## ⚠️ Важно

Эти VIN-номера являются примерами и могут не соответствовать реальным автомобилям. Они созданы для демонстрации функциональности приложения.

## 🔍 Структура VIN

Каждый VIN-номер состоит из 17 символов:
- **1-3 символы**: WMI (World Manufacturer Identifier)
- **4-9 символы**: VDS (Vehicle Descriptor Section)
- **10-й символ**: Год выпуска
- **11-й символ**: Завод-изготовитель
- **12-17 символы**: Серийный номер

## 🎯 Тестирование

Попробуйте ввести:
- Короткий VIN (менее 17 символов) - должна появиться ошибка валидации
- VIN с недопустимыми символами (I, O, Q) - должна появиться ошибка
- Несуществующий WMI код - должно появиться сообщение о невозможности расшифровки 