﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Список.Параметры.УстановитьЗначениеПараметра("ЭтоОсновнойЯзык", ТекущийЯзык() = Метаданные.ОсновнойЯзык);
	Список.Параметры.УстановитьЗначениеПараметра("КодЯзыка", ТекущийЯзык().КодЯзыка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	// Проверим, выполняется ли копирование группы.
	Если Копирование И Группа Тогда
		Отказ = Истина;
		
		ПоказатьПредупреждение(, НСтр("ru = 'Добавление новых групп в справочнике запрещено.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные.ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		ПерейтиКСписку(Неопределено);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСписку(Команда)
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОткрытьФорму(ИмяФормыСписка(Элементы.Список.ТекущиеДанные.Ссылка));
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяФормыСписка(ВидКонтактнойИнформацииСсылка)
	
	ЭтоГруппа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидКонтактнойИнформацииСсылка, "ЭтоГруппа,Родитель");
	ГруппаВидаСсылка = ?(ЭтоГруппа.ЭтоГруппа, ВидКонтактнойИнформацииСсылка, ЭтоГруппа.Родитель);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|ВЫБОР
		|	КОГДА ВидыКонтактнойИнформации.ИмяПредопределенногоВида <> """"
		|	ТОГДА ВидыКонтактнойИнформации.ИмяПредопределенногоВида
		|	ИНАЧЕ ВидыКонтактнойИнформации.ИмяПредопределенныхДанных
		|КОНЕЦ КАК ИмяПредопределенногоВида
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Ссылка = &ГруппаВидаСсылка");
	
	Запрос.УстановитьПараметр("ГруппаВидаСсылка", ГруппаВидаСсылка);
	ИмяПредопределенногоВида = ВРЕГ(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяПредопределенногоВида")[0]);

	ИменаБазовыхТипов = Новый Массив;
	ИменаБазовыхТипов.Добавить("Справочник");
	ИменаБазовыхТипов.Добавить("Документ");
	ИменаБазовыхТипов.Добавить("БизнесПроцесс");
	ИменаБазовыхТипов.Добавить("Задача");
	ИменаБазовыхТипов.Добавить("ПланСчетов");
	ИменаБазовыхТипов.Добавить("ПланОбмена");
	ИменаБазовыхТипов.Добавить("ПланВидовХарактеристик");
	ИменаБазовыхТипов.Добавить("ПланВидовРасчета");
	Для каждого ИмяБазовогоТипа Из ИменаБазовыхТипов Цикл
		Если СтрНачинаетсяС(ИмяПредопределенногоВида, ВРег(ИмяБазовогоТипа)) Тогда
			 Возврат ИмяБазовогоТипа + "." 
			 	+ Сред(ИмяПредопределенногоВида, СтрДлина(ИмяБазовогоТипа) + 1, СтрДлина(ИмяПредопределенногоВида)) 
				+ ".ФормаСписка";
		КонецЕсли;	
	КонецЦикла;
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Невозможно перейти в списку для %1'"), ВидКонтактнойИнформацииСсылка);
	
КонецФункции	
	
#КонецОбласти