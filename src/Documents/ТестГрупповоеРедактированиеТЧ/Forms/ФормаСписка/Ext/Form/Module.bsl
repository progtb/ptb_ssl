﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РаботаСФормамиПТБ.ПриСозданииНаСервереФормаСписка(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Настройки = ГрупповоеРедактированиеТабличныхЧастейСервер.НастройкиИнициализации();
	// Соответствие Элементов ТаблицаФормы (для которой вычисляем суммы) и ГруппаФормы(в которой создаем реквизиты расчета) 
	Настройки.ДоступныеТаблицы.Добавить("Список");
	Настройки.НастройкиРазмещения.Вставить("Список", "Группа1");

	ГрупповоеРедактированиеТабличныхЧастейСервер.СформироватьОписаниеТабличныхЧастейФормы(ЭтаФорма,Настройки);
	
	
	
	НастройкиСуммирования = ГрупповоеРедактированиеТабличныхЧастейСервер.НастройкиИнициализацииСуммыВыделенныхСтрок();
	НастройкиСуммирования.ДоступныеТаблицы.Добавить("Список");
	НастройкиСуммирования.НастройкиРазмещения.Вставить("Список", "Группа1");
	
	ГрупповоеРедактированиеТабличныхЧастейСервер.ОписаниеТабличныхЧастейДляСуммированияСтрок(ЭтотОбъект,НастройкиСуммирования);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РаботаСФормамиПТБКлиент.ПриОткрытииФормыСписка(ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РасчетСуммыВыделенныхСтрок() Экспорт
	ГрупповоеРедактированиеТабличныхЧастейКлиент.РасчетСуммыВыделенныхСтрок(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииЯчейки(Элемент)
	ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_РасчетСуммыВыделенныхСтрок", 0.2, Истина);
КонецПроцедуры
