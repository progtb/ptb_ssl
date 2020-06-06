﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекстПредупреждения) Тогда
		Элементы.Надпись.Заголовок = Параметры.ТекстПредупреждения;
	ИначеЕсли ЗначениеЗаполнено(Параметры.НазваниеРегиона) Тогда
		ТекстВопроса = НСтр("ru = 'Для автоподбора и выбора адресных сведений необходимо загрузить классификатор по региону ""%1"".'");
		Элементы.Надпись.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Параметры.НазваниеРегиона);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	УстановитьФлагНапоминанияОЗагрузкеКлассификатора();
	Закрыть(КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	УстановитьФлагНапоминанияОЗагрузкеКлассификатора();
	Закрыть(КодВозвратаДиалога.Нет);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьФлагНапоминанияОЗагрузкеКлассификатора()
	Если НеНапоминатьОЗагрузке Тогда
		ПараметрыПриложения.Вставить("АдресныйКлассификатор.НеЗагружатьКлассификатор", Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти




