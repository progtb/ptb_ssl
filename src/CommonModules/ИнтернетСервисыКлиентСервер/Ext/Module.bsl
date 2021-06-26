﻿
#Область ПрограммныйИнтерфейс

// Разбирает строку с параметрами вида Имя1=Значение1<&Имя2=Значение2&...>
// в структуру с именами и значениями параметров
//
// Параметры
//	СтрокаКоманды - Тип: Строка.
//
// Возвращаемое значение
//	Структура
//		Ключ - Строка. Имя параметра
//		Значение - Строка. Значение параметра
//
Функция ПолучитьПараметрыКоманды(СтрокаКоманды) Экспорт
	СтруктураПараметров = Новый Структура;
	
	ДанныеПараметров = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаКоманды, "&");
	Для Каждого Параметр Из ДанныеПараметров Цикл
		ДанныеПараметра = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Параметр, "=");
		Если ДанныеПараметра.Количество() > 1 Тогда
			СтруктураПараметров.Вставить(ДанныеПараметра[0], ДанныеПараметра[1]);
		ИначеЕсли ДанныеПараметра.Количество() = 1 Тогда
			СтруктураПараметров.Вставить(ДанныеПараметра[0], "");
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураПараметров;
КонецФункции

// Выводит сообщение об ошибке. При необходимости вызывает исключение
//
// Параметры:
//	Текст				- Строка - текст сообщения
//	ВызыватьИсключение	- Булево - признак использования исключения
//	НеСообщать			- Булево - не выводит сообщение
// 
Процедура ОбработатьТекстОшибки(знач Текст, знач ВызыватьИсключение = Ложь, знач НеСообщать = Ложь) Экспорт
	Если НЕ НеСообщать = Истина Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	КонецЕсли;
	
	Если ВызыватьИсключение Тогда
		ВызватьИсключение Текст;
	КонецЕсли;
КонецПроцедуры

// Выводит сообщение об ошибке HTTP запроса
//
// Параметры:
//	ОтветHTTP			- ОтветHTTP
//	ВызыватьИсключение	- Булево - признак использования исключения
//	НеСообщать			- Булево - не выводит сообщение
// 
Процедура ОбработатьОшибкуЗапроса(знач ОтветHTTP, знач ВызыватьИсключение = Ложь, знач НеСообщать = Ложь) Экспорт
	Перем ТекстОшибки;
	
	СтрТелоОтвета = ОтветHTTP.ПолучитьТелоКакСтроку();
	Если НЕ ПустаяСтрока(СтрТелоОтвета) Тогда
		Если СтрНачинаетсяС(СтрТелоОтвета, "{") Тогда
			СтруктураОшибки = ЗначениеИзСтрокиJSON(СтрТелоОтвета, Истина);
			ТекстОшибки = СтруктураОшибки.Получить("text");
		КонецЕсли;
	КонецЕсли;
	
	ТекстСообщения = СтрШаблон(НСтр("ru='Произошла ошибка при подключении к сервису (код: %1%2).'"),
		Строка(ОтветHTTP.КодСостояния),
		?(ЗначениеЗаполнено(ТекстОшибки), "; " + ТекстОшибки, ""));
		
	ОбработатьТекстОшибки(ТекстСообщения, ВызыватьИсключение, НеСообщать);
КонецПроцедуры

// Формирует объект HTTPЗапрос согласно настройкам
//
// Параметры:
//	АдресРесурса	- Строка - адрес ресурса запроса без учета адреса сервера (/ не обязателен в конце)
//		Например: /hs/partners/
//	Параметры			- Структура - параметры для формирования строки параметров ?key=value[&key1=value1]
//		Ключ 		- Строка - имя параметра
//		Значение	- Строка - значение параметра
//	Заголовки		- Соответствие - значения заголовков для подстановки в запрос
//
// Возвращаемое значение:
//	HTTPЗапрос
//
Функция ПолучитьHTTPЗапрос(знач АдресРесурса, знач Параметры = Неопределено, знач Заголовки = Неопределено) Экспорт
	ПараметрыКоллекция = (ТипЗнч(Параметры) = Тип("Соответствие")
		ИЛИ ТипЗнч(Параметры) = Тип("Структура"));
	
	Если НЕ ПараметрыКоллекция = Истина Тогда
		Параметры = Новый Соответствие;
	КонецЕсли;
	Если НЕ ТипЗнч(Заголовки) = Тип("Соответствие") Тогда
		Заголовки = Новый Соответствие;
	КонецЕсли;
	
	СтрПараметры = "";
	Для Каждого КлючИЗначение Из Параметры Цикл 
		Если НЕ ЗначениеЗаполнено(КлючИЗначение.Ключ) ИЛИ НЕ ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрПараметры = СтрПараметры
			+ ?(ПустаяСтрока(СтрПараметры), "", "&")
			+ СтрШаблон("%1=%2", КлючИЗначение.Ключ, КлючИЗначение.Значение);		
	КонецЦикла;
	
	Если НЕ СтрНачинаетсяС(АдресРесурса, "/") Тогда
		АдресРесурса = "/" + АдресРесурса;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтрПараметры) Тогда
		ШаблонАдреса = "%1?%2";
	Иначе 
		ШаблонАдреса = "%1%2";
	КонецЕсли;
	
	ПолныйАдрес = СтрШаблон(ШаблонАдреса, АдресРесурса, СтрПараметры);
	Возврат Новый HTTPЗапрос(ПолныйАдрес, Заголовки);
КонецФункции

// Формирует объект HTTPСоединение согласно настройкам
//
// Параметры:
//	АдресРесурса		- Строка, Структура - ссылка на ресурс в формате URI или структура
//		Структура - см. ОбщегоНазначенияКлиентСервер.СтруктураURI
//	Пользователь		- Строка - значение имени пользователя для подключения
//	ПарольПользователя	- Строка - значение пароля для подключения
//	ИспользоватьПрокси	- Булево - при установке Истина используется бесплатный прокси
//
// Возвращаемое значение:
//	HTTPСоединение
//
Функция ПолучитьHTTPСоединение(знач АдресРесурса, знач Пользователь = "", знач ПарольПользователя = "", знач ИспользоватьПрокси = Ложь, знач Таймаут = Неопределено) Экспорт
	Если ТипЗнч(АдресРесурса) = Тип("Структура") Тогда
		СтруктураАдреса = АдресРесурса;
	Иначе 
		СтруктураАдреса = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресРесурса);
	КонецЕсли;
	
	Если СтруктураАдреса.Схема = "https" Тогда
		БезопасноеСоединение = Новый ЗащищенноеСоединениеOpenSSL;
	Иначе 
		БезопасноеСоединение = Неопределено;
	КонецЕсли;
	
	Если ИспользоватьПрокси = Истина Тогда
		ИнтернетПрокси = ПолучитьНастройкиПрокси();
	КонецЕсли;
	
	СоединениеHTTP = Новый HTTPСоединение(СтруктураАдреса.ИмяСервера,,
		Пользователь,
		ПарольПользователя,,
		Таймаут,
		БезопасноеСоединение);
		
	Возврат СоединениеHTTP;
КонецФункции

// Проверяет что тип объекта - HTTPСоединение и адрес сервера задан
//
// Параметры:
//	СоединениеHTTP 		- HTTPСоединение
//	ВызыватьИсключение	- Булево - признак использования исключения
//	НеСообщать			- Булево - не выводит сообщение
//
// Возвращаемое значение:
//   Булево
// 
Функция ПроверитьHTTPСоединение(знач СоединениеHTTP, знач ВызыватьИсключение = Ложь, знач НеСообщать = Ложь) Экспорт
	Результат = (ТипЗнч(СоединениеHTTP) = Тип("HTTPСоединение") И НЕ ПустаяСтрока(СоединениеHTTP.Сервер));
	
	Если НЕ Результат Тогда
		ТекстСообщения = НСтр("ru='Ошибка проверки интернет-соединения с ИБ.'");
		ИнтернетСервисыКлиентСервер.ОбработатьТекстОшибки(ТекстСообщения, ВызыватьИсключение, НеСообщать);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Возвращает объект ИнтернетПрокси с бесплатным прокси полученным с сайта https://gimmeproxy.com
//
// Возвращаемое значение:
//   ИнтернетПрокси, Неопределено
// 
Функция ПолучитьНастройкиПрокси() Экспорт
	Параметры = Новый Соответствие;
	Параметры.Вставить("protocol"		, "http");
	Параметры.Вставить("post"			, "false");
	Параметры.Вставить("maxCheckPeriod"	, "3600");
	Параметры.Вставить("anonymityLevel"	, "0");
	
	ЗапросHTTP = ПолучитьHTTPЗапрос("api/getProxy", Параметры);
	Соединение = ПолучитьHTTPСоединение("https://gimmeproxy.com"); 
	
	Результат = Соединение.Получить(ЗапросHTTP);
	Если Результат.КодСостояния <> 200 Тогда
		Возврат Неопределено;
	КонецЕсли;
	ТелоРезультата = Результат.ПолучитьТелоКакСтроку();
	
	ДанныеПрокси = ЗначениеИзСтрокиJSON(ТелоРезультата, Истина);
	
	Протокол	= ДанныеПрокси.Получить("protocol");
	Сервер		= ДанныеПрокси.Получить("ip");
	Порт		= ДанныеПрокси.Получить("port");
	ПортЧисло	= ?(Порт = Неопределено, Неопределено,
		СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Порт));
	
	Если Протокол = Неопределено ИЛИ Сервер = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	ИнтернетПрокси = Новый ИнтернетПрокси;
	ИнтернетПрокси.Установить(Протокол, Сервер, ПортЧисло,,, Ложь);
		
	Возврат ИнтернетПрокси;
КонецФункции

// Возвращает структуру с описанием текста ошибки
//
// Параметры:
//	ТекстОшибки - Строка
//
// Возвращаемое значение:
//   Структура
//		type - Строка - "error"
//		text - Строка - значение параметра ТекстОшибки
// 
Функция СтруктураError(знач ТекстОшибки = "") Экспорт
	Возврат Новый Структура("type, text", "error", ТекстОшибки);
КонецФункции

#КонецОбласти

#Область JSON

// Преобразует значение в строку JSON
//
// Параметры:
//	ОбъектДанных	- Любое значение
//	Настройки		- НастройкиСериализацииJSON
//
// Возвращаемое значение:
//   Строка
// 
Функция ЗначениеВСтрокуJSON(знач ОбъектДанных, знач Настройки = Неопределено) Экспорт
	Результат = "";
	
	Если ИнтернетСервисыКлиентСерверПовтИсп.ИспользоватьЗаписьJSON() Тогда
		Попытка
			ЗаписьJSON = Новый ЗаписьJSON;
			ЗаписьJSON.УстановитьСтроку();
			ЗаписатьJSON(ЗаписьJSON, ОбъектДанных, Настройки);
			Результат = ЗаписьJSON.Закрыть();
		Исключение
			СтрОшибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрОшибка);
			Результат = ИнтернетСервисыВызовСервера.ПолучитьСтрокуJSON(ОбъектДанных); 
		КонецПопытки;
	Иначе 
		Результат = ИнтернетСервисыВызовСервера.ПолучитьСтрокуJSON(ОбъектДанных); 
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Преобразует строку JSON в значение
//
// Параметры:
//	СтрокаJSON		- Строка
//	КакСоответствие - Булево
//	СвойстваДаты	- Строка - имена свойств с датами
//	ФорматДаты		- ФорматДатыJSON
//
// Возвращаемое значение:
//   ЛюбоеЗначение
// 
Функция ЗначениеИзСтрокиJSON(знач СтрокаJSON,
	знач КакСоответствие = Ложь,
	знач СвойстваДаты = "",
	знач ФорматДаты = Неопределено) Экспорт
	
	Если НЕ ТипЗнч(ФорматДаты) = Тип("ФорматДатыJSON") Тогда
		ФорматДаты = ФорматДатыJSON.ISO;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Значение = ПрочитатьJSON(ЧтениеJSON, КакСоответствие, СвойстваДаты, ФорматДаты);
	
	ЧтениеJSON = Неопределено;
	
	Возврат Значение;
КонецФункции

#КонецОбласти 
