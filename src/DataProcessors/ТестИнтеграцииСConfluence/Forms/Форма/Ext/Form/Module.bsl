﻿
#Область УправлениеФормой

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, ИмяРеквизита)

	Если НЕ Обработано.Найти(ИмяРеквизита) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Обработано.Добавить(ИмяРеквизита);

	Элементы	= Форма.Элементы;
	Объект		= Форма.Объект;

	#Область Наборы
	
	Если ИмяРеквизита = "РеквизитыПроверкаДоступа" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, "ГруппаПроверитьНастройкуДоступа");
	КонецЕсли;

	#КонецОбласти
	
	#Область Элементы
	
	Если ИмяРеквизита = "Пользователь" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"Пользователь", "ТолькоПросмотр", ЗначениеЗаполнено(Объект.Пользователь));
	КонецЕсли;
	
	Если ИмяРеквизита = "ОтборПространстваОбщие" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ОтборПространстваОбщие", "ТолькоПросмотр", НЕ Форма.ОтборПространстваОбщиеИспользовать);
	КонецЕсли;
	
	Если ИмяРеквизита = "ОтборПространстваДействующие" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ОтборПространстваДействующие", "ТолькоПросмотр", НЕ Форма.ОтборПространстваДействующиеИспользовать);
	КонецЕсли;

	Если ИмяРеквизита = "ГруппаПроверитьНастройкуДоступа" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ГруппаПроверитьНастройкуДоступа", "Видимость", НЕ Форма.ДоступПроверен);
	КонецЕсли;

	#КонецОбласти 
	
	#Область ТабЧасть_Имя
	
	//Если ИмяРеквизита = "ИмяТабличнойЧастиОтветственный" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
	//	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
	//		"ИмяТабличнойЧастиОтветственный", "ТолькоПросмотр", ЗначениеЗаполнено(Объект.Ответственный));
	//КонецЕсли;

	#КонецОбласти
	
	#Область Команды
	
	//Если ИмяРеквизита = "КомандаЗаполнить" ИЛИ ПустаяСтрока(ИмяРеквизита) Тогда
	//	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
	//		"ТаблицаФормыЗаполнить", "Видимость", НЕ Объект.Проведен);
	//КонецЕсли;

	#КонецОбласти 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьУсловноеОформление(Форма, ИменаРеквизитов = "")

	Если ТипЗнч(ИменаРеквизитов) = Тип("Строка") Тогда
		Если ПустаяСтрока(ИменаРеквизитов) Тогда
			МассивИмен = Новый Массив;
			МассивИмен.Добавить("");
		Иначе
			МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаРеквизитов, ",");
		КонецЕсли;
	ИначеЕсли ТипЗнч(ИменаРеквизитов) = Тип("Массив") Тогда
		МассивИмен = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ИменаРеквизитов);
	Иначе
		Возврат;
	КонецЕсли;
 
	//Форма.ТолькоПросмотр = (Форма.СостоянияЗаблокировано.Найти(Форма.СведенияОЗаявкеСостояние) <> Неопределено);

	Обработано = Новый Массив;
	Для Каждого ИмяРеквизита Из МассивИмен Цикл
		УстановитьУсловноеОформлениеРеквизита(Форма, Обработано, СокрЛП(ИмяРеквизита));
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	ПроверитьНастройкиДоступаНаСервере();;
	
КонецПроцедуры

&НаКлиенте
Процедура БазаЗнанийПриИзменении(Элемент)
	
	ПроверитьНастройкиДоступаНаСервере();;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_НастройкаПоиска

&НаКлиенте
Процедура НастройкаПоискаПолеПоискаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.НастройкаПоиска.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьТипДанныхЗначения(ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПоискаВидСравненияПриИзменении(Элемент)
	ТекущиеДанные = Элементы.НастройкаПоиска.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьТипДанныхЗначения(ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Токен выгрузки из базы знаний
	//ЭтотОбъект.ТокенID = "Q04tXBlPMu0HLfdmWFY24CBD";
	
	Если НЕ ЗначениеЗаполнено(Объект.Пользователь) Тогда
		Объект.Пользователь	= Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.БазаЗнаний) Тогда
		Объект.БазаЗнаний = Справочники.БазыЗнанийConfluence.ОсновнаяБазаЗнаний();
	КонецЕсли;
	
	ПроверитьНастройкиДоступаНаСервере();
	
	Если ЭтотОбъект.ДоступПроверен Тогда
		РезультатЗапроса = ПолучитьПространства(Объект.Пользователь, Объект.БазаЗнаний);
		Если РезультатЗапроса = Неопределено Тогда
			РезультатЗапроса = Новый Структура("Значения", Новый Массив);
		КонецЕсли;
		
		Элементы.ПространствоСтатьи.СписокВыбора.Очистить();
		
		Для Каждого СтруктураПространства Из РезультатЗапроса.Значения Цикл
			Элементы.ПространствоСтатьи.СписокВыбора.Добавить(СтруктураПространства, СтруктураПространства.Наименование);
		КонецЦикла;
	КонецЕсли;
	
	ЭтотОбъект.СтатьяЗаголовок = НСтр("ru='Интеграция Confluence-1С'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьУсловноеОформление(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "НастройкиИнтеграцииConfluenceИзменение" Тогда
		ПользовательСобытия = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметр, "Пользователь", Неопределено);
		БазаЗнанийСобытия = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметр, "БазаЗнаний", Неопределено);
		
		Если ПользовательСобытия = Объект.Пользователь И БазаЗнанийСобытия = Объект.БазаЗнаний Тогда
			ПроверитьНастройкиДоступаНаСервере();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьНастройкиДоступа(Команда)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Пользователь", Объект.Пользователь);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("РегистрСведений.НастройкиИнтеграцииConfluence.ФормаСписка",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтрокуПоиска(Команда)
	СтруктураНастройкаПоиска = ПолучитьНастройкуПоискаНаСервере();
	ЭтотОбъект.СтрокаПоиска = ИнтеграцияConfluenceКлиентСервер.ПолучитьСтрокуЗапросаПоиска(СтруктураНастройкаПоиска);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	НастройкиПодключения = ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(Объект.БазаЗнаний, Объект.Пользователь);
	
	СтруктураНастройкаПоиска	= ПолучитьНастройкуПоискаНаСервере();
	СтруктураПараметрыПоиска	= ИнтеграцияConfluenceКлиентСервер.ПараметрыПоиска();
	
	Результат = ИнтеграцияConfluenceКлиентСервер.Поиск(НастройкиПодключения, СтруктураНастройкаПоиска, СтруктураПараметрыПоиска);
	ЭтотОбъект.РезультатПоиска	= ЗначениеВСтроку(Результат, "");
	
	ЭтотОбъект.СтрокаПоиска		= ИнтеграцияConfluenceКлиентСервер.ПолучитьСтрокуЗапросаПоиска(СтруктураНастройкаПоиска);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПространства(Команда)
	ПараметрыЗапроса = ИнтеграцияConfluenceКлиентСервер.ПараметрыПолучитьПространства();
	ПараметрыЗапроса.Общие			= ?(ЭтотОбъект.ОтборПространстваОбщиеИспользовать, ЭтотОбъект.ОтборПространстваОбщие, Неопределено);
	ПараметрыЗапроса.Действующие	= ?(ЭтотОбъект.ОтборПространстваДействующиеИспользовать, ЭтотОбъект.ОтборПространстваДействующие, Неопределено);
	ПараметрыЗапроса.Метка			= ЭтотОбъект.ОтборПространстваМетка;
	ПараметрыЗапроса.Избранное		= ЭтотОбъект.ОтборПространстваИзбранные;
	
	РезультатЗапроса = ПолучитьПространства(Объект.Пользователь, Объект.БазаЗнаний, ПараметрыЗапроса);
	Если РезультатЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.Пространства.Очистить();
	
	Для Каждого СтруктураПространства Из РезультатЗапроса.Значения Цикл
		НоваяСтрока = ЭтотОбъект.Пространства.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПространства,, "Метки");
		Для Каждого СтруктураМетки Из СтруктураПространства.Метки Цикл
			СтрокаМетки = НоваяСтрока.Метки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаМетки, СтруктураМетки);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВывестиВТабДокумент(Команда)
	НастройкиПодключения = ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(Объект.БазаЗнаний, Объект.Пользователь);
	
	СтруктураНастройкаПоиска	= ПолучитьНастройкуПоискаНаСервере();
	СтруктураПараметрыПоиска	= ИнтеграцияConfluenceКлиентСервер.ПараметрыПоиска();
	СтруктураПараметрыПоиска.Размер = 200;
	
	Результат = ИнтеграцияConfluenceКлиентСервер.Поиск(НастройкиПодключения, СтруктураНастройкаПоиска, СтруктураПараметрыПоиска);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(Результат, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	ТД = Новый ТабличныйДокумент;
	ИндексСтроки = 0;
	Для Каждого СтруктураДанных Из Результат.Значения Цикл
		ИндексСтроки = ИндексСтроки + 1;
		
		ТД.Область(ИндексСтроки, 1, ИндексСтроки, 1).Текст = СтруктураДанных.Заголовок;
		ТД.Область(ИндексСтроки, 2, ИндексСтроки, 2).Текст = СтруктураДанных.Пространство.Заголовок;
		ТД.Область(ИндексСтроки, 3, ИндексСтроки, 3).Текст = СтруктураДанных.Обновлено;
		ТД.Область(ИндексСтроки, 4, ИндексСтроки, 4).Текст = СтруктураДанных.Ссылка;
	КонецЦикла;
	
	ТД.Показать();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСтатью(Команда)
	СтруктураСтатья = ПолучитьСтруктуруКонтентаConfluence(ЭтотОбъект.СтатьяКакЗаписьБлога);
	
	ЭтотОбъект.СтатьяConfluenceStorage = ИнтеграцияConfluenceКлиентСервер.ПолучитьСтрокуConfluenceStorage(СтруктураСтатья);
	
	НастройкиПодключения = ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(Объект.БазаЗнаний, Объект.Пользователь);
	
	// сначала попробуем удалить текущую статью
	СтатьяДанные = НайтиСтатьюПоЗаголовку(НастройкиПодключения,
		ЭтотОбъект.ПространствоСтатьи.Ключ,
		ЭтотОбъект.СтатьяЗаголовок,
		ЭтотОбъект.СтатьяКакЗаписьБлога);
		
	// попробуем удалить статью
	Если СтатьяДанные <> Неопределено Тогда
		Идентификатор = СтатьяДанные.Контент.Идентификатор;
		
		Результат = УдалитьКонтентПоИдентификатору(НастройкиПодключения, Идентификатор);
		Если НЕ Результат Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// создадим новую статью
	РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.СоздатьКонтент(НастройкиПодключения, СтруктураСтатья);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(РезультатЗапроса, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.СтатьяИдентификатор	= РезультатЗапроса.Идентификатор;
	ЭтотОбъект.СтатьяВерсия			= РезультатЗапроса.Версия.Номер;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатью(Команда)
	ДанныеТекст = ИнтеграцияConfluenceКлиентСервер.ЭлементHTML("<p>Это изменение</p>");
	
	СтруктураДоп = ИнтеграцияConfluenceКлиентСервер.ЭлементКонтентаБлок(0);
	СтруктураДоп.Элементы[0].Элементы.Добавить(ДанныеТекст);
	
	СтруктураСтатья = ПолучитьСтруктуруКонтентаConfluence(ЭтотОбъект.СтатьяКакЗаписьБлога, Истина);
	СтруктураСтатья.Тело[0].Элементы.Вставить(0, СтруктураДоп);
	
	ЭтотОбъект.СтатьяConfluenceStorage = ИнтеграцияConfluenceКлиентСервер.ПолучитьСтрокуConfluenceStorage(СтруктураСтатья);
	
	НастройкиПодключения = ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(Объект.БазаЗнаний, Объект.Пользователь);
	
	// изменим текущую статью
	РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.ИзменитьКонтент(НастройкиПодключения, ЭтотОбъект.СтатьяИдентификатор, СтруктураСтатья);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(РезультатЗапроса, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.СтатьяИдентификатор	= РезультатЗапроса.Идентификатор;
	ЭтотОбъект.СтатьяВерсия			= РезультатЗапроса.Версия.Номер;
КонецПроцедуры

&НаКлиенте
Процедура НайтиСтатью(Команда)
	ЭтотОбъект.СтатьяИдентификатор	= "";
	ЭтотОбъект.СтатьяВерсия			= "";
	
	НастройкиПодключения = ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(Объект.БазаЗнаний, Объект.Пользователь);
	
	ДанныеСтатьи = НайтиСтатьюПоЗаголовку(НастройкиПодключения,
		ЭтотОбъект.ПространствоСтатьи.Ключ,
		ЭтотОбъект.СтатьяЗаголовок,
		ЭтотОбъект.СтатьяКакЗаписьБлога);
		
	Если ДанныеСтатьи = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='По вашему запросу ничего не найдено!!!'"));
		Возврат;
	КонецЕсли;
	
	КонтентСтатьи = ИнтеграцияConfluenceКлиентСервер.ПолучитьКонтентПоИдентификатору(НастройкиПодключения, ДанныеСтатьи.Контент.Идентификатор);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(КонтентСтатьи, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Получение контента завершилось с ошибкой.'"));
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.СтатьяИдентификатор	= КонтентСтатьи.Идентификатор;
	ЭтотОбъект.СтатьяВерсия			= КонтентСтатьи.Версия.Номер;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтатью(Команда)
	Если ПустаяСтрока(ЭтотОбъект.СтатьяИдентификатор) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Идентификатор удаляемой статьи не указан.'"));
		Возврат;
	КонецЕсли;
	
	НастройкиПодключения = ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(Объект.БазаЗнаний, Объект.Пользователь);
	
	Результат = УдалитьКонтентПоИдентификатору(НастройкиПодключения, ЭтотОбъект.СтатьяИдентификатор);
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Удаление контента выполнено'")); 
КонецПроцедуры

#КонецОбласти

#Область ЗавершениеНемодальныхВызовов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте 
процедура УстановитьТипДанныхЗначения(ТекущиеДанные)
	
	МассивТипов = Новый Массив;
	КЧ = Неопределено;
	КС = Неопределено;
	КД = Неопределено;
	
	Если ТекущиеДанные.ПолеПоиска = "ВИерархии" Тогда
		МассивТипов.Добавить(Тип("Число"));
		КЧ = Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный);
	ИначеЕсли ТекущиеДанные.ПолеПоиска = "Родитель" Тогда
		МассивТипов.Добавить(Тип("Число"));
		КЧ = Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный);
	ИначеЕсли ТекущиеДанные.ПолеПоиска = "Заголовок" Тогда
		МассивТипов.Добавить(Тип("Строка"));
		КС = Новый КвалификаторыСтроки(0);
	ИначеЕсли ТекущиеДанные.ПолеПоиска = "Текст" Тогда
		МассивТипов.Добавить(Тип("Строка"));
		КС = Новый КвалификаторыСтроки(0);
	ИначеЕсли ТекущиеДанные.ПолеПоиска = "ДатаСоздания" Тогда
		МассивТипов.Добавить(Тип("Дата"));
		КД = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
	ИначеЕсли ТекущиеДанные.ПолеПоиска = "ДатаИзменения" Тогда
		МассивТипов.Добавить(Тип("Дата"));
		КД = Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя);
	ИначеЕсли ТекущиеДанные.ПолеПоиска = "Пространство" Тогда
		МассивТипов.Добавить(Тип("Строка"));
		КС = Новый КвалификаторыСтроки(100);
	ИначеЕсли ТекущиеДанные.ПолеПоиска = "ТипДанных" Тогда
		МассивТипов.Добавить(Тип("ПеречислениеСсылка.ТипыДанныхConfluence"));
	КонецЕсли;
	
	Если ТекущиеДанные.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке
		ИЛИ ТекущиеДанные.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.ТипЗначения = Новый ОписаниеТипов(МассивТипов, КЧ, КС, КД);
		
		НовЗначение = СписокЗначений.ТипЗначения.ПривестиЗначение(ТекущиеДанные.Значение);
		Если ТекущиеДанные.Значение = НовЗначение Тогда
			СписокЗначений.Добавить(ТекущиеДанные.Значение);
		КонецЕсли;
		
		ТекущиеДанные.ТипДанных = Новый ОписаниеТипов("СписокЗначений");
		ТекущиеДанные.Значение	= СписокЗначений;
	Иначе 
		Если ТипЗнч(ТекущиеДанные.Значение) = Тип("СписокЗначений") И ТекущиеДанные.Значение.Количество() > 0 Тогда
			ТекущееЗначение = ТекущиеДанные.Значение[0].Значение;
		Иначе 
			ТекущееЗначение = ТекущиеДанные.Значение;
		КонецЕсли;
		
		ТекущиеДанные.ТипДанных = Новый ОписаниеТипов(МассивТипов, КЧ, КС, КД);
		ТекущиеДанные.Значение	= ТекущиеДанные.ТипДанных.ПривестиЗначение(ТекущееЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Функция ПолучитьСтруктуруКонтентаConfluence(знач ЗаписьБлога, знач КакИзменение = Ложь)
	// Блоки
	СтруктураБлоки = ИнтеграцияConfluenceКлиентСервер.ЭлементКонтентаБлоки();
	
	#Область МакросИнформационныйБлок_МакросСодержание
	ЭлементТекст = ИнтеграцияConfluenceКлиентСервер.ЭлементТекст(НСтр("ru='Эта статья добавлена при тестировании интеграции между 1С и Confluence cloud посредством REST API'"));
	
	ЭлементыИнформация = Новый Массив;
	ЭлементыИнформация.Добавить(ЭлементТекст);
	
	СтруктураИнформация = ИнтеграцияConfluenceКлиентСервер.МакросИнформационныйБлок(2, НСтр("ru='ВНИМАНИЕ!!!'"), ЭлементыИнформация, Истина);
	
	СтруктураСодержание = ИнтеграцияConfluenceКлиентСервер.МакросСодержание(, Истина,,, 1,, НСтр("ru='Содержание'"), Истина); 
	
	СтруктураБлок = ИнтеграцияConfluenceКлиентСервер.ЭлементКонтентаБлок(3);
	СтруктураБлок.Элементы[0].Элементы.Добавить(СтруктураИнформация);
	СтруктураБлок.Элементы[1].Элементы.Добавить(ИнтеграцияConfluenceКлиентСервер.ЭлементЗаголовок(1, НСтр("ru='Содержание'")));
	СтруктураБлок.Элементы[1].Элементы.Добавить(СтруктураСодержание);
	СтруктураБлоки.Элементы.Добавить(СтруктураБлок);
	#КонецОбласти 
	
	#Область МакросНеформатированныйБлок_СсылкаНаСтатью
	СтруктураСсылка	= ИнтеграцияConfluenceКлиентСервер.ЭлементСсылкаНаСтатью(ЭтотОбъект.СтатьяЗаголовок,, НСтр("ru='Тест'"));
	
	ЭлементыБлок = Новый Массив;
	ЭлементыБлок.Добавить(СтруктураСсылка);
	
	СтруктураНеформатированныйБлок = ИнтеграцияConfluenceКлиентСервер.МакросНеформатированныйБлок(Истина, ЭлементыБлок);
	
	СтруктураБлок = ИнтеграцияConfluenceКлиентСервер.ЭлементКонтентаБлок(0);
	СтруктураБлок.Элементы[0].Элементы.Добавить(ИнтеграцияConfluenceКлиентСервер.ЭлементЗаголовок(1, НСтр("ru='Ссылка на статью'")));
	СтруктураБлок.Элементы[0].Элементы.Добавить(СтруктураНеформатированныйБлок);
	СтруктураБлоки.Элементы.Добавить(СтруктураБлок);
	#КонецОбласти 
	
	#Область СтруктураКонтента
	Если НЕ ЗаписьБлога Тогда
		СтруктураКонтент = ИнтеграцияConfluenceКлиентСервер.СтруктураСтатьи();
	Иначе
		СтруктураКонтент = ИнтеграцияConfluenceКлиентСервер.СтруктураЗаписиБлока();
	КонецЕсли;
	СтруктураКонтент.Пространство	= ЭтотОбъект.ПространствоСтатьи.Ключ;
	СтруктураКонтент.Заголовок		= ЭтотОбъект.СтатьяЗаголовок;
	СтруктураКонтент.Тело.Добавить(СтруктураБлоки);
	#КонецОбласти 
	
	Если КакИзменение = Истина Тогда
		СтруктураКонтент.Версия = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ЭтотОбъект.СтатьяВерсия) + 1;
	КонецЕсли;
	
	Возврат СтруктураКонтент;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НайтиСтатьюПоЗаголовку(знач НастройкиПодключения, знач Пространство, знач Заголовок, знач ЗаписьБлога = Ложь)
	ТипСтатья = ?(ЗаписьБлога,
		ПредопределенноеЗначение("Перечисление.ТипыДанныхConfluence.ЗаписьБлога"),
		ПредопределенноеЗначение("Перечисление.ТипыДанныхConfluence.Статья"));
	
	НастройкаПоиска = ИнтеграцияConfluenceКлиентСервер.НастройкаПоиска();
	ИнтеграцияConfluenceКлиентСервер.ДобавитьЭлементПоиска(НастройкаПоиска, "Пространство", ВидСравненияКомпоновкиДанных.Равно, Пространство);
	ИнтеграцияConfluenceКлиентСервер.ДобавитьЭлементПоиска(НастройкаПоиска, "ТипДанных", ВидСравненияКомпоновкиДанных.Равно, ТипСтатья);
	ИнтеграцияConfluenceКлиентСервер.ДобавитьЭлементПоиска(НастройкаПоиска, "Заголовок", ВидСравненияКомпоновкиДанных.Равно, Заголовок);
	
	РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.Поиск(НастройкиПодключения, НастройкаПоиска);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(РезультатЗапроса, Истина) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если РезультатЗапроса.Значения.Количество() < 1 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Значения[0];
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция УдалитьКонтентПоИдентификатору(знач НастройкиПодключения, знач Идентификатор)
	// пометка удаления
	РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.УдалитьКонтент(НастройкиПодключения, Идентификатор, Истина);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(РезультатЗапроса, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При пометке удаления статьи произошла ошибка. Выполните операцию вручную.'"));
		Возврат Ложь;
	КонецЕсли;
	
	// полное удаление
	РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.УдалитьКонтент(НастройкиПодключения, Идентификатор, Ложь);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(РезультатЗапроса, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При удалении статьи произошла ошибка. Выполните операцию вручную.'"));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаКлиентеНаСервереБезКонтекста 
Функция ПолучитьПространства(знач Пользователь, знач БазаЗнаний, знач ПараметрыЗапроса = Неопределено)
	НастройкиПодключения = ИнтеграцияConfluenceВызовСервераПовтИсп.НастройкиПодключения(БазаЗнаний, Пользователь);
	
	Если НЕ ТипЗнч(ПараметрыЗапроса) = Тип("Структура") Тогда
		ПараметрыЗапроса = ИнтеграцияConfluenceКлиентСервер.ПараметрыПолучитьПространства();
	КонецЕсли;
	
	РезультатЗапроса = ИнтеграцияConfluenceКлиентСервер.ПолучитьПространства(НастройкиПодключения, ПараметрыЗапроса);
	Если ИнтеграцияConfluenceКлиентСервер.ПроверитьОшибки(РезультатЗапроса, Истина) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса;
КонецФункции

&НаСервере 
Процедура ПроверитьНастройкиДоступаНаСервере()
	НастройкиПользователя = РегистрыСведений.НастройкиИнтеграцииConfluence.НастройкиПользователя(Объект.Пользователь, Объект.БазаЗнаний);
	
	Если ЭтотОбъект.ДоступПроверен <> НастройкиПользователя.ДоступПроверен Тогда
		ЭтотОбъект.ДоступПроверен	= НастройкиПользователя.ДоступПроверен;
		УстановитьУсловноеОформление(ЭтотОбъект, "РеквизитыПроверкаДоступа");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Поиск

&НаКлиентеНаСервереБезКонтекста 
Функция ЗначениеВСтроку(знач Результат, знач Отступ)
	ТипРезультат = ТипЗнч(Результат);
	Если ТипРезультат = Тип("Структура") Тогда
		СтрРезультат = СтруктураВСтроку(Результат, Отступ);
	ИначеЕсли ТипРезультат = Тип("Массив") Тогда
		СтрРезультат = МассивВСтроку(Результат, Отступ);
	Иначе 
		СтрРезультат = """" + Строка(Результат) + """";
	КонецЕсли;
	
	Возврат СтрРезультат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураВСтроку(знач Структура, знач Отступ = "")
	СтрСтруктура = "{"; 
	
	Отступ = Отступ + Символы.Таб;
	Для Каждого КлючИЗначение Из Структура Цикл
		СтрСтруктура = СтрСтруктура
			+ ?(ПустаяСтрока(СтрСтруктура), "", Символы.ПС + Отступ)
			+ КлючИЗначение.Ключ + ": " + ЗначениеВСтроку(КлючИЗначение.Значение, Отступ);
	КонецЦикла;
	
	Возврат СтрСтруктура + Символы.ПС + Отступ + "}"
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МассивВСтроку(знач Массив, знач Отступ = "")
	СтрМассив = "["; 
	
	Отступ = Отступ + Символы.Таб;
	Индекс = 0;
	Для Каждого ЗначениеМассива Из Массив Цикл
		СтрМассив = СтрМассив
			+ ?(ПустаяСтрока(СтрМассив), "", Символы.ПС + Отступ)
			+ Формат(Индекс, "ЧН=0; ЧГ=") + ": " + ЗначениеВСтроку(ЗначениеМассива, Отступ);
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Возврат СтрМассив + Символы.ПС + Отступ + "]"
КонецФункции

&НаСервере
Функция ПолучитьНастройкуПоискаНаСервере()
	
	КопияТаблицы = ЭтотОбъект.НастройкаПоиска.Выгрузить();
	КопияТаблицы.Сортировать("ПолеПоиска ВОЗР");
	
	СтруктураНастройкаПоиска = ИнтеграцияConfluenceКлиентСервер.НастройкаПоиска();
	
	Для Каждого СтрокаТаблицы Из КопияТаблицы Цикл
		Если ПустаяСтрока(СтрокаТаблицы.ПолеПоиска) Тогда
			Продолжить;
		КонецЕсли;
		
		ИнтеграцияConfluenceКлиентСервер.ДобавитьЭлементПоиска(СтруктураНастройкаПоиска,
			СтрокаТаблицы.ПолеПоиска,
			СтрокаТаблицы.ВидСравнения,
			СтрокаТаблицы.Значение);
	КонецЦикла;  
	
	Возврат СтруктураНастройкаПоиска;
	
КонецФункции

&НаКлиенте
Процедура ОтборПространстваОбщиеИспользоватьПриИзменении(Элемент)
	УстановитьУсловноеОформление(ЭтотОбъект, "ОтборПространстваОбщие");
КонецПроцедуры

&НаКлиенте
Процедура ОтборПространстваДействующиеИспользоватьПриИзменении(Элемент)
	УстановитьУсловноеОформление(ЭтотОбъект, "ОтборПространстваДействующие");
КонецПроцедуры

#КонецОбласти

 
