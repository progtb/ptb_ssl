﻿// Copyright (c) 2023, ООО ПрогТехБизнес
// Лицензия Attribution 4.0 International (CC BY 4.0)

#Область ПараметрыОбласти

Процедура ЗаполнитьДеревоПараметров(знач ДеревоОбластей, знач ПараметрыПоУмолчанию, знач ПараметрыМакета = Неопределено) Экспорт
	ДеревоОбластей.Строки.Очистить();
	Если НЕ ТипЗнч(ПараметрыПоУмолчанию) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ПараметрыПоУмолчанию Цикл
		ДанныеОбластей			= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(КлючИЗначение.Значение, "Параметры", Новый Структура);
		ПоляПредставлений		= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(КлючИЗначение.Значение, "Представления", Новый Структура);
		ПользовательскиеПоля	= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(КлючИЗначение.Значение, "ПользовательскиеПоля", Новый Структура);
		
		СтрокаДерева = ДеревоОбластей.Строки.Добавить();
		СтрокаДерева.Представление		= КлючИЗначение.Ключ;
		СтрокаДерева.Значение			= "";
		СтрокаДерева.ИмяРеквизита		= КлючИЗначение.Ключ;
		СтрокаДерева.ПолныйПуть			= КлючИЗначение.Ключ;
		СтрокаДерева.ТипДанных			= Неопределено;
		СтрокаДерева.ЭтоРаздел			= Истина;
		СтрокаДерева.ЭтоГруппа			= Истина;
		СтрокаДерева.ЭтоСтрокаМассива	= Истина;
		СтрокаДерева.КартинкаТипа		= 1;
		
		СтрокаДерева.ПоляПредставлений		= ПолучитьПоляПредставленияОбласти(ПоляПредставлений, КлючИЗначение.Ключ, ПараметрыМакета);
		СтрокаДерева.ПользовательскиеПоля	= ПолучитьПользовательскиеПоляОбласти(ПользовательскиеПоля, КлючИЗначение.Ключ, ПараметрыМакета);

		ЗаполнитьДеревоПараметровРекурсивно(СтрокаДерева, ДанныеОбластей);
	КонецЦикла;
	
	ДеревоОбластей.Строки.Сортировать("ИмяРеквизита", Ложь);
КонецПроцедуры

Функция ДеревоПараметровОбластей() Экспорт
	ДеревоЗначений = Новый ДеревоЗначений;
	ДеревоЗначений.Колонки.Добавить("Представление"			, ОбщегоНазначения.ОписаниеТипаСтрока(150)	, НСтр("ru='Реквизит'"));
	ДеревоЗначений.Колонки.Добавить("ПолныйПуть"			, ОбщегоНазначения.ОписаниеТипаСтрока(0)	, НСтр("ru='Полный путь'"));
	ДеревоЗначений.Колонки.Добавить("ИмяРеквизита"			, ОбщегоНазначения.ОписаниеТипаСтрока(150)	, НСтр("ru='Имя реквизита'"));
	ДеревоЗначений.Колонки.Добавить("Значение"				, Новый ОписаниеТипов()						, НСтр("ru='Значение'"));
	ДеревоЗначений.Колонки.Добавить("ТипДанных"				, Новый ОписаниеТипов()						, НСтр("ru='Тип данных'"));
	ДеревоЗначений.Колонки.Добавить("ЭтоРаздел"				, Новый ОписаниеТипов("Булево")				, НСтр("ru='Это раздел'"));
	ДеревоЗначений.Колонки.Добавить("ЭтоГруппа"				, Новый ОписаниеТипов("Булево")				, НСтр("ru='Это группа'"));
	ДеревоЗначений.Колонки.Добавить("ЭтоСтрокаМассива"		, Новый ОписаниеТипов("Булево")				, НСтр("ru='Это строка массива'"));
	ДеревоЗначений.Колонки.Добавить("КартинкаТипа"			, ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ДеревоЗначений.Колонки.Добавить("ПоляПредставлений"		, Новый ОписаниеТипов("ТаблицаЗначений"));
	ДеревоЗначений.Колонки.Добавить("ПользовательскиеПоля"	, Новый ОписаниеТипов("ТаблицаЗначений"));
	
	Возврат ДеревоЗначений;
КонецФункции

Функция ТаблицаПолейПредставления() Экспорт
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ИмяРеквизита"		, ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ТаблицаЗначений.Колонки.Добавить("Реквизиты"		, ОбщегоНазначения.ОписаниеТипаСтрока(0));
	ТаблицаЗначений.Колонки.Добавить("Настройки"		, Новый ОписаниеТипов());
	ТаблицаЗначений.Колонки.Добавить("Предопределенный"	, Новый ОписаниеТипов("Булево"));
	ТаблицаЗначений.Колонки.Добавить("ЕстьИзменения"	, Новый ОписаниеТипов("Булево"));
	ТаблицаЗначений.Колонки.Добавить("ИсходныеДанные"	, Новый ОписаниеТипов());
	Возврат ТаблицаЗначений;
КонецФункции

Функция ТаблицаПользовательскихПолей() Экспорт
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ИмяРеквизита"	, ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ТаблицаЗначений.Колонки.Добавить("Формула"		, ОбщегоНазначения.ОписаниеТипаСтрока(0));
	Возврат ТаблицаЗначений;
КонецФункции

Функция ТаблицаРеквизитовПоляПредставления() Экспорт
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("Представление"	, ОбщегоНазначения.ОписаниеТипаСтрока(150)	, НСтр("ru='Реквизит'"));
	ТаблицаЗначений.Колонки.Добавить("Префикс"			, ОбщегоНазначения.ОписаниеТипаСтрока(150)	, НСтр("ru='Префикс'"));
	ТаблицаЗначений.Колонки.Добавить("Значение"			, Новый ОписаниеТипов()						, НСтр("ru='Значение'"));
	ТаблицаЗначений.Колонки.Добавить("ИмяРеквизита"		, ОбщегоНазначения.ОписаниеТипаСтрока(150)	, НСтр("ru='Имя реквизита'"));
	ТаблицаЗначений.Колонки.Добавить("ПолныйПуть"		, ОбщегоНазначения.ОписаниеТипаСтрока(0)	, НСтр("ru='Полный путь'"));
	ТаблицаЗначений.Колонки.Добавить("ТипДанных"		, Новый ОписаниеТипов()						, НСтр("ru='Тип данных'"));
	ТаблицаЗначений.Колонки.Добавить("КартинкаФормат"	, ОбщегоНазначения.ОписаниеТипаЧисло(10)	, НСтр("ru='F'"));
	ТаблицаЗначений.Колонки.Добавить("КартинкаПоложение", ОбщегоНазначения.ОписаниеТипаЧисло(10)	, НСтр("ru='-'"));
	ТаблицаЗначений.Колонки.Добавить("Формат"			, ОбщегоНазначения.ОписаниеТипаСтрока(20));
	ТаблицаЗначений.Колонки.Добавить("Положение"		, ОбщегоНазначения.ОписаниеТипаЧисло(1));
	ТаблицаЗначений.Колонки.Добавить("КартинкаТипа"		, ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ТаблицаЗначений.Колонки.Добавить("ПрефиксДо"		, ОбщегоНазначения.ОписаниеТипаСтрока(150));
	ТаблицаЗначений.Колонки.Добавить("ФорматДо"			, ОбщегоНазначения.ОписаниеТипаСтрока(20));	
	ТаблицаЗначений.Колонки.Добавить("ПоложениеДо"		, ОбщегоНазначения.ОписаниеТипаЧисло(1));
	ТаблицаЗначений.Колонки.Добавить("ПорядокДо"		, ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ТаблицаЗначений.Колонки.Добавить("ЭтоНовый"			, Новый ОписаниеТипов("Булево"));
	Возврат ТаблицаЗначений;
КонецФункции

Функция ПолучитьДанныеПечатиПоСхеме(знач Источники, знач Схемы) Экспорт
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДеревоПараметровРекурсивно(знач СтрокаРодитель, знач Данные)
	ПростыеТипы = Новый Массив;
	ПростыеТипы.Добавить(Тип("УникальныйИдентификатор"));
	ПростыеТипы.Добавить(Тип("Число"));
	ПростыеТипы.Добавить(Тип("Строка"));
	ПростыеТипы.Добавить(Тип("Дата"));
	ПростыеТипы.Добавить(Тип("Булево"));
	
	КоллекцииТипы = Новый Массив;
	КоллекцииТипы.Добавить(Тип("Структура"));
	КоллекцииТипы.Добавить(Тип("ФиксированнаяСтруктура"));
	КоллекцииТипы.Добавить(Тип("Массив"));
	КоллекцииТипы.Добавить(Тип("ФиксированныйМассив"));
	КоллекцииТипы.Добавить(Тип("Соответствие"));
	КоллекцииТипы.Добавить(Тип("ФиксированноеСоответствие"));
	
	ДопустимыеТипы = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДопустимыеТипы, ПростыеТипы);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДопустимыеТипы, КоллекцииТипы);
	
	ТипДанных = ТипЗнч(Данные);
	Если ТипДанных = Тип("Массив") ИЛИ ТипДанных = Тип("ФиксированныйМассив") Тогда
		Для Индекс = 0 По Мин(Данные.ВГРаница(), 4) Цикл
			ЭлементМассива = Данные[Индекс];
			
			СтрокаДерева = СтрокаРодитель.Строки.Добавить();
			СтрокаДерева.Представление		= СтрШаблон("[%1]", Формат(Индекс, "ЧН=0; ЧГ="));
			СтрокаДерева.Значение			= Неопределено;
			СтрокаДерева.ИмяРеквизита		= "";
			СтрокаДерева.ПолныйПуть			= "";
			СтрокаДерева.ТипДанных			= "";
			СтрокаДерева.ЭтоРаздел			= Ложь;
			СтрокаДерева.ЭтоГруппа			= Истина;
			СтрокаДерева.ЭтоСтрокаМассива	= Истина;
			СтрокаДерева.КартинкаТипа		= 9;
			
			ЗаполнитьДеревоПараметровРекурсивно(СтрокаДерева, ЭлементМассива);
		КонецЦикла;
		
		Возврат;
	КонецЕсли;	
	
	Если ТипДанных = Тип("Структура") ИЛИ ТипДанных = Тип("ФиксированнаяСтруктура") Тогда
		ИсточникДанных = Данные;
	ИначеЕсли ТипДанных = Тип("Соответствие") ИЛИ ТипДанных = Тип("ФиксированноеСоответствие") Тогда
		ИсточникДанных = Данные;
	Иначе 
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ИсточникДанных Цикл
		ТипДанных = ТипЗнч(КлючИЗначение.Значение);
		Если ДопустимыеТипы.Найти(ТипДанных) = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ЭтоПростойТип = (ПростыеТипы.Найти(ТипДанных) <> Неопределено);
		Если НЕ ЭтоПростойТип Тогда
			ЗначениеУзла = "";
		Иначе 
			ЗначениеУзла = КлючИЗначение.Значение;
		КонецЕсли;
		
		ПутьРодителя = ?(СтрокаРодитель.ЭтоРаздел ИЛИ СтрокаРодитель.ЭтоСтрокаМассива, "", СтрокаРодитель.ПолныйПуть + ".");
		
		СтрокаДерева = СтрокаРодитель.Строки.Добавить();
		СтрокаДерева.Представление	= КлючИЗначение.Ключ;
		СтрокаДерева.Значение		= ЗначениеУзла;
		СтрокаДерева.ИмяРеквизита	= КлючИЗначение.Ключ;
		СтрокаДерева.ПолныйПуть		= ПутьРодителя + КлючИЗначение.Ключ;
		СтрокаДерева.ТипДанных		= ТипДанных;
		СтрокаДерева.ЭтоРаздел		= Ложь;
		СтрокаДерева.ЭтоГруппа		= НЕ ЭтоПростойТип;
		СтрокаДерева.КартинкаТипа	= ОбщегоНазначенияПТБКлиентСервер.НомерКартинкиПоТипуДанных(ТипДанных);
		
		ЗаполнитьДеревоПараметровРекурсивно(СтрокаДерева, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьПоляПредставленияОбласти(знач НаборПредставлений, знач ИмяОбласти, знач ПараметрыМакета)
	Если НЕ ТипЗнч(НаборПредставлений) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;

	ТаблицаЗначений = ТаблицаПолейПредставления();
	
	Для Каждого КлючИЗначение Из НаборПредставлений Цикл
		Реквизиты			= ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(КлючИЗначение.Значение, "Реквизиты", "");
		Настройки			= ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(КлючИЗначение.Значение, "Настройки", Неопределено);
		Предопределенный	= ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(КлючИЗначение.Значение, "Предопределенный", Ложь);
		
		ИсходныеДанные = УправлениеПечатьюПТБКлиентСервер.КоллекцияПредставление(Реквизиты, Настройки, Предопределенный);
		
		ДанныеПредставления = ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(ПараметрыМакета, ИмяОбласти + ".Представления." + КлючИЗначение.Ключ, Неопределено);
		Если НЕ ТипЗнч(ДанныеПредставления) = Тип("Структура") Тогда
			ЕстьИзменения = Ложь;
			ДанныеПредставления = ИсходныеДанные;
		Иначе 
			ЕстьИзменения = Истина;
		КонецЕсли;
		
		СтрокаТаблицы = ТаблицаЗначений.Добавить();
		СтрокаТаблицы.ИмяРеквизита		= КлючИЗначение.Ключ;
		СтрокаТаблицы.Реквизиты			= ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(ДанныеПредставления, "Реквизиты", "");
		СтрокаТаблицы.Настройки			= ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(ДанныеПредставления, "Настройки", Неопределено);
		СтрокаТаблицы.Предопределенный	= ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(ДанныеПредставления, "Предопределенный", Ложь);
		СтрокаТаблицы.ЕстьИзменения		= ЕстьИзменения;
		СтрокаТаблицы.ИсходныеДанные	= ИсходныеДанные;
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
КонецФункции

Функция ПолучитьПользовательскиеПоляОбласти(знач НаборПолей, знач ИмяОбласти, знач ПараметрыМакета)
	Если НЕ ТипЗнч(НаборПолей) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаЗначений = ТаблицаПользовательскихПолей();
	
	Для Каждого КлючИЗначение Из НаборПолей Цикл
		СтрокаТаблицы = ТаблицаЗначений.Добавить();
		СтрокаТаблицы.ИмяРеквизита	= КлючИЗначение.Ключ;
		СтрокаТаблицы.Формула		= КлючИЗначение.Значение;
	КонецЦикла;
	
	ПользовательскиеПоля = ОбщегоНазначенияПТБКлиентСервер.СвойствоСтруктуры(ПараметрыМакета, ИмяОбласти + ".ПользовательскиеПоля", Новый Структура);
	Для Каждого КлючИЗначение Из ПользовательскиеПоля Цикл
		СтрокаТаблицы = ТаблицаЗначений.Добавить();
		СтрокаТаблицы.ИмяРеквизита	= КлючИЗначение.Ключ;
		СтрокаТаблицы.Формула		= КлючИЗначение.Значение;
	КонецЦикла;
	
	Возврат ТаблицаЗначений;
КонецФункции

#КонецОбласти
