﻿Функция ПоказатьИзмененныеОбъекты(ИдентификаторСообщения = "", ПолноеИмяОбъекта = "", РелизКонфигурации = "") Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияИзмененияОбъектов.ИдентификаторСообщения,
	|	ИсторияИзмененияОбъектов.ПолноеИмяОбъекта,
	|	ИсторияИзмененияОбъектов.РелизКонфигурации,
	|	ИсторияИзмененияОбъектов.НомерКартинки
	|ИЗ
	|	РегистрСведений.ИсторияИзмененияОбъектов КАК ИсторияИзмененияОбъектов
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ИспользоватьИдентификатор
	|				ТОГДА ИсторияИзмененияОбъектов.ИдентификаторСообщения = &ИдентификаторСообщения
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИспользоватьИмяОбъекта
	|				ТОГДА ИсторияИзмененияОбъектов.ПолноеИмяОбъекта = &ПолноеИмяОбъекта
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИспользоватьРелиз
	|				ТОГДА ИсторияИзмененияОбъектов.РелизКонфигурации = &РелизКонфигурации
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	Запрос.УстановитьПараметр("ИдентификаторСообщения", 	ИдентификаторСообщения);
	Запрос.УстановитьПараметр("ИспользоватьИдентификатор",	ЗначениеЗаполнено(ИдентификаторСообщения));
	Запрос.УстановитьПараметр("ПолноеИмяОбъекта", 			ПолноеИмяОбъекта);
	Запрос.УстановитьПараметр("ИспользоватьИмяОбъекта", 	ЗначениеЗаполнено(ПолноеИмяОбъекта));
	Запрос.УстановитьПараметр("РелизКонфигурации", 			РелизКонфигурации);
	Запрос.УстановитьПараметр("ИспользоватьРелиз", 			ЗначениеЗаполнено(РелизКонфигурации));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивСтруктур = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Струкрура = Новый Структура;
		Струкрура.Вставить("ИдентификаторСообщения",	Выборка.ИдентификаторСообщения);
		Струкрура.Вставить("ПолноеИмяОбъекта",			Выборка.ПолноеИмяОбъекта);
		Струкрура.Вставить("РелизКонфигурации",			Выборка.РелизКонфигурации);
		Струкрура.Вставить("НомерКартинки",				Выборка.НомерКартинки);
		МассивСтруктур.Добавить(Струкрура);		
	КонецЦикла;	
	
	Возврат МассивСтруктур;
	
КонецФункции
