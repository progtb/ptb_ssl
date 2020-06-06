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
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.КаталогНаДиске) Тогда
		ВызватьИсключение НСтр("ru='Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	ГруппаФайлов = Параметры.ГруппаФайлов;
	Каталог = Параметры.КаталогНаДиске;
	ПапкаДляДобавления = Параметры.ПапкаДляДобавления;
	ПапкаДляДобавленияСтрокой = ОбщегоНазначения.ПредметСтрокой(ПапкаДляДобавления);
	ВыборКаталогов = Истина;
	ХранитьВерсии = РаботаСФайламиСлужебныйВызовСервера.ЭтоСправочникФайлы(ПапкаДляДобавления);
	Элементы.ХранитьВерсии.Видимость = ХранитьВерсии;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Обработка.РаботаСФайлами.Форма.ВыборКодировки") Тогда
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		КодировкаТекстаФайла = ВыбранноеЗначение.Значение;
		КодировкаПредставление = ВыбранноеЗначение.Представление;
		УстановитьПредставлениеКомандыКодировки(КодировкаПредставление);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбранныйКаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// Код вызывается только из IE или тонкого клиента, проверка на веб-клиент не требуется.
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	
	ДиалогОткрытияФайла.Каталог = Каталог;
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		Если ВыборКаталогов = Истина Тогда 
			
			Каталог = ДиалогОткрытияФайла.Каталог;
			
		КонецЕсли;
		
	КонецЕсли;
		
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИмпортВыполнить()
	
	Если ПустаяСтрока(Каталог) Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не выбран каталог для импорта.'"), , "Каталог");
		Возврат;
		
	КонецЕсли;
	
	Если ПапкаДляДобавления.Пустая() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Укажите папку.'"), , "ПапкаДляДобавления");
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайлы = Новый СписокЗначений;
	ВыбранныеФайлы.Добавить(Каталог);
	
	Обработчик = Новый ОписаниеОповещения("ИмпортЗавершение", ЭтотОбъект);
	
	ПараметрыВыполнения = РаботаСФайламиСлужебныйКлиент.ПараметрыИмпортаФайлов();
	ПараметрыВыполнения.ОбработчикРезультата          = Обработчик;
	ПараметрыВыполнения.Владелец                      = ПапкаДляДобавления;
	ПараметрыВыполнения.ВыбранныеФайлы                = ВыбранныеФайлы; 
	ПараметрыВыполнения.Комментарий                   = Описание;
	ПараметрыВыполнения.ХранитьВерсии                 = ХранитьВерсии;
	ПараметрыВыполнения.УдалятьФайлыПослеДобавления   = УдалятьФайлыПослеДобавления;
	ПараметрыВыполнения.Рекурсивно                    = Истина;
	ПараметрыВыполнения.ИдентификаторФормы            = УникальныйИдентификатор;
	ПараметрыВыполнения.Кодировка                     = КодировкаТекстаФайла;
	ПараметрыВыполнения.ГруппаФайлов                  = ГруппаФайлов;
	РаботаСФайламиСлужебныйКлиент.ВыполнитьИмпортФайлов(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть();
	Оповестить("Запись_ПапкиФайлов", Новый Структура, Результат.ПапкаДляДобавленияТекущая);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВыборКодировки", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПредставлениеКомандыКодировки(Представление)
	
	Команды.ВыбратьКодировку.Заголовок = Представление;
	
КонецПроцедуры

#КонецОбласти
