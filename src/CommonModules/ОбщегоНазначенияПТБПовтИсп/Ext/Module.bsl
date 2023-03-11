﻿
Функция ОписаниеТипаВсеСсылки(знач Объекты = "", знач ИмяРасширения = "") Экспорт
	Если НЕ ЗначениеЗаполнено(ИмяРасширения) Тогда
		ТолькоРасширение = Неопределено;
	Иначе 
		ТолькоРасширение = Истина;
	КонецЕсли;
	
	Если ПустаяСтрока(Объекты) Тогда
		Объекты = "Справочники,Документы,ПланыОбмена,Перечисления,ПланыВидовХарактеристик,ПланыСчетов"
		+ ",ПланыВидовРасчета,БизнесПроцессы,Задачи";
	КонецЕсли;
	
	МассивОбъекты = СтрРазделить(Объекты, ",");
	
	МассивТипов = Новый Массив;
	Для Каждого Имя Из МассивОбъекты Цикл
		Для Каждого МетаОбъект Из Метаданные[Имя] Цикл
			Если ТолькоРасширение <> Неопределено Тогда
				МетаРасширение = МетаОбъект.РасширениеКонфигурации();
				
				ДобавитьВМассив = (МетаРасширение <> Неопределено И МетаРасширение.Имя = ИмяРасширения);
				
				Если НЕ ДобавитьВМассив Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;					
			
			ПолноеИмя = СтрЗаменить(МетаОбъект.ПолноеИмя(), ".", "Ссылка.");
			МассивТипов.Добавить(Тип(ПолноеИмя));
			
			Если Имя = "БизнесПроцессы" Тогда
				Для Каждого ТочкаМаршрута Из БизнесПроцессы[МетаОбъект.Имя].ТочкиМаршрута Цикл
					МассивТипов.Добавить(ТипЗнч(ТочкаМаршрута));
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый ОписаниеТипов(МассивТипов);
КонецФункции

Функция ОписаниеТипаПростыеТипы() Экспорт
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Число"));
	МассивТипов.Добавить(Тип("Строка"));
	МассивТипов.Добавить(Тип("Дата"));
	МассивТипов.Добавить(Тип("Булево"));
	
	Возврат Новый ОписаниеТипов(МассивТипов);
КонецФункции

Функция ХешСуммаКонфигурации() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Идентификатор = ПолучитьИдентификаторКонфигурации();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ОбщегоНазначения.КонтрольнаяСуммаСтрокой(Идентификатор);
КонецФункции
