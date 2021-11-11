﻿
#Область ПрограммныйИнтерфейс

// Выполняет открытие формы редактирования формулы
//
// Параметры:
//	Параметры - Структура - см. ПараметрыРедактирования
//
Процедура РедактироватьФормулу(знач Параметры) Экспорт
	
	ФормаВладелец	= Параметры.Форма;
	ФормулыРасчета	= Параметры.ФормулыРасчета;
	СтрокаФормулы	= Параметры.СтрокаФормулы;
	Показатели		= Параметры.Показатели;
	Оповещение		= Параметры.Оповещение;
	ТолькоПросмотр	= Параметры.ТолькоПросмотр;
	
	ОтборФормулы = Новый Структура;
	ОтборФормулы.Вставить("Идентификатор"	, СтрокаФормулы.Идентификатор);
	ОтборФормулы.Вставить("Колонка"			, СтрокаФормулы.Колонка);
	
	МассивСтрокФормул = Новый Массив;
	Для Каждого СтрокаТаблицы Из ФормулыРасчета Цикл
		СтруктураСтроки = РаботаСФормуламиКлиентСервер.СтруктураФормулы();
		ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрокаТаблицы);
		МассивСтрокФормул.Добавить(СтруктураСтроки);
	КонецЦикла;
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ФормулыРасчета"	, ФормулыРасчета);
	ДопПараметры.Вставить("Оповещение"		, Оповещение);
	ДопПараметры.Вставить("Идентификатор"	, СтрокаФормулы.Идентификатор);
	ДопПараметры.Вставить("Колонка"			, СтрокаФормулы.Колонка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьФормулуЗавершение", ЭтотОбъект, ДопПараметры);
	
	ТекущаяФормула = РаботаСФормуламиКлиентСервер.СтруктураФормулы();
	ЗаполнитьЗначенияСвойств(ТекущаяФормула, СтрокаФормулы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор"	, СтрокаФормулы.Идентификатор);
	ПараметрыФормы.Вставить("Колонка"		, СтрокаФормулы.Колонка);
	ПараметрыФормы.Вставить("ТекущаяФормула", ТекущаяФормула);
	ПараметрыФормы.Вставить("Формулы"		, МассивСтрокФормул);
	ПараметрыФормы.Вставить("Показатели"	, Показатели);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ПараметрыФормы.Вставить("ЗапретитьПоказатель"		, Параметры.ЗапретитьПоказатель);
	ПараметрыФормы.Вставить("РазрешитьПустоеЗначение"	, Параметры.РазрешитьПустоеЗначение);
	
	ОткрытьФорму("Обработка.РаботаСФормулами.Форма",
		ПараметрыФормы,
		ФормаВладелец,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Возвращает структуру для передачи в качестве параметра
// в метод РедактироватьФормулу
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма владелец, для
//		открываемой формы редактирования формулы
//
// Возвращаемое значение:
//   Структура
//		Форма					- ФормаКлиентскогоПриложения 
//		ФормулыРасчета			- ДанныеФормыКоллекция - табличная часть ФормулыРасчета
//		СтрокаФормулы			- ДанныеФормыЭлементКоллекции - тек. строка ФормулыРасчета
//		Показатели				- Структура - коллекция групп показателей
//			см. РаботаСФормуламиКлиентСервер.ДобавитьГруппуПоказателей
//		Оповещение				- ОписаниеОповещения - оповещение для вызова по окончанию редактирования
//			формулы. В качестве результата передается Булево, признак необходимости пересчета
//			значения по текущей строке формулы (при изменении значимых реквизитов
//		ТолькоПросмотр			- Булево - признак открытия формы в режиме просмотра
//		ЗапретитьПоказатель		- Булево - признак запрета создания показателя в строке (скрыт блок показателя)
//		РазрешитьПустоеЗначение	- Булево - признак разрешения пустого значения в результате
//
Функция ПараметрыРедактирования(знач Форма) Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("Форма"			, Форма);
	Параметры.Вставить("ФормулыРасчета"	, Неопределено);
	Параметры.Вставить("СтрокаФормулы"	, Неопределено);
	Параметры.Вставить("Показатели"		, Неопределено);
	Параметры.Вставить("Оповещение"		, Неопределено);
	Параметры.Вставить("ТолькоПросмотр"	, Ложь);
	
	Параметры.Вставить("РазрешитьПустоеЗначение"	, Ложь);
	Параметры.Вставить("ЗапретитьПоказатель"		, Ложь);
	
	Возврат Параметры;
КонецФункции

#КонецОбласти

#Область ЗавершениеНемодальныхВызовов

Процедура РедактироватьФормулуЗавершение(Результат, ДопПараметры) Экспорт	
	Если НЕ ТипЗнч(Результат) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ФормулыРасчета	= ДопПараметры.ФормулыРасчета;
	Оповещение		= ДопПараметры.Оповещение;
	Идентификатор	= ДопПараметры.Идентификатор;
	Колонка			= ДопПараметры.Колонка;
	
	ОтборФормулы = Новый Структура("Идентификатор, Колонка", Идентификатор, Колонка);
	
	МассивСтрокФормулы = ФормулыРасчета.НайтиСтроки(ОтборФормулы);
	Если МассивСтрокФормулы.Количество() > 0 Тогда
		СтрокаТаблицы = МассивСтрокФормулы[0];
	Иначе 
		СтрокаТаблицы = ФормулыРасчета.Добавить();
		СтрокаТаблицы.Идентификатор	= Результат.Идентификатор;
	КонецЕсли;
	
	ФормулаИзменилась		= (СтрокаТаблицы.Формула <> Результат.Формула);
	ИзменилосьЗначение		= (СтрокаТаблицы.РучноеЗначение <> Результат.РучноеЗначение);
	ИзменилосьОкругление	= (СтрокаТаблицы.НеОкруглять <> Результат.НеОкруглять ИЛИ СтрокаТаблицы.ТочностьОкругления <> Результат.ТочностьОкругления);
	ИзменилосьМодальность	= (СтрокаТаблицы.НеОтрицательное <> Результат.НеОтрицательное);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Результат,, "Идентификатор");
		
	СтрокаТаблицы.РасчетПредставление = РаботаСФормуламиКлиентСервер.ПолучитьРасчетПредставление(Результат);
	
	ТребуетсяПересчет = (ФормулаИзменилась ИЛИ ИзменилосьЗначение ИЛИ ИзменилосьОкругление ИЛИ ИзменилосьМодальность);
	
	Если ТипЗнч(Оповещение) = Тип("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(Оповещение, ТребуетсяПересчет);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти