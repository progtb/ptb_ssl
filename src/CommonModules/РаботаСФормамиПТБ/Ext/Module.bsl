﻿// Copyright (c) 2023, ООО ПрогТехБизнес
// Лицензия Attribution 4.0 International (CC BY 4.0)

#Область ПрограммныйИнтерфейс

// Добавляет реквизит в форму на основании таблицы значений
//
// Параметры:
//	Форма - УправляемаяФорма
//	ИмяТабличнойЧасти - Строка
//	ТаблицаЗначений - ТаблицаЗначений
//	СохраняемыеДанные - Булево
// 
Процедура СоздатьРеквизитыФормыПоТаблицеЗначений(Форма, ИмяТабличнойЧасти, ТаблицаЗначений, СохраняемыеДанные = Ложь) Экспорт
	МассивДобавить = Новый Массив;
	
	МассивДобавить.Добавить(Новый РеквизитФормы(ИмяТабличнойЧасти, Новый ОписаниеТипов("ТаблицаЗначений"),,, СохраняемыеДанные));
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		НовыйРеквизитФормы = Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, ИмяТабличнойЧасти, Колонка.Заголовок);
		МассивДобавить.Добавить(НовыйРеквизитФормы);
	КонецЦикла;
	
	Форма.ИзменитьРеквизиты(МассивДобавить);
	
	Форма.ЗначениеВРеквизитФормы(ТаблицаЗначений, ИмяТабличнойЧасти);
КонецПроцедуры

// Выполняет проверку параметра "Режим выбора" в форме и устанавливает соотв. значение в свойство динамического списка
// Если режим выбора включен, отключается сохранение данных в настройках
// Дополнительно см. РаботаСФормамиПТБКлиент.ОтключитьПользовательскиеНастройкиДинамическогоСписка
//
// Параметры:
//	Форма 			- ФормаКлиентскогоПриложения
//	ИмяРеквизита	- Строка - имя реквизита динамического списка
//
Процедура ПроверитьРежимВыбораДинамическогоСписка(знач Форма, знач ИмяРеквизита = "Список") Экспорт
	
	// проверим наличие установленного режима выбора на форме и списке
	// если имеются различия, берем режим выбора из формы
	РежимВыбораФормы	= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Форма.Параметры, "РежимВыбора", Ложь);
	РежимВыбораСписка	= ОбщегоНазначенияКлиентСервер.ЗначениеСвойстваЭлементаФормы(Форма.Элементы, ИмяРеквизита, "РежимВыбора");
	Если РежимВыбораФормы <> РежимВыбораСписка Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы,
			ИмяРеквизита, "РежимВыбора", РежимВыбораФормы);
	КонецЕсли;
	
	// установим признак не сохранять настройки формы
	Если РежимВыбораФормы = Истина Тогда
		Форма.СохранениеДанныхВНастройках = СохранениеДанныхФормыВНастройках.НеИспользовать;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

Процедура ПриСозданииНаСервереФормаСписка(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ЭлементСписок = Форма.Элементы.Найти("Список");
	Если ЭлементСписок <> Неопределено Тогда
		РаботаСФормамиПТБ.ПроверитьРежимВыбораДинамическогоСписка(Форма, "Список");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область КопияДанныхФормы

// Выполняет настройку формы для хранения копии данных реквизитов до изменения
// подробнее об использовании см. РаботаСФормамиКлиентСервер.СкопироватьДанныеФормы
//
// Параметры:
//	Форма		- ФормаКлиентскогоПриложения
//	Реквизиты	- Строка, Массив, Соответствие, Структура - в т.ч. фиксированные варианты коллекций.
//		Реквизиты формы указываются как <ИмяРеквизита>. Допустимо использование реквизитов с точками
//		например: "Объект.<ИмяРеквизита>"
// 
Процедура КопияДанныхФормыИнициализация(Форма, знач Реквизиты = Неопределено) Экспорт
	ЕстьРеквизитКопия = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "_КопияДанныхФормы_");
	Если ЕстьРеквизитКопия Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитФормы = Новый РеквизитФормы("_КопияДанныхФормы_", Новый ОписаниеТипов());
	
	МассивДобавить = Новый Массив;
	МассивДобавить.Добавить(РеквизитФормы);
	
	Форма.ИзменитьРеквизиты(МассивДобавить);
	
	КопияДанных = Новый Структура("Реквизиты,Группы,Сохраненные,Значения",
		Новый ФиксированныйМассив(Новый Массив),
		Новый ФиксированнаяСтруктура(Новый Структура),
		Новый ФиксированныйМассив(Новый Массив),
		Новый ФиксированноеСоответствие(Новый Соответствие));
		
	Форма._КопияДанныхФормы_ = Новый ФиксированнаяСтруктура(КопияДанных);
	
	РаботаСФормамиПТБКлиентСервер.КопияДанныхФормыДобавитьРеквизиты(Форма, Реквизиты);
КонецПроцедуры

#Область УстаревшийИнтерфейс

// устарела. см. КопияДанныхФормыИнициализация
Процедура СоздатьРеквизитХраненияКопииДанныхФормы(Форма) Экспорт
	КопияДанныхФормыИнициализация(Форма);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

