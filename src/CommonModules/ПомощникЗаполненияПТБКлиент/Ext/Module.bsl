﻿// Copyright (c) 2023, ООО ПрогТехБизнес
// Лицензия Attribution 4.0 International (CC BY 4.0)

#Область ПрограммныйИнтерфейс
 
// Выполняет обработку события Нажатие на элементе формы представления настройки отбора
//
// Параметры:
//	Форма					- УправляемаяФорма
//	Элемент					- ЭлементФормы - берется из параметра события Нажатие
//	СтандартнаяОбработка	- Булево - берется из параметра события Нажатие
//	ЗапрещенныеПоля			- Массив - массив имен запрещенных к отбору полей.
//		Допустимо использовать имена полей через точку.
// 
Процедура ПомощникЗаполненияОтборНажатие(Форма, Элемент, СтандартнаяОбработка, знач ЗапрещенныеПоля = Неопределено) Экспорт 
	СтандартнаяОбработка = Ложь;
	
	// Подготовка
	РеквизитКомпоновщик = СтрЗаменить(Элемент.Имя, "_НадписьОтбор", "");
	
	// Формирование параметров формы
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок"				, НСтр("ru='Настройка отбора'"));
	ПараметрыФормы.Вставить("ЗапрещенныеПоля"		, ЗапрещенныеПоля);
	ПараметрыФормы.Вставить("КомпоновщикНастроек"	, Форма[РеквизитКомпоновщик]);

	// Описание оповещения о завершении редактирования
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Форма"				, Форма);
	ДопПараметры.Вставить("РеквизитКомпоновщик"	, РеквизитКомпоновщик);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастройкаОтбораКомпоновкиЗавершение", ЭтотОбъект, ДопПараметры);
	
	// Форма для настройки
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкиОтбораКомпоновкиПТБ",
		ПараметрыФормы, Форма,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастройкаОтбораКомпоновкиЗавершение(Результат, ДопПараметры) Экспорт	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли НЕ ТипЗнч(Результат) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;
	
	Форма				= ДопПараметры.Форма;
	РеквизитКомпоновщик	= ДопПараметры.РеквизитКомпоновщик;
	
	// Обработка результата
	Форма[РеквизитКомпоновщик]	= Результат;
	Форма.Модифицированность	= Истина;
	ПомощникЗаполненияПТБКлиентСервер.ОбновитьПредставлениеОтбора(Форма, РеквизитКомпоновщик);
КонецПроцедуры

#КонецОбласти
