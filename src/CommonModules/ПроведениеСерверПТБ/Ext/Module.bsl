﻿
#Область ПрограммныйИнтерфейс

// Заполняет вспомогательную структуру для хранения данных связанных с проведением документа
//
// Параметры:
//	ДокументСсылка - ДокументСсылка - любой документ, имеющий возможность проведения
//	ДополнительныеСвойства - Структура - структура для хранения вспомогательных данных
//	РежимПроведения - РежимПроведенияДокумента
// 
Процедура ИнициализацияДополнительныхСвойствДляПроведения(ДокументСсылка, ДополнительныеСвойства, РежимПроведения = Неопределено) Экспорт 
	
	// Хранение данных для формирования проведения документа
	ДополнительныеСвойства.Вставить("ПараметрыПроведения", Новый Структура);
	
	// Устанавливаем признак наличия контроля по регистрам
	ДополнительныеСвойства.Вставить("РассчитыватьИзменения"	, Истина);
	ДополнительныеСвойства.Вставить("РезультатКонтроля"		, Новый Структура);
	
	// Хранение дополнительных реквизитов
	ДополнительныеСвойства.Вставить("ОбщиеДанные", Новый Структура);
	
	// Предопределенные свойства
	ДополнительныеСвойства.ОбщиеДанные.Вставить("МенеджерВременныхТаблиц"	, Новый МенеджерВременныхТаблиц);
	ДополнительныеСвойства.ОбщиеДанные.Вставить("ТекстыЗапроса"				, Новый Массив);
	ДополнительныеСвойства.ОбщиеДанные.Вставить("РегистрыДляКонтроля"		, Новый Массив);
	ДополнительныеСвойства.ОбщиеДанные.Вставить("Метаданные"				, ДокументСсылка.Метаданные());
	ДополнительныеСвойства.ОбщиеДанные.Вставить("Ссылка"					, ДокументСсылка);
	ДополнительныеСвойства.ОбщиеДанные.Вставить("РежимПроведения"			, РежимПроведения);
	
КонецПроцедуры

// Выполняет запись регистров
// 
Процедура ЗаписатьНаборыЗаписей(Объект) Экспорт
	Перем РегистрыДляКонтроля, РассчитыватьИзменения, ПараметрыКонтроля;
	
	Для Каждого Движение Из Объект.Движения Цикл
		ЗаполнитьДополнительныеСвойстваНабораПоДокументу(Объект, Движение);
	КонецЦикла;
	
	// Регистры, для которых будут рассчитаны таблицы изменений движений.
	Если Объект.ДополнительныеСвойства.ОбщиеДанные.Свойство("РегистрыДляКонтроля", РегистрыДляКонтроля) Тогда
		
		// Установка флага регистрации изменений в наборе записей.
		Если НЕ Объект.ДополнительныеСвойства.Свойство("РассчитыватьИзменения", РассчитыватьИзменения) Тогда
			РассчитыватьИзменения = Истина;
		КонецЕсли;
		
		Для Каждого НаборЗаписей Из РегистрыДляКонтроля Цикл
			Если НаборЗаписей.Записывать Тогда
				НаборЗаписей.ДополнительныеСвойства.Вставить("РассчитыватьИзменения", РассчитыватьИзменения);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Объект.Движения.Записать();
КонецПроцедуры

// Процедура выполняет контроль результатов проведения.
//  Процедура вызывается из модуля документов при проведении.
//
// Параметры:
//  Объект	 - ДокументОбъект - документ для контроля
//  Отказ	 - булево - признак отказа от записи.
//
Процедура ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ) Экспорт
	
	ЕстьРегистрыСКонтролемИзменений = Ложь;
	
	Если Объект.ДополнительныеСвойства.ОбщиеДанные.РегистрыДляКонтроля.Количество() > 0 Тогда
		ЕстьРегистрыСКонтролемИзменений = Истина;
	Иначе
		Для Каждого ДвигаемыйРегистр Из Объект.Движения Цикл
			Если ДвигаемыйРегистр.ДополнительныеСвойства.Свойство("РассчитыватьИзменения")
				И ДвигаемыйРегистр.ДополнительныеСвойства.РассчитыватьИзменения Тогда
					ЕстьРегистрыСКонтролемИзменений = Истина;
					Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЕстьРегистрыСКонтролемИзменений Тогда
		Возврат;
	КонецЕсли;
	          
	МассивРегистров = Объект.ДополнительныеСвойства.ОбщиеДанные.РегистрыДляКонтроля;
	Для Каждого НаборЗаписей Из МассивРегистров Цикл
		ЕстьИзменения = Ложь;
		Если НЕ НаборЗаписей.ДополнительныеСвойства.Свойство("ЕстьИзменения", ЕстьИзменения)
			ИЛИ НЕ ЕстьИзменения Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Попытка
			НаборЗаписей.ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ);
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru='Проведение.Контроль'"),
				УровеньЖурналаРегистрации.Ошибка,
				НаборЗаписей.ДополнительныеСвойства.Метаданные,
				Объект.Ссылка,
				НСтр("ru='Не реализован метод ВыполнитьКонтрольРезультатовПроведения'")); 
		КонецПопытки;
	КонецЦикла;

	Если Отказ Тогда
		Если Объект.ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ТекстСообщения = НСтр("ru='Проведение не выполнено %1'");
		Иначе
			ТекстСообщения = НСтр("ru='Отмена проведения не выполнена %1'");
		КонецЕсли;

		ТекстСообщения = СтрШаблон(ТекстСообщения, Строка(Объект));
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект);
	КонецЕсли;

КонецПроцедуры

// Выполняет закрытие менеджера временных таблиц в структуре дополнительных свойств документа, используемых 
// при проведении.
//
// Параметры:
//	ДополнительныеСвойства - Структура - структура с дополнительными свойствами документа, используемыми
//		при проведении.
//
Процедура ОчиститьДополнительныеСвойства(ДополнительныеСвойства) Экспорт
	
	ДополнительныеСвойства.ОбщиеДанные.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область РучнаяКорректировка

// Проверка ручной корректировки по документу и удаление движений.
// допустимо использование свойств аналогично процедуре УдалитьДвиженияРегистратора
//
// Параметры:
//	ДокументОбъект - ДокументОбъект - объект документа для удаления записей из движений
//
// Возвращаемое значение:
//	Булево.
//		Истина - движения изменены вручную
//
Функция РучнаяКорректировкаОбработкаПроведения(ДокументОбъект, Отказ)  Экспорт
	
	Если ДокументОбъект.Метаданные().Реквизиты.Найти("РучнаяКорректировка") <> Неопределено Тогда
		РучнаяКорректировка = ДокументОбъект.РучнаяКорректировка;
	Иначе 
		РучнаяКорректировка = Ложь;
	КонецЕсли;
	
	Если РучнаяКорректировка Тогда
		ИзменитьАктивностьПоРегистратору(ДокументОбъект, Отказ);
		ТекстСообщения = НСтр("ru='Движения документа отредактированы вручную и не могут быть автоматически актуализированы.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Истина;
	Иначе
		УдалитьДвиженияРегистратора(ДокументОбъект, Отказ);
		Возврат Ложь;
	КонецЕсли;
 	
КонецФункции // РучнаяКорректировкаОбработкаПроведения()

// Процедура удаления существующих движений документа при перепроведении (отмене проведения).
// Удаление записей можно производить выборочно, для этого параметр объекта ДополнительныеСвойства
// необходимо добавить следующие свойства:
//	ВыборочноОчищатьРегистры - Булево - Истина если необходимо очищать конкретные регистры
//	СписокРегистровДляОчистки - Массив - список имен регистров для очистки
//		Например: РегистрСведенийНаборЗаписей.ДополнительныеСведения
//
// Параметры:
//	ДокументОбъект - ДокументОбъект - объект документа для удаления записей из движений
//
Процедура УдалитьДвиженияРегистратора(ДокументОбъект, Отказ) Экспорт
	
	ВыборочноОчищатьРегистры = (ДокументОбъект.ДополнительныеСвойства.Свойство("ВыборочноОчищатьРегистры")
		И ДокументОбъект.ДополнительныеСвойства.ВыборочноОчищатьРегистры);
	
	СписокРегистровДляОчисткиДвижений = ?(ДокументОбъект.ДополнительныеСвойства.Свойство("СписокРегистровДляОчистки"),
		ДокументОбъект.ДополнительныеСвойства.СписокРегистровДляОчистки, Новый Массив);
	
	//Очистка движений документа
	Для Каждого Движение Из ДокументОбъект.Движения Цикл
		
		Если ВыборочноОчищатьРегистры И (СписокРегистровДляОчисткиДвижений.Найти(ТипЗнч(Движение))<>неопределено) Тогда
			Продолжить;
		КонецЕсли;
		Движение.Очистить();
		
	КонецЦикла;
	
	//Запись пустых наборов движений в ИБ(очистка старых движений)	
	Для Каждого Движение ИЗ ДокументОбъект.Движения Цикл
		
		Если (ВыборочноОчищатьРегистры И (СписокРегистровДляОчисткиДвижений.Найти(ТипЗнч(Движение))<>неопределено))
			ИЛИ НЕ ВыборочноОчищатьРегистры Тогда
			
			Если Движение.Количество() > 0 Тогда
				ПозицияТочки = Найти(Строка(Движение), ".");
				ТипРегистра = Лев(Строка(Движение), ПозицияТочки - 13);
				ИмяРегистра = СокрП(Сред(Строка(Движение), ПозицияТочки + 1));
				
				ЕСли ТипРегистра = "РегистрНакопления" Тогда
					МетаданныеНабора = Метаданные.РегистрыНакопления[ИмяРегистра];
					Набор = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
					
				ИначеЕсли ТипРегистра = "РегистрБухгалтерии" Тогда
					МетаданныеНабора = Метаданные.РегистрыБухгалтерии[ИмяРегистра];
					Набор = РегистрыБухгалтерии[ИмяРегистра].СоздатьНаборЗаписей();
					
				ИначеЕсли ТипРегистра = "РегистрСведений" Тогда
					МетаданныеНабора = Метаданные.РегистрыСведений[ИмяРегистра];
					Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
					
				ИначеЕсли ТипРегистра = "РегистрРасчета" Тогда
					МетаданныеНабора = Метаданные.РегистрыРасчета[ИмяРегистра];
					Набор = РегистрыРасчета[ИмяРегистра].СоздатьНаборЗаписей();
					
				КонецЕсли;
				
				Если НЕ ПравоДоступа("Изменение", МетаданныеНабора) Тогда
					// отсутствуют права на всю таблицу регистра
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='Нарушение прав доступа к регистру %1.'"),
						МетаданныеНабора.Представление());
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
					Возврат;
				КонецЕсли;
				
				Набор.Отбор.Регистратор.Установить(ДокументОбъект.Ссылка);			
				
			Иначе
				Набор = Движение;
			КонецЕсли;
			
			Попытка
				Набор.Записать();
			Исключение
				// возможно «сработал» RLS или механизм даты запрета изменения
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Ошибка при удалении движений:
					|%1'"),
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
				ВызватьИсключение НСтр("ru='Операция не выполнена'");
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Процедура включения активности движений при проведении документа, движения которого
// заданы вручную
Процедура ИзменитьАктивностьПоРегистратору(ДокументОбъект, Отказ, ВключитьАктивность = Истина) Экспорт
	
	Для Каждого Набор ИЗ ДокументОбъект.Движения Цикл
		
		Набор.Прочитать();
		Набор.УстановитьАктивность(ВключитьАктивность);
		
		Попытка
			Набор.Записать();
		Исключение
			// возможно «сработал» RLS или механизм даты запрета изменения
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка при изменении активности движений:
				|%1'"),
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение НСтр("ru='Операция не выполнена'");
		КонецПопытки;	
		
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийМодуляДокумента

Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	Объект.ДополнительныеСвойства.Вставить("ЭтоНовый"	, Объект.ЭтоНовый());
	Объект.ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийМодуляНабораЗаписейРегистра

Процедура ПередЗаписьюРегистра(НаборЗаписей, Отказ, Замещение) Экспорт

	Если НаборЗаписей.ОбменДанными.Загрузка Или Не РассчитыватьИзменения(НаборЗаписей.ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяКонтроль = Истина;
	Если НЕ ТребуетсяКонтроль Тогда
		НаборЗаписей.ДополнительныеСвойства.РассчитыватьИзменения = Ложь;
		Возврат;
	КонецЕсли;
	
	МетаРегистр = НаборЗаписей.ДополнительныеСвойства.Метаданные;
	
	ЭтоРегистрОстатки = (МетаРегистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки);
	
	ПоляЗапроса = "";
	Для Каждого МетаИзмерение Из МетаРегистр.Измерения Цикл
		ПоляЗапроса = ПоляЗапроса
			+ ?(ПустаяСтрока(ПоляЗапроса), "", "," + Символы.ПС + Символы.Таб)
			+ СтрШаблон("Т.%1 КАК %1", МетаИзмерение.Имя);
	КонецЦикла;
	Для Каждого МетаРесурс Из МетаРегистр.Ресурсы Цикл
		ТекстПоля = ПолучитьПолеЗапросаРесурса(МетаРегистр, МетаРесурс);
			
		ПоляЗапроса = ПоляЗапроса
			+ ?(ПустаяСтрока(ПоляЗапроса), "", "," + Символы.ПС + Символы.Таб)
			+ ТекстПоля;
	КонецЦикла;
	
	ТекстЗапроса = СтрШаблон(
		"ВЫБРАТЬ
		|	%1
		|ПОМЕСТИТЬ Движения%2ПередЗаписью
		|ИЗ
		|	%3 КАК Т
		|ГДЕ
		|	Т.Регистратор = &Регистратор
		|	И НЕ &ЭтоНовый",
		ПоляЗапроса,
		МетаРегистр.Имя,
		МетаРегистр.ПолноеИмя());
	
	// Текущее состояние набора помещается во временную таблицу "Движения[ИмяРегистра]ПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор"	, НаборЗаписей.Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый"	, НаборЗаписей.ДополнительныеСвойства.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = НаборЗаписей.ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписиРегистра(НаборЗаписей, Отказ, Замещение) Экспорт

	Если НаборЗаписей.ОбменДанными.Загрузка ИЛИ НЕ РассчитыватьИзменения(НаборЗаписей.ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	МетаРегистр		= НаборЗаписей.ДополнительныеСвойства.Метаданные;
	ПравилаПроверки	= НаборЗаписей.ДополнительныеСвойства.ПравилаПроверкиРесурсов;
	
	ЗаполнитьПравила = (ПравилаПроверки.Количество() = 0);
	
	ПоляИзмерений	= "";
	ПоляРесурсов	= "";
	ПоляЗапроса1	= "";
	ПоляЗапроса2	= "";
	Для Каждого МетаИзмерение Из МетаРегистр.Измерения Цикл
		ТекстПоля1 = "ТаблицаДвижений.%1";
		ТекстПоля2 = "Т.%1 КАК %1";
			
		ПоляИзмерений = ПоляИзмерений
			+ ?(ПустаяСтрока(ПоляИзмерений), "", "," + Символы.ПС + Символы.Таб)
			+ СтрШаблон(ТекстПоля1, МетаИзмерение.Имя);
			
		ПоляЗапроса1 = ПоляЗапроса1
			+ ?(ПустаяСтрока(ПоляЗапроса1), "", "," + Символы.ПС + Символы.Таб + Символы.Таб)
			+ СтрШаблон(ТекстПоля2, МетаИзмерение.Имя);
			
		ПоляЗапроса2 = ПоляЗапроса2
			+ ?(ПустаяСтрока(ПоляЗапроса2), "", "," + Символы.ПС + Символы.Таб + Символы.Таб)
			+ СтрШаблон(ТекстПоля2, МетаИзмерение.Имя);
	КонецЦикла;
	Для Каждого МетаРесурс Из МетаРегистр.Ресурсы Цикл
		ТекстПоля1 = СтрШаблон("СУММА(ТаблицаДвижений.%1) КАК %1", МетаРесурс.Имя);
		ТекстПоля2 = СтрШаблон("Т.%1 КАК %1", МетаРесурс.Имя);
		ТекстПоля3 = ПолучитьПолеЗапросаРесурса(МетаРегистр, МетаРесурс);
			
		ПоляРесурсов = ПоляРесурсов
			+ ?(ПустаяСтрока(ПоляРесурсов), "", "," + Символы.ПС + Символы.Таб)
			+ ТекстПоля1;
			
		ПоляЗапроса1 = ПоляЗапроса1
			+ ?(ПустаяСтрока(ПоляЗапроса1), "", "," + Символы.ПС + Символы.Таб + Символы.Таб)
			+ "-" + ТекстПоля2;
		
		ПоляЗапроса2 = ПоляЗапроса2
			+ ?(ПустаяСтрока(ПоляЗапроса2), "", "," + Символы.ПС + Символы.Таб + Символы.Таб)
			+ ТекстПоля3;
			
		Если ЗаполнитьПравила Тогда
			ПравилаПроверки.Добавить(СтрШаблон("СУММА(ТаблицаДвижений.%1) < 0", МетаРесурс.Имя));
		КонецЕсли;
	КонецЦикла;
	
	ТекстИмеющие = СтрСоединить(ПравилаПроверки, Символы.ПС + "		ИЛИ ");
	
	ТекстЗапроса = СтрШаблон(
		"ВЫБРАТЬ
		|	%1,
		|	%2
		|ПОМЕСТИТЬ %6Изменение
		|ИЗ
		|	(ВЫБРАТЬ
		|		%3
		|	ИЗ Движения%6ПередЗаписью КАК Т
	    |   
	    |   ОБЪЕДИНИТЬ ВСЕ
	    |   
	    |   ВЫБРАТЬ
		|		%4
		|	ИЗ %7 КАК Т
	    |	ГДЕ
		|		Т.Регистратор = &Регистратор) КАК ТаблицаДвижений
	    |
	    |СГРУППИРОВАТЬ ПО
		|	%1
	    |
	    |ИМЕЮЩИЕ
	    |   (%5)
	    |;
	    |
	    |////////////////////////////////////////////////////////////////////////////////
	    |УНИЧТОЖИТЬ Движения%6ПередЗаписью",
		ПоляИзмерений,
		ПоляРесурсов,
		ПоляЗапроса1,
		ПоляЗапроса2,
		ТекстИмеющие,
		МетаРегистр.Имя,
		МетаРегистр.ПолноеИмя());

	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", НаборЗаписей.Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = НаборЗаписей.ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.ВыполнитьПакет()[0].Выбрать();
	Выборка.Следующий();
	
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	НаборЗаписей.ДополнительныеСвойства.ЕстьИзменения = (Выборка.Количество > 0);

КонецПроцедуры

#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьТаблицуЗапроса(ИмяТаблицы, ДополнительныеСвойства) Экспорт
	ТекстыЗапроса = ДополнительныеСвойства.ОбщиеДанные.ТекстыЗапроса;
	ТекстыЗапроса.Добавить(ИмяТаблицы);
КонецПроцедуры

Процедура ДобавитьТекстЗапроса(ТекстЗапроса, Запрос) Экспорт
	ТекстРазделитель = ОбщегоНазначенияПТБКлиентСервер.ТекстРазделителяЗапросовПакета();
	
	Запрос.Текст = Запрос.Текст
		+ ?(ПустаяСтрока(Запрос.Текст), "", ТекстРазделитель)
		+ ТекстЗапроса;
КонецПроцедуры

Процедура ВыполнитьЗапросДанныхРеквизитов(Запрос, ДополнительныеСвойства) Экспорт
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ОбщиеДанные.МенеджерВременныхТаблиц;
	
	ВыполнитьЗапросДанных(Запрос, ДополнительныеСвойства);
	
	СтрокаРеквизиты = ДополнительныеСвойства.ПараметрыПроведения.Реквизиты[0];
	СтруктураРеквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаРеквизиты);
	ДополнительныеСвойства.ПараметрыПроведения.Реквизиты = СтруктураРеквизиты;
	
	Для каждого КлючИЗначение Из СтруктураРеквизиты Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
КонецПроцедуры

Процедура ВыполнитьЗапросДанных(Запрос, ДополнительныеСвойства) Экспорт
	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		Результат = Запрос.ВыполнитьПакет();
		
		МассивЗапросов = ДополнительныеСвойства.ОбщиеДанные.ТекстыЗапроса;
		Для Индекс = 0 По МассивЗапросов.ВГраница() Цикл
			ДополнительныеСвойства.ПараметрыПроведения.Вставить(
				МассивЗапросов[Индекс],
				Результат[Индекс].Выгрузить());
		КонецЦикла;
	КонецЕсли;
	
	ДополнительныеСвойства.ОбщиеДанные.ТекстыЗапроса.Очистить();
	Запрос.Текст = "";
	
КонецПроцедуры

// Функция вызывается из модулей наборов записей для проверки необходимости
//  контроля изменений движений в регистре.
//
// Параметры:
//  ДополнительныеСвойстваНабораЗаписей	 - Структура - дополнительные свойства набора записей.
// 
// Возвращаемое значение:
//  Булево, Истина - признак необходимости выполнения контроля изменений движений в регистре.
//
Функция РассчитыватьИзменения(ДополнительныеСвойстваНабораЗаписей) Экспорт
	Перем РассчитыватьИзменения;
	
	Возврат ДополнительныеСвойстваНабораЗаписей.Свойство("РассчитыватьИзменения", РассчитыватьИзменения)
		И РассчитыватьИзменения;
КонецФункции

#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДополнительныеСвойстваНабораПоДокументу(ДокументОбъект, НаборЗаписей)
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЭтоНовый"			, ДокументОбъект.ДополнительныеСвойства.ЭтоНовый);
	НаборЗаписей.ДополнительныеСвойства.Вставить("РежимЗаписи"		, ДокументОбъект.ДополнительныеСвойства.РежимЗаписи);
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПравилаПроверкиРесурсов"	, Новый Массив);
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ДатаРегистратора"			, ДокументОбъект.Дата);
	НаборЗаписей.ДополнительныеСвойства.Вставить("Метаданные"				, НаборЗаписей.Метаданные());
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЕстьИзменения"			, Ложь);
	
	НаборЗаписей.ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц",
		ДокументОбъект.ДополнительныеСвойства.ОбщиеДанные.МенеджерВременныхТаблиц);
	
КонецПроцедуры

// Функция проверяет наличие изменений в таблице регистра.
//
Функция ЕстьИзмененияВТаблице(СтруктураДанных, Ключ)

	Перем ЕстьИзменения;
	
	Если СтруктураДанных.Свойство(Ключ, ЕстьИзменения) Тогда
		
		Если ТипЗнч(ЕстьИзменения) = Тип("Булево") Тогда
			Возврат ЕстьИзменения;
		Иначе
			Возврат ЕстьИзменения.ЕстьЗаписиВТаблице;
		КонецЕсли;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Функция ПолучитьПолеЗапросаРесурса(МетаРегистр, МетаРесурс)
	ЭтоРегистрОстатки = (МетаРегистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки);
	Если ЭтоРегистрОстатки Тогда
		ТекстПоля = СтрШаблон("ВЫБОР
			|		КОГДА Т.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|			ТОГДА Т.%1
			|		ИНАЧЕ -Т.%1
			|	КОНЕЦ КАК %1", МетаРесурс.Имя);
	Иначе 
		ТекстПоля = СтрШаблон("Т.%1 КАК %1", МетаРесурс.Имя);
	КонецЕсли;
	
	Возврат ТекстПоля;
КонецФункции

#КонецОбласти
 
 