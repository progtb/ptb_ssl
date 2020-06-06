﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы();
	
	ПараметрыПриЗапускеПрограммы = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПриЗапускеПрограммы"];
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПолученныеПараметрыКлиента", Неопределено);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
		И ТипЗнч(ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.Вставить("ПолученныеПараметрыКлиента", ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(
			ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента));
	КонецЕсли;
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
		Параметры.Вставить("ПропуститьОчисткуСкрытияРабочегоСтола");
	КонецЕсли;
	
	Параметры.Вставить("ПараметрЗапуска", ПараметрЗапуска);
	Параметры.Вставить("СтрокаСоединенияИнформационнойБазы", СтрокаСоединенияИнформационнойБазы());
	Параметры.Вставить("ЭтоВебКлиент", ЭтоВебКлиент());
	Параметры.Вставить("ЭтоLinuxКлиент", ОбщегоНазначенияКлиент.ЭтоLinuxКлиент());
	Параметры.Вставить("ЭтоOSXКлиент", ОбщегоНазначенияКлиент.ЭтоOSXКлиент());
	Параметры.Вставить("ЭтоWindowsКлиент", ОбщегоНазначенияКлиент.ЭтоWindowsКлиент());
	Параметры.Вставить("ЭтоМобильныйКлиент", ЭтоМобильныйКлиент());
	Параметры.Вставить("ИспользуемыйКлиент", ИспользуемыйКлиент());
	Параметры.Вставить("КаталогПрограммы", ТекущийКаталогПрограммы());
	Параметры.Вставить("ИдентификаторКлиента", ИдентификаторКлиента());
	Параметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Ложь);
	Параметры.Вставить("ОперативнаяПамять", ОбщегоНазначенияКлиент.ОперативнаяПамятьДоступнаяКлиентскомуПриложению());
	Параметры.Вставить("РазрешениеОсновногоЭкрана", РазрешениеОсновногоЭкрана());
	
	// Установка даты клиента непосредственно перед вызовом, чтобы уменьшить погрешность.
	Параметры.Вставить("ТекущаяДатаНаКлиенте", ТекущаяДата()); // Для расчета ПоправкаКВремениСеанса.
	Параметры.Вставить("ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте", ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ОпцииИнтерфейса")
	   И ТипЗнч(Параметры.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.ПолученныеПараметрыКлиента.Вставить("ОпцииИнтерфейса");
	КонецЕсли;
	
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	Если ПараметрыПриЗапускеПрограммы.Свойство("ПолученныеПараметрыКлиента")
		И ПараметрыПриЗапускеПрограммы.ПолученныеПараметрыКлиента <> Неопределено
		И Не ПараметрыПриЗапускеПрограммы.Свойство("ОпцииИнтерфейса") Тогда
		
		ПараметрыПриЗапускеПрограммы.Вставить("ОпцииИнтерфейса", ПараметрыКлиента.ОпцииИнтерфейса);
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ЗаполнитьПараметрыКлиента(ПараметрыКлиента);
	
	// Обновление состояния скрытия рабочего стола на клиенте по состоянию на сервере.
	СтандартныеПодсистемыКлиент.СкрытьРабочийСтолПриНачалеРаботыСистемы(
		Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы, Истина);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

// См. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().
Функция ПараметрыРаботыКлиента() Экспорт
	
	ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы();
	ПроверитьПорядокЗапускаПрограммыПриНачалеРаботыСистемы();
	
	СвойстваКлиента = Новый Структура;
	
	// Установка даты клиента непосредственно перед вызовом, чтобы уменьшить погрешность.
	СвойстваКлиента.Вставить("ТекущаяДатаНаКлиенте", ТекущаяДата()); // Для расчета ПоправкаКВремениСеанса.
	СвойстваКлиента.Вставить("ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте",
		ТекущаяУниверсальнаяДатаВМиллисекундах());
	
	Возврат СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента(СвойстваКлиента);
	
КонецФункции

#Область ПредопределенныйЭлемент

// См. СтандартныеПодсистемыПовтИсп.СсылкиПоИменамПредопределенных
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

#КонецОбласти

Процедура ПроверитьПорядокЗапускаПрограммыПередНачаломРаботыСистемы()
	
	ИмяПараметра = "СтандартныеПодсистемы.ЗапускПрограммыЗавершен";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ВызватьИсключение
			НСтр("ru = 'Ошибка порядка запуска программы.
			           |Первой процедурой, которая вызывается из обработчика события ПередНачаломРаботыСистемы
			           |должна быть процедура БСП СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы.'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПорядокЗапускаПрограммыПриНачалеРаботыСистемы()
	
	Если Не СтандартныеПодсистемыКлиент.ЗапускПрограммыЗавершен() Тогда
		ВызватьИсключение
			НСтр("ru = 'Ошибка порядка запуска программы.
			           |Перед получением параметров работы клиента запуск программы должен быть завершен.'");
	КонецЕсли;
	
КонецПроцедуры

#Область ПараметрыРаботыКлиентаПриЗапуске

Функция ИспользуемыйКлиент()
	
	ИспользуемыйКлиент = "";
	#Если ТонкийКлиент Тогда
		ИспользуемыйКлиент = "ТонкийКлиент";
	#ИначеЕсли ТолстыйКлиентУправляемоеПриложение Тогда
		ИспользуемыйКлиент = "ТолстыйКлиентУправляемоеПриложение";
	#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
		ИспользуемыйКлиент = "ТолстыйКлиентОбычноеПриложение";
	#ИначеЕсли ВебКлиент Тогда
		ОписаниеБраузера = ТекущийБраузер();
		Если ПустаяСтрока(ОписаниеБраузера.Версия) Тогда
			ИспользуемыйКлиент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВебКлиент.%1", ОписаниеБраузера.Название);
		Иначе
			ИспользуемыйКлиент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВебКлиент.%1.%2", ОписаниеБраузера.Название, СтрРазделить(ОписаниеБраузера.Версия, ".")[0]);
		КонецЕсли;
	#КонецЕсли
	
	Возврат ИспользуемыйКлиент;
	
КонецФункции

Функция ТекущийБраузер()
	
	Результат = Новый Структура("Название,Версия", "Другой", "");
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Строка = СистемнаяИнформация.ИнформацияПрограммыПросмотра;
	Строка = СтрЗаменить(Строка, ",", ";");

	// Opera
	Идентификатор = "Opera";
	Позиция = СтрНайти(Строка, Идентификатор, НаправлениеПоиска.СКонца);
	Если Позиция > 0 Тогда
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Результат.Название = "Opera";
		Идентификатор = "Version/";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Результат.Версия = СокрЛП(Строка);
		Иначе
			Строка = СокрЛП(Строка);
			Если СтрНачинаетсяС(Строка, "/") Тогда
				Строка = Сред(Строка, 2);
			КонецЕсли;
			Результат.Версия = СокрЛ(Строка);
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// IE
	Идентификатор = "MSIE"; // v11-
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "IE";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Позиция = СтрНайти(Строка, ";");
		Если Позиция > 0 Тогда
			Строка = СокрЛ(Лев(Строка, Позиция - 1));
			Результат.Версия = Строка;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	Идентификатор = "Trident"; // v11+
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "IE";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		
		Идентификатор = "rv:";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Позиция = СтрНайти(Строка, ")");
			Если Позиция > 0 Тогда
				Строка = СокрЛ(Лев(Строка, Позиция - 1));
				Результат.Версия = Строка;
			КонецЕсли;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Chrome
	Идентификатор = "Chrome/";
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "Chrome";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Позиция = СтрНайти(Строка, " ");
		Если Позиция > 0 Тогда
			Строка = СокрЛ(Лев(Строка, Позиция - 1));
			Результат.Версия = Строка;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Safari
	Идентификатор = "Safari/";
	Если СтрНайти(Строка, Идентификатор) > 0 Тогда
		Результат.Название = "Safari";
		Идентификатор = "Version/";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Позиция = СтрНайти(Строка, " ");
			Если Позиция > 0 Тогда
				Результат.Версия = СокрЛП(Лев(Строка, Позиция - 1));
			КонецЕсли;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Firefox
	Идентификатор = "Firefox/";
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "Firefox";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Если Не ПустаяСтрока(Строка) Тогда
			Результат.Версия = СокрЛП(Строка);
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТекущийКаталогПрограммы()
	
	#Если ВебКлиент Или МобильныйКлиент Тогда
		КаталогПрограммы = "";
	#Иначе
		КаталогПрограммы = КаталогПрограммы();
	#КонецЕсли
	
	Возврат КаталогПрограммы;
	
КонецФункции

Функция РазрешениеОсновногоЭкрана()
	
	ИнформациюЭкрановКлиента = ПолучитьИнформациюЭкрановКлиента();
	Если ИнформациюЭкрановКлиента.Количество() > 0 Тогда
		DPI = ИнформациюЭкрановКлиента[0].DPI;
		РазрешениеОсновногоЭкрана = ?(DPI = 0, 72, DPI);
	Иначе
		РазрешениеОсновногоЭкрана = 72;
	КонецЕсли;
	
	Возврат РазрешениеОсновногоЭкрана;
	
КонецФункции

Функция ИдентификаторКлиента()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Возврат СистемнаяИнформация.ИдентификаторКлиента;
	
КонецФункции

Функция ЭтоВебКлиент() Экспорт
	
#Если ВебКлиент Тогда
	Возврат Истина;
#Иначе
	Возврат Ложь;
#КонецЕсли
	
КонецФункции

Функция ЭтоМобильныйКлиент() Экспорт
	
#Если МобильныйКлиент Тогда
	Возврат Истина;
#Иначе
	Возврат Ложь;
#КонецЕсли
	
КонецФункции

#КонецОбласти

#КонецОбласти
