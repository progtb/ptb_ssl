﻿#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КолонкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ЗаполнениеТаблицыЗначенийНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеТаблицыЗначенийНаСервере(ВыбранноеЗначение, ЗначениеВТекущейЯчейке = Неопределено)
	Если ЗначениеВТекущейЯчейке = Неопределено Тогда
		ЗначенияСтрокКолонки.Очистить();
	КонецЕсли;	
	Если Колонка <> "" Тогда
		ЗначениеДляЗаполнения = ЗначениеВТекущейЯчейке;
	КонецЕсли;

	ТаблицаСтрок = РеквизитФормыВЗначение("ЗначенияСтрокКолонки");

	Для Каждого СтрокаМассива Из Параметры.МассивДанныхТаблицы Цикл
		Если СтрокаМассива.Имя = ВыбранноеЗначение Тогда
			Колонка = СтрокаМассива.Имя;

			Элементы.ЗначениеДляЗаполнения.ОграничениеТипа = СтрокаМассива.ТипЗначения;
			Для Каждого Значение Из СтрокаМассива.Значения Цикл
				НоваяСтрока = ТаблицаСтрок.Добавить();
				НоваяСтрока.Значение 				= ?(ЗначениеЗаполнено(Значение.Значение), Значение.Значение, "<Пустое значение>");
				НоваяСтрока.ИндексВыделеннойСтроки 	= Значение.ИндексВыделеннойСтроки;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	ЗначенияСтрокКолонки.Загрузить(ТаблицаСтрок);
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияСтрокКолонкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	ЗначениеДляЗаполнения = ?(ТекущиеДанные.Значение = "<Пустое значение>", Элементы.ЗначениеДляЗаполнения.ОграничениеТипа.ПривестиЗначение(), ТекущиеДанные.Значение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("МассивДанныхТаблицы") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.МассивДанныхТаблицы) <> Тип("Массив") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекущаяВыделеннаяКолонка = "";
	ЗначениеВТекущейЯчейке = Неопределено;
	Если Параметры.Свойство("ДанныеТекущейСтроки") И Параметры.ДанныеТекущейСтроки.Свойство("ЗначениеВТекущейЯчейке") Тогда 
		ЗначениеВТекущейЯчейке 		= Параметры.ДанныеТекущейСтроки.ЗначениеВТекущейЯчейке;
		ТекущаяВыделеннаяКолонка 	= Параметры.ДанныеТекущейСтроки.ТекущаяВыделеннаяКолонка;
	КонецЕсли;
	
	Для Каждого СтрокаМассива Из Параметры.МассивДанныхТаблицы Цикл
		Элементы.Колонка.СписокВыбора.Добавить(СтрокаМассива.Имя, СтрокаМассива.Заголовок);
		Если ТекущаяВыделеннаяКолонка = СтрокаМассива.Имя Тогда
			Колонка = СтрокаМассива.Имя;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнениеТаблицыЗначенийНаСервере(ТекущаяВыделеннаяКолонка, ЗначениеВТекущейЯчейке);	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВвестиЗначениеЗаполнения(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВвестиЗначениеЗаполненияЗавершение", ЭтаФорма, Новый Структура); 
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Вы действительно хотите изменить значения в выделенных строках?'"), РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

#КонецОбласти

#Область ЗавершениеНемодальныхВызовов

&НаКлиенте
Процедура ВвестиЗначениеЗаполненияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СтруктураВозврат = Новый Структура;
		СтруктураВозврат.Вставить("ИмяСтруктуры",		 	"ГрупповоеРедактированиеСтрок");
		СтруктураВозврат.Вставить("ЗначениеДляЗаполнения", 	ЗначениеДляЗаполнения);
		СтруктураВозврат.Вставить("Колонка", 				Колонка);
		
		МассивВыделенныхСтрок = новый Массив;
		Для Каждого Строка Из ЗначенияСтрокКолонки Цикл
			МассивВыделенныхСтрок.Добавить(Строка.Индексвыделеннойстроки);
		КонецЦикла;
		СтруктураВозврат.Вставить("МассивВыделенныхСтрок",		МассивВыделенныхСтрок);
		СтруктураВозврат.Вставить("ПутьКДаннымТекущейТаблицы",	Параметры.ДанныеТекущейСтроки.ПутьКДаннымТекущейТаблицы);

		ОповеститьОВыборе(СтруктураВозврат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
