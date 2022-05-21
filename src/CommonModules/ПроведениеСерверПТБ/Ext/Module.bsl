﻿
#Область ПрограммныйИнтерфейс

// Выполняет обновление движений по документу по типовому механизму проведения
// При этом запись в регистрах выполняется без регистрации изменений
//
// Параметры:
//	ДокументОбъект	- ДокументОбъект
//	СписокРегистров - Строка, Массив - список регистров для записи. Если не указано, то все
//	Отказ			- Булево
//	РежимПроведения	- РежимПроведенияДокумента
//
Процедура ОбновитьДвиженияДокумента(знач Объект, знач СписокРегистров = "", Отказ = Ложь, РежимПроведения = Неопределено) Экспорт
	
	Если НЕ ТипЗнч(РежимПроведения) = Тип("РежимПроведенияДокумента") Тогда 
		РежимПроведения = РежимПроведенияДокумента.Неоперативный;
	КонецЕсли;
	
	ТипСписокРегистров = ТипЗнч(СписокРегистров);
	Если ТипСписокРегистров = Тип("Строка") Тогда
		СписокРегистров = СтрЗаменить(СписокРегистров, " ", "");
		МассивРегистров = СтрРазделить(СписокРегистров, ",");
	ИначеЕсли ТипСписокРегистров = Тип("Массив") Тогда
		МассивРегистров = СписокРегистров;
	Иначе 
		МассивРегистров = Новый Массив;
	КонецЕсли;
	
	МодульМенеджера = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	// Дополнение свойствами перед записью
	ПроведениеСерверПТБ.ПередЗаписью(Объект, Отказ, РежимЗаписиДокумента.Проведение, РежимПроведения);

	// Предварительная подготовка параметров
	ПроведениеСерверПТБ.ИнициализацияДополнительныхСвойствДляПроведения(Объект.Ссылка, Объект.ДополнительныеСвойства, РежимПроведения);
	
	// Проверим наличие ручной корректировки по документу
	Если НЕ ПроведениеСерверПТБ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовка параметров для проведения
	МодульМенеджера.ПодготовитьПараметрыПроведения(Объект.Ссылка, Объект.ДополнительныеСвойства, Отказ);
	
	// Дополнительные проверки
	МодульМенеджера.ВыполнитьДополнительныеПроверки(Объект.ДополнительныеСвойства, Отказ);
	
	// Формирование движений до выполнения контроля
	МодульМенеджера.СформироватьДвиженияПоРегистрам(Объект.Движения, Объект.ДополнительныеСвойства, Отказ);
	
	// Выполним собственную процедуру записи, чтобы не регистрировать изменения
	ЕстьОтборПоРегистрам = (МассивРегистров.Количество() > 0);
	Для Каждого НаборЗаписей Из Объект.Движения Цикл
		Если ЕстьОтборПоРегистрам И МассивРегистров.Найти(НаборЗаписей.Метаданные().Имя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей, Ложь, Ложь);
	КонецЦикла;
	
	// Очистка дополнительных свойств
	ПроведениеСерверПТБ.ОчиститьДополнительныеСвойства(Объект.ДополнительныеСвойства);
	
КонецПроцедуры

// Заполняет вспомогательную структуру для хранения данных связанных с проведением документа
//
// Параметры:
//	ДокументСсылка - ДокументСсылка - любой документ, имеющий возможность проведения
//	ДополнительныеСвойства - Структура - структура для хранения вспомогательных данных
//	РежимПроведения - РежимПроведенияДокумента
// 
Процедура ИнициализацияДополнительныхСвойствДляПроведения(знач ДокументСсылка, ДополнительныеСвойства, РежимПроведения = Неопределено) Экспорт 
	
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

// Формирует массив имен регистров, по которым документ имеет движения.
// Вызывается при подготовке записей к регистрации движений.
//
// Параметры:
//  ДокументСсылка		- ДокументСсылка	- ссылка на документ, для которого формируется список регистров
//  Движения			- КоллекцияДвижений - движения документа
//  МассивИсключений	- Массив			- исключаемые регистры.
// 
// Возвращаемое значение:
//  Массив - массив имен регистров, по которым документ имеет движения.
//
Функция ПолучитьИспользуемыеРегистры(знач ДокументСсылка, знач Движения, знач МассивИсключений = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", ДокументСсылка);

	Результат = Новый Массив;
	МаксимумТаблицВЗапросе = 256;

	СчетчикТаблиц   = 0;
	СчетчикДвижений = 0;

	ВсегоДвижений = Движения.Количество();
	ТекстЗапроса  = "";
	Для Каждого Движение Из Движения Цикл

		СчетчикДвижений = СчетчикДвижений + 1;

		ПропуститьРегистр = (МассивИсключений <> Неопределено
			И МассивИсключений.Найти(Движение.Имя) <> Неопределено);

		Если Не ПропуститьРегистр Тогда

			Если СчетчикТаблиц > 0 Тогда

				ТекстЗапроса = ТекстЗапроса + "
				|ОБЪЕДИНИТЬ ВСЕ
				|";

			КонецЕсли;

			СчетчикТаблиц = СчетчикТаблиц + 1;

			ТекстЗапроса = ТекстЗапроса + 
			"
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|""" + Движение.Имя + """ КАК ИмяРегистра
			|
			|ИЗ " + Движение.ПолноеИмя() + "
			|
			|ГДЕ Регистратор = &Регистратор
			|";

		КонецЕсли;

		Если СчетчикТаблиц = МаксимумТаблицВЗапросе Или СчетчикДвижений = ВсегоДвижений Тогда

			Запрос.Текст  = ТекстЗапроса;
			ТекстЗапроса  = "";
			СчетчикТаблиц = 0;

			Если Результат.Количество() = 0 Тогда

				Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");

			Иначе

				Выборка = Запрос.Выполнить().Выбрать();
				Пока Выборка.Следующий() Цикл
					Результат.Добавить(Выборка.ИмяРегистра);
				КонецЦикла;

			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Возвращает путь к реквизиту табличной части с учетом номера строки табличной части
//
// Параметры:
//	ДополнительныеСвойства	- Структура - см. СообщитьКонтрольРезультатовПроведения
//	ИмяТаблицыДанных		- Строка - имя таблицы данных для поиска номера строки
//		Таблица должна содержать все колонки из ОтборСтрок, а также колонку НомерСтроки или НомерСтрокиТЧ
//	ОтборСтрок				- Структура - структура с отбором строк для поиска номера строки
//	ПолноеИмяРеквизита		- Строка - полное имя реквизита табличной части, с учетом имени таб. части
//		Например: Объект.ИмяТабличнойЧасти.ИмяРеквизита
//
// Возвращаемое значение:
//   Строка - путь к реквизиту табличной части с указанием номера строки
//
Функция ПутьКТабличнойЧасти(знач ДополнительныеСвойства, знач ИмяТаблицыДанных, знач ОтборСтрок, знач ПолноеИмяРеквизита) Экспорт
	ПараметрыПроведения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойства, "ПараметрыПроведения", Неопределено);
	Если НЕ ТипЗнч(ПараметрыПроведения) = Тип("Структура") ИЛИ НЕ ПараметрыПроведения.Свойство(ИмяТаблицыДанных) Тогда
		Возврат ПолноеИмяРеквизита;
	КонецЕсли;
	
	МассивСтрок = ПараметрыПроведения[ИмяТаблицыДанных].НайтиСтроки(ОтборСтрок);
	НомераСтрок = Новый Структура("НомерСтроки,НомерСтрокиТЧ", 0, 0);
	Если МассивСтрок.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(НомераСтрок, МассивСтрок[0]);
	КонецЕсли;
	
	НомерСтроки = ?(НомераСтрок.НомерСтрокиТЧ <> 0, НомераСтрок.НомерСтрокиТЧ, НомераСтрок.НомерСтроки);
	Если НомерСтроки <= 0 Тогда
		Возврат ПолноеИмяРеквизита;
	КонецЕсли;
	
	Подстроки = СтрРазделить(ПолноеИмяРеквизита, ".");
	КолЧастей = Подстроки.Количество();
	
	ИмяТабЧасти 	= Подстроки[0] + ?(КолЧастей = 3, "." + Подстроки[1], "");
	ИмяРеквизита	= Подстроки[КолЧастей-1];
	
	Возврат ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабЧасти, НомерСтроки, ИмяРеквизита);
КонецФункции

#КонецОбласти

#Область РучнаяКорректировка

// Проверка ручной корректировки по документу и снятие активности движений.
// Если ручная корректировка не применяется, удаление движений происходит
// при установленном признаке УдалитьДвижения = ИСТИНА
//
// Параметры:
//	ДокументОбъект - ДокументОбъект - объект документа для удаления записей из движений
//
// Возвращаемое значение:
//	Булево.
//		Истина - движения изменены вручную
//
Функция ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект, Отказ)  Экспорт
	
	Если Объект.Метаданные().Реквизиты.Найти("РучнаяКорректировка") <> Неопределено Тогда
		РучнаяКорректировка = Объект.РучнаяКорректировка;
	Иначе 
		РучнаяКорректировка = Ложь;
	КонецЕсли;
	
	Если РучнаяКорректировка Тогда
		ИзменитьАктивностьПоРегистратору(Объект, Отказ);
		ТекстСообщения = НСтр("ru='Движения документа отредактированы вручную и не могут быть автоматически актуализированы.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
	Иначе
		УдалитьДвиженияРегистратора(Объект, Отказ);
		
		Возврат Истина;
	КонецЕсли;
 	
КонецФункции

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
Процедура УдалитьДвиженияРегистратора(Объект, Отказ) Экспорт
	Перем ЭтоНовыйДокумент, МетаданныеДвижения;
	
	ИсключаемыеРегистры = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Объект.ДополнительныеСвойства, "ИсключаемыеРегистры", Новый Массив);
	
	//Очистка движений документа
	Для Каждого НаборЗаписей Из Объект.Движения Цикл
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Очистить();
		КонецЕсли;
	КонецЦикла;
	
	ЭтоНовыйДокумент = Объект.ДополнительныеСвойства.ЭтоНовый;
	
	Если НЕ ЭтоНовыйДокумент Тогда
		МетаданныеДвижения = Объект.Метаданные().Движения;
		
		МассивИменРегистров = ПолучитьИспользуемыеРегистры(
			Объект.Ссылка,
			МетаданныеДвижения,
			ИсключаемыеРегистры);

		Для Каждого ИмяРегистра Из МассивИменРегистров Цикл
			Объект.Движения[ИмяРегистра].Записывать = Истина;
		КонецЦикла;
   КонецЕсли;

КонецПроцедуры

// Процедура включения активности движений при проведении документа, движения которого
// заданы вручную
Процедура ИзменитьАктивностьПоРегистратору(Объект, Отказ, ВключитьАктивность = Истина) Экспорт
	
	Для Каждого Набор ИЗ Объект.Движения Цикл
		
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
				
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
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

Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	МодульМенеджера = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);

	// Предварительная подготовка параметров
	ПроведениеСерверПТБ.ИнициализацияДополнительныхСвойствДляПроведения(Объект.Ссылка, Объект.ДополнительныеСвойства, РежимПроведения);
	
	// Проверим наличие ручной корректировки по документу
	Если НЕ ПроведениеСерверПТБ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект, Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовка параметров для проведения
	МодульМенеджера.ПодготовитьПараметрыПроведения(Объект.Ссылка, Объект.ДополнительныеСвойства, Отказ);
	
	// Дополнительные проверки
	МодульМенеджера.ВыполнитьДополнительныеПроверки(Объект.ДополнительныеСвойства, Отказ);
	
	// Формирование движений до выполнения контроля
	МодульМенеджера.СформироватьДвиженияПоРегистрам(Объект.Движения, Объект.ДополнительныеСвойства, Отказ);
	
	// Добавляет регистры для выполнения контроля движений
	МодульМенеджера.СформироватьСписокРегистровДляКонтроля(Объект.Движения, Объект.ДополнительныеСвойства, Отказ);
	
	// Запись наборов
	ПроведениеСерверПТБ.ЗаписатьНаборыЗаписей(Объект);

	// Контроль результатов проведения
	ПроведениеСерверПТБ.ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ);
	
	// Сообщим результат контроля пользователю
	МодульМенеджера.СообщитьКонтрольРезультатовПроведения(Объект.ДополнительныеСвойства, Отказ);
	
	// Очистка дополнительных свойств
	ПроведениеСерверПТБ.ОчиститьДополнительныеСвойства(Объект.ДополнительныеСвойства);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	// Предварительная подготовка параметров
	ПроведениеСерверПТБ.ИнициализацияДополнительныхСвойствДляПроведения(Объект, Объект.ДополнительныеСвойства);
	
	// Проверим наличие ручной корректировки по документу
	ПроведениеСерверПТБ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект, Отказ);
	
	// Запись наборов
	ПроведениеСерверПТБ.ЗаписатьНаборыЗаписей(Объект);
	
	// Очистка дополнительных свойств
	ПроведениеСерверПТБ.ОчиститьДополнительныеСвойства(Объект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведенияСКонтролем(Объект, Отказ) Экспорт
	
	МодульМенеджера = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);

	// Предварительная подготовка параметров
	ПроведениеСерверПТБ.ИнициализацияДополнительныхСвойствДляПроведения(Объект.Ссылка, Объект.ДополнительныеСвойства);
	
	// Проверим наличие ручной корректировки по документу
	ПроведениеСерверПТБ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(Объект, Отказ);
	
	// Добавляет регистры для выполнения контроля движений
	МодульМенеджера.СформироватьСписокРегистровДляКонтроля(Объект.Движения, Объект.ДополнительныеСвойства, Отказ);
	
	// Запись наборов
	ПроведениеСерверПТБ.ЗаписатьНаборыЗаписей(Объект);

	// Контроль результатов проведения
	ПроведениеСерверПТБ.ВыполнитьКонтрольРезультатовПроведения(Объект, Отказ);
	
	// Сообщим результат контроля пользователю
	МодульМенеджера.СообщитьКонтрольРезультатовПроведения(Объект.ДополнительныеСвойства, Отказ);
	
	// Очистка дополнительных свойств
	ПроведениеСерверПТБ.ОчиститьДополнительныеСвойства(Объект.ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийМодуляНабораЗаписейРегистра

// Выполняет добавление правил проверки регистра в доп. свойства набора записей
//
// Параметры:
//	НаборЗаписей	- НаборЗаписей - набор записей регистра
//	ПравилаПроверки	- Массив - массив правил проверки регистра
//
Процедура УстановитьПравилаПроверкиРегистра(НаборЗаписей, ПравилаПроверки) Экспорт
	НаборЗаписей.ДополнительныеСвойства.Вставить("ПравилаПроверкиРесурсов", ПравилаПроверки);
КонецПроцедуры

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

Процедура ДобавитьРегистрДляКонтроля(НаборЗаписей, ДополнительныеСвойства) Экспорт
	Массив = ДополнительныеСвойства.ОбщиеДанные.РегистрыДляКонтроля;
	Массив.Добавить(НаборЗаписей);
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
 
 