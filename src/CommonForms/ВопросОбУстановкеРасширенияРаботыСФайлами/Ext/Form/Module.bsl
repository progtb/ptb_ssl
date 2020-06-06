﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ТекстПредложения) Тогда
		Элементы.ДекорацияПояснение.Заголовок = Параметры.ТекстПредложения
			+ Символы.ПС
			+ НСтр("ru = 'Установить?'");
		
	ИначеЕсли Не Параметры.ВозможноПродолжениеБезУстановки Тогда
		Элементы.ДекорацияПояснение.Заголовок =
			НСтр("ru = 'Для выполнения действия требуется установить расширение для веб-клиента 1С:Предприятие.
			           |Установить?'");
	КонецЕсли;
	
	Если Не Параметры.ВозможноПродолжениеБезУстановки Тогда
		Элементы.ПродолжитьБезУстановки.Заголовок = НСтр("ru = 'Отмена'");
		Элементы.БольшеНеНапоминать.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИПродолжить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИПродолжитьЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБезУстановки(Команда)
	
	Закрыть("ПродолжитьБезУстановки");
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеНеНапоминать(Команда)
	
	Закрыть("БольшеНеПредлагать");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьИПродолжитьЗавершение(Контекст) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИПродолжитьПослеПодключенияРасширения", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИПродолжитьПослеПодключенияРасширения(Подключено, Контекст) Экспорт
	
	Если Подключено Тогда
		Закрыть("РасширениеПодключено");
	Иначе
		Оповещение = Новый ОписаниеОповещения("УстановитьИПродолжитьПослеПредупреждениеОбОшибке", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, 
			НСтр("ru = 'Не удалось установить расширение для работы с файлами.
			           |по причине:
			           |Метод НачатьПодключениеРасширенияРаботыСФайлами вернул Ложь
			           |
			           |Обратитесь к администратору.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИПродолжитьПослеПредупреждениеОбОшибке(Контекст) Экспорт
	
	Закрыть("ПродолжитьБезУстановки");
	
КонецПроцедуры

#КонецОбласти
