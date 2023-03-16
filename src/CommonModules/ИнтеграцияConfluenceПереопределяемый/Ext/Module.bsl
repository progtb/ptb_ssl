﻿// Copyright (c) 2023, ООО ПрогТехБизнес
// Лицензия Attribution 4.0 International (CC BY 4.0)

#Область ПрограммныйИнтерфейс

// Возвращает список баз знаний для которых возможен обмен с 1С
//
// В данной процедуре определяются все базы знаний, по которым предполагается
// возможное наличие объектов данных для обмена
//
// Возвращаемое значение:
//   Массив. Элемент массива СправочникСсылка.БазыЗнанийConfluence
// 
Функция ПолучитьБазыЗнанийДляОбмена() Экспорт
	
	БазыЗнаний = Новый Массив;
	
	// изменения тут
	
	Возврат БазыЗнаний;
	
КонецФункции

// Возвращает список баз знаний для которых возможен обмен с 1С по определенному объекту
//
// В данной процедуре определяются базы знаний, по которым требуется выполнить
// обмен данными в рамках определенного объекта обмена
//
// Параметры:
//	ОбъектСсылка - ОпределяемыйТип.ОбъектыИнтеграцииConfluence
//
// Возвращаемое значение:
//   Массив. Элемент массива СправочникСсылка.БазыЗнанийConfluence
// 
Функция ПолучитьБазыЗнанийПоОбъекту(знач ОбъектСсылка) Экспорт
	
	БазыЗнаний = Новый Массив;
	
	// изменения тут
	
	Возврат БазыЗнаний;
	
КонецФункции

// Выполняется проверка необходимости обмена данными по определенному объекту
// без учета базы знаний.
//
// Параметры:
//	ОбъектСсылка - ОпределяемыйТип.ОбъектыИнтеграцииConfluence
//
// Возвращаемое значение:
//   Булево
// 
Функция ВыполнятьОбменПоОбъекту(знач ОбъектСсылка) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Выполняется отправка данных в указанную базу знаний Confluence по определенному объекту
//
// Параметры:
//	БазаЗнанийСсылка	- СправочникСсылка.БазыЗнанийConfluence
//	ОбъектСсылка		- ОпределяемыйТип.ОбъектыИнтеграцииConfluence
//
// Возвращаемое значение:
//   Булево 
// 
Функция ВыполнитьОтправкуДанныхПоОбъекту(знач БазаЗнанийСсылка, знач ОбъектСсылка) Экспорт
	
	// после подготовки контента рекомендуется использовать метод ВыполнитьВыгрузкуКонтентаВБазуЗнаний
	// поскольку он не только определяет правило загрузки данных (создание или изменение), а также
	// фиксирует результат в регистре сведений "ИдентификаторыБазыЗнанийConfluence"
	
	Возврат Истина;
	
КонецФункции

// Возвращает настройки подключения пользователя к базе знаний по переданному объекту для обмена
//
// Параметры:
//	БазаЗнанийСсылка	- СправочникСсылка.БазыЗнанийConfluence
//	ОбъектСсылка		- ОпределяемыйТип.ОбъектыИнтеграцииConfluence
//
// Возвращаемое значение:
//   см. ИнтеграцияConfluence.НастройкиПодключения 
// 
Функция ПолучитьНастройкиПодключенияПоОбъекту(знач БазаЗнанийСсылка, знач ОбъектСсылка) Экспорт
	
	// в зависимости от объекта могут быть разные способы подключения к базе знаний
	// в любом случае надо вернуть настройки по пользователю, но сам пользователь может зависеть
	// от передаваемых данных
	// Например: статьи выкладываются от имени автора, а общая информация от имени системы
	
	Если ТипЗнч(ОбъектСсылка) = Тип("СправочникСсылка.Пользователи") Тогда
		// выполняем определение пользователя для отправки данных
		ТекущийПользователь = ОбъектСсылка;
	Иначе 
		ТекущийПользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Возврат ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(БазаЗнанийСсылка, ТекущийПользователь);
	
КонецФункции

// Выполняет создание или изменение данных контента на сервере базы знаний Confluence
//
// Параметры:
//	БазаЗнанийСсылка		- СправочникСсылка.БазыЗнанийConfluence
//	ОбъектСсылка			- ОпределяемыйТип.ОбъектыИнтеграцииConfluence
//	НастройкиПодключения	- Структура - см. ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения
//	Контент					- Структура	- см. ИнтеграцияConfluenceКлиентСервер.СтруктураСтатьи или СтруктураЗаписиБлока
//	Идентификатор			- Строка - текущий идентификатор объекта в базе знаний
//
// Возвращаемое значение:
//   Булево
// 
Функция ВыполнитьВыгрузкуКонтентаВБазуЗнаний(знач БазаЗнанийСсылка, знач ОбъектСсылка, знач НастройкиПодключения, знач Контент, знач Идентификатор = "") Экспорт
	Если ЗначениеЗаполнено(Идентификатор) И Контент.Версия <> 0 Тогда
		РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.ИзменитьКонтент(НастройкиПодключения, Идентификатор, Контент);
	Иначе 
		РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.СоздатьКонтент(НастройкиПодключения, Контент);
	КонецЕсли;
	
	Попытка
		ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(РезультатЗапроса, Ложь);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ИнтеграцияConfluence.ДобавитьЗаписьВЖурналРегистрации(УровеньЖурналаРегистрации.Ошибка,, ОбъектСсылка,
			НСтр("ru='При выгрузке статьи произошла ошибка: '") + ТекстОшибки); 
			
		Возврат Ложь;
	КонецПопытки;
	
	АдресСсылки = РезультатЗапроса.Ссылка;
	Если ПустаяСтрока(АдресСсылки) Тогда
		АдресСсылки = РезультатЗапроса.Ссылки.Основа + РезультатЗапроса.Ссылки.Просмотр;
	КонецЕсли;
	
	РегистрыСведений.ИдентификаторыБазыЗнанийConfluence.ЗаписатьИдентификатор(БазаЗнанийСсылка,
		ОбъектСсылка,
		Контент.ТипДанных,
		РезультатЗапроса.Идентификатор,
		РезультатЗапроса.Версия.Номер,
		АдресСсылки,
		РезультатЗапроса.Заголовок,
		ТекущаяДатаСеанса());
	
	Возврат Истина;
КонецФункции

#КонецОбласти
