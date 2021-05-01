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
	
	Если Параметры.РежимОткрытияОкна <> Неопределено Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	Если Параметры.ТабличныйДокумент = Неопределено Тогда
		Если Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) Тогда
			РедактированиеЗапрещено = Не Параметры.Редактирование;
			ЗагрузитьТабличныйДокументИзМетаданных(Параметры.КодЯзыка);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Параметры.ТабличныйДокумент) = Тип("ТабличныйДокумент") Тогда
		ТабличныйДокумент = Параметры.ТабличныйДокумент;
	Иначе
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(Параметры.ТабличныйДокумент); // ДвоичныеДанные - 
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
		УдалитьФайлы(ИмяВременногоФайла);
	КонецЕсли;
	
	Элементы.ТабличныйДокумент.Редактирование = Параметры.Редактирование;
	Элементы.ТабличныйДокумент.ОтображатьГруппировки = Истина;
	
	ЭтоМакет = Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета);
	Элементы.Предупреждение.Видимость = ЭтоМакет И Параметры.Редактирование;
	
	Элементы.РедактироватьВоВнешнейПрограмме.Видимость = ОбщегоНазначения.ЭтоВебКлиент() 
		И Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать");
	
	Если Не ПустаяСтрока(Параметры.ИмяДокумента) Тогда
		ИмяДокумента = Параметры.ИмяДокумента;
	КонецЕсли;
	
	Элементы.ТабличныйДокумент.ОтображатьИменаСтрокИКолонок = ТабличныйДокумент.Макет;
	Элементы.ТабличныйДокумент.ОтображатьИменаЯчеек = ТабличныйДокумент.Макет;
	
	Если ЭтоМакет Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.Печать") Тогда
			МодульУправлениеПечатьюМультиязычность = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатьюМультиязычность");
			МодульУправлениеПечатьюМультиязычность.ЗаполнитьПодменюЯзык(ЭтотОбъект, Параметры.КодЯзыка);
			ДоступенАвтоматическийПеревод = МодульУправлениеПечатьюМультиязычность.ДоступенАвтоматическийПеревод(ТекущийЯзык);
		КонецЕсли;
	КонецЕсли;
	Элементы.Перевести.Видимость = ДоступенАвтоматическийПеревод;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КоманднаяПанель",					"Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Предупреждение",					"Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) Тогда
		Файл = Новый Файл(Параметры.ПутьКФайлу);
		Если ПустаяСтрока(ИмяДокумента) Тогда
			ИмяДокумента = Файл.ИмяБезРасширения;
		КонецЕсли;
		Файл.НачатьПолучениеТолькоЧтения(Новый ОписаниеОповещения("ПриЗавершенииПолученияТолькоЧтения", ЭтотОбъект));
		Возврат;
	КонецЕсли;
	
	УстановитьНачальныеНастройкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сохранить изменения в %1?'"), ИмяДокумента);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ, ЗавершениеРаботы, ТекстВопроса);
	
	Если Модифицированность Или ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОЗаписиТабличногоДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуПослеЗаписиТабличногоДокумента", ЭтотОбъект);
	ЗаписатьТабличныйДокумент(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗапросИменРедактируемыхТабличныхДокументов" И Источник <> ЭтотОбъект Тогда
		ИменаДокументов = Параметр; // Массив -
		ИменаДокументов.Добавить(ИмяДокумента);
	ИначеЕсли ИмяСобытия = "ЗакрытиеФормыВладельца" И Источник = ВладелецФормы Тогда
		Закрыть();
		Если Открыта() Тогда
			Параметр.Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТабличныйДокументПриАктивизации(Элемент)
	ОбновитьПометкиКнопокКоманднойПанели();
	СинхронизироватьОбластьПросмотраМакетов();
КонецПроцедуры

&НаКлиенте
Процедура ПоставляемыйМакетПриАктивизации(Элемент)
	
	СинхронизироватьОбластьПросмотраМакетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Действия с документом

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытьФормуПослеЗаписиТабличногоДокумента", ЭтотОбъект);
	ЗаписатьТабличныйДокумент(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьТабличныйДокумент();
	ОповеститьОЗаписиТабличногоДокумента();
КонецПроцедуры

&НаКлиенте
Процедура Редактирование(Команда)
	Элементы.ТабличныйДокумент.Редактирование = Не Элементы.ТабличныйДокумент.Редактирование;
	НастроитьПредставлениеКоманд();
	НастроитьОтображениеТабличногоДокумента();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВоВнешнейПрограмме(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
		ПараметрыОткрытия.Вставить("ИмяОбъектаМетаданныхМакета", Параметры.ИмяОбъектаМетаданныхМакета);
		ПараметрыОткрытия.Вставить("ТипМакета", "MXL");
		ОписаниеОповещения = Новый ОписаниеОповещения("РедактироватьВоВнешнейПрограммеЗавершение", ЭтотОбъект);
		МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеПечатьюКлиент");
		МодульУправлениеПечатьюКлиент.РедактироватьМакетВоВнешнейПрограмме(ОписаниеОповещения, ПараметрыОткрытия, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

// Форматирование

&НаКлиенте
Процедура УвеличитьРазмерШрифта(Команда)
	
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Размер = Область.Шрифт.Размер;
		Размер = Размер + ШагИзмененияРазмераШрифтаУвеличение(Размер);
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,Размер);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьРазмерШрифта(Команда)
	
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Размер = Область.Шрифт.Размер;
		Размер = Размер - ШагИзмененияРазмераШрифтаУменьшение(Размер);
		Если Размер < 1 Тогда
			Размер = 1;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,Размер);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Зачеркивание(Команда)
	
	УстанавливаемоеЗначение = Неопределено;
	Для Каждого Область Из СписокОбластейДляИзмененияШрифта() Цикл
		Если УстанавливаемоеЗначение = Неопределено Тогда
			УстанавливаемоеЗначение = Не Область.Шрифт.Зачеркивание = Истина;
		КонецЕсли;
		Область.Шрифт = Новый Шрифт(Область.Шрифт,,,,,,УстанавливаемоеЗначение);
	КонецЦикла;
	
	ОбновитьПометкиКнопокКоманднойПанели();
	
КонецПроцедуры

&НаКлиенте
Процедура Перевести(Команда)
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Выполнить автоматический перевод на %1 язык?'"), Элементы.Язык.Заголовок);
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Выполнить перевод'"));
	Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не выполнять'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОПереводеМакета", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьТабличныйДокументИзМетаданных(Знач КодЯзыка = Неопределено)
	
	ТребуетсяПеревод = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
		ТабличныйДокумент = МодульУправлениеПечатью.МакетПечатнойФормы(Параметры.ИмяОбъектаМетаданныхМакета, КодЯзыка);
		ПоставляемыйМакет = МодульУправлениеПечатью.ПоставляемыйМакет(Параметры.ИмяОбъектаМетаданныхМакета, КодЯзыка);
	КонецЕсли;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.Печать") Тогда
		МодульУправлениеПечатьюМультиязычность = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатьюМультиязычность");
		Если ЗначениеЗаполнено(КодЯзыка) Тогда
			ДоступныеЯзыкиТабличногоДокумента = МодульУправлениеПечатьюМультиязычность.ЯзыкиМакета(Параметры.ИмяОбъектаМетаданныхМакета);
			ТребуетсяПеревод = ДоступныеЯзыкиТабличногоДокумента.Найти(КодЯзыка) = Неопределено;
		КонецЕсли;
		
		ДоступенАвтоматическийПеревод = МодульУправлениеПечатьюМультиязычность.ДоступенАвтоматическийПеревод(ТекущийЯзык);
		Элементы.Перевести.Видимость = ДоступенАвтоматическийПеревод;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеТабличногоДокумента()
	Элементы.ТабличныйДокумент.ОтображатьЗаголовки = Элементы.ТабличныйДокумент.Редактирование;
	Элементы.ТабличныйДокумент.ОтображатьСетку = Элементы.ТабличныйДокумент.Редактирование;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПометкиКнопокКоманднойПанели();
	
#Если Не ВебКлиент И НЕ МобильныйКлиент Тогда
	Область = Элементы.ТабличныйДокумент.ТекущаяОбласть;
	Если ТипЗнч(Область) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		Возврат;
	КонецЕсли;
	
	// Шрифт
	Шрифт = Область.Шрифт;
	Элементы.ТабличныйДокументЖирный.Пометка = Шрифт <> Неопределено И Шрифт.Полужирный = Истина;
	Элементы.ТабличныйДокументНаклонный.Пометка = Шрифт <> Неопределено И Шрифт.Наклонный = Истина;
	Элементы.ТабличныйДокументПодчеркивание.Пометка = Шрифт <> Неопределено И Шрифт.Подчеркивание = Истина;
	Элементы.Зачеркивание.Пометка = Шрифт <> Неопределено И Шрифт.Зачеркивание = Истина;
	
	// Горизонтальное положение
	Элементы.ТабличныйДокументВыровнятьВлево.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
	Элементы.ТабличныйДокументВыровнятьПоЦентру.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	Элементы.ТабличныйДокументВыровнятьВправо.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;
	Элементы.ТабличныйДокументВыровнятьПоШирине.Пометка = Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.ПоШирине;
	
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ШагИзмененияРазмераШрифтаУвеличение(Размер)
	Если Размер = -1 Тогда
		Возврат 10;
	КонецЕсли;
	
	Если Размер < 10 Тогда
		Возврат 1;
	ИначеЕсли 10 <= Размер И  Размер < 20 Тогда
		Возврат 2;
	ИначеЕсли 20 <= Размер И  Размер < 48 Тогда
		Возврат 4;
	ИначеЕсли 48 <= Размер И  Размер < 72 Тогда
		Возврат 6;
	ИначеЕсли 72 <= Размер И  Размер < 96 Тогда
		Возврат 8;
	Иначе
		Возврат Окр(Размер / 10);
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ШагИзмененияРазмераШрифтаУменьшение(Размер)
	Если Размер = -1 Тогда
		Возврат -8;
	КонецЕсли;
	
	Если Размер <= 11 Тогда
		Возврат 1;
	ИначеЕсли 11 < Размер И Размер <= 23 Тогда
		Возврат 2;
	ИначеЕсли 23 < Размер И Размер <= 53 Тогда
		Возврат 4;
	ИначеЕсли 53 < Размер И Размер <= 79 Тогда
		Возврат 6;
	ИначеЕсли 79 < Размер И Размер <= 105 Тогда
		Возврат 8;
	Иначе
		Возврат Окр(Размер / 11);
	КонецЕсли;
КонецФункции

// Возвращаемое значение:
//   Массив из ОбластьЯчеекТабличногоДокумента
//
&НаКлиенте
Функция СписокОбластейДляИзмененияШрифта()
	
	Результат = Новый Массив;
	
	Для Каждого ОбрабатываемаяОбласть Из Элементы.ТабличныйДокумент.ПолучитьВыделенныеОбласти() Цикл
		Если ОбрабатываемаяОбласть.Шрифт <> Неопределено Тогда
			Результат.Добавить(ОбрабатываемаяОбласть);
			Продолжить;
		КонецЕсли;
		
		ОбрабатываемаяОбластьВерх = ОбрабатываемаяОбласть.Верх;
		ОбрабатываемаяОбластьНиз = ОбрабатываемаяОбласть.Низ;
		ОбрабатываемаяОбластьЛево = ОбрабатываемаяОбласть.Лево;
		ОбрабатываемаяОбластьПраво = ОбрабатываемаяОбласть.Право;
		
		Если ОбрабатываемаяОбластьВерх = 0 Тогда
			ОбрабатываемаяОбластьВерх = 1;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьНиз = 0 Тогда
			ОбрабатываемаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьЛево = 0 Тогда
			ОбрабатываемаяОбластьЛево = 1;
		КонецЕсли;
		
		Если ОбрабатываемаяОбластьПраво = 0 Тогда
			ОбрабатываемаяОбластьПраво = ТабличныйДокумент.ШиринаТаблицы;
		КонецЕсли;
		
		Если ОбрабатываемаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
			ОбрабатываемаяОбластьВерх = ОбрабатываемаяОбласть.Низ;
			ОбрабатываемаяОбластьНиз = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
			
		Для НомерКолонки = ОбрабатываемаяОбластьЛево По ОбрабатываемаяОбластьПраво Цикл
			ШиринаКолонки = Неопределено;
			Для НомерСтроки = ОбрабатываемаяОбластьВерх По ОбрабатываемаяОбластьНиз Цикл
				Ячейка = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
				Если ОбрабатываемаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Колонки Тогда
					Если ШиринаКолонки = Неопределено Тогда
						ШиринаКолонки = Ячейка.ШиринаКолонки;
					КонецЕсли;
					Если Ячейка.ШиринаКолонки <> ШиринаКолонки Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				Если Ячейка.Шрифт <> Неопределено Тогда
					Результат.Добавить(Ячейка);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуПослеЗаписиТабличногоДокумента(Закрывать, ДополнительныеПараметры) Экспорт
	Если Закрывать Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТабличныйДокумент(ОбработчикЗавершения = Неопределено)
	
	Если ЭтоНовый() Или РедактированиеЗапрещено Тогда
		НачатьДиалогСохраненияФайла(ОбработчикЗавершения);
		Возврат;
	КонецЕсли;
		
	ЗаписатьТабличныйДокументИмяФайлаВыбрано(ОбработчикЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТабличныйДокументИмяФайлаВыбрано(Знач ОбработчикЗавершения)
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) Тогда
		ТабличныйДокумент.НачатьЗапись(
			Новый ОписаниеОповещения("ОбработатьРезультатЗаписиТабличногоДокумента", ЭтотОбъект, ОбработчикЗавершения),
			Параметры.ПутьКФайлу);
	Иначе
		ПослеЗаписиТабличногоДокумента(ОбработчикЗавершения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗаписиТабличногоДокумента(Результат, ОбработчикЗавершения) Экспорт 
	Если Результат <> Истина Тогда 
		Возврат;
	КонецЕсли;
	
	РедактированиеЗапрещено = Ложь;
	ПослеЗаписиТабличногоДокумента(ОбработчикЗавершения);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиТабличногоДокумента(ОбработчикЗавершения)
	ЗаписьВыполнена = Истина;
	Модифицированность = Ложь;
	УстановитьЗаголовок();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		Если ЗначениеЗаполнено(Параметры.ПрисоединенныйФайл) Тогда
			МодульРаботаСФайламиСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиСлужебныйКлиент");
			ПараметрыОбновленияФайла = МодульРаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(ОбработчикЗавершения, Параметры.ПрисоединенныйФайл, УникальныйИдентификатор);
			МодульРаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОбработчикЗавершения, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НачатьДиалогСохраненияФайла(Знач ОбработчикЗавершения)
	
	Перем ДиалогСохраненияФайла, ОписаниеОповещения;
	
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогСохраненияФайла.ПолноеИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяДокумента);
	ДиалогСохраненияФайла.Фильтр = НСтр("ru = 'Табличный документ'") + " (*.mxl)|*.mxl";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииДиалогаВыбораФайла", ЭтотОбъект, ОбработчикЗавершения);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, ДиалогСохраненияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииДиалогаВыбораФайла(ВыбранныеФайлы, ОбработчикЗавершения) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = ВыбранныеФайлы[0];
	
	Параметры.ПутьКФайлу = ПолноеИмяФайла;
	ИмяДокумента = Сред(ПолноеИмяФайла, СтрДлина(ОписаниеФайла(ПолноеИмяФайла).Путь) + 1);
	Если НРег(Прав(ИмяДокумента, 4)) = ".mxl" Тогда
		ИмяДокумента = Лев(ИмяДокумента, СтрДлина(ИмяДокумента) - 4);
	КонецЕсли;
	
	ЗаписатьТабличныйДокументИмяФайлаВыбрано(ОбработчикЗавершения);
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеФайла(ПолноеИмя)
	
	ПозицияРазделителя = СтрНайти(ПолноеИмя, ПолучитьРазделительПути(), НаправлениеПоиска.СКонца);
	
	Имя = Сред(ПолноеИмя, ПозицияРазделителя + 1);
	Путь = Лев(ПолноеИмя, ПозицияРазделителя);
	
	ПозицияРасширения = СтрНайти(Имя, ".", НаправлениеПоиска.СКонца);
	
	ИмяБезРасширения = Лев(Имя, ПозицияРасширения - 1);
	Расширение = Сред(Имя, ПозицияРасширения + 1);
	
	Результат = Новый Структура;
	Результат.Вставить("ПолноеИмя", ПолноеИмя);
	Результат.Вставить("Имя", Имя);
	Результат.Вставить("Путь", Путь);
	Результат.Вставить("ИмяБезРасширения", ИмяБезРасширения);
	Результат.Вставить("Расширение", Расширение);
	
	Возврат Результат;
	
КонецФункции
	
&НаКлиенте
Функция ИмяНовогоДокумента()
	Возврат НСтр("ru = 'Новый'");
КонецФункции

&НаКлиенте
Процедура УстановитьЗаголовок()
	
	Заголовок = ИмяДокумента;
	Если ЭтоНовый() Тогда
		Заголовок = Заголовок + " (" + НСтр("ru = 'создание'") + ")";
	ИначеЕсли РедактированиеЗапрещено Тогда
		Заголовок = Заголовок + " (" + НСтр("ru = 'только просмотр'") + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПредставлениеКоманд()
	
	ДокументРедактируется = Элементы.ТабличныйДокумент.Редактирование;
	Элементы.Редактирование.Пометка = ДокументРедактируется;
	Элементы.КомандыРедактирования.Доступность = ДокументРедактируется;
	Элементы.ЗаписатьИЗакрыть.Доступность = ДокументРедактируется Или Модифицированность;
	Элементы.Записать.Доступность = ДокументРедактируется Или Модифицированность;
	
	Если ДокументРедактируется И Не ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) Тогда
		Элементы.Предупреждение.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоНовый()
	Возврат ПустаяСтрока(Параметры.ИмяОбъектаМетаданныхМакета) И ПустаяСтрока(Параметры.ПутьКФайлу);
КонецФункции

&НаКлиенте
Процедура РедактироватьВоВнешнейПрограммеЗавершение(ЗагруженныйТабличныйДокумент, ДополнительныеПараметры) Экспорт
	Если ЗагруженныйТабличныйДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ОбновитьТабличныйДокумент(ЗагруженныйТабличныйДокумент);
КонецПроцедуры

&НаСервере
Процедура ОбновитьТабличныйДокумент(ЗагруженныйТабличныйДокумент)
	ТабличныйДокумент = ЗагруженныйТабличныйДокумент;
КонецПроцедуры


&НаКлиенте
Процедура УстановитьНачальныеНастройкиФормы()
	
	Если Не ПустаяСтрока(Параметры.ПутьКФайлу) И Не РедактированиеЗапрещено Тогда
		Элементы.ТабличныйДокумент.Редактирование = Истина;
	КонецЕсли;
	
	УстановитьИмяДокумента();
	УстановитьЗаголовок();
	НастроитьПредставлениеКоманд();
	НастроитьОтображениеТабличногоДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИмяДокумента()

	Если ПустаяСтрока(ИмяДокумента) Тогда
		ИспользованныеИмена = Новый Массив;
		Оповестить("ЗапросИменРедактируемыхТабличныхДокументов", ИспользованныеИмена, ЭтотОбъект);
		
		Индекс = 1;
		Пока ИспользованныеИмена.Найти(ИмяНовогоДокумента() + Индекс) <> Неопределено Цикл
			Индекс = Индекс + 1;
		КонецЦикла;
		
		ИмяДокумента = ИмяНовогоДокумента() + Индекс;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииПолученияТолькоЧтения(ТолькоЧтение, ДополнительныеПараметры) Экспорт
	
	РедактированиеЗапрещено = ТолькоЧтение;
	УстановитьНачальныеНастройкиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПереключитьЯзык(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатьюКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеПечатьюКлиент");
		МодульУправлениеПечатьюКлиент.ПереключитьЯзык(ЭтотОбъект, Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриПереключенииЯзыка(КодЯзыка, ДополнительныеПараметры) Экспорт
	
	ЗагрузитьТабличныйДокументИзМетаданных(КодЯзыка);
	Если ТребуетсяПеревод И ДоступенАвтоматическийПеревод Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Макет еще не переведен на %1 язык.
			|Выполнить автоматический перевод?'"), Элементы.Язык.Заголовок);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Выполнить перевод'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не выполнять'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОПереводеМакета", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОПереводеМакета(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПеревестиТекстыМакета();
	
КонецПроцедуры

&НаСервере
Процедура ПеревестиТекстыМакета()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.ПереводТекста") Тогда
		МодульПереводТекстаНаДругиеЯзыки = ОбщегоНазначения.ОбщийМодуль("ПереводТекстаНаДругиеЯзыки");
	Иначе
		Возврат;
	КонецЕсли;
	
	ТекстыЯчеек = Новый Соответствие;
	
	Для НомерСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			Если ЗначениеЗаполнено(Область.Текст) Тогда
				Текст = УбратьПараметрыИзТекста(Область.Текст).Текст;
				ТекстыЯчеек.Вставить(Текст, Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ТекстыДляПеревода = Новый Массив;
	Для Каждого Элемент Из ТекстыЯчеек Цикл
		ТекстыДляПеревода.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	Переводы = МодульПереводТекстаНаДругиеЯзыки.ПеревестиТексты(
		ТекстыДляПеревода, ТекущийЯзык, ОбщегоНазначения.КодОсновногоЯзыка());
	
	Для НомерСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		Для НомерКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки);
			Если ЗначениеЗаполнено(Область.Текст) Тогда
				РезультатОбработки = УбратьПараметрыИзТекста(Область.Текст);
				Текст = РезультатОбработки.Текст;
				Если ЗначениеЗаполнено(Переводы[Текст]) Тогда
					Область.Текст = ВернутьПараметрыВТекст(Переводы[Текст], РезультатОбработки.Параметры);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция УбратьПараметрыИзТекста(Знач Текст)
	
	НайденныеПараметры = Новый Массив;
	
	ЧастиСтроки = СтрРазделить(Текст, "[]", Истина);
	Для Индекс = 1 По ЧастиСтроки.ВГраница() Цикл
		НайденныеПараметры.Добавить("[" + ЧастиСтроки[Индекс] + "]");
		Индекс = Индекс + 1;
	КонецЦикла;
	
	ОбработанныеПараметры = Новый Массив;
	Счетчик = 0;
	Для Каждого Параметр Из НайденныеПараметры Цикл
		Если СтрНайти(Текст, Параметр) Тогда
			Счетчик = Счетчик + 1;
			Идентификатор = "%" + XMLСтрока(Счетчик);
			Текст = СтрЗаменить(Текст, Параметр, Идентификатор);
			ОбработанныеПараметры.Добавить(Параметр);
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Текст", Текст);
	Результат.Вставить("Параметры", ОбработанныеПараметры);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВернутьПараметрыВТекст(Знач Текст, ОбработанныеПараметры)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(Текст, ОбработанныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура ПоказатьСкрытьОригинал(Команда)
	
	Элементы.КнопкаПоказатьСкрытьОригинал.Пометка = Не Элементы.КнопкаПоказатьСкрытьОригинал.Пометка;
	Элементы.ПоставляемыйМакет.Видимость = Элементы.КнопкаПоказатьСкрытьОригинал.Пометка;
	Если Элементы.КнопкаПоказатьСкрытьОригинал.Пометка Тогда
		Элементы.ТабличныйДокумент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	Иначе
		Элементы.ТабличныйДокумент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьОбластьПросмотраМакетов()
	
	Если Не Элементы.ПоставляемыйМакет.Видимость Тогда
		Возврат;
	КонецЕсли;
	
	УправляемыйЭлемент =  Элементы.ПоставляемыйМакет;
	Если ТекущийЭлемент <> Элементы.ТабличныйДокумент Тогда
		УправляемыйЭлемент = Элементы.ТабличныйДокумент;
	КонецЕсли;
	
	Область = ТекущийЭлемент.ТекущаяОбласть;
	Если Область = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УправляемыйЭлемент.ТекущаяОбласть = ЭтотОбъект[ТекущийЭлемент.Имя].Область(
		Область.Верх, Область.Лево, Область.Низ, Область.Право);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОЗаписиТабличногоДокумента()
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ПутьКФайлу", Параметры.ПутьКФайлу);
	ПараметрыОповещения.Вставить("ИмяОбъектаМетаданныхМакета", Параметры.ИмяОбъектаМетаданныхМакета);
	ПараметрыОповещения.Вставить("КодЯзыка", ТекущийЯзык);
	
	Если ЗаписьВыполнена Тогда
		ИмяСобытия = "Запись_ТабличныйДокумент";
		ПараметрыОповещения.Вставить("ТабличныйДокумент", ТабличныйДокумент);
	Иначе
		ИмяСобытия = "ОтменаРедактированияТабличногоДокумента";
	КонецЕсли;
	Оповестить(ИмяСобытия, ПараметрыОповещения, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти
