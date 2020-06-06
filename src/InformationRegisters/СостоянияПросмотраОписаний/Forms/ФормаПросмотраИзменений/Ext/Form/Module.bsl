﻿// 21.10.2015, Белопухов А.Н., п.3388
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ПолноеИмяОбъекта") = Истина Тогда
		УстановленОтбор = Истина;
		ОтборПоОбъекту = Параметры.ПолноеИмяОбъекта;
	КонецЕсли;
	
	Если Параметры.Свойство("РелизКонфигурации") = Истина Тогда
		ОтборПоРелизу = Параметры.РелизКонфигурации;
	КонецЕсли;

	ИнициализацияФормыНаСервере();

КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормыНаСервере()
	УстановленОтбор = ?(ОтборПоОбъекту = "", Ложь, Истина);
	МассивПунктов = РегистрыСведений.СостоянияПросмотраОписаний.ПолучитьСписокПунктовОбъектаНаСервере(ОтборПоОбъекту);
	
	Таблица.Очистить();
	Релизы = РегистрыСведений.СостоянияПросмотраОписаний.ПолучитьСписокРелизов(МассивПунктов);
	
	Для Каждого СтрокаРелиза Из Релизы Цикл
		СтрокаТЗ = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЗ,СтрокаРелиза);
	КонецЦикла;
	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРелизовПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВерсияКонфигурации = Элемент.ТекущиеДанные.НомерРелиза;
	ВОбновленииЕстьПунктыПользователя = ЕстьПунктыПользователяНаСервере(ТекущийПользователь, ВерсияКонфигурации);
	Печать(ТекущийПользователь, ВерсияКонфигурации);
	Элементы.ОписаниеИзменений.ТекущаяОбласть = ТабличныйДокумент.Область("R1C1");
	
КонецПроцедуры

&НаСервере
Функция ЕстьПунктыПользователяНаСервере(ТекущийПользователь, ВерсияКонфигурации)
	Возврат Регистрысведений.СостоянияПросмотраОписаний.ВОбновленииЕстьПунктыПользователя(ТекущийПользователь, ВерсияКонфигурации);	
КонецФункции

&НаСервере
Процедура Печать(ТекущийПользователь, ВерсияКонфигурации) 
	
	ТабличныйДокумент.Очистить();
		
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = РегистрыСведений.СостоянияПросмотраОписаний.ПолучитьМакет("Макет");
	
	Область = Макет.ПолучитьОбласть("Заголовок");
	
	Область.Параметры.НомерРелиза = ВерсияКонфигурации;
	Область.Параметры.ДатаРелиза = Формат(РегистрыСведений.СостоянияПросмотраОписаний.ПолучитьДатуРелиза(ВерсияКонфигурации),"ДФ=dd.MM.yyyy");	
	ТабДок.Вывести(Область);
		
	ПоказатьПовторяющиесяСтроки(ВерсияКонфигурации,ТабДок,Макет,Истина);
	ПоказатьПовторяющиесяСтроки(ВерсияКонфигурации,ТабДок,Макет,Ложь);
	
	ТабличныйДокумент.Вывести(ТабДок);	
    
КонецПроцедуры

&НаСервере
Процедура ПоказатьПовторяющиесяСтроки(ВерсияКонфигурации,ТабДок,Макет,Собственные)
	МассивПунктов = РегистрыСведений.СостоянияПросмотраОписаний.ПолучитьСписокПунктовОбъектаНаСервере(ОтборПоОбъекту);
	
	ДанныеДляПечати = РегистрыСведений.СостоянияПросмотраОписаний.ПолучитьДанныеДляПечати(ТекущийПользователь, ВерсияКонфигурации,МассивПунктов);

	ОбластьТема 	= Макет.ПолучитьОбласть("Тема");
	ОбластьДетали 	= Макет.ПолучитьОбласть("Детали");
	
	ОбластьОписаниеЗаголовок 	= Макет.ПолучитьОбласть("ОписаниеЗаголовок");
    ОбластьОписание 			= Макет.ПолучитьОбласть("ОписаниеИзменений");

	Если Собственные И НЕ ВОбновленииЕстьПунктыПользователя Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ УстановленОтбор Тогда
		Если НЕ Собственные И ВОбновленииЕстьПунктыПользователя Тогда
			ОбластьДругиеПункты = Макет.ПолучитьОбласть("ДругиеПункты");
			ТабДок.Вывести(ОбластьДругиеПункты);
	       	ТабДок.НачатьГруппуСтрок("Группа Прочие", НЕ ВОбновленииЕстьПунктыПользователя);

		КонецЕсли;
	КонецЕсли;
	Для Каждого СтрокаТаблицы Из ДанныеДляПечати Цикл
		Если СтрокаТаблицы.СобственныйПункт = Собственные Тогда
			ОбластьТема.Параметры.КодРазработчика 	= Формат(СтрокаТаблицы.КодРазработчика,"ЧГ=");
			ОбластьТема.Параметры.Тема 			= СтрокаТаблицы.Тема;
			ТабДок.Вывести(ОбластьТема);
			
			ОбластьДетали.Параметры.Текст			= СтрокаТаблицы.Текст;
			ОбластьДетали.Параметры.ДатаОтправки 	= Формат(СтрокаТаблицы.ДатаОтправки,"ДФ=dd.MM.yyyy");
			ОбластьДетали.Параметры.Отправитель 	= СтрокаТаблицы.Отправитель;		
			
			ТабДок.Вывести(ОбластьДетали);
			
			ТабДок.Вывести(ОбластьОписаниеЗаголовок);

			Если СтрокаТаблицы.ЗаданиеНаРазработку <> "" Тогда
				ОбластьЗадание = Макет.ПолучитьОбласть("Задание");	
				ОбластьЗадание.Параметры.ЗаданиеНаРазработку = СтрокаТаблицы.ЗаданиеНаРазработку;
				ТабДок.Вывести(ОбластьЗадание);
			КонецЕсли;
			
			Если СтрокаТаблицы.ОписаниеИзменений = "" Тогда
				ОбластьОписание.Параметры.ОписаниеИзменений = "Исправлено. Без описаний";
				ТабДок.Вывести(ОбластьОписание);
			Иначе
				ОбластьОписание.Параметры.ОписаниеИзменений = СтрокаТаблицы.ОписаниеИзменений;
				ТабДок.Вывести(ОбластьОписание);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если НЕ УстановленОтбор Тогда
		
		Если НЕ Собственные И ВОбновленииЕстьПунктыПользователя Тогда
			ТабДок.ЗакончитьГруппуСтрок();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоОбъектуОчистка(Элемент, СтандартнаяОбработка)
	ИнициализацияФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоОбъектуПриИзменении(Элемент)
	ИнициализацияФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоРелизуОчистка(Элемент, СтандартнаяОбработка)
	ИнициализацияФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоРелизуПриИзменении(Элемент)
	ИнициализацияФормыНаСервере();
КонецПроцедуры


