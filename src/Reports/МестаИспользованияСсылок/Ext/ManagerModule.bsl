﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Включен = Ложь;
	НастройкиВарианта.Описание = НСтр("ru = 'Поиск мест использования объектов приложения.'");
КонецПроцедуры

// Для вызова из процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. 
//                                      См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено - добавленная команда или Неопределено, если нет прав на просмотр отчета.
//
Функция ДобавитьКомандуМестаИспользования(КомандыОтчетов) Экспорт
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.МестаИспользованияСсылок) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Команда = КомандыОтчетов.Добавить();
	Команда.Представление      = НСтр("ru = 'Места использования'");
	Команда.МножественныйВыбор = Истина;
	Команда.Важность           = "СмТакже";
	Команда.ИмяПараметраФормы  = "Отбор.НаборСсылок";
	Команда.КлючВарианта       = "Основной";
	Команда.Менеджер           = "Отчет.МестаИспользованияСсылок";
	Возврат Команда;
КонецФункции

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли