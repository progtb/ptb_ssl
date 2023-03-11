﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ЗначениеВСтрокуJSON(знач ОбъектДанных, знач Настройки = Неопределено, знач Параметры = Неопределено) Экспорт
	Возврат ИнтернетСервисыКлиентСервер.ЗначениеВСтрокуJSON(ОбъектДанных, Настройки, Параметры);
КонецФункции

Функция ЗначениеИзСтрокиJSON(знач СтрокаJSON, знач КакСоответствие = Ложь, знач СвойстваДаты = "", знач ФорматДаты = Неопределено) Экспорт
	Возврат ИнтернетСервисыКлиентСервер.ЗначениеИзСтрокиJSON(СтрокаJSON, КакСоответствие, СвойстваДаты, ФорматДаты);
КонецФункции

Процедура ПодготовитьПараметрыСериализацииВJSON(Параметры) Экспорт
	Параметры.Вставить("ТипВсеСсылки"		, ОбщегоНазначения.ОписаниеТипаВсеСсылки());
	Параметры.Вставить("ТипПеречисление"	, Перечисления.ТипВсеСсылки());
КонецПроцедуры

Функция ПодготовитьЗначениеТип(знач Значение) Экспорт
	Возврат ОбщегоНазначения.СтроковоеПредставлениеТипа(Значение);
КонецФункции

Функция ПодготовитьЗначениеОписаниеТипов(знач Значение) Экспорт
	МассивТипов = Новый Массив;
	Для Каждого Тип Из Значение.Типы() Цикл
		МассивТипов.Добавить(ОбщегоНазначения.СтроковоеПредставлениеТипа(Тип));
	КонецЦикла;
	
	Возврат МассивТипов;
КонецФункции

Функция ПодготовитьЗначениеПеречисление(знач Значение) Экспорт
	Если НЕ ЗначениеЗаполнено(Значение) Тогда
		ИмяЗначения = "ПустаяСсылка";
	Иначе 
		ИмяЗначения = ОбщегоНазначения.ИмяЗначенияПеречисления(Значение);
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ИмяТаблицыПоСсылке(Значение) + "." + ИмяЗначения;
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_Устарело

// Устарела. Рекомендуется использовать ИнтернетСервисыКлиентСервер.ЗначениеВСтрокуJSON
Функция ПолучитьСтрокуJSON(знач ОбъектДанных) Экспорт
	Возврат ЗначениеВСтрокуJSON(ОбъектДанных); 
КонецФункции

#КонецОбласти
