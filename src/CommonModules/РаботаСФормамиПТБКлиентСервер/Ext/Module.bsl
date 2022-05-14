﻿
#Область ПрограммныйИнтерфейс

// Добавляет переданные поля в коллекцию полей условного оформления
//
// Параметры:
//	Поля		- ОформляемыеПоляКомпоновкиДанных - 
//	СписокПолей - Строка, Массив
// 
Процедура ДобавитьПоляУсловногоОформления(Поля, знач СписокПолей = "") Экспорт 
	ТипСписокПолей = ТипЗнч(СписокПолей);
	Если ТипСписокПолей = Тип("Строка") Тогда
		МассивПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СписокПолей, ",", Истина, Истина);
	ИначеЕсли ТипСписокПолей = Тип("Массив") Тогда
		МассивПолей = СписокПолей;
	КонецЕсли;
	
	Для Каждого ИмяПоля Из МассивПолей Цикл
		Поле = Поля.Элементы.Добавить();
		Поле.Использование	= Истина;
		Поле.Поле			= Новый ПолеКомпоновкиДанных(ИмяПоля);
	КонецЦикла;
КонецПроцедуры

// Устанавливает оформление ячейки недоступной для ввода данных
// По умолчанию:
//	Текст					- х
//	ГоризонтальноеПоложение - Центр
//	ЦветТекста				- СветлоСерый
//
// Параметры:
//	Оформление		- ОформлениеКомпоновкиДанных
//	ТолькоПросмотр	- Булево - устанавливать признак "ТолькоПросмотр" или нет
// 
Процедура УстановитьПараметрыОформленияНедоступнойЯчейки(Оформление, знач ТолькоПросмотр = Ложь) Экспорт
	Если ТолькоПросмотр Тогда
		Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	КонецЕсли;
	
	Оформление.УстановитьЗначениеПараметра("Текст"						, "х");
	Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение"	, ГоризонтальноеПоложение.Центр);	
	Оформление.УстановитьЗначениеПараметра("ЦветТекста"					, WebЦвета.СветлоСерый);
КонецПроцедуры

// Проверяет что тип значения элемента соответствует ДанныеФормыЭлементДерева или ДанныеФормыДерево
//
// Параметры:
//	СтрокаДерева	- ЛюбоеЗначение
//	ТипПроверки		- Число
//		0 - это ДанныеФормыЭлементДерева
//		1 - это ДанныеФормыДерево
//		2 - это любое из вышеперечисленных
//
// Возвращаемое значение:
//   Булево
// 
Функция ЭтоСтрокаДанныеФормы(знач СтрокаДерева, знач ТипПроверки = 2) Экспорт
	#Если ВнешнееСоединение Тогда
		Возврат Ложь;
	#КонецЕсли
	
	ТипСтроки = ТипЗнч(СтрокаДерева);
	
	ЭтоСтрока = (ТипСтроки = Тип("ДанныеФормыЭлементДерева"));
	ЭтоДерево = (ТипСтроки = Тип("ДанныеФормыДерево"));
	
	Если ТипПроверки = 0 Тогда
		Возврат ЭтоСтрока;
	ИначеЕсли ТипПроверки = 1 Тогда
		Возврат ЭтоДерево;
	ИначеЕсли ТипПроверки = 2 Тогда
		Возврат ЭтоСтрока ИЛИ ЭтоДерево;
	КонецЕсли;
КонецФункции

// Проверяет что тип значения элемента соответствует СтрокаДереваЗначений или ДеревоЗначений
//
// Параметры:
//	СтрокаДерева	- ЛюбоеЗначение
//	ТипПроверки		- Число
//		0 - это СтрокаДереваЗначений
//		1 - это ДеревоЗначений
//		2 - это любое из вышеперечисленных
//
// Возвращаемое значение:
//   Булево
// 
Функция ЭтоСтрокаДереваЗначений(знач СтрокаДерева, знач ТипПроверки = 2) Экспорт
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение ИЛИ Сервер ИЛИ ВнешнееСоединение ИЛИ МобильноеПриложениеСервер Тогда
		ТипСтроки = ТипЗнч(СтрокаДерева);
		
		ЭтоСтрока = (ТипСтроки = Тип("СтрокаДереваЗначений"));
		ЭтоДерево = (ТипСтроки = Тип("ДеревоЗначений"));
		
		Если ТипПроверки = 0 Тогда
			Возврат ЭтоСтрока;
		ИначеЕсли ТипПроверки = 1 Тогда
			Возврат ЭтоДерево;
		ИначеЕсли ТипПроверки = 2 Тогда
			Возврат ЭтоСтрока ИЛИ ЭтоДерево;
		КонецЕсли;
	#КонецЕсли
	
	Возврат Ложь;
КонецФункции

#КонецОбласти

#Область КопияДанныхФормы

// Дополняет список реквизитов для которых хранятся значения до изменений
//
// Параметры:
//	Форма 		- ФормаКлиентскогоПриложения
//	Реквизиты	- Строка, Массив, Соответствие, Структура - в т.ч. фиксированные варианты коллекций.
//		Реквизиты формы указываются как <ИмяРеквизита>. Допустимо использование реквизитов с точками
//		например: "Объект.<ИмяРеквизита>"
//
Процедура КопияДанныхФормыДобавитьРеквизиты(Форма, знач Реквизиты, знач ИмяГруппы = "ПоУмолчанию") Экспорт
	Если НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "_КопияДанныхФормы_") Тогда
		Возврат;
	КонецЕсли;
	
	КопияДанных = Новый Структура(Форма._КопияДанныхФормы_); 
	
	// Обработка параметра Реквизиты в массив
	МассивРеквизитов = Новый Массив;
	ОбщегоНазначенияПТБКлиентСервер.ДополнитьМассивИзЗначения(МассивРеквизитов, Реквизиты);
	
	// Дополнение списка реквизитов, данными из группы
	ВсеРеквизиты = Новый Массив(КопияДанных.Реквизиты);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеРеквизиты, МассивРеквизитов, Истина);
	
	// Дополнение групп информацией о реквизитах
	ВсеГруппы = Новый Структура(КопияДанных.Группы);
	РеквизитыГруппы = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ВсеГруппы, ИмяГруппы, Новый Массив);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(РеквизитыГруппы, МассивРеквизитов, Истина);
	ВсеГруппы.Вставить(ИмяГруппы, РеквизитыГруппы);
	
	// сохранение данных
	КопияДанных.Группы			= Новый ФиксированнаяСтруктура(ВсеГруппы);
	КопияДанных.Реквизиты		= Новый ФиксированныйМассив(ВсеРеквизиты);
	Форма._КопияДанныхФормы_	= Новый ФиксированнаяСтруктура(КопияДанных);
КонецПроцедуры

// Сохраняет значение указанных реквизитов, без учета реквизитов заданных при инициализации
//
// Параметры:
//	Форма		- ФормаКлиентскогоПриложения
//	Реквизиты	- Массив, Структура, Соответствие, Строка - имена отдельных реквизитов формы
// 
Процедура КопияДанныхФормыОбновитьРеквизиты(знач Форма, знач Реквизиты = "") Экспорт
	ЕстьРеквизитКопия = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "_КопияДанныхФормы_");
	Если ЕстьРеквизитКопия Тогда
		Возврат;
	КонецЕсли;
	
	КопияДанных = КопияДанныхВКоллекцию(Форма._КопияДанныхФормы_);
	
	МассивРеквизитов = Новый Массив;
	ОбщегоНазначенияПТБКлиентСервер.ДополнитьМассивИзЗначения(МассивРеквизитов, Реквизиты);
	Если МассивРеквизитов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Создание структур копии данных формы
	Для Каждого ИмяРеквизита Из МассивРеквизитов Цикл
		ЗначениеРеквизита = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ИмяРеквизита);
		КопияДанных.Значения.Вставить(ИмяРеквизита, ЗначениеРеквизита);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(КопияДанных.Сохраненные, МассивРеквизитов);
	
	// Сохраним набор обработанных реквизитов
	Форма._КопияДанныхФормы_ = КопияДанныхВКоллекцию(КопияДанных, Истина);
КонецПроцедуры

// Сохраняет текущие значения реквизитов в служебный реквизит хранения копии данных формы
//	
// ВНИМАНИЕ:
//	1. Если хотя бы один из параметров передан неверно вызывается исключение.
// 	2. Табличные части не копируются, для них необходимо писать собственные обработчики
//
// Параметры:
//	Форма		- ФормаКлиентскогоПриложения
//	Реквизиты	- Массив, Структура, Соответствие, Строка - имена дополнительных реквизитов формы,
// 
Процедура КопияДанныхФормыОбновить(знач Форма, знач Реквизиты = "") Экспорт
	ЕстьРеквизитКопия = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "_КопияДанныхФормы_");
	Если ЕстьРеквизитКопия Тогда
		Возврат;
	КонецЕсли;
	
	КопияДанных = КопияДанныхВКоллекцию(Форма._КопияДанныхФормы_);

	// поместим в сохраненные все реквизиты, которые необходимо получить
	КопияДанных.Сохраненные.Очистить();
	ОбщегоНазначенияПТБКлиентСервер.ДополнитьМассивИзЗначения(КопияДанных.Сохраненные, КопияДанных.Реквизиты);
	ОбщегоНазначенияПТБКлиентСервер.ДополнитьМассивИзЗначения(КопияДанных.Сохраненные, Реквизиты);
	Если КопияДанных.Сохраненные.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Создание структур копии данных формы
	КопияДанных.Значения.Очистить();
	Для Каждого ИмяРеквизита Из КопияДанных.Сохраненные Цикл
		ЗначениеРеквизита = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ИмяРеквизита);
		КопияДанных.Значения.Вставить(ИмяРеквизита, ЗначениеРеквизита);
	КонецЦикла;
	
	// Установка в реквизит формы
	Форма._КопияДанныхФормы_ = КопияДанныхВКоллекцию(КопияДанных, Истина);
КонецПроцедуры

// Сравнивает текущее значение с копией и возвращает признак равенства значений
//
// Параметры:
//	Форма			- ФормаКлиентскогоПриложения
//	ИмяРеквизита	- Строка - имя реквизита для обновления значения
//
// Возвращаемое значение:
//   Булево
//		Истина	- если они равны
//		Ложь	- если реквизита нет в копии или значения не равны
// 
Функция КопияДанныхФормыСравнить(знач Форма, знач ИмяРеквизита) Экспорт
	Если НЕ ТипЗнч(ИмяРеквизита) = Тип("Строка") ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		ВызватьИсключение НСтр("ru='Не указано имя реквизита проверки.'");
	КонецЕсли;
	
	// Получение значения копии данных формы
	ЕстьЗначение		= Ложь;
	ТекущееЗначение		= КопияДанныхФормыПолучить(Форма, ИмяРеквизита, ЕстьЗначение);
	ЗначениеРеквизита 	= ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ИмяРеквизита);
	
	// Возврат значения
	Возврат (ЕстьЗначение И ТекущееЗначение = ЗначениеРеквизита);
КонецФункции

// Вычисляет и возвращает значение из копии данных
//
// Параметры:
//	Форма			- ФормаКлиентскогоПриложения
//	ИмяРеквизита	- Строка - имя реквизита для обновления значения
//	ЕстьЗначение	- Булево - реквизит для возвращения признака наличия реквизита в копии
//
// Возвращаемое значение:
//   Значение реквизита или Неопределено если он отсутствует
// 
Функция КопияДанныхФормыПолучить(знач Форма, знач ИмяРеквизита, ЕстьЗначение = Ложь) Экспорт
	Если НЕ ТипЗнч(ИмяРеквизита) = Тип("Строка") ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		ВызватьИсключение НСтр("ru='Не указано имя реквизита проверки.'");
	КонецЕсли;
	
	ЕстьРеквизитКопия = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "_КопияДанныхФормы_");
	Если ЕстьРеквизитКопия Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Получение значения реквизита
	ТекущееЗначение	= Форма._КопияДанныхФормы_.Значения.Получить(ИмяРеквизита);
	ЕстьЗначение	= (Форма._КопияДанныхФормы_.Сохраненные.Найти(ИмяРеквизита) <> Неопределено);
	
	// Возврат значения
	Возврат ?(ЕстьЗначение, ТекущееЗначение, Неопределено);
КонецФункции

#Область УстаревшийИнтерфейс

// устарела. см. КопияДанныхФормыОбновить
Процедура СкопироватьДанныеФормы(Форма, знач Реквизиты = "") Экспорт
	КопияДанныхФормыОбновить(Форма, Реквизиты);
КонецПроцедуры

// устарела см. КопияДанныхФормыСравнить
Функция СравнитьСКопиейДанныхФормы(знач Форма, знач ИмяРеквизита) Экспорт
	Возврат КопияДанныхФормыСравнить(Форма, ИмяРеквизита);
КонецФункции

// устарела см. КопияДанныхФормыПолучить
Функция ЗначениеИзКопииДанныхФормы(знач Форма, знач ИмяРеквизита, ЕстьСвойство = Ложь) Экспорт
	Возврат КопияДанныхФормыПолучить(Форма, ИмяРеквизита, ЕстьСвойство);
КонецФункции

#КонецОбласти

#КонецОбласти

#Область МетодыРаботыСДеревомНаФорме

// Устанавливает значение признака вышестоящих уровней по вложенным элементам
//
// Параметры
//	ЭлементДерева - Тип: ДанныеФормыЭлементДерева. Элемент от которого необходимо установить отметки
//	ИмяКолонки - Тип: Строка. Имя колонки для которой устанавливается значение
//
Процедура УстановитьЗначениеПризнакаВышестоящихЭлементов(ЭлементДерева, знач ИменаКолонок) Экспорт
	ЭлементРодитель = ЭлементДерева.ПолучитьРодителя();
	Если ЭлементРодитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаборЭлементов = ЭлементРодитель.ПолучитьЭлементы();
	
	МассивИмен		= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаКолонок);
	СтруктураДанных	= Новый Структура;
	Для Каждого ИмяКолонки Из МассивИмен Цикл
		ИмяКолонки = СокрЛП(ИмяКолонки);
		СтруктураДанных.Вставить(ИмяКолонки, Неопределено);
	КонецЦикла;
	
	ЗначениеРодителя = Неопределено;
	Для Каждого ВложенныйЭлемент Из НаборЭлементов Цикл
		Для Каждого КлючИЗначение Из СтруктураДанных Цикл
			ИмяКолонки			= КлючИЗначение.Ключ;
			ЗначениеРодителя	= КлючИЗначение.Значение;
			
			ЗначениеРеквизита	= ?(ВложенныйЭлемент[ИмяКолонки] = ЗначениеРодителя, ЗначениеРодителя, 2);
			ЗначениеРодителя	= ?(ЗначениеРодителя = Неопределено, ВложенныйЭлемент[ИмяКолонки], ЗначениеРеквизита); 
			
			СтруктураДанных.Вставить(ИмяКолонки, ЗначениеРодителя);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из СтруктураДанных Цикл
		ЭлементРодитель[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
	КонецЦикла;
	
	УстановитьЗначениеПризнакаВышестоящихЭлементов(ЭлементРодитель, ИменаКолонок);
КонецПроцедуры

// Устанавливает значение признака вложенных элементов по значению родителя
//
// Параметры
//	ЭлементДерева - Тип: ДанныеФормыЭлементДерева. Элемент от которого необходимо установить отметки
//	ИмяКолонки - Тип: Строка. Имя колонки для которой устанавливается значение
//
Процедура УстановитьЗначениеПризнакаВложенныхЭлементов(ЭлементДерева, знач ИменаКолонок) Экспорт
	МассивИмен		= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаКолонок);
	СтруктураДанных	= Новый Структура;
	Для Каждого ИмяКолонки Из МассивИмен Цикл
		ИмяКолонки = СокрЛП(ИмяКолонки);
		СтруктураДанных.Вставить(ИмяКолонки, ЭлементДерева[ИмяКолонки]);
	КонецЦикла;
	
	НаборЭлементов = ЭлементДерева.ПолучитьЭлементы();
	Для Каждого ВложенныйЭлемент Из НаборЭлементов Цикл
		Для Каждого КлючИЗначение Из СтруктураДанных Цикл
			ВложенныйЭлемент[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЦикла;
		
		УстановитьЗначениеПризнакаВложенныхЭлементов(ВложенныйЭлемент, ИменаКолонок);
	КонецЦикла;
КонецПроцедуры

// Рассчитывает и возвращает значение родителя по значениям вложенных элементов
//
// Параметры
//	НаборЭлементов - Тип: ДанныеФормыКоллекцияЭлементовДерева.
//	ИмяКолонки - Тип: Строка.
//
Функция ПолучитьЗначениеПризнакаПоВложеннымЭлементам(НаборЭлементов, знач ИмяКолонки) Экспорт
	ЗначениеРодителя = Неопределено;
	Для Каждого ЭлементДерева Из НаборЭлементов Цикл
		ВложенныеЭлементы = ЭлементДерева.ПолучитьЭлементы();
		
		Если ВложенныеЭлементы.Количество() > 0 Тогда
			ЗначениеЭлемента = ПолучитьЗначениеПризнакаПоВложеннымЭлементам(ВложенныеЭлементы, ИмяКолонки);
			ЭлементДерева[ИмяКолонки] = ЗначениеЭлемента;
		КонецЕсли;
		
		ЗначениеРеквизита	= ?(ЭлементДерева[ИмяКолонки] = ЗначениеРодителя, ЗначениеРодителя, 2);
		ЗначениеРодителя	= ?(ЗначениеРодителя = Неопределено, ЭлементДерева[ИмяКолонки], ЗначениеРеквизита);
	КонецЦикла;
	
	Возврат ЗначениеРодителя;
КонецФункции

// Рассчитывает сумму, разницу, минимум или максимум вышестоящих уровней по вложенным элементам
//
// Параметры:
//	ЭлементДерева			- СтрокаДереваЗначений, ДанныеФормыЭлементДерева - элемент от которого необходимо рассчитать значения
//	ИменаКолонок			- Строка - имя колонки для которой устанавливается значение
//	ВидОперации				- Строка - предопределенная функция: СУММА, РАЗНИЦА, МИНИМУМ, МАКСИМУМ
//	ВычислитьТекущуюСтроку	- Булево - предварительно рассчитать текущую строку по вложенным элементам
// 	МодульОповещения		- УправляемаяФорма, Модуль, ОписаниеОповещения, Неопределено
//		Клиентский контекст в котором будет вызвана процедура (см. ИмяПроцедуры)
//	ИмяПроцедуры			- Строка - имя публичного метода для контроля пересчета данных
//
Процедура РассчитатьЗначенияВышестоящихЭлементов(ЭлементДерева, знач ИменаКолонок, знач ВидОперации = "СУММА", знач ВычислитьТекущуюСтроку = Ложь, знач МодульОповещения = Неопределено, знач ИмяПроцедуры = "") Экспорт
	МассивКолонок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаКолонок, ",", Истина, Истина);

	Оповещение = Неопределено;
	#Если Клиент Тогда
		Если ЗначениеЗаполнено(ИмяПроцедуры) Тогда
			Оповещение = Новый ОписаниеОповещения(ИмяПроцедуры, МодульОповещения);
		КонецЕсли; 
 	#КонецЕсли

	РассчитатьЗначенияВышестоящихЭлементов_Рекурсивно(ЭлементДерева, МассивКолонок, ВидОперации, ВычислитьТекущуюСтроку, Оповещение);
КонецПроцедуры

// Рассчитывает сумму, разницу, минимум или максимум вложенных уровней по текущей строке
//
// Параметры:
//	ЭлементДерева			- СтрокаДереваЗначений, ДанныеФормыЭлементДерева, ДеревоЗначений, ДанныеФормыДерево
//		Элемент от которого необходимо рассчитать значения
//	ИменаКолонок			- Строка - имя колонки для которой устанавливается значение
//	ВидОперации				- Строка - предопределенная функция: СУММА, РАЗНИЦА, МИНИМУМ, МАКСИМУМ
// 	МодульОповещения		- УправляемаяФорма, Модуль, ОписаниеОповещения, Неопределено
//		Клиентский контекст в котором будет вызвана процедура (см. ИмяПроцедуры)
//	ИмяПроцедуры			- Строка - имя публичного метода для контроля пересчета данных
//
Процедура РассчитатьЗначенияВложенныхЭлементов(ЭлементДерева, знач ИменаКолонок, знач ВидОперации = "СУММА", знач МодульОповещения = Неопределено, знач ИмяПроцедуры = "") Экспорт
	МассивКолонок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаКолонок, ",", Истина, Истина);
	
	Оповещение = Неопределено;
	#Если Клиент Тогда
		Если ЗначениеЗаполнено(ИмяПроцедуры) Тогда
			Оповещение = Новый ОписаниеОповещения(ИмяПроцедуры, МодульОповещения);
		КонецЕсли; 
 	#КонецЕсли
	
	РассчитатьЗначенияВложенныхЭлементов_Рекурсивно(ЭлементДерева, МассивКолонок, ВидОперации, Оповещение);
КонецПроцедуры

#КонецОбласти

#Область МетодыРаботыСФормамиСписков

// Устанавливает условное оформление на строки с пометкой на удаление
//
// Параметры:
//	Список		- ДинамическийСписок - реквизит формы для оформления
//	СписокПолей - Строка, Массив
// 
Процедура УстановитьОформлениеПометкаУдаления(Список, знач СписокПолей = "") Экспорт
	
	// Новый элемент условного оформления
	ЭлементПометкаУдаления = Список.УсловноеОформление.Элементы.Добавить();
	ЭлементПометкаУдаления.Использование	= Истина;
	ЭлементПометкаУдаления.Представление	= НСтр("ru='Помеченные на удаление темно-серым'"); 
	ЭлементПометкаУдаления.РежимОтображения	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	// Отбор
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементПометкаУдаления.Отбор,
		"ПометкаУдаления",
		Истина,
		ВидСравненияКомпоновкиДанных.Равно,,
		Истина);
	
	// Оформление
	ЭлементПометкаУдаления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСерый);
	
	// Поля
	ДобавитьПоляУсловногоОформления(ЭлементПометкаУдаления.Поля, СписокПолей);
	
КонецПроцедуры

#КонецОбласти 

#Область ПроверкаРеквизитовФормы

// Добавляет данные для проверки реквизитов на форме
//	1. Для проверки реквизита формы:
//		ДобавитьРеквизитФормыДляПроверки(Структура, "ИмяРеквизитаФормы", НСтр("ru='Имя реквизита формы'"));
//	2. Для проверки реквизита таблицы формы:
//		ДобавитьРеквизитФормыДляПроверки(Структура, "ИмяТабЧасти.ИмяРеквизита", НСтр("ru='Имя реквизита табличной части'"));
//
// Параметры:
//	Структура		- Структура - объект для хранения настройки проверки
//	Поле			- Строка - имя реквизита формы, имя реквизита табличной части с именем ТЧ
//	Представление	- Строка - представление реквизита для сообщения
//
Процедура ДобавитьРеквизитФормыДляПроверки(Структура, знач Поле, знач Представление) Экспорт
	// Проверка типа реквизита
	Если НЕ ТипЗнч(Структура) = Тип("Структура") Тогда
		Структура = Новый Структура;
	КонецЕсли;
	
	// Проверка наличия служебного свойства "__ТабличныеЧасти"
	ТабличныеЧасти = Неопределено;
	Если НЕ Структура.Свойство("__ТабличныеЧасти", ТабличныеЧасти) ИЛИ НЕ ТипЗнч(ТабличныеЧасти) = Тип("Структура") Тогда
		ТабличныеЧасти = Новый Структура;
		Структура.Вставить("__ТабличныеЧасти", ТабличныеЧасти);
	КонецЕсли;
	
	// Обработка и добавление переданного поля
	Если СтрНайти(Поле, ".") > 0 Тогда
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Поле, ".");
		Если МассивПодстрок.Количество() < 2 Тогда
			Возврат;
		КонецЕсли;
		
		ИмяТабличнойЧасти	= СокрЛП(МассивПодстрок[0]);
		ИмяРеквизитаТЧ		= СокрЛП(МассивПодстрок[1]);
		
		СтруктураПолей = Неопределено;
		ТабличныеЧасти.Свойство(ИмяТабличнойЧасти, СтруктураПолей);
		Если НЕ ТипЗнч(СтруктураПолей) = Тип("Структура") Тогда
			СтруктураПолей = Новый Структура;
		КонецЕсли;
		
		СтруктураПолей.Вставить(ИмяРеквизитаТЧ, Представление);
		ТабличныеЧасти.Вставить(ИмяТабличнойЧасти, СтруктураПолей);
		Структура.Вставить("__ТабличныеЧасти", ТабличныеЧасти);
	Иначе 
		Структура.Вставить(Поле, Представление);
	КонецЕсли;
КонецПроцедуры

// Выполняет проверку заполненности реквизитов формы
//
// Параметры:
//	Форма		- ФормаКлиентскогоПриложения
//	Структура	- Структура
//	Отказ		- Булево
//
Процедура ПроверитьЗаполнениеРеквизитовФормы(знач Форма, знач Структура, Отказ) Экспорт
	Для Каждого КлючИЗначение Из Структура Цикл
		ИмяРеквизита	= КлючИЗначение.Ключ;
		Представление	= КлючИЗначение.Значение;
		
		Если ИмяРеквизита = "__ТабличныеЧасти" Тогда
			Для Каждого ТабЧастьРеквизиты Из КлючИЗначение.Значение Цикл
				ПроверитьЗаполнениеТабличнойЧасти(Форма,
					ТабЧастьРеквизиты.Ключ,
					ТабЧастьРеквизиты.Значение,
					Отказ);
			КонецЦикла;
		Иначе
			ПроверитьЗаполнениеРеквизитаФормы(Форма,
				ИмяРеквизита,
				Представление,
				Отказ);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьЗначенияВышестоящихЭлементов_Рекурсивно(СтрокаДерева, знач Колонки, знач Операция, знач ТекСтрока, знач Оповещение)
	ВрегВидОперации = ВРег(Операция);
	
	Если ЭтоСтрокаДанныеФормы(СтрокаДерева) Тогда
		ЭлементРодитель = ?(ТекСтрока, СтрокаДерева, СтрокаДерева.ПолучитьРодителя());
	ИначеЕсли ЭтоСтрокаДереваЗначений(СтрокаДерева) Тогда
		ЭлементРодитель = ?(ТекСтрока, СтрокаДерева, СтрокаДерева.Родитель);
	КонецЕсли;
		
	Если ЭлементРодитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоСтрокаДанныеФормы(ЭлементРодитель) Тогда
		НаборЭлементов	= ЭлементРодитель.ПолучитьЭлементы();
	ИначеЕсли ЭтоСтрокаДереваЗначений(ЭлементРодитель) Тогда
		НаборЭлементов	= ЭлементРодитель.Строки;
	КонецЕсли;
	
	СтруктураДанных	= Новый Соответствие;
	Для Каждого ИмяКолонки Из Колонки Цикл
		СтруктураДанных.Вставить(СокрЛП(ИмяКолонки), 0);
	КонецЦикла;
	
	Для Каждого ВложенныйЭлемент Из НаборЭлементов Цикл
		Для Каждого КлючИЗначение Из СтруктураДанных Цикл
			ЗначениеРеквизита	= ВложенныйЭлемент[КлючИЗначение.Ключ];
			ЗначениеРодителя	= КлючИЗначение.Значение;
			
			Если ВрегВидОперации = "СУММА" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, ЗначениеРодителя + ЗначениеРеквизита);
			ИначеЕсли ВрегВидОперации = "РАЗНИЦА" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, ЗначениеРодителя - ЗначениеРеквизита);
			ИначеЕсли ВрегВидОперации = "МИНИМУМ" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, Мин(ЗначениеРодителя, ЗначениеРеквизита));
			ИначеЕсли ВрегВидОперации = "МАКСИМУМ" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, Макс(ЗначениеРодителя, ЗначениеРеквизита));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из СтруктураДанных Цикл
		ЭлементРодитель[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
	КонецЦикла;
	
	#Если Клиент Тогда
		Если ТипЗнч(Оповещение) = Тип("ОписаниеОповещения") Тогда
			ВыполнитьОбработкуОповещения(Оповещение, СтрокаДерева);
		КонецЕсли;
	#КонецЕсли 
	
	РассчитатьЗначенияВышестоящихЭлементов_Рекурсивно(ЭлементРодитель, Колонки, Операция, Ложь, Оповещение);
КонецПроцедуры

Процедура РассчитатьЗначенияВложенныхЭлементов_Рекурсивно(СтрокаДерева, знач Колонки, знач Операция, знач Оповещение)
	ВрегВидОперации = ВРег(Операция);
	
	ТипСтроки = ТипЗнч(СтрокаДерева);
	Если ЭтоСтрокаДанныеФормы(СтрокаДерева) Тогда
		НаборЭлементов = СтрокаДерева.ПолучитьЭлементы();
	ИначеЕсли ЭтоСтрокаДереваЗначений(СтрокаДерева) Тогда
		НаборЭлементов = СтрокаДерева.Строки;
	КонецЕсли;
		
	Если НаборЭлементов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных	= Новый Соответствие;
	Для Каждого ИмяКолонки Из Колонки Цикл
		СтруктураДанных.Вставить(СокрЛП(ИмяКолонки), 0);
	КонецЦикла;
	
	Для Каждого ВложенныйЭлемент Из НаборЭлементов Цикл
		РассчитатьЗначенияВложенныхЭлементов_Рекурсивно(ВложенныйЭлемент, Колонки, Операция, Оповещение);
		
		Для Каждого КлючИЗначение Из СтруктураДанных Цикл
			ЗначениеРеквизита	= ВложенныйЭлемент[КлючИЗначение.Ключ];
			ЗначениеРодителя	= КлючИЗначение.Значение;
			
			Если ВрегВидОперации = "СУММА" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, ЗначениеРодителя + ЗначениеРеквизита);
			ИначеЕсли ВрегВидОперации = "РАЗНИЦА" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, ЗначениеРодителя - ЗначениеРеквизита);
			ИначеЕсли ВрегВидОперации = "МИНИМУМ" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, Мин(ЗначениеРодителя, ЗначениеРеквизита));
			ИначеЕсли ВрегВидОперации = "МАКСИМУМ" Тогда
				СтруктураДанных.Вставить(КлючИЗначение.Ключ, Макс(ЗначениеРодителя, ЗначениеРеквизита));
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// проверим что переданный элемент не является деревом
	Если ЭтоСтрокаДанныеФормы(СтрокаДерева, 1) ИЛИ ЭтоСтрокаДереваЗначений(СтрокаДерева, 1) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из СтруктураДанных Цикл
		СтрокаДерева[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
	КонецЦикла;
	
	#Если Клиент Тогда
		Если ТипЗнч(Оповещение) = Тип("ОписаниеОповещения") Тогда
			ВыполнитьОбработкуОповещения(Оповещение, СтрокаДерева);
		КонецЕсли;
	#КонецЕсли 
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧасти(знач Форма, знач ИмяТабЧасти, знач РеквизитыТабЧасти, Отказ)
	ЗначениеТабЧасти = Форма[ИмяТабЧасти];
	Если НЕ ТипЗнч(ЗначениеТабЧасти) = Тип("ДанныеФормыКоллекция") Тогда
		Возврат;
	КонецЕсли;
				
	СчетчикСтрок = 0;
	Для Каждого СтрокаТаблицы Из ЗначениеТабЧасти Цикл
		СчетчикСтрок = СчетчикСтрок + 1;
		
		Для Каждого КлючИЗначение Из РеквизитыТабЧасти Цикл
			ДанныеЗаполнены = ЗначениеЗаполнено(СтрокаТаблицы[КлючИЗначение.Ключ]);
			Если ДанныеЗаполнены Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстСообщения	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Поле ""%1"" не заполнено.'"),
				КлючИЗначение.Значение);
			
			ИмяРеквизита = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабЧасти,
				СчетчикСтрок,
				КлючИЗначение.Ключ);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяРеквизита,, Отказ);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитаФормы(знач Форма, знач ИмяРеквизита, знач ПредставлениеРеквизита, Отказ)
	ЗначениеРеквизита		= Форма[ИмяРеквизита];
	ТипЗначенияРеквизита	= ТипЗнч(ЗначениеРеквизита);
	
	Если ТипЗначенияРеквизита = Тип("ДанныеФормыКоллекция") Тогда
		ДанныеЗаполнены = (ЗначениеРеквизита.Количество() > 0);
		ТипРеквизита	= НСтр("ru='Таблица'");
		ТекстРезультата	= НСтр("ru='не заполнена'");
	ИначеЕсли ТипЗначенияРеквизита = Тип("ДанныеФормыДерево") Тогда
		ДанныеЗаполнены = (ЗначениеРеквизита.ПолучитьЭлементы().Количество() > 0);
		ТипРеквизита	= НСтр("ru='Дерево'"); 
		ТекстРезультата	= НСтр("ru='не заполнено'");
	Иначе 
		ДанныеЗаполнены = ЗначениеЗаполнено(ЗначениеРеквизита);
		ТипРеквизита	= НСтр("ru='Поле'"); 
		ТекстРезультата	= НСтр("ru='не заполнено'");
	КонецЕсли;
	
	Если ДанныеЗаполнены Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='%1 ""%2"" %3.'"),
		ТипРеквизита,
		ПредставлениеРеквизита,
		ТекстРезультата);
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяРеквизита,, Отказ);
КонецПроцедуры

Функция КопияДанныхВКоллекцию(знач КопияДанных, знач Фиксировать = Ложь)
	Коллекция = Новый Структура("Реквизиты,Сохраненные,Значения");
	
	Если Фиксировать Тогда
		Коллекция.Реквизиты		= Новый ФиксированныйМассив(КопияДанных.Реквизиты);
		Коллекция.Сохраненные	= Новый ФиксированныйМассив(КопияДанных.Сохраненные);
		Коллекция.Значения		= Новый ФиксированноеСоответствие(КопияДанных.Значения);
	Иначе 
		Коллекция.Реквизиты		= Новый Массив(КопияДанных.Реквизиты);
		Коллекция.Сохраненные	= Новый Массив(КопияДанных.Сохраненные);
		Коллекция.Значения		= Новый Соответствие(КопияДанных.Значения);
	КонецЕсли;
	
	Возврат Коллекция;
КонецФункции

#КонецОбласти


