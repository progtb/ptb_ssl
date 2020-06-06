﻿
#Область ПрограммныйИнтерфейс_User

Функция ЭтоКоманда_User(знач ИмяКоманды) Экспорт 
	Возврат (ИмяКоманды = "/user");
КонецФункции

Функция ВыполнитьКоманду_User(знач ИмяКоманды, знач ДанныеКоманды) Экспорт
	ТекстКоманды = ДанныеКоманды.text;
	
	Если ТекстКоманды = "help" Тогда
		Ответ = ВыполнитьКоманду_User_Help(ДанныеКоманды);
	ИначеЕсли СтрНачинаетсяС(ТекстКоманды, "checkin") Тогда
		Ответ = ВыполнитьКоманду_User_CheckInOut(ДанныеКоманды);
	ИначеЕсли СтрНачинаетсяС(ТекстКоманды, "checkout") Тогда
		Ответ = ВыполнитьКоманду_User_CheckInOut(ДанныеКоманды);
	Иначе 
		Ответ = Неопределено;
	КонецЕсли;	
	
	Если ТипЗнч(Ответ) = Тип("HTTPСервисОтвет") Тогда
		Возврат Ответ;
	Иначе
		ТекстОшибки		= НСтр("ru='команда не определена'");
		ТекстПодсказки	= СтрШаблон(НСтр("ru='Используйте подсказку `/user help`.'"), ИмяКоманды);
		Возврат ИнтеграцияSlack.ОтветОшибка(ТекстОшибки, ТекстПодсказки);
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_User

Функция ВыполнитьКоманду_User_Help(знач СтруктураКоманды)
	ТекстОтвета = НСтр("ru=':wave: Привет! Я помощник для Slack. Для взаимодействия со мной'")
		+ НСтр("ru=' введи одну из этих команд в окне сообщения:'");
		
	ТекстКоманды = 
		СтрШаблон("`/user checkin <КонтрольноеЧисло>`: %1", НСтр("ru='создание связи с пользователем 1С'"));
		
	СтруктураКоманды = Новый Структура;
	СтруктураКоманды.Вставить("color"	, ВРег(ОбщегоНазначенияПТБКлиентСервер.ЦветВHex(255, 69, 0)));
	СтруктураКоманды.Вставить("text"	, ТекстКоманды);
	
	МассивКоманды = Новый Массив;
	МассивКоманды.Добавить(СтруктураКоманды);
	
	Структура = Новый Структура;
	Структура.Вставить("text"		, ТекстОтвета); 
	Структура.Вставить("attachments", МассивКоманды);
	
	Возврат ИнтернетСервисы.ПолучитьОтвет200(, ИнтернетСервисы.ПолучитьСтрокуJSON(Структура),,);
КонецФункции

Функция ВыполнитьКоманду_User_CheckInOut(знач СтруктураКоманды)
	МассивПараметров = СтрРазделить(СтруктураКоманды.text, "+", Ложь);
	Если МассивПараметров.Количество() < 2 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВидКоманды			= МассивПараметров[0];
	КонтрольноеЧисло	= МассивПараметров[1];
	
	ИдентификаторПользователя	= СтруктураКоманды.user_id;
	ПользовательСсылка			= РегистрыСведений.НастройкиИнтеграцииSlack.ПолучитьПользователяПоКонтрольномуЧислу(КонтрольноеЧисло);
	НастройкаСсылка				= Перечисления.ВидыНастроекИнтеграцииSlack.ПользовательId;
	
	Если НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
		Возврат ИнтеграцияSlack.ОтветОшибка(НСтр("ru='пользователь не найден'"), НСтр("ru='Проверьте контрольное число.'"));
	КонецЕсли;
	
	Если ВидКоманды = "checkin" Тогда
		РегистрыСведений.НастройкиИнтеграцииSlack.УстановитьЗначениеНастройки(ПользовательСсылка, НастройкаСсылка, ИдентификаторПользователя);
		РезультатВыполнения = СтрШаблон(НСтр("ru='Пользователь связан с `%1`.'"), СокрЛП(ПользовательСсылка));
	ИначеЕсли ВидКоманды = "checkout" Тогда
		РегистрыСведений.НастройкиИнтеграцииSlack.УстановитьЗначениеНастройки(ПользовательСсылка, НастройкаСсылка, "");
		РезультатВыполнения = СтрШаблон(НСтр("ru='Связь с пользователем `%1` разорвана.'"), СокрЛП(ПользовательСсылка));
	КонецЕсли;
	
	Структура = Новый Структура;
	Структура.Вставить("text", НСтр("ru=':ok_hand: Команда выполнена. '") + РезультатВыполнения); 
	
	Возврат ИнтернетСервисы.ПолучитьОтвет200(, ИнтернетСервисы.ПолучитьСтрокуJSON(Структура),,);
КонецФункции

#КонецОбласти
 
